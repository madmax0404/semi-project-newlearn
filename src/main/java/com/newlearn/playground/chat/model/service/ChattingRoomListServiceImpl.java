package com.newlearn.playground.chat.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.newlearn.playground.chat.model.dao.ChattingRoomListDao;
import com.newlearn.playground.chat.model.vo.ChatImageDTO;
import com.newlearn.playground.chat.model.vo.ChatMessage;
import com.newlearn.playground.chat.model.vo.ChatMessageDTO;
import com.newlearn.playground.chat.model.vo.ChattingRoom;
import com.newlearn.playground.chat.model.vo.ChattingRoomDTO;
import com.newlearn.playground.chat.model.vo.ChatFriend;
import com.newlearn.playground.chat.model.vo.FriendDTO;
import com.newlearn.playground.common.model.vo.PageInfo;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ChattingRoomListServiceImpl implements ChattingRoomListService{
	@Autowired
	private ChattingRoomListDao crd;
	
	@Override
	public List<FriendDTO> selectFriendList(int userNo) {
		// 친구 목록 조회
		return crd.selectFriendList(userNo);
	}
	
	@Override
	public List<ChattingRoom> selectChattingRoomList(int userNo) {
		// 채팅방 목록 조회
		return crd.selectChattingRoomList(userNo);
	}
	
	@Transactional(rollbackFor = Exception.class)
	@Override
	public int createRoom(Map<String, Object> createRoomInf) {
		int result = 0;
		// CHAT_ROOM 테이블에 방만들기 입력값 추가
		result += crd.createRoom(createRoomInf);
		
		// CHAT_JOIN에 방장 정보 추가
		result += crd.insertUserJoin(createRoomInf);
		
		// CHAT_JOIN에 선택한 친구 정보 추가
		List<Integer> selectFriendList = (List<Integer>)createRoomInf.get("selectFriendList");
		if(selectFriendList != null && !selectFriendList.isEmpty()) {
			result += crd.insertFriendJoin(createRoomInf);
		}
		
		return result;
	}

	@Override
	public List<ChatFriend> friendProfile(int friendNo) {
		return crd.friendProfile(friendNo);
	}

	@Override
	public int insertUserJoin(Map<String, Object> param) {
		// 현재 참여정보가 존재하는 경우 , insert 하지않는다.
		int result= crd.checkUserJoin(param);
		
		if(result == 0) result = crd.insertUserJoin(param);
		
		return result;
	}

	@Override
	public List<FriendDTO> selectRoomMembers(Map<String, Object> param) {
		return crd.selectRoomMembers(param);
	}

	@Override
	public List<ChatMessageDTO> chatMessageList(Map<String, Object> param) {
		return crd.chatMessageList(param);
	}

	@Override
	public int insertChatMessage(ChatMessage cm) {
		return crd.insertChatMessage(cm);
	}
	
	@Transactional(rollbackFor = Exception.class)
	@Override
	public int insertChatImage(ChatImageDTO dto, ChatMessage cm) {
		// 1. 챗매세지
		int result = crd.insertChatMessage(cm);
		
		if(result == 0) {
			throw new RuntimeException("메시지 등록 실패");
		}
		
		// 2. 이미지
		result = crd.insertImage(dto);
		if(result == 0) {
			throw new RuntimeException("이미지 등록 실패");
		}
		HashMap<String, Integer> param = new HashMap<>();
		param.put("messageNo", cm.getMessageNo());
		param.put("imgNo", dto.getImgNo());
		
		// 3. 챗 이미지
		result = crd.insertChatImage(param);
		if(result == 0) {
			throw new RuntimeException("이미지 등록 실패");
		}
		
		return result;
	}

	@Override
	public int updateChatMessage(ChatMessage cm) {
		return crd.updateChatMessage(cm);
	}

	@Override
	public int roomExit(Map<String, Object> param) {
		return crd.roomExit(param);
	}

	@Override
	public int updateChatContent(ChatMessage cm) {
		return crd.updateChatContent(cm);
	}

	@Override
	public int deleteChatContent(ChatMessage cm) {
		return crd.deleteChatContent(cm);
	}

	// 은성이의 똥코드 (채팅 답장)
	@Override
	public int replyChatContent(ChatMessage cm) {
		return crd.replyChatContent(cm);
	}

	@Override
	public ChattingRoomDTO selectChatRoom(Map<String, Object> param) {
		return crd.selectChatRoom(param);
	}
	
}
