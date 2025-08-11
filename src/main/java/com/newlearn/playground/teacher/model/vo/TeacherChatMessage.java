package com.newlearn.playground.teacher.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class TeacherChatMessage {
	private String sender;
	private String content;
}
