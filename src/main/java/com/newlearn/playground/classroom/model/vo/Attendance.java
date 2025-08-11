package com.newlearn.playground.classroom.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Attendance {
	private int userNo;
	private int classNo;
	private Date entryTime;
	private Date exitTime;
	private String attStatus;
	
	private String selectedDate;
}
