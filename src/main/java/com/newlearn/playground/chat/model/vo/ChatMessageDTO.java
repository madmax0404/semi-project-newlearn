package com.newlearn.playground.chat.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class ChatMessageDTO {
	private int messageNo;
	private String content;
	private String userName;
	private String profile;
	private String attachment;
	private int userNo;
	private String isNoti;
	private String notification;
	private String notiDate;
}
