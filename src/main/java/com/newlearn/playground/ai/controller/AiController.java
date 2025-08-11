//# Copyright (c) 2025 Jongyun Han (한종윤)
//# All rights reserved.
//#
//# This software is the confidential and proprietary information of Jongyun Han ("Confidential Information").
//# You shall not disclose such Confidential Information and shall use it only in accordance with the terms of the license agreement.
//#
//# Author: Jongyun Han
//# Project: Imperium Context Engine (ICE)
//# Description: Cross-model LLM context continuity system

package com.newlearn.playground.ai.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.genai.Client;
import com.google.genai.types.Content;
import com.google.genai.types.GenerateContentConfig;
import com.google.genai.types.GenerateContentResponse;
import com.google.genai.types.Part;
import com.newlearn.playground.ai.model.service.AiService;
import com.newlearn.playground.ai.model.vo.Ai;
import com.newlearn.playground.ai.model.vo.AiChatHistory;
import com.newlearn.playground.ai.model.vo.AiChatSession;
import com.newlearn.playground.member.model.vo.Member;
import com.openai.client.OpenAIClient;
import com.openai.client.okhttp.OpenAIOkHttpClient;
import com.openai.models.ChatModel;
import com.openai.models.chat.completions.ChatCompletion;
import com.openai.models.chat.completions.ChatCompletionCreateParams;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/ai")
@RequiredArgsConstructor
@PropertySource("classpath:driver.properties")
public class AiController {
	private final AiService aiService;
	private final ServletContext application;
	
	@Value("${dataSource.openaiApiKey}")
	private String myApiKey;
	
	@Value("${dataSource.geminiApiKey}")
	private String geminiApiKey;
	
	// Configures using one of:
    // - The `OPENAI_API_KEY` environment variable
    // - The `OPENAI_BASE_URL` and `AZURE_OPENAI_KEY` environment variables
	private OpenAIClient client;
	private Client geminiClient;
	
	@PostConstruct
	public void init() {
		client = OpenAIOkHttpClient.builder()
				// Configures using the `OPENAI_API_KEY`, `OPENAI_ORG_ID`, `OPENAI_PROJECT_ID`, `OPENAI_WEBHOOK_SECRET` and `OPENAI_BASE_URL` environment variables
				.fromEnv()
				.apiKey(myApiKey)
				.build();
		geminiClient = Client.builder().apiKey(geminiApiKey).build();
		
		List<Ai> aiList = aiService.getAiList();
		application.setAttribute("aiList", aiList);
	}
	
	@GetMapping("/main")
	public String showMain(
			HttpSession session,
			Authentication auth
			) {
		// DB의 ai_chat_sessions 테이블에서 해당 유저의 chat_session 정보들을 불러온다.
		Member loginUser = (Member)auth.getPrincipal();
		int userNo = loginUser.getUserNo();
		List<AiChatSession> aiChatSessionsList = aiService.getAiChatSessionsList(userNo);
		
		session.setAttribute("aiChatSessionsList", aiChatSessionsList);
		
		return "ai/aiMain";
	}
	
