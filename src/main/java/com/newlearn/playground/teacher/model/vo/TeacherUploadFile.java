package com.newlearn.playground.teacher.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class TeacherUploadFile {
	private int fileNo;
	private String originName;
	private String changeName;
	private String visibility;
	private Date createDate;
	private long fileSize;
	private String deleted;
	private String source;
	private int sourceNo;
	private int userNo;
}
