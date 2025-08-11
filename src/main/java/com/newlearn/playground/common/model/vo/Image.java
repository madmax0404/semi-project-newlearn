package com.newlearn.playground.common.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Image {
	private int imgNo;
	private String originName;
	private String changeName;
	private Date createDate;
}
