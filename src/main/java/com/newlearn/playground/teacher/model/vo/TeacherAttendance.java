package com.newlearn.playground.teacher.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class TeacherAttendance {
	private int attNo;
	private int userNo;
	private String userName;
	private Date entryTime;
	private Date exitTime;
	private String attStatus;
	private String note;
}
