package com.newlearn.playground.ai.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.ai.model.vo.Ai;
import com.newlearn.playground.ai.model.vo.AiChatHistory;
import com.newlearn.playground.ai.model.vo.AiChatSession;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AiDaoImpl implements AiDao {
	private final SqlSessionTemplate session;

	@Override
	public List<Ai> getAiList() {
		return session.selectList("ai.getAiList", "modelNo");
	}

	@Override
	public int checkUsedBefore(Map<String, Object> aiParamMap) {
		return session.selectOne("ai.checkUsedBefore", aiParamMap);
	}

	@Override
	public List<AiChatSession> getAiChatSessionsList(int userNo) {
		return session.selectList("ai.getAiChatSessionsList", userNo);
	}

	@Override
	public int updateAiUsage(Map<String, Object> aiParamMap) {
		return session.update("ai.updateAiUsage", aiParamMap);
	}

	@Override
	public int insertAiUsage(Map<String, Object> aiParamMap) {
		return session.insert("ai.insertAiUsage", aiParamMap);
	}

	@Override
	public int createChatSesion(Map<String, Object> aiParamMap) {
		return session.insert("ai.createChatSesion", aiParamMap);
	}

	@Override
	public int updateChatSession(Map<String, Object> aiParamMap) {
		return session.update("ai.updateChatSession", aiParamMap);
	}

	@Override
	public int insertAiChatHistoryUser(Map<String, Object> chatHistoryParamMap) {
		return session.insert("ai.insertAiChatHistoryUser", chatHistoryParamMap);
	}

	@Override
	public int insertAiChatHistoryAssistant(Map<String, Object> chatHistoryParamMap) {
		return session.insert("ai.insertAiChatHistoryAssistant", chatHistoryParamMap);
	}

	@Override
	public List<AiChatHistory> getChatHistory(int sessionNo) {
		return session.selectList("ai.getChatHistory", sessionNo);
	}

	@Override
	public int sessionDelete(int sessionNo) {
		return session.delete("ai.sessionDelete", sessionNo);
	}

}
