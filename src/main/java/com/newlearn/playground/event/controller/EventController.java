package com.newlearn.playground.event.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.newlearn.playground.classroom.model.vo.Classroom;
import com.newlearn.playground.classroom.service.ClassroomService;
import com.newlearn.playground.event.service.EventService;
import com.newlearn.playground.event.vo.Event;
import com.newlearn.playground.event.vo.Event.EventType;
import com.newlearn.playground.event.vo.EventValidator;
import com.newlearn.playground.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/event")
public class EventController {
	private final EventService eventService;
	private final ClassroomService classService;
	private final SimpMessagingTemplate messagingTemplate;
	
	// 이벤트 페이지로 리디렉트 되거나 바로 이동했을때 오늘날짜로 뷰페이지 출력
	@GetMapping
	public String pageload(@RequestParam Map <String, Object> paramMap, Authentication auth, Model model) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-M-d");
		paramMap.put("selectedDate", dateFormat.format(new Date()));
		return eventPage(paramMap, auth, model);
	}
	
	// 캘린더에서 날짜 클릭했을 때
	@GetMapping("/calendar")
	public String eventPage(@RequestParam Map <String, Object> paramMap, Authentication auth, Model model) {
		paramMap.put("eventType", "PERSONAL");
		Map <String, Integer> personalEventCss = eventService.getEventCnt(paramMap);
		String json = new Gson().toJson(personalEventCss);
		model.addAttribute("personalEventCss", json);
		
		paramMap.put("userNo", ((Member)auth.getPrincipal()).getUserNo());
		model.addAttribute("sharedEvents", eventService.findAllByDate(paramMap));
		model.addAttribute("personalEvents", eventService.findAllPersonalByClass(paramMap));
		model.addAttribute("selectedDate", paramMap.get("selectedDate"));
		model.addAttribute("classNo", paramMap.get("classNo"));
		return "event/event";
	}
	
	// 추가 버튼 클릭 시 빈 폼 요청
	@GetMapping("/new")
	public String insertEvent(@RequestParam Map <String, Object> paramMap, Authentication auth, Model model) {
		model.addAttribute("event", new Event());
		return eventPage(paramMap, auth, model);
	}
	
	// 상세 이벤트 보기 요청
	@GetMapping("/detail")
	public String eventDetail(@RequestParam Map <String, Object> paramMap, Authentication auth, Model model) {
		int eventNo = Integer.parseInt((String)paramMap.get("eventNo"));
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-M-d");
		String selectedDate = null; // null 괜찮나?
		if (eventNo != 0) {
			Event selectedEvent = eventService.findByNo(eventNo);
			if (selectedEvent == null) {
				selectedDate = dateFormat.format(new Date());
			} else {
				model.addAttribute("event", selectedEvent);
				selectedDate = dateFormat.format(selectedEvent.getStartDate());
			}
		}
		paramMap.put("selectedDate", selectedDate);
		return eventPage(paramMap, auth, model);
	}
	
	// 날짜 형식 변환
	@InitBinder
	public void formatDatetime(WebDataBinder binder) {
		binder.addValidators(new EventValidator());
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
		dateFormat.setLenient(false);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
	}
	
	// 이벤트 참여
	@PostMapping("/join")
	public String joinEvent(@ModelAttribute("event") Event event, Authentication auth, RedirectAttributes ra) {
		if (event.getJoinDeadline() != null && event.getJoinDeadline().compareTo(new Date()) < 0) {
			ra.addFlashAttribute("alertMsg", "참여기한이 지난 이벤트입니다.");
			return "redirect:/event/detail?eventNo=" + event.getEventNo() + "&classNo=" + event.getClassNo();
		}
		if (event.getNumPpl() != 0 && eventService.joinMemberCnt(event.getEventNo()) >= event.getNumPpl()) {
			ra.addFlashAttribute("alertMsg", "모집 인원이 가득 찼습니다.");
			return "redirect:/event/detail?eventNo=" + event.getEventNo() + "&classNo=" + event.getClassNo();
		}
		int userNo = ((Member)auth.getPrincipal()).getUserNo();
		List<Integer> list = eventService.getSubscription(userNo);
		for (Integer eventNo : list) {
			if (eventNo != null && eventNo == event.getEventNo()) {
				ra.addFlashAttribute("alertMsg", "이미 참여한 이벤트입니다.");
				return "redirect:/event/detail?eventNo=" + event.getEventNo() + "&classNo=" + event.getClassNo();
			}
		}
		int result = eventService.joinMember(event, userNo);
		if (result == 1) {
			ra.addFlashAttribute("alertMsg", "이벤트에 참여하였습니다.");
		} else {
			ra.addFlashAttribute("alertMsg", "이벤트 참여 중 에러발생");
		}
		return "redirect:/event/detail?eventNo=" + event.getEventNo() + "&classNo=" + event.getClassNo();
	}
	
	// 이벤트 나가기
	@PostMapping("/exit")
	public String exitEvent(@ModelAttribute("event") Event event, Authentication auth, RedirectAttributes ra) {
		int userNo = ((Member)auth.getPrincipal()).getUserNo();
		List<Integer> list = eventService.getSubscription(userNo);
		if (!list.contains(event.getEventNo())) {
			ra.addFlashAttribute("alertMsg", "참여중인 이벤트가 아닙니다.");
			return "redirect:/event/detail?eventNo=" + event.getEventNo() + "&classNo=" + event.getClassNo();
		}
		if (event.getStartDate().compareTo(new Date()) < 0) {
			ra.addFlashAttribute("alertMsg", "이미 시작된 이벤트는 나갈 수 없습니다.");
			return "redirect:/event/detail?eventNo=" + event.getEventNo() + "&classNo=" + event.getClassNo();
		}
		int result = eventService.exitEvent(event, userNo);
		if (result == 1) {
			ra.addFlashAttribute("alertMsg", "이벤트 탈주 성공");
		} else {
			ra.addFlashAttribute("alertMsg", "이벤트 탈주 실패");
		}
		return "redirect:/event/detail?eventNo=" + event.getEventNo() + "&classNo=" + event.getClassNo();
	}
	
	// 마이페이지에서 개인일정 삭제
	@GetMapping("/deletePersonal")
	public String deletePersonalEvent(@RequestParam int eventNo, @RequestParam int mypageNo, RedirectAttributes ra) {
		int result = eventService.deleteEvent(eventNo);
		if (result == 1) {
			ra.addFlashAttribute("alertMsg", "일정이 정상적으로 삭제되었습니다.");
		} else {
			ra.addFlashAttribute("alertMsg", "일정을 삭제하는 도중 에러가 발생하였습니다.");
		}
		return "redirect:/mypage/" + mypageNo + "?to=event";
	}
	
	// 이벤트페이지에서 개인일정 삭제
	@PostMapping("/deletePersonal")
	public String deletePersonalEvent(@ModelAttribute("event") Event event, RedirectAttributes ra) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-M-d");
		String selectedDate = dateFormat.format(event.getStartDate());
		int result = eventService.deleteEvent(event.getEventNo());
		if (result == 1) {
			ra.addFlashAttribute("alertMsg", "일정이 정상적으로 삭제되었습니다.");
		} else {
			ra.addFlashAttribute("alertMsg", "일정을 삭제하는 도중 에러가 발생하였습니다.");
		}
		return "redirect:/event/calendar?selectedDate=" + selectedDate + "&classNo=" + event.getClassNo();
	}
	
	// 이벤트페이지에서 공유이벤트 삭제
	@PostMapping("/deleteShared")
	public String deleteSharedEvent(@ModelAttribute("event") Event event, Authentication auth, RedirectAttributes ra) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-M-d");
		String selectedDate = dateFormat.format(event.getStartDate());
		int result = eventService.deleteEvent(event.getEventNo());
		if (result == 1) {
			ra.addFlashAttribute("alertMsg", "일정이 정상적으로 삭제되었습니다.");
			messagingTemplate.convertAndSend("/topic/eventD/" + event.getEventNo(), event);
		} else {
			ra.addFlashAttribute("alertMsg", "일정을 삭제하는 도중 에러가 발생하였습니다.");
		}
		return "redirect:/event/calendar?selectedDate=" + selectedDate + "&classNo=" + event.getClassNo();
	}
	
	// 마이페이지에서 개인일정 추가/수정
	@PostMapping("/personal")
	public String personalEvent(@Validated @ModelAttribute("event") Event event, BindingResult bindingResult, RedirectAttributes ra) {
		if (bindingResult.hasErrors()) {
			ra.addFlashAttribute("alertMsg", bindingResult.getAllErrors().get(0).getDefaultMessage());
	        return "redirect:/mypage/" + event.getUserNo() + "?to=event";
		}
		event.setEventType(EventType.PERSONAL);
		int result = 0;
		switch (event.getType()) {
			case "insert": result = eventService.insertEvent(event); break;
			case "update": result = eventService.updateEvent(event); break;
		}
		if (result == 1) {
			ra.addFlashAttribute("alertMsg", "이벤트가 정상적으로 추가/수정되었습니다.");
		} else {
			ra.addFlashAttribute("alertMsg", "이벤트를 추가/수정하는 도중 에러가 발생하였습니다.");
		}
		return "redirect:/mypage/" + event.getUserNo() + "?to=event";
	}
	
	// 이벤트페이지에서 공유이벤트 추가
	@PostMapping("/newShared")
	public String newSharedEvent(@Validated @ModelAttribute("event") Event event, BindingResult bindingResult, RedirectAttributes ra) {
		if (bindingResult.hasErrors()) {
			ra.addFlashAttribute("alertMsg", bindingResult.getAllErrors().get(0).getDefaultMessage());
	        return "redirect:/event?classNo=" + event.getClassNo();
		}
		if (eventService.insertEvent(event) == 1) {
			ra.addFlashAttribute("alertMsg", "이벤트가 정상적으로 추가되었습니다.");
			Classroom classroom = classService.getClassroom(event.getClassNo());
			Map <String, Object> message = new HashMap<>();
			message.put("event", event);
			message.put("class", classroom.getClassName());
			messagingTemplate.convertAndSend("/topic/classE/" + event.getClassNo(), message);
		} else {
			ra.addFlashAttribute("alertMsg", "이벤트를 추가하는 도중 에러가 발생하였습니다.");
		}
		return "redirect:/event?classNo=" + event.getClassNo();
	}
	
	// 이벤트페이지에서 일정수정 (공유/개인)
	@PostMapping("/update")
	public String updateSharedEvent(@Validated @ModelAttribute("event") Event event, BindingResult bindingResult, RedirectAttributes ra) {
		if (bindingResult.hasErrors()) {
			ra.addFlashAttribute("alertMsg", bindingResult.getAllErrors().get(0).getDefaultMessage());
	        return "redirect:/event?classNo=" + event.getClassNo();
		}
		if (event.getEventType() == EventType.SHARED) {
			event.setVisibility("Y");
		}
		if (eventService.updateEvent(event) == 1) {
			ra.addFlashAttribute("alertMsg", "이벤트가 정상적으로 수정되었습니다.");
			if (event.getEventType() == EventType.SHARED) {
				messagingTemplate.convertAndSend("/topic/eventE/" + event.getEventNo(), event);
			}
		} else {
			ra.addFlashAttribute("alertMsg", "이벤트를 수정하는 도중 에러가 발생하였습니다.");
		}
		return "redirect:/event?classNo=" + event.getClassNo();
	}
	
}
