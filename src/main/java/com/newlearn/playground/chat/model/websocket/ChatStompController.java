package com.newlearn.playground.chat.model.websocket;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.multipart.MultipartFile;

import com.newlearn.playground.chat.model.service.ChattingRoomListService;
import com.newlearn.playground.chat.model.vo.ChatImageDTO;
import com.newlearn.playground.chat.model.vo.ChatMessage;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequiredArgsConstructor
public class ChatStompController {
	private final SimpMessagingTemplate template;
	
	@Autowired
	private ChattingRoomListService service;
	
	@MessageMapping("/chat/sendMessage")
	public void sendMessage(
			@Payload ChatMessage cm
			) {
		int result = service.insertChatMessage(cm);
		
		template.convertAndSend("/topic/chatroom/" + cm.getChatRoomNo(), cm);
	}
	
	@MessageMapping("/chatMessage/{messageNo}/notification")
	public void enrollNotification(@DestinationVariable int messageNo , @Payload ChatMessage cm) {	
		int result = service.updateChatMessage(cm);
		log.debug("chatMessage >>> {}",cm);
		template.convertAndSend("/topic/chatroom/" + cm.getChatRoomNo()+"/notification", cm);
	}
	
	@MessageMapping("/chatMessage/{messageNo}/update")
	public void updateChatMessage(@DestinationVariable int messageNo , @Payload ChatMessage cm) {	
		// 수정시 매 유저번호와 메시지의 유저번호가 일치할 때 수정되게
		// xss+new line처리 필요
		int result = service.updateChatContent(cm);
		log.debug("chatMessage >>> {}",cm);
		template.convertAndSend("/topic/chatroom/" + cm.getChatRoomNo()+"/update", cm);
	}
	
	@MessageMapping("/chatMessage/{messageNo}/delete")
	public void deleteChatMessage(@DestinationVariable int messageNo , @Payload ChatMessage cm) {	
		// 수정시 매 유저번호와 메시지의 유저번호가 일치할 때 수정되게
		// xss+new line처리 필요
		int result = service.deleteChatContent(cm);
		log.debug("chatMessage >>> {}",cm);
		template.convertAndSend("/topic/chatroom/" + cm.getChatRoomNo()+"/delete", cm);
	}
	
	// 은성이의 똥코드 (채팅 답장)
	@MessageMapping("/chatMessage/{messageNo}/reply")
	public void replyChatMessage(@DestinationVariable int messageNo ,@Payload ChatMessage cm) {
		int result = service.replyChatContent(cm);
		log.debug("chatMessage >>> {}",cm);
		template.convertAndSend("/topic/chatroom/" + cm.getChatRoomNo()+"/reply", cm);
		
	}
	
}









