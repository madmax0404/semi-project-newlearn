package com.newlearn.playground.common;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.newlearn.playground.member.model.vo.Member;

public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		HttpSession session = request.getSession(true);
		
		// 오늘날짜 세션에 저장, 월별 달력 출력을 위한 데이터
		Calendar calendar = Calendar.getInstance();
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH)+1;
		int today = calendar.get(Calendar.DATE);
		
		calendar.set(year, month-1, 1);
		int startDay = calendar.get(Calendar.DAY_OF_WEEK);
		int lastDay = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
		
		List<Integer> days = new ArrayList<>();
		for (int day = 1; day <= lastDay; day++) {
			days.add(day);
		}
		session.setAttribute("year", year);
		session.setAttribute("month", month);
		session.setAttribute("today", today);
		session.setAttribute("startDay", startDay);
		session.setAttribute("lastDay", lastDay);
		session.setAttribute("days", days);
		
		Member userDetails = (Member) authentication.getPrincipal();
		int userNo = userDetails.getUserNo();
		String contextPath = request.getContextPath();
		session.setAttribute("loginUser", userDetails);
		response.sendRedirect(contextPath + "/mypage/" + userNo);
	}
	
}
