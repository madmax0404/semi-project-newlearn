package com.newlearn.playground.ai.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.newlearn.playground.ai.model.dao.AiDao;
import com.newlearn.playground.ai.model.vo.Ai;
import com.newlearn.playground.ai.model.vo.AiChatHistory;
import com.newlearn.playground.ai.model.vo.AiChatSession;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AiServiceImpl implements AiService {
	private final AiDao aiDao;

	@Override
	public List<Ai> getAiList() {
		return aiDao.getAiList();
	}

	@Override
	public int checkUsedBefore(Map<String, Object> aiParamMap) {
		return aiDao.checkUsedBefore(aiParamMap);
	}

	@Override
	public List<AiChatSession> getAiChatSessionsList(int userNo) {
		return aiDao.getAiChatSessionsList(userNo);
	}

	@Override
	public int updateAiUsage(Map<String, Object> aiParamMap) {
		return aiDao.updateAiUsage(aiParamMap);
	}

	@Override
	public int insertAiUsage(Map<String, Object> aiParamMap) {
		return aiDao.insertAiUsage(aiParamMap);
	}

	@Override
	public int createChatSession(Map<String, Object> aiParamMap) {
		return aiDao.createChatSesion(aiParamMap);
	}

	@Override
	public int updateChatSession(Map<String, Object> aiParamMap) {
		return aiDao.updateChatSession(aiParamMap);
	}

	@Override
	@Transactional(rollbackFor = {Exception.class})
	public int insertAiChatHistory(Map<String, Object> chatHistoryParamMap) {
		int result = 0;
		result = aiDao.insertAiChatHistoryUser(chatHistoryParamMap);
		result = aiDao.insertAiChatHistoryAssistant(chatHistoryParamMap);
		
		return result;
	}

	@Override
	public List<AiChatHistory> getChatHistory(int sessionNo) {
		return aiDao.getChatHistory(sessionNo);
	}

	@Override
	public int sessionDelete(int sessionNo) {
		return aiDao.sessionDelete(sessionNo);
	}

}
