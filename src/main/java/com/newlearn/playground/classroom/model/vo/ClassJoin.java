package com.newlearn.playground.classroom.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ClassJoin {
	private int classJoinNo;
	private int classNo;
	private int userNo;
	private Date classJoinDate;
	private String classRole;
	private String accouncementNoti;
	private String assignmentNoti;
	private String sharedEventNoti;
	private String personalEventNoti;
}
