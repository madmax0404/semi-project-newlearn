package com.newlearn.playground.ai.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class AiChatHistory {
	private int historyNo;
	private int sessionNo;
	private String role;
	private String content;
	private Date createdDate;
	private int userNo;
}
