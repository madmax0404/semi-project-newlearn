package com.newlearn.playground.mypage.model.vo;

import com.newlearn.playground.common.Utils;
import com.newlearn.playground.common.XssCleanable;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Repository implements XssCleanable {
	private int repoNo;
	private int mypageNo;
	private String dirName;
	private int parentRepoNo;
	
	private int level;

	@Override
	public void xssHandling() {
		this.dirName = Utils.XSSHandling(this.dirName);
	}

	@Override
	public void newLineHandling() {
		
	}

	@Override
	public void clearNewLine() {
		
	}
}
