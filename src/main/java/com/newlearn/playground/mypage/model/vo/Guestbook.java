package com.newlearn.playground.mypage.model.vo;

import java.util.Date;

import com.newlearn.playground.common.Utils;
import com.newlearn.playground.common.XssCleanable;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Guestbook implements XssCleanable {
	private int guestbookNo;
	private int mypageNo;
	private int userNo;
	private String content;
	private Date createDate;
	private String visibilitiy;
	private String deleted;
	
	private String userName;

	@Override
	public void xssHandling() {
		this.content = Utils.XSSHandling(this.content);
	}

	@Override
	public void newLineHandling() {
		this.content = Utils.newLineHandling(this.content);
	}

	@Override
	public void clearNewLine() {
		this.content = Utils.newLineClear(this.content);
	}
}
