package com.newlearn.playground.board.model.service;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.newlearn.playground.board.model.dao.AssignmentSubmissionDao;
import com.newlearn.playground.board.model.vo.AssignmentSubmission;
import com.newlearn.playground.board.model.vo.Board;
import com.newlearn.playground.board.model.vo.BoardFile;
import com.newlearn.playground.common.Utils;

@Service
public class AssignmentSubmissionServiceImpl implements AssignmentSubmissionService{

	@Autowired
	private AssignmentSubmissionDao assignmentSubmissionDao;
	
	@Override
	public AssignmentSubmission getSubmissionByBoardNo(int boardNo) {
		return assignmentSubmissionDao.getSubmissionByBoardNo(boardNo);
	}

	@Override
	public int updateAssignmentSubmission(Board board, List<MultipartFile> upfiles, HttpServletRequest request,
			Integer assignmentNo) {
		
		// 1. 게시글 내용 수정
        int result = assignmentSubmissionDao.updateBoard(board);

        // 2. AssignmentSubmission 정보도 업데이트 (assignmentNo가 변경될 수 있음)
        AssignmentSubmission sub = AssignmentSubmission.builder()
            .assignmentNo(assignmentNo)
            .userNo(Integer.parseInt(board.getUserNo()))
            .boardNo(board.getBoardNo())
            .submissionDate(new Date())
            .build();
        assignmentSubmissionDao.updateAssignmentSubmission(sub);

        // 3. 첨부파일 처리
        if (upfiles != null && !upfiles.isEmpty()) {
            assignmentSubmissionDao.deleteFilesByRefBno(board.getBoardNo());

            int fileLevel = 0;
            for (MultipartFile upfile : upfiles) {
                if (upfile.isEmpty()) continue;
                String changeName = Utils.saveFile(upfile, request.getServletContext(), board.getCategory());
                BoardFile file = new BoardFile();
                file.setRefBno(board.getBoardNo());
                file.setOriginName(upfile.getOriginalFilename());
                file.setChangeName(changeName);
                file.setFileLevel(fileLevel++);
                assignmentSubmissionDao.insertBoardFile(file);
            }
        }
        return result;
    }

}
