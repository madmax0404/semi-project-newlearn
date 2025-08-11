package com.newlearn.playground.ai.model.vo;

import java.io.Serializable;
import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class AiChatSession implements Serializable {
	private static final long serialVersionUID = 7956429820325527252L;
	private int sessionNo;
	private String title;
	private Date createdAt; // sql Date 타입임.
	private int userNo;
	private int modelNo;
	private Date lastUsedAt; // sql Date 타입임.
}
