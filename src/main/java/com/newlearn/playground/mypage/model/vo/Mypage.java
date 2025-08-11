package com.newlearn.playground.mypage.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Mypage {
	private int mypageNo;
	private int userNo;
	private String mypageName;
	private String statusMessage;
	private long maxStorage;
	
	private String userName;
}