	@GetMapping("/getPrompt/1")
	@ResponseBody
	public Map<String, String> getPromptGPT(
			String prompt,
			int sessionNo,
			RedirectAttributes ra,
			Authentication auth
			) {
		System.out.println("ChatGPT responds");
		Member loginUser = (Member)auth.getPrincipal();
		int userNo = loginUser.getUserNo();
		int modelNo = 1;
		long tokensUsed = 0;
		
		Map<String, Object> aiParamMap = new HashMap<>();
		aiParamMap.put("userNo", userNo);
		aiParamMap.put("modelNo", modelNo);
		aiParamMap.put("sessionNo", sessionNo);
		aiParamMap.put("tokensUsed", tokensUsed);
		aiParamMap.put("title", null);
		
		// 1. 해당 유저가 해당 모델을 사용한적이 있는지 DB에서 확인한다.
		int usedBefore = aiService.checkUsedBefore(aiParamMap);
		
		// 2. 사용한적이 없으면 ai_usage 테이블 insert.		
		if (usedBefore == 0) {
			int insertAiUsageResult = aiService.insertAiUsage(aiParamMap);
		}
		
		// 업무로직
		// 1. 만약 sessionNo 가 0 이라면, 새로운 세션을 생성(ai_chat_session 테이블에 행 삽입).
		//    아니라면 해당 세션의 데이터를 업데이트.
		List<Map<String, String>> messageHistory = new ArrayList<>();
		
		if (sessionNo != 0) {
			List<AiChatHistory> list = aiService.getChatHistory(sessionNo);
			for (AiChatHistory history : list) {
				Map<String, String> message = new HashMap<>();
				message.put("role", history.getRole());
				message.put("content", history.getContent());
				messageHistory.add(message);
			}
		}
		
		// Add the new user message to history
		Map<String, String> userMessage = new HashMap<>();
		userMessage.put("role", "user");
		userMessage.put("content", prompt);
		messageHistory.add(userMessage);
		
		ChatCompletionCreateParams.Builder paramsBuilder = ChatCompletionCreateParams.builder().model(ChatModel.of("gpt-5-nano")).addDeveloperMessage(
				"Always respond in HTML format, wrapped in a single <div>...</div>. " +
	            "Use semantic HTML for line breaks/headings/emphasis. Your name is ChatGPT. " +
	            "Do not include <script> or event handlers."
				);
		
		// Add all messages from history
		for (Map<String, String> msg : messageHistory) {
			if ("user".equals(msg.get("role"))) {
				paramsBuilder.addUserMessage(msg.get("content"));
			} else if ("assistant".equals(msg.get("role"))) {
				paramsBuilder.addAssistantMessage(msg.get("content"));
			}
		}
		
		ChatCompletionCreateParams params = paramsBuilder.build();
		ChatCompletion chatCompletion = client.chat().completions().create(params);
		
		StringBuilder sb = new StringBuilder();
		chatCompletion.choices().get(0).message().content().ifPresent(v -> sb.append(v));
		
		// Add the AI's response to conversation history
		Map<String, String> assistantMessage = new HashMap<>();
		assistantMessage.put("role", "assistant");
		assistantMessage.put("content", sb.toString());
		messageHistory.add(assistantMessage);
		
		tokensUsed += chatCompletion.usage()
			    .map(v -> v.totalTokens())
			    .orElse(0L);
		
		if (sessionNo == 0) {
			int createChatSessionResult = aiService.createChatSession(aiParamMap);
			sessionNo = Integer.parseInt(aiParamMap.get("sessionNo").toString());
			
			// create title
			List<Map<String, String>> CreateTitleList = new ArrayList<>();
			
			Map<String, String> createTitleDeveloperMessage = new HashMap<>();
			createTitleDeveloperMessage.put("role", "developer");
			createTitleDeveloperMessage.put(
					"content", "Create ONLY a short title in the language of the user prompt. " +
					"The title MUST be less than 30 characters, including spaces. " +
					"Do not add quotes, punctuation, or extra words. " +
					"Output the title only — nothing else."
					);
			CreateTitleList.add(createTitleDeveloperMessage);
			
			Map<String, String> createTitleUserMessage = new HashMap<>();
			createTitleUserMessage.put("role", "user");
			createTitleUserMessage.put("content", prompt);
			CreateTitleList.add(createTitleUserMessage);
			
			Map<String, String> createTitleAssistantMessage = new HashMap<>();
			createTitleAssistantMessage.put("role", "assistant");
			createTitleAssistantMessage.put("content", sb.toString());
			CreateTitleList.add(createTitleAssistantMessage);
			
			ChatCompletionCreateParams.Builder titleParamsBuilder = ChatCompletionCreateParams.builder().model(ChatModel.of("gpt-5-nano"));
			
			for (Map<String, String> msg : CreateTitleList) {
				if ("developer".equals(msg.get("role"))) {
					titleParamsBuilder.addDeveloperMessage(msg.get("content"));
				} else if ("user".equals(msg.get("role"))) {
					titleParamsBuilder.addUserMessage(msg.get("content"));
				} else if ("assistant".equals(msg.get("role"))) {
					titleParamsBuilder.addAssistantMessage(msg.get("content"));
				}
			}
			
			ChatCompletionCreateParams titleParams = titleParamsBuilder.build();
			ChatCompletion titleCompletion = client.chat().completions().create(titleParams);
			StringBuilder sbTitle = new StringBuilder();
			titleCompletion.choices().get(0).message().content().ifPresent(v -> sbTitle.append(v));
			
			tokensUsed += titleCompletion.usage()
				    .map(v -> v.totalTokens())
				    .orElse(0L);
			
			aiParamMap.put("title", sbTitle.toString());
		}
		aiParamMap.put("tokensUsed", tokensUsed);
		
		// ai_chat_session 테이블 업데이트.		
		int updateChatSessionResult = aiService.updateChatSession(aiParamMap);
		
		// ai_usage 테이블 업데이트.
		int updateAiUsageResult = aiService.updateAiUsage(aiParamMap);
		
		// ai_chat_history 테이블에 데이터 삽입.
		Map<String, Object> chatHistoryParamMap = new HashMap<>();
		chatHistoryParamMap.put("userNo", userNo);
		chatHistoryParamMap.put("sessionNo", sessionNo);
		chatHistoryParamMap.put("user", prompt);
		chatHistoryParamMap.put("assistant", sb.toString());
		
		int insertAiChatHistoryResult = aiService.insertAiChatHistory(chatHistoryParamMap);
		
		assistantMessage.put("sessionNo", "" + aiParamMap.get("sessionNo"));
		
		return assistantMessage;
	}
	
