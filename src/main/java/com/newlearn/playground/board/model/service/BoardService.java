package com.newlearn.playground.board.model.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import com.newlearn.playground.board.model.vo.Assignment;
import com.newlearn.playground.board.model.vo.AssignmentSubmission;
import com.newlearn.playground.board.model.vo.Board;
import com.newlearn.playground.board.model.vo.BoardExt;
import com.newlearn.playground.board.model.vo.BoardFile;
import com.newlearn.playground.board.model.vo.BoardType;
import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.teacher.model.vo.TeacherReport;

public interface BoardService {

	int selectListCount(Map<String, Object> paramMap);

	List<Board> selectList(PageInfo pi, Map<String, Object> paramMap);

	int insertBoard(Board board, List<BoardFile> fileList);

	int insertBoardReturnBoardNo(Board board, List<BoardFile> fileList);

	int insertAssignmentSubmission(AssignmentSubmission sub);

	// 게시판 상세보기 - 조회수
	int increaseCount(int boardNo);
	// 게시판 상세보기 - 게시글찾기	
	BoardExt selectBoard(int boardNo);

	// 추천수
	boolean hasUserLiked(int boardNo, int userNo);
	int insertBoardLike(int boardNo, int userNo);
	int selectLikeCount(int boardNo);
	int increaseBoardLike(int boardNo);

	List<BoardFile> selectFilesByBoardNo(int boardNo);

	// 수정하기
	int updateBoard(Board board, List<MultipartFile> upfiles, HttpServletRequest request);

	// 게시글삭제(논리)
	void deleteBoard(int boardNo);

	// 신고하기
	int insertBoardReport(TeacherReport report);


	

	

	
	

	
	
	
	
	


	

}
