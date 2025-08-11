package com.newlearn.playground.ai.model.service;

import java.util.List;
import java.util.Map;

import com.newlearn.playground.ai.model.vo.Ai;
import com.newlearn.playground.ai.model.vo.AiChatHistory;
import com.newlearn.playground.ai.model.vo.AiChatSession;

public interface AiService {

	List<Ai> getAiList();

	int checkUsedBefore(Map<String, Object> aiParamMap);

	List<AiChatSession> getAiChatSessionsList(int userNo);

	int updateAiUsage(Map<String, Object> aiParamMap);

	int insertAiUsage(Map<String, Object> aiParamMap);

	int createChatSession(Map<String, Object> aiParamMap);

	int updateChatSession(Map<String, Object> aiParamMap);

	int insertAiChatHistory(Map<String, Object> chatHistoryParamMap);

	List<AiChatHistory> getChatHistory(int sessionNo);

	int sessionDelete(int sessionNo);

}
