package com.newlearn.playground.board.model.service;

import java.util.List;

import com.newlearn.playground.board.model.vo.Assignment;

public interface AssignmentService {

	// 전체 과제 조회
	List<Assignment> getAllAssignment();
	// boardNo로 과제 정보 조회
	Assignment getAssignmentByBoardNo(int boardNo);
	// classno별 과제 정보 조회
	List<Assignment> getAssignmentsByClassNo(int classNo);

	List<Assignment> getAssignmentsWithFileByClassNo(int classNo);


	

	

}
