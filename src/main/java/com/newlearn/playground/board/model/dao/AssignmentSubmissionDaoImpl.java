package com.newlearn.playground.board.model.dao;

import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.board.model.vo.AssignmentSubmission;
import com.newlearn.playground.board.model.vo.Board;
import com.newlearn.playground.board.model.vo.BoardFile;

@Repository
public class AssignmentSubmissionDaoImpl implements AssignmentSubmissionDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public AssignmentSubmission getSubmissionByBoardNo(int boardNo) {
		return sqlSession.selectOne("assignmentSubmission.getSubmissionByBoardNo", boardNo);
	}

	@Override
	public int updateAssignmentSubmission(AssignmentSubmission sub) {
		return sqlSession.update("assignmentSubmission.updateAssignmentSubmission", sub);
	}

	@Override
	public int updateBoard(Board board) {
		 return sqlSession.update("assignmentSubmission.updateBoard", board);
	}

	@Override
	public void deleteFilesByRefBno(int boardNo) {
		sqlSession.delete("assignmentSubmission.deleteFilesByRefBno", boardNo);
	}

	@Override
	public void insertBoardFile(BoardFile file) {
		sqlSession.insert("assignmentSubmission.insertBoardFile", file);
	}

}
