package com.newlearn.playground.board.model.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.newlearn.playground.board.model.dao.BoardDao;
import com.newlearn.playground.board.model.vo.Assignment;
import com.newlearn.playground.board.model.vo.AssignmentSubmission;
import com.newlearn.playground.board.model.vo.Board;
import com.newlearn.playground.board.model.vo.BoardExt;
import com.newlearn.playground.board.model.vo.BoardFile;
import com.newlearn.playground.common.Utils;
import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.teacher.model.vo.TeacherReport;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

	private final BoardDao boardDao;
	
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public int selectListCount(Map<String, Object> paramMap) {
		if ("all".equals(paramMap.get("category"))) {
			paramMap.remove("category");
		}
		return boardDao.selectListCount(paramMap);
	}

	@Override
	public List<Board> selectList(PageInfo pi, Map<String, Object> paramMap) {
		String category = (String)paramMap.get("category");
		
		if("all".equals(category)) {
			paramMap.remove("category");
		}
		
		return boardDao.selectList(pi, paramMap);
	}
	
	@Override
	public int insertBoard(Board board, List<BoardFile> fileList) {
		int result = boardDao.insertBoard(sqlSession, board);

		if (result > 0 && fileList != null && !fileList.isEmpty()) {
			for (BoardFile file : fileList) {
				file.setRefBno(board.getBoardNo()); // 방금 등록된 게시글 번호
				boardDao.insertBoardImage(sqlSession, file);
			}
		}
		return result;
	}

	
	@Override
	public int insertBoardReturnBoardNo(Board board, List<BoardFile> fileList) {
		 // 1) 게시글 저장, PK 반환 (MyBatis <selectKey> 사용)
        int boardNo = boardDao.insertBoardReturnBoardNo(board);

        // 2) 파일 저장
        if (fileList != null && !fileList.isEmpty()) {
            for (BoardFile file : fileList) {
                file.setRefBno(boardNo);
                boardDao.insertBoardFile(file);
            }
        }
        return boardNo;
	}

	@Override
	public int insertAssignmentSubmission(AssignmentSubmission sub) {
		return boardDao.insertAssignmentSubmission(sub);
	}

	@Override
	public int increaseCount(int boardNo) {
		return boardDao.increaseCount(boardNo);
	}

	@Override
	public BoardExt selectBoard(int boardNo) {
		return boardDao.selectBoard(boardNo);
	}

	@Override
	public boolean hasUserLiked(int boardNo, int userNo) {
		return boardDao.hasUserLiked(boardNo, userNo);
	}

	@Override
	public int insertBoardLike(int boardNo, int userNo) {
		return boardDao.insertBoardLike(boardNo, userNo);
	}

	@Override
	public int selectLikeCount(int boardNo) {
		return boardDao.selectLikeCount(boardNo);
	}

	@Override
	public int increaseBoardLike(int boardNo) {
		return boardDao.increaseBoardLike(boardNo);
	}

	@Override
	public List<BoardFile> selectFilesByBoardNo(int boardNo) {
		return boardDao.selectFilesByBoardNo(boardNo);
	}

	@Override
	public int updateBoard(Board board, List<MultipartFile> upfiles, HttpServletRequest request) {
		 // 1. 게시글 내용 수정
        int result = boardDao.updateBoard(board);

        // 2. 파일 업데이트
        if (upfiles != null && !upfiles.isEmpty()) {
            // (선택) 기존 파일 삭제 (refBno 기준)
            boardDao.deleteFilesByRefBno(board.getBoardNo());

            int fileLevel = 0;
            for (MultipartFile upfile : upfiles) {
                if (upfile.isEmpty()) continue;
                String changeName = Utils.saveFile(upfile, request.getServletContext(), board.getCategory());

                BoardFile file = new BoardFile();
                file.setRefBno(board.getBoardNo()); 
                file.setOriginName(upfile.getOriginalFilename());
                file.setChangeName(changeName);
                file.setFileLevel(fileLevel++);
                boardDao.insertBoardFile(file);
            }
        }
        return result;
	}

		@Override
		public void deleteBoard(int boardNo) {
			boardDao.deleteBoard(boardNo);
		}
	
		@Override
		public int insertBoardReport(TeacherReport report) {
			return boardDao.insertBoardReport(report);
		}
		

	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
