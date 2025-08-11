package com.newlearn.playground.mypage.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.newlearn.playground.classroom.model.vo.Attendance;
import com.newlearn.playground.classroom.model.vo.Classroom;
import com.newlearn.playground.classroom.service.ClassroomService;
import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.common.template.Pagination;
import com.newlearn.playground.event.service.EventService;
import com.newlearn.playground.event.vo.Event;
import com.newlearn.playground.member.model.vo.Member;
import com.newlearn.playground.mypage.service.MypageService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class CalendarController {
	private final MypageService mypageService;
	private final EventService eventService;
	private final ClassroomService classService;

	@GetMapping("/calendar")
	public String loadCalendar(@RequestParam(value = "date", required = false) String date, @RequestParam String mypageNo,
			@RequestParam(value="currentPage", defaultValue="1") int currentPage, Model model) {
		// 날짜 지정하지 않은 경우, 오늘날짜로
	    if (date == null || date.trim().isEmpty()) {
	        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-M-d");
	        date = dateFormat.format(new Date());
	    }
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("selectedDate", date);
	    paramMap.put("mypageNo", mypageNo);
	    List<Event> publicPersonal = eventService.findPublicPersonal(paramMap);
	    List<Event> privatePersonal = eventService.findPrivatePersonal(paramMap);
	    List<Classroom> classroomList = classService.getClasslist(Integer.parseInt(mypageNo));
	    model.addAttribute("publicPersonal", publicPersonal);
	    model.addAttribute("privatePersonal", privatePersonal);
	    model.addAttribute("classroomList", classroomList);
	    model.addAttribute("selectedDate", date);
	    model.addAttribute("mypageNo", mypageNo);
	    return "mypage/calendar";
	}
	
	// 월 별 출석률 계산
	@ResponseBody
	@GetMapping("/calendar/calcAttRate")
	private Map <String, Object> calcAttRate(@RequestParam Map<String, String> paramMap) {
		String date = paramMap.get("selectedDate");
		Map <String, Object> response = new HashMap<>();
		
	    Attendance a = new Attendance();
	    a.setUserNo(Integer.parseInt(paramMap.get("mypageNo")));
	    a.setClassNo(Integer.parseInt(paramMap.get("classNo")));
	    a.setSelectedDate(date);
	    a = classService.getAttendance(a);
    	response.put("entryTime", (a == null ? "" : a.getEntryTime()));
    	response.put("exitTime", (a == null ? "" : a.getExitTime()));
		
	    String month = date.substring(0, date.lastIndexOf("-"));
	    String day = date.substring(date.lastIndexOf("-") + 1);
	    response.put("month", month);
	    response.put("day", day);

		int monthlyAttCnt = mypageService.getMontlyAttCnt(paramMap);
		response.put("monthlyAttRate", monthlyAttCnt / Double.parseDouble(day) * 100);
		return response;
	}
	
	// 개인일정 수정/생성 모달창 열기
	@GetMapping("/modal/{dmlType}")
	public String getModal(@PathVariable("dmlType") String dmlType, @RequestParam int eventNo, 
			Authentication auth, Model model) {
		Event event = new Event();
		if (dmlType.equals("edit")) {
			event = eventService.findByNo(eventNo);
		}
		model.addAttribute("event", event);
		
		// 로그인한 사용자 데이터
		Member userDetails = (Member)auth.getPrincipal();
		model.addAttribute("userDetails", userDetails);
		return "mypage/eventForm";
	}
	
	// 날짜 형식 변환
	@InitBinder
	public void formatDatetime(WebDataBinder binder) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
		dateFormat.setLenient(false);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
	}
}
