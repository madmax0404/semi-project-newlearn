package com.newlearn.playground.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.newlearn.playground.board.model.service.ReplyService;
import com.newlearn.playground.board.model.vo.Reply;
import com.newlearn.playground.member.model.vo.Member;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/reply")
public class ReplyController {

	private final ReplyService replyService;

	// 댓글 등록 (AJAX)
	@PostMapping("/insert")
	@ResponseBody
	public Map<String, Object> insertReply(@RequestBody Reply reply, Authentication auth) {
		if (auth != null && auth.isAuthenticated()) {
			Member loginUser = (Member) auth.getPrincipal();
			reply.setUserNo(String.valueOf(loginUser.getUserNo()));
		} else {
			// 테스트용
			reply.setUserNo("3");
		}
		int result = replyService.insertReply(reply);
		Map<String, Object> map = new HashMap<>();
		map.put("result", result > 0 ? "success" : "fail");
		return map;
	}

	// 댓글 목록 조회 (AJAX)
	@GetMapping("/list/{boardNo}")
	@ResponseBody
	public List<Reply> getReplyList(@PathVariable int boardNo) {
		return replyService.selectReplyList(boardNo);
	}

	// 댓글 수정
	@PostMapping("/update")
	@ResponseBody
	public Map<String, Object> updateReply(@RequestBody Reply reply, Authentication auth) {
		Map<String, Object> response = new HashMap<>();

		if (auth != null && auth.isAuthenticated()) {
			Member loginUser = (Member) auth.getPrincipal();

			// 본인 댓글인지 확인하려면 서비스에서 검증 가능
			reply.setUserNo(String.valueOf(loginUser.getUserNo()));
		} else {
			// 테스트 사용자 번호
			reply.setUserNo("3");
		}

		int result = replyService.updateReply(reply);

		response.put("result", result > 0 ? "success" : "fail");
		return response;
	}

	// 댓글 삭제
	@PostMapping("/delete/{replyNo}")
	@ResponseBody
	public Map<String, Object> deleteReply(@PathVariable int replyNo, Authentication auth) {
		Map<String, Object> map = new HashMap<>();

		int userNo = 3; // 기본값 (테스트 계정)

		if (auth != null && auth.isAuthenticated()) {
			Member loginUser = (Member) auth.getPrincipal();
			userNo = loginUser.getUserNo();
		}

		System.out.println("삭제 요청: replyNo = " + replyNo + ", userNo = " + userNo);

		int result = replyService.deleteReply(replyNo, userNo);

		System.out.println("삭제 결과: " + result);

		map.put("result", result > 0 ? "success" : "fail");

		return map;
	}
}
