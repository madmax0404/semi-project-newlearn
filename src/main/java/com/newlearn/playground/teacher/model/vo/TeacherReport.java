package com.newlearn.playground.teacher.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class TeacherReport {
	private int reportNo;
	private int reporterUserNo;
	private String reporterUserName;
	private int reportedUserNo;
	private String reportedUserName;
	private String reportType;
	private int refNo;
	private String reportContent;
	private Date reportTime;
	private String reportStatus;
	private String link;
	private int classNo;
}
