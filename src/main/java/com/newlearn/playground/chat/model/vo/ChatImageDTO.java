package com.newlearn.playground.chat.model.vo;

import java.util.Date;

import com.google.auto.value.AutoValue.Builder;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class ChatImageDTO {
	private String originName;
	private String changeName;
	private Date createDate;
	private int imgNo;
}
