package com.newlearn.playground.board.model.dao;

import java.util.List;

import com.newlearn.playground.board.model.vo.Reply;

public interface ReplyDao {

	List<Reply> selectReplyList(int boardNo);

	int insertReply(Reply reply);
	
	int updateReply(Reply reply);
	
	int deleteReply(int replyNo, int userNo);


}
