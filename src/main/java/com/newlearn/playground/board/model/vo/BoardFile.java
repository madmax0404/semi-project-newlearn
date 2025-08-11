package com.newlearn.playground.board.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
@AllArgsConstructor
public class BoardFile {
	private int fileNo;
	private String originName; 
	private String changeName; 
	private int refBno; 
	private int fileLevel;
	private String fileType;
}









