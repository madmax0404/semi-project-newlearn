package com.newlearn.playground.teacher.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class TeacherClass {
	private int classNo;
	private String className;
	private int teacherNo;
	private String entryCode;
	private Date createDate;
	private String classCode;
}
