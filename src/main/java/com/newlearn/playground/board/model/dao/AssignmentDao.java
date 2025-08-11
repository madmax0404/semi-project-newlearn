package com.newlearn.playground.board.model.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.newlearn.playground.board.model.vo.Assignment;

public interface AssignmentDao {

	List<Assignment> getAllAssignment();

	Assignment getAssignmentByBoardNo(int boardNo);

	List<Assignment> selectAssignmentsByClassNo(int classNo);

	List<Assignment> selectAssignmentsWithFileByClassNo(int classNo);
}