	@GetMapping("/getPrompt/2")
	@ResponseBody
	public Map<String, String> getPromptGemini(
			String prompt,
			int sessionNo,
			RedirectAttributes ra,
			Authentication auth
			) {
		System.out.println("Gemini responds");
		Member loginUser = (Member)auth.getPrincipal();
		int userNo = loginUser.getUserNo();
		int modelNo = 2;
		long tokensUsed = 0;
		
		Map<String, Object> aiParamMap = new HashMap<>();
		aiParamMap.put("userNo", userNo);
		aiParamMap.put("modelNo", modelNo);
		aiParamMap.put("sessionNo", sessionNo);
		aiParamMap.put("tokensUsed", tokensUsed);
		aiParamMap.put("title", null);
		
		// 1. 해당 유저가 해당 모델을 사용한적이 있는지 DB에서 확인한다.
		int usedBefore = aiService.checkUsedBefore(aiParamMap);
		
		// 2. 사용한적이 없으면 ai_usage 테이블 insert.		
		if (usedBefore == 0) {
			int insertAiUsageResult = aiService.insertAiUsage(aiParamMap);
		}
		
		List<Content> geminiMessageHistory = new ArrayList<>();
		
		if (sessionNo != 0) {
			List<AiChatHistory> list = aiService.getChatHistory(sessionNo);

			for (AiChatHistory history : list) {
				if (history.getRole().equals("user")) {
					Content promptContent = Content.builder().role("user").parts(
							Part.fromText(history.getContent())
							).build();
					geminiMessageHistory.add(promptContent);
				} else if (history.getRole().equals("assistant")) {
					Content responseContent = Content.builder().role("model").parts(
							Part.fromText(history.getContent())
							).build();
					geminiMessageHistory.add(responseContent);
				}			
			}
		}
		
		// 업무로직
		// 1. 만약 sessionNo 가 0 이라면, 새로운 세션을 생성(ai_chat_session 테이블에 행 삽입).
		//    아니라면 해당 세션의 데이터를 업데이트.
		Content promptContent = Content.builder().role("user").parts(
				Part.fromText(prompt)
				).build();
		geminiMessageHistory.add(promptContent);
		
		Content systemInstruction = Content.fromParts(
				Part.fromText(
						"Always respond in HTML format, wrapped in a single <div>...</div>. " +
			            "Use semantic HTML for line breaks/headings/emphasis. Your name is Gemini. " +
			            "Do not include <script> or event handlers."
						)
				);
		GenerateContentConfig config = GenerateContentConfig.builder().systemInstruction(systemInstruction).build();
		
		GenerateContentResponse response = geminiClient.models.generateContent("gemini-2.5-flash-lite", geminiMessageHistory, config);
		
		Content responseContent = Content.builder().role("model").parts(
				Part.fromText(response.text())
				).build();
		geminiMessageHistory.add(responseContent);
		
		tokensUsed += response.usageMetadata().get().totalTokenCount().get();
		
		if (sessionNo == 0) {
			int createChatSessionResult = aiService.createChatSession(aiParamMap);
			sessionNo = Integer.parseInt(aiParamMap.get("sessionNo").toString());
			
			Content titleSystemInstruction = Content.fromParts(
					Part.fromText(
							"Create ONLY a short title in the language of the user prompt. " +
							"The title MUST be less than 30 characters, including spaces. " +
							"Do not add quotes, punctuation, or extra words. " +
							"Output the title only — nothing else."
							)
					);
			GenerateContentConfig titleConfig = GenerateContentConfig.builder().systemInstruction(titleSystemInstruction).build();
			String promptAndResponse = "User prompt: " + prompt + "\n" + "Model response: " + response.text();
			
			GenerateContentResponse titleResponse = geminiClient.models.generateContent("gemini-2.5-flash-lite", promptAndResponse, titleConfig);
			tokensUsed += titleResponse.usageMetadata().get().totalTokenCount().get();
			
			aiParamMap.put("title", titleResponse.text());
		}
		aiParamMap.put("tokensUsed", tokensUsed);
		
		// ai_chat_session 테이블 업데이트.	
		int updateChatSessionResult = aiService.updateChatSession(aiParamMap);
		
		// ai_usage 테이블 업데이트.
		int updateAiUsageResult = aiService.updateAiUsage(aiParamMap);
		
		// ai_chat_history 테이블에 데이터 삽입.
		Map<String, Object> chatHistoryParamMap = new HashMap<>();
		chatHistoryParamMap.put("userNo", userNo);
		chatHistoryParamMap.put("sessionNo", sessionNo);
		chatHistoryParamMap.put("user", prompt);
		chatHistoryParamMap.put("assistant", response.text());
		
		int insertAiChatHistoryResult = aiService.insertAiChatHistory(chatHistoryParamMap);
		
		Map<String, String> assistantMessage = new HashMap<>();
		assistantMessage.put("role", "assistant");
		assistantMessage.put("content", response.text());
		
		assistantMessage.put("sessionNo", "" + aiParamMap.get("sessionNo"));
		
		return assistantMessage;
	}
	
	@GetMapping("/sessionListFragment")
	public String getSessionListFragment(
			Model model,
			Authentication auth
			) {
		Member loginUser = (Member)auth.getPrincipal();
	    int userNo = loginUser.getUserNo(); // 실제로는 세션 등에서 가져오기
	    List<AiChatSession> aiChatSessionsList = aiService.getAiChatSessionsList(userNo);
	    model.addAttribute("aiChatSessionsList", aiChatSessionsList);
	    
	    return "ai/sessionListFragment"; // JSP 파일명, 예: ai/sessionListFragment.jsp
	}
	
	@GetMapping("/getChatHistory")
	@ResponseBody
	public List<AiChatHistory> getChatHistory(
			int sessionNo
			) {
		List<AiChatHistory> list = aiService.getChatHistory(sessionNo);
		
	    // DB에서 해당 sessionNo의 전체 메시지 SELECT
	    return list; 
	}
	
	@GetMapping("/sessionDelete")
	@ResponseBody
	public int sessionDelete(
			int sessionNo
			) {
		return aiService.sessionDelete(sessionNo);
	}
}









