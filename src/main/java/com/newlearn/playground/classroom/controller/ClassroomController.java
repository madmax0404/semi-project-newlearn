package com.newlearn.playground.classroom.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.newlearn.playground.board.model.service.BoardService;
import com.newlearn.playground.board.model.vo.Board;
import com.newlearn.playground.classroom.model.vo.Attendance;
import com.newlearn.playground.classroom.model.vo.ClassJoin;
import com.newlearn.playground.classroom.model.vo.Classroom;
import com.newlearn.playground.classroom.service.ClassroomService;
import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.common.template.Pagination;
import com.newlearn.playground.event.service.EventService;
import com.newlearn.playground.event.vo.Event;
import com.newlearn.playground.member.model.vo.Member;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/class")
public class ClassroomController {
	private final EventService eventService;
	private final ClassroomService classroomService;
	private final BoardService boardService;
	private final SimpMessagingTemplate messagingTemplate;
	
	@GetMapping("/{classNo}")
	public String home(
			HttpSession session,
			Model model,
			@PathVariable("classNo") int classNo,
			Authentication auth,
			@RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
		    @RequestParam Map<String, Object> paramMap
			) {
		Member loginUser = (Member)auth.getPrincipal();
		
		List<Event> upcomingEvents = eventService.upcomingEvents(classNo);
		Map<Event, Integer> eventWithMemberCnt = new HashMap<>();
		for (Event event : upcomingEvents) {
			eventWithMemberCnt.put(event, eventService.joinMemberCnt(event.getEventNo()));
		}
		model.addAttribute("upcomingEvents", upcomingEvents);
		model.addAttribute("eventWithMemberCnt", eventWithMemberCnt);
		
		Classroom classroom = classroomService.getClassroom(classNo);
		String className = classroom.getClassName();
		
		Map<String, Object> map = new HashMap<>();
		map.put("classNo", classNo);
		map.put("userNo", loginUser.getUserNo());
		ClassJoin cjoin = classroomService.getClassJoin(map);
		
		session.setAttribute("classNo", classNo);
		session.setAttribute("className", className);
		session.setAttribute("classRole", cjoin.getClassRole());
		
		map.put("eventType", "SHARED");
		Map <String, Integer> sharedEventCss = eventService.getEventCnt(map);
		String json = new Gson().toJson(sharedEventCss);
		model.addAttribute("sharedEventCss", json);
		
		// 권한 추가
		if (cjoin.getClassRole().equals("teacher")) {
			List<GrantedAuthority> updatedAuths = new ArrayList<>(auth.getAuthorities());
			updatedAuths.add(new SimpleGrantedAuthority("ROLE_TEACHER"));
			Authentication newAuth = new UsernamePasswordAuthenticationToken(auth.getPrincipal(), auth.getCredentials(), updatedAuths);
			SecurityContextHolder.getContext().setAuthentication(newAuth);
		}
		
		Attendance a = new Attendance();
		a.setUserNo(loginUser.getUserNo());
		a.setClassNo(classNo);
		a.setSelectedDate(new SimpleDateFormat("yyyy-M-d").format(new Date()));
		a = classroomService.getAttendance(a);
		model.addAttribute("attendance", a);
		
		// 메인페이지 전체게시판(남건후)
		ClassJoin classInfo = classroomService.getClassJoinByUserNo(loginUser.getUserNo(), classNo);
		int classNoo = classInfo.getClassNo();
		
		paramMap.put("category", "all");
		paramMap.put("classNo", classNoo);

		int listCount = boardService.selectListCount(paramMap);
		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, 10, 10);
		int startRow = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
		int endRow = startRow + pi.getBoardLimit() - 1;
		paramMap.put("startRow", startRow);
		paramMap.put("endRow", endRow);
		
		List<Board> list = boardService.selectList(pi, paramMap);

		model.addAttribute("list", list);
	    model.addAttribute("pi", pi);
	    model.addAttribute("param", paramMap);
	    model.addAttribute("category", "all");
		
		return "main";
	}
	
	@PostMapping("/entry")
	public String entry(
			@RequestParam String attEntryCode,
			@RequestParam int classNo,
			RedirectAttributes ra,
			Authentication auth
			) {
		// 입실코드가 틀린 경우
		Classroom c = classroomService.getClassroom(classNo);
		if (!attEntryCode.equals(c.getEntryCode())) {
			ra.addFlashAttribute("entryMsg", "잘못된 코드입니다.");
			return "redirect:/class/" + classNo;
		}
		// 이미 입실한 경우
		Member loginUser = (Member)auth.getPrincipal();
		int userNo = loginUser.getUserNo();
		Attendance a = new Attendance();
		a.setUserNo(userNo);
		a.setClassNo(classNo);
		a.setSelectedDate(new SimpleDateFormat("yyyy-M-d").format(new Date()));
		if (classroomService.getAttendance(a) != null) {
			ra.addFlashAttribute("entryMsg", "이미 입실완료 되었습니다.");
			return "redirect:/class/" + classNo;
		}
		// attendance db에 데이터 추가
		int result = classroomService.addAttendance(a);
		if (result == 1) {
			ra.addFlashAttribute("entryMsg", "정상적으로 입실처리 되었습니다.");
			if (c.getTeacherNo() != userNo) {
				Map <String, String> response = new HashMap<>();
				response.put("className", c.getClassName());
				response.put("userName", loginUser.getUsername());
				messagingTemplate.convertAndSend("/topic/classT/" + classNo, response);
			}
		}
		return "redirect:/class/" + classNo;
	}
	
	@ResponseBody
	@GetMapping("/list")
	public List<Classroom> getClassList(@RequestParam int userNo) {
		return classroomService.getClasslist(userNo);
	}
}