package com.newlearn.playground.chat.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.newlearn.playground.chat.model.vo.ChatImageDTO;
import com.newlearn.playground.chat.model.vo.ChatMessage;
import com.newlearn.playground.chat.model.vo.ChatMessageDTO;
import com.newlearn.playground.chat.model.vo.ChattingRoom;
import com.newlearn.playground.chat.model.vo.ChattingRoomDTO;
import com.newlearn.playground.chat.model.vo.ChatFriend;
import com.newlearn.playground.chat.model.vo.FriendDTO;
import com.newlearn.playground.common.model.vo.PageInfo;

public interface ChattingRoomListDao {

	List<FriendDTO> selectFriendList(int userNo);
	
	List<ChattingRoom> selectChattingRoomList(int userNo);

	int createRoom(Map<String, Object> createRoomInf);
	int insertUserJoin(Map<String, Object> createRoomInf);
	int insertFriendJoin(Map<String,Object> createRoomInf);
	
	List<ChatFriend> friendProfile(int friendNo);

	List<FriendDTO> selectRoomMembers(Map<String, Object> param);

	List<ChatMessageDTO> chatMessageList(Map<String, Object> param);

	int checkUserJoin(Map<String, Object> param);
	
	int insertChatMessage(ChatMessage cm);

	int insertImage(ChatImageDTO dto);

	int insertChatImage(HashMap<String, Integer> param);

	int updateChatMessage(ChatMessage cm);

	int roomExit(Map<String, Object> param);

	int updateChatContent(ChatMessage cm);

	int deleteChatContent(ChatMessage cm);
	
	// 은성이의 똥코드 (채팅 답장)
	int replyChatContent(ChatMessage cm);

	ChattingRoomDTO selectChatRoom(Map<String, Object> param);

}
