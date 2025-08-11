package com.newlearn.playground.chat.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FriendDTO {
	private int userNo;
	private String changeName;
	private String userName;
	private String statusMessage;
	private int isOwner; 
}
