package com.newlearn.playground.board.model.vo;

import java.util.Date;

import com.newlearn.playground.teacher.model.vo.TeacherUploadFile;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Assignment {
	private int assignmentNo;
	private int classNo;
	private String assignmentTitle;
	private String assignmentDetails;
	private Date createDate;
	private Date startDate;
	private Date endDate;
	private String deleted;
	private int fileNo;
	
	private TeacherUploadFile uploadFile;
}
