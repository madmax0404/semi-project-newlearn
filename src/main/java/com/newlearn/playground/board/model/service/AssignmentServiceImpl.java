package com.newlearn.playground.board.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.newlearn.playground.board.model.dao.AssignmentDao;
import com.newlearn.playground.board.model.vo.Assignment;


import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AssignmentServiceImpl implements AssignmentService{
	
	 @Autowired
	 private final AssignmentDao assignmentDao;

	@Override
	public List<Assignment> getAllAssignment() {
		return assignmentDao.getAllAssignment();
	}

	@Override
	public Assignment getAssignmentByBoardNo(int boardNo) {
		return assignmentDao.getAssignmentByBoardNo(boardNo);
	}

	@Override
	public List<Assignment> getAssignmentsByClassNo(int classNo) {
		return assignmentDao.selectAssignmentsByClassNo(classNo);
	}

	@Override
	public List<Assignment> getAssignmentsWithFileByClassNo(int classNo) {
		 return assignmentDao.selectAssignmentsWithFileByClassNo(classNo);
	}
	
	 
	

}
