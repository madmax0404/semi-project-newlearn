package com.newlearn.playground.mypage.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UploadFile {
	private int fileNo;
//	private Integer submissionNo;
//	private Integer repoNo;
//	private Integer messageNo;
	private String originName;
	private String changeName;
	private String visibility;
	private Date createDate;
	private long fileSize; // db랑 자동으로 매핑 되나?
	private String deleted;
	
	private String source;
	private int sourceNo;
	private int userNo;
}
