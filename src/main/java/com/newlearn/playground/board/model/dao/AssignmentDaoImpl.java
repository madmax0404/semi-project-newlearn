package com.newlearn.playground.board.model.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.board.model.service.AssignmentService;
import com.newlearn.playground.board.model.vo.Assignment;

@Repository
public class AssignmentDaoImpl implements AssignmentDao{

	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public List<Assignment> getAllAssignment() {
		return sqlSession.selectList("assignment.getAllAssignments");
	}

	@Override
	public Assignment getAssignmentByBoardNo(int boardNo) {
		return sqlSession.selectOne("assignment.getAssignmentByBoardNo", boardNo);
	}

	@Override
	public List<Assignment> selectAssignmentsByClassNo(int classNo) {
		return sqlSession.selectList("assignment.selectAssignmentsByClassNo", classNo);
	}

	@Override
	public List<Assignment> selectAssignmentsWithFileByClassNo(int classNo) {
		return sqlSession.selectList("assignment.selectAssignmentsWithFileByClassNo", classNo);
	}
	
}

	