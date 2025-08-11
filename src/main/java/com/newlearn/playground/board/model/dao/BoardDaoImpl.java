package com.newlearn.playground.board.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.board.model.vo.Assignment;
import com.newlearn.playground.board.model.vo.AssignmentSubmission;
import com.newlearn.playground.board.model.vo.Board;
import com.newlearn.playground.board.model.vo.BoardExt;
import com.newlearn.playground.board.model.vo.BoardFile;
import com.newlearn.playground.board.model.vo.BoardType;
import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.teacher.model.vo.TeacherReport;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class BoardDaoImpl implements BoardDao {
	
	@Autowired
    private SqlSession sqlSession;
	
	@Override
	public int selectListCount(Map<String, Object> paramMap) {
		return sqlSession.selectOne("board.selectListCount", paramMap);
	}
	
	@Override
	public List<Board> selectList(PageInfo pi, Map<String, Object> paramMap) {
		return sqlSession.selectList("board.selectList", paramMap);
	}

	@Override
	public int insertBoard(SqlSession sqlSession, Board board) {
		log.debug("board {}", board);
        return sqlSession.insert("board.insertBoard", board);
	}

	@Override
	public int insertBoardImage(SqlSession sqlSession, BoardFile file) {
		return sqlSession.insert("board.insertBoardFile", file);
	}

	
	@Override
	public int insertBoardReturnBoardNo(Board board) {
		 // MyBatis Mapper XML의 insert문에는 <selectKey> 사용 (boardNo 셋팅)
        int result = sqlSession.insert("board.insertBoardReturnBoardNo", board);
        // board.setBoardNo()가 이미 <selectKey>에 의해 채워짐
        return board.getBoardNo();
	}


	@Override
	public int insertAssignmentSubmission(AssignmentSubmission sub) {
		  return sqlSession.insert("board.insertAssignmentSubmission", sub);
	}

	@Override
	public void insertBoardFile(BoardFile file) {
		 sqlSession.insert("board.insertBoardFile", file);
		
	}

	@Override
	public int increaseCount(int boardNo) {
		return sqlSession.update("board.increaseCount", boardNo);
	}

	@Override
	public BoardExt selectBoard(int boardNo) {
		return sqlSession.selectOne("board.selectBoard", boardNo);
	}

	@Override
	public boolean hasUserLiked(int boardNo, int userNo) {
		Map<String, Integer> map = new HashMap<>();
        map.put("boardNo", boardNo);
        map.put("userNo", userNo);
        Integer count = sqlSession.selectOne("board.hasUserLiked", map);
        return count != null && count > 0;
	}

	@Override
	public int insertBoardLike(int boardNo, int userNo) {
		 Map<String, Integer> map = new HashMap<>();
	        map.put("boardNo", boardNo);
	        map.put("userNo", userNo);
	        return sqlSession.insert("board.insertBoardLike", map);
	}

	@Override
	public int selectLikeCount(int boardNo) {
		return sqlSession.selectOne("board.selectLikeCount", boardNo);
	}

	@Override
	public int increaseBoardLike(int boardNo) {
		 return sqlSession.update("board.increaseBoardLike", boardNo);
	}

	@Override
	public List<BoardFile> selectFilesByBoardNo(int boardNo) {
		return sqlSession.selectList("board.selectFilesByBoardNo", boardNo);
	}

	@Override
	public int updateBoard(Board board) {
		return sqlSession.update("board.updateBoard", board);
	}

	@Override
	public int deleteFilesByRefBno(int boardNo) {
		 return sqlSession.delete("board.deleteFilesByRefBno", boardNo);
	}

	@Override
	public void deleteBoard(int boardNo) {
		sqlSession.update("board.deleteBoard", boardNo);
	}

	@Override
	public int insertBoardReport(TeacherReport report) {
		return sqlSession.insert("board.insertBoardReport", report);
	}

	

	
	
	





	

	

}
