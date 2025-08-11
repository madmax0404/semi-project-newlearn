package com.newlearn.playground.event.vo;

import java.util.Date;

import com.newlearn.playground.common.Utils;
import com.newlearn.playground.common.XssCleanable;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Event implements XssCleanable {
	private int eventNo;
	private Integer classNo;
	private int userNo;
	private String eventName;
	private Date startDate;
	private Date endDate;
	private String content;
	private String place;
	private Date createDate;

	public enum EventType {
		SHARED, PERSONAL
	}
	private EventType eventType;
	
	private String visibility;
	private int numPpl;
	private Date joinDeadline;
	
	private String userName;
	private String type;
	
	@Override
	public void xssHandling() {
		this.eventName = Utils.XSSHandling(this.eventName);
		this.content = Utils.XSSHandling(this.content);
		this.place = Utils.XSSHandling(this.place);		
	}
	
	@Override
	public void newLineHandling() {
		this.content = Utils.newLineHandling(this.content);
	}
	
	@Override
	public void clearNewLine() {
		this.content = Utils.newLineClear(this.content);
	}
	
}
