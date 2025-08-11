package com.newlearn.playground.teacher.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Student {
	private int userNo;
	private String userName;
	private String userId;
	private String email;
	private Date classJoinDate;
	private String memberStatus;
}
