package com.newlearn.playground.board.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AssignmentSubmission {

	private int submissionNo;
	private int assignmentNo;
	private int userNo;
	private Date submissionDate;
	private int boardNo;
}
