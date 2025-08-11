package com.newlearn.playground.mypage.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.common.template.Pagination;
import com.newlearn.playground.member.model.vo.Member;
import com.newlearn.playground.mypage.model.vo.Guestbook;
import com.newlearn.playground.mypage.service.MypageService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage/guestbook")
public class GuestbookController {
	private final MypageService mypageService;
	private final SimpMessagingTemplate messagingTemplate;

	@GetMapping
	public String loadGuestbook(HttpSession session, @RequestParam int mypageNo, 
			@RequestParam(value="currentPage", defaultValue="1") int currentPage, 
			@RequestParam String visibility, Model model) {
		Map <String, Object> paramMap = new HashMap<>();
		paramMap.put("mypageNo", mypageNo);
		paramMap.put("visibility", visibility);
		int listcount = mypageService.guestbookCnt(paramMap);
		PageInfo pi = Pagination.getPageInfo(listcount, currentPage, 10, 3); // pageLimit, boardLimit
		List<Guestbook> gbList = mypageService.loadGuestbook(pi, paramMap);
		model.addAttribute("gbList", gbList);
		model.addAttribute("pi", pi);
		model.addAttribute("listcount", listcount);
		model.addAttribute("mypageNo", mypageNo);
		model.addAttribute("visibility", visibility);
		return "mypage/guestbook";
	}
	
	@PostMapping("/hide")
	public String guestbookHide(@RequestParam int guestbookNo, @RequestParam int mypageNo, HttpSession session) {
		int result = mypageService.guestbookHide(guestbookNo);
		return "redirect:/mypage/"+mypageNo;
	}
	
	@PostMapping("/delete")
	public String guestbookDelete(@RequestParam int guestbookNo, @RequestParam int mypageNo, HttpSession session) {
		int result = mypageService.guestbookDelete(guestbookNo);
		return "redirect:/mypage/"+mypageNo;
	}
	
	@PostMapping("/new")
	public String guestbookInsert(@RequestParam String content, @RequestParam int mypageNo, 
			@RequestParam int userNo, @RequestParam String userName, Authentication auth) {
		Guestbook g = new Guestbook();
		g.setContent(content);
		g.setMypageNo(mypageNo);
		g.setUserNo(userNo);
		g.setUserName(userName);
		int result = mypageService.guestbookInsert(g);
		if (mypageNo != ((Member)auth.getPrincipal()).getUserNo()) {
			messagingTemplate.convertAndSend("/topic/newGb/" + mypageNo, g);
		}
		return "redirect:/mypage/"+mypageNo;
	}
}
