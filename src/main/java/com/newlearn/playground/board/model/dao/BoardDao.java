package com.newlearn.playground.board.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.newlearn.playground.board.model.vo.Assignment;
import com.newlearn.playground.board.model.vo.AssignmentSubmission;
import com.newlearn.playground.board.model.vo.Board;
import com.newlearn.playground.board.model.vo.BoardExt;
import com.newlearn.playground.board.model.vo.BoardFile;
import com.newlearn.playground.board.model.vo.BoardType;
import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.teacher.model.vo.TeacherReport;

public interface BoardDao {

	int selectListCount(Map<String, Object> paramMap);

	List<Board> selectList(PageInfo pi, Map<String, Object> paramMap);

	int insertBoard(SqlSession sqlSession, Board board);
	
	int insertBoardImage(SqlSession sqlSession, BoardFile file);
	
	int insertBoardReturnBoardNo(Board board);

	int insertAssignmentSubmission(AssignmentSubmission sub);

	void insertBoardFile(BoardFile file);

	int increaseCount(int boardNo);

	BoardExt selectBoard(int boardNo);

	boolean hasUserLiked(int boardNo, int userNo);

	int insertBoardLike(int boardNo, int userNo);

	int selectLikeCount(int boardNo);

	int increaseBoardLike(int boardNo);

	List<BoardFile> selectFilesByBoardNo(int boardNo);

	// 게시글수정
	int updateBoard(Board board);

	int deleteFilesByRefBno(int boardNo);

	void deleteBoard(int boardNo);

	int insertBoardReport(TeacherReport report);


	
	
	


	

	
	
	




	

}
