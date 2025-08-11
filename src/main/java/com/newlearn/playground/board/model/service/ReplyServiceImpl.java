package com.newlearn.playground.board.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.newlearn.playground.board.model.dao.ReplyDao;
import com.newlearn.playground.board.model.vo.Reply;

@Service
public class ReplyServiceImpl implements ReplyService {

	@Autowired
	private ReplyDao replyDao;

	@Override
	public List<Reply> selectReplyList(int boardNo) {
		return replyDao.selectReplyList(boardNo);
	}
	
	@Override
	public int insertReply(Reply reply) {
		return replyDao.insertReply(reply);
	}
	
	@Override
	public int updateReply(Reply reply) {
		
		return replyDao.updateReply(reply);
	}

	@Override
	public int deleteReply(int replyNo, int userNo) {
		return replyDao.deleteReply(replyNo, userNo);
	}

	
	
	
	
	
	


}
