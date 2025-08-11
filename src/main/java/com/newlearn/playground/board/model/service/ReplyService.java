package com.newlearn.playground.board.model.service;

import java.util.List;

import com.newlearn.playground.board.model.vo.Reply;

public interface ReplyService {

	// 게시글 번호로 목록조회
	List<Reply> selectReplyList(int boardNo);

	// 댓글 등록	
	int insertReply(Reply reply);

	// 댓글 수정
	int updateReply(Reply reply);

	// 댓글 삭제
	int deleteReply(int replyNo, int userNo);



}
