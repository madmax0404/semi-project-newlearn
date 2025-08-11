package com.newlearn.playground.friend.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Friend {
	
	    private int userNo;          // 요청 보낸 사람
	    private int friendUserNo;    // 요청 받은 사람
	    private String responseStatus;       // WAITING / ACCEPTED / REJECTED
	    private String favorite;
	    private Date requestDate;
	    private Date responseDate;
	    private String hidden;
	}


