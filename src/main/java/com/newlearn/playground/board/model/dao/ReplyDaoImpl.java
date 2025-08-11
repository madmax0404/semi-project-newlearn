package com.newlearn.playground.board.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.board.model.vo.Reply;

@Repository
public class ReplyDaoImpl implements ReplyDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public List<Reply> selectReplyList(int boardNo) {
		return sqlSession.selectList("reply.selectReplyList", boardNo);
	}

	@Override
	public int insertReply(Reply reply) {
		return sqlSession.insert("reply.insertReply", reply);
	}
	
	@Override
	public int updateReply(Reply reply) {
		return sqlSession.update("reply.updateReply", reply);
	}

	@Override
	public int deleteReply(int replyNo, int userNo) {
		Map<String, Object> param = new HashMap<>();
	    param.put("replyNo", replyNo);
	    param.put("userNo", userNo);
		return sqlSession.update("reply.deleteReply", param);
	}

}
