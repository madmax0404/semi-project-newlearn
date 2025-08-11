package com.newlearn.playground.mypage.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.newlearn.playground.member.model.vo.Member;
import com.newlearn.playground.mypage.model.vo.Mypage;
import com.newlearn.playground.mypage.service.EditProfileService;
import com.newlearn.playground.mypage.service.MypageService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/mypage")
@RequiredArgsConstructor
@SessionAttributes("mypageOriginal")
public class EditProfileController {
	private final ServletContext application;
	private final EditProfileService service;
	private final MypageService mypageService;
	private final BCryptPasswordEncoder passwordEncoder;
	
//	@InitBinder
//	public void initBinder(WebDataBinder binder) {
//		binder.addValidators(new MemberValidator());
//	}
	
	@GetMapping("/editProfile")
	public String editProfile(
			Authentication auth,
			String currentPw,
			RedirectAttributes ra
			) {
		Member loginUser = (Member)auth.getPrincipal();
		String passwordHash = loginUser.getPassword();
		
		if (!passwordEncoder.matches(currentPw, passwordHash)) {
			ra.addFlashAttribute("alertMsg", "비밀번호가 일치하지 않습니다.");
			return "redirect:/mypage/" + loginUser.getUserNo();
		}
		
		return "mypage/editProfile";
	}
	
	@PostMapping("/editProfile")
	public String editProfile(
			Authentication auth,
			@Validated @ModelAttribute Member member,
			String mypageName,
			String statusMessage,
			BindingResult bindingResult,
			RedirectAttributes ra,
			HttpSession session
			) {
		Member loginUser = (Member)auth.getPrincipal();
		Mypage mypage = mypageService.getMypageByMypageNo(loginUser.getUserNo());
		
		if (bindingResult.hasErrors()) {
			ra.addFlashAttribute("alertMsg", "에러 발생.");
			return "redirect:/mypage/" + loginUser.getUserNo();
		}
		
		loginUser.setUserId(member.getUserId());
		loginUser.setUserPwd(member.getUserPwd());
		loginUser.setUserName(member.getUserName());
		loginUser.setPhone(member.getPhone());
		loginUser.setEmail(member.getEmail());
		
		if (mypageName == null || mypageName.trim().equals("")) mypageName = "마이페이지";
		mypage.setMypageName(mypageName);
		mypage.setStatusMessage(statusMessage);
		
		Map<String, Object> map = new HashMap<>();
		map.put("loginUser", loginUser);
		map.put("mypage", mypage);
		
		// 비즈니스 로직
		// 1. DB 의 member 수정
		int result = service.editProfile(map);
		
		if (result > 0) {
			// 새로운 Authentication 객체 생성
			Authentication newAuth = new UsernamePasswordAuthenticationToken(
					loginUser, auth.getCredentials(), auth.getAuthorities()
					);
			
			SecurityContextHolder.getContext().setAuthentication(newAuth);
			ra.addFlashAttribute("alertMsg", "내정보 수정 성공.");			
		} else {
			ra.addFlashAttribute("alertMsg", "내정보 수정 실패.");
		}
		
		return "redirect:/mypage/" + loginUser.getUserNo();
	}
}










