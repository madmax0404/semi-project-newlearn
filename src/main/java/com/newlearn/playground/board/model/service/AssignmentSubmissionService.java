package com.newlearn.playground.board.model.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import com.newlearn.playground.board.model.vo.AssignmentSubmission;
import com.newlearn.playground.board.model.vo.Board;

public interface AssignmentSubmissionService {

	// boardno로 과제 제출 정보 조회
	AssignmentSubmission getSubmissionByBoardNo(int boardNo);

	// boardno값으로 과제제출게시판 파일조회
	int updateAssignmentSubmission(Board board, List<MultipartFile> upfiles, HttpServletRequest request,
			Integer assignmentNo);

}
