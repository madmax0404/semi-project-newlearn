package com.newlearn.playground.teacher.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class TeacherAssignment {
	private int assignmentNo;
	private int classNo;
	private String assignmentTitle;
	private String assignmentDetails;
	private Date createDate;
	private Date startDate;
	private Date endDate;
	private int fileNo;
}
