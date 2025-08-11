package com.newlearn.playground.board.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Reply {
	
	private int replyNo;
	private int boardNo;
	private String userNo;
	private String content;
	private int likeCount;
	private Date createDate;
	private Date modDate;
	private String deleted;
	private String userName;
}
