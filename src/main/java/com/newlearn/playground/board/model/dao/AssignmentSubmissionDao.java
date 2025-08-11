package com.newlearn.playground.board.model.dao;

import com.newlearn.playground.board.model.vo.AssignmentSubmission;
import com.newlearn.playground.board.model.vo.Board;
import com.newlearn.playground.board.model.vo.BoardFile;

public interface AssignmentSubmissionDao {

	AssignmentSubmission getSubmissionByBoardNo(int boardNo);

	int updateAssignmentSubmission(AssignmentSubmission sub);

	int updateBoard(Board board);

	void deleteFilesByRefBno(int boardNo);

	void insertBoardFile(BoardFile file);

}
