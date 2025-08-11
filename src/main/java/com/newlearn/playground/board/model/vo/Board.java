package com.newlearn.playground.board.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Board {
	private int boardNo;
	private int classNo;
	private String userNo;
	private String category;
	private String boardTitle; 
	private Date createDate;
	private Date updateDate;
	private int viewCount;
	private int likeCount;
	private String deleted;
	private String userName;
	private String thumbnail;
	private String boardContent;
}









