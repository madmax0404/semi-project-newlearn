package com.newlearn.playground.classroom.model.vo;

import java.util.Date;

import com.newlearn.playground.common.Utils;
import com.newlearn.playground.common.XssCleanable;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Classroom implements XssCleanable {
	private int classNo;
	private String className;
	private int teacherNo;
	private String entryCode;
	private Date createDate;
	private String deleted;
	private String classCode;
	
	@Override
	public void xssHandling() {
		this.className = Utils.XSSHandling(this.className);
	}
	
	@Override
	public void newLineHandling() {
		
	}
	
	@Override
	public void clearNewLine() {
		
	}
}
