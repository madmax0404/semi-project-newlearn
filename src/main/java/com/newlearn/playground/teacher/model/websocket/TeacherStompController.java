package com.newlearn.playground.teacher.model.websocket;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.newlearn.playground.teacher.model.vo.TeacherChatMessage;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class TeacherStompController {
	private final SimpMessagingTemplate mTemplate;
	
	@MessageMapping("/sendToUser/{userNo}")
	public void sendMessage(
			@DestinationVariable int userNo,
			@Payload TeacherChatMessage message
			) {		
		mTemplate.convertAndSend("/topic/teacher/" + userNo, message);
	}
}
