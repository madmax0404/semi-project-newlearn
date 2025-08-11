package com.newlearn.playground.chat.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.chat.model.vo.ChatImageDTO;
import com.newlearn.playground.chat.model.vo.ChatMessage;
import com.newlearn.playground.chat.model.vo.ChatMessageDTO;
import com.newlearn.playground.chat.model.vo.ChattingRoom;
import com.newlearn.playground.chat.model.vo.ChattingRoomDTO;
import com.newlearn.playground.chat.model.vo.ChatFriend;
import com.newlearn.playground.chat.model.vo.FriendDTO;
import com.newlearn.playground.common.model.vo.PageInfo;

@Repository
public class ChattingRoomListDaoImpl implements ChattingRoomListDao{
	@Autowired
	private SqlSessionTemplate session;

	@Override
	public List<FriendDTO> selectFriendList(int userNo) {
		// 친구 목록 조회
		return session.selectList("chat.selectFriendList",userNo);
	}
	
	@Override
	public List<ChattingRoom> selectChattingRoomList(int userNo) {
		// 채팅방 목록 조회
		return session.selectList("chat.selectChattingRoomList",userNo);
	}

	@Override
	public int createRoom(Map<String, Object> createRoomInf) {
		return session.insert("chat.createRoom",createRoomInf);
	}
	
	@Override
	public int insertUserJoin(Map<String, Object> createRoomInf) {
		return session.insert("chat.insertUserJoin",createRoomInf);
	}

	@Override
	public int insertFriendJoin(Map<String, Object> createRoomInf) {
		return session.insert("chat.insertFriendJoin", createRoomInf);
	}

	@Override
	public List<ChatFriend> friendProfile(int friendNo) {
		// 친구 프로필 조회
		return session.selectList("chat.friendProfile",friendNo);
	}

	@Override
	public List<FriendDTO> selectRoomMembers(Map<String, Object> param) {
		return session.selectList("chat.chatRoomMembers",param);
	}

	@Override
	public List<ChatMessageDTO> chatMessageList(Map<String, Object> param) {
		return session.selectList("chat.chatMessageList",param);
	}

	@Override
	public int checkUserJoin(Map<String, Object> param) {
		return session.insert("chat.checkUserJoin" , param);
	}

	@Override
	public int insertChatMessage(ChatMessage cm) {
		return session.insert("chat.insertChatMessage",cm);
	}

	@Override
	public int insertImage(ChatImageDTO dto) {
		return session.insert("chat.insertImage",dto);
	}

	@Override
	public int insertChatImage(HashMap<String, Integer> param) {
		return session.insert("chat.insertChatImage",param);
	}

	@Override
	public int updateChatMessage(ChatMessage cm) {
		return session.update("chat.updateChatMessage",cm);
	}

	@Override
	public int roomExit(Map<String, Object> param) {
		return session.delete("chat.roomExit", param);
	}

	@Override
	public int updateChatContent(ChatMessage cm) {
		return session.update("chat.updateChatContent",cm);
	}

	@Override
	public int deleteChatContent(ChatMessage cm) {
		return session.update("chat.deleteChatContent",cm);
	}

	// 은성이의 똥코드 (채팅 답장)
	@Override
	public int replyChatContent(ChatMessage cm) {
		return session.insert("chat.replyChatContent",cm);
	}

	@Override
	public ChattingRoomDTO selectChatRoom(Map<String, Object> param) {
		return session.selectOne("chat.selectChatRoom", param);
	}
	
}
