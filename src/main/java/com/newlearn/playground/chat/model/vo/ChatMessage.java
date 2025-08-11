package com.newlearn.playground.chat.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class ChatMessage {
	private int messageNo;
	private String content;
	private Date sendDate;
	private int chatRoomNo;
	private int userNo;
	
	private String userName;
}
