package com.newlearn.playground.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.servlet.HandlerInterceptor;

import com.newlearn.playground.board.model.service.BoardService;
import com.newlearn.playground.board.model.vo.BoardExt;
import com.newlearn.playground.member.model.vo.Member;


public class BoardOwnerCheckInterceptor implements HandlerInterceptor {
	
	@Autowired
	private BoardService boardService; // 게시글 작성자정보 조회용
	
	// 전처리(preHandle)함수: 컨트롤러가 서블릿의 요청을 처리하기 "전"에 먼저 실행되는 함수
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		 System.out.println("=== BoardOwnerCheckInterceptor ===");
		    // 1. 인증 정보
		    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		    System.out.println("auth: " + auth);
		    if (auth != null) {
		        System.out.println("principal: " + auth.getPrincipal());
		        System.out.println("authorities: " + auth.getAuthorities());
		    }

		    // 로그인 사용자 정보
		    if (auth == null || !(auth.getPrincipal() instanceof Member)) {
		        System.out.println("비로그인 또는 Member 아님");
		        return true;
		    }
		    Member loginUser = (Member) auth.getPrincipal();
		    System.out.println("loginUser: " + loginUser);
		    System.out.println("loginUserNo: " + loginUser.getUserNo());

		    // 관리자
		    if (auth.getAuthorities().stream().anyMatch(v -> v.getAuthority().equals("ROLE_ADMIN"))) {
		        System.out.println("관리자라서 통과");
		        return true;
		    }
		    
		    // 선생님 / 한종윤 수정 20250809 15:39
		    if (auth.getAuthorities().stream().anyMatch(v -> v.getAuthority().equals("ROLE_TEACHER"))) {
		        System.out.println("선생님이라서 통과");
		        return true;
		    }

		    // URI, 게시글 번호 추출
		    String[] uri = request.getRequestURI().split("/");
		    for (int i = 0; i < uri.length; i++) {
		        System.out.println("uri[" + i + "] = " + uri[i]);
		    }
		    String boardNoStr = uri[uri.length - 1];
		    System.out.println("boardNoStr: " + boardNoStr);

		    int boardNo;
		    try {
		        boardNo = Integer.parseInt(boardNoStr);
		        System.out.println("boardNo: " + boardNo);
		    } catch (NumberFormatException e) {
		        System.out.println("게시글 번호 파싱 실패!");
		        response.sendRedirect(request.getContextPath() + "/security/accessDenied");
		        return false;
		    }

		    BoardExt board = boardService.selectBoard(boardNo);
		    System.out.println("board: " + board);

		    if (board != null) {
		        System.out.println("board.userNo: " + board.getUserNo());
		    }

		    if (board == null || !String.valueOf(loginUser.getUserNo()).equals(board.getUserNo())) {
		        System.out.println("접근 불가: 로그인유저no=" + loginUser.getUserNo() + ", 게시글유저no=" + (board != null ? board.getUserNo() : "null"));
		        response.sendRedirect(request.getContextPath() + "/security/accessDenied");
		        return false;
		    }
		    System.out.println("정상통과");
		    return true;
	}
}
