package com.newlearn.playground;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.newlearn.playground.classroom.service.ClassroomService;
import com.newlearn.playground.event.service.EventService;

import com.newlearn.playground.member.model.vo.Member;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MainController {
	private final EventService eventService;
	private final ClassroomService classService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) {
		HttpSession session = request.getSession(true);
		Member userDetails = (Member) authentication.getPrincipal();
		int userNo = userDetails.getUserNo();
		String contextPath = request.getContextPath();
		session.setAttribute("loginUser", userDetails);
		return "redirect:/mypage/" + userNo;
	}
	
	@ResponseBody
	@GetMapping("/getSubsUrl")
	public Map<String, Object> getSubsUrl(@RequestParam int userNo) {
		Map<String, Object> response = new HashMap<>();
		List <Integer> eventSubs = eventService.getSubscription(userNo);
		List <Integer> classSubs = classService.getClassJoins(userNo);
		List <Integer> teacherSubs = classService.getTeacherClassJoins(userNo);
		response.put("eventSubs", eventSubs);
		response.put("classSubs", classSubs);
		response.put("teacherSubs", teacherSubs);
		return response;
	}
}