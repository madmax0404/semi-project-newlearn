package com.newlearn.playground.chat.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class ChatRoomJoin {
	private int userNo;
	private int chatRoomNo;
}
