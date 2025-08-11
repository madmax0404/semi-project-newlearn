package com.newlearn.playground.security.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
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

import com.newlearn.playground.member.model.service.MemberService;
import com.newlearn.playground.member.model.validator.MemberValidator;
import com.newlearn.playground.member.model.vo.Member;

@Controller
@RequestMapping("/security")
public class SecurityController {

	@Autowired
	private MemberService mService;
	
	@Autowired
	private MemberValidator memberValidator;
	
	@InitBinder("member")
	public void initBinder(WebDataBinder binder) {
		binder.addValidators(memberValidator);
	}
	
	// 접근 거부 페이지를 보여주는 기능
	@GetMapping("/accessDenied")
	public String accessDenied() {
		// /WEB-INF/views/security/accessDenied.jsp 파일을 보여줌
		return "common/errorPage";
	}
	
	
	
	// 회원가입 정보입력 페이지
	@GetMapping("/insert")
	public String enrollForm(Model model) {
		model.addAttribute("member", new Member());
		return "member/enroll";
	}
	
	// 회원가입 요청
	@PostMapping("/insert")
	public String insertMember(@Validated @ModelAttribute("member") Member m, BindingResult bindingResult, @RequestParam("ssn1") String ssn1,
			@RequestParam("ssn2") String ssn2, @RequestParam("emailId") String emailId,
			@RequestParam("emailDomain") String emailDomain, @RequestParam("emailCert") String emailCert,
			HttpSession session, // 세션 부르기
			Model model, RedirectAttributes ra) {

		// 세션에서 서버가 발급한 인증코드를 가져옴
		String serverCertCode = (String) session.getAttribute("certCode");

		// 사용자가 입력한 인증코드와 서버의 인증코드가 일치하는지 체크
		if (serverCertCode == null || !serverCertCode.equals(emailCert)) {
			ra.addFlashAttribute("result", "fail");
			ra.addFlashAttribute("message", "이메일 인증번호가 일치하지 않습니다.");
			return "redirect:/member/enrollComplete"; // 실패 페이지로 이동시킴
		}

		if (bindingResult.hasErrors()) {
			// Validator에서 발견하고 해당하는 오류 메세지를 가져옴
			String errorMessage = bindingResult.getAllErrors().get(0).getDefaultMessage();

			ra.addFlashAttribute("result", "fail");
			ra.addFlashAttribute("message", errorMessage); // 오류메세지 전달

			return "redirect:/member/enrollComplete";
		}

		String ssn = ssn1 + "-" + ssn2;
		String email = emailId + "@" + emailDomain;

		m.setSsn(ssn);
		m.setEmail(email);

		int result = mService.insertMember(m);
		String viewName = "";

		if (result > 0) {
			ra.addFlashAttribute("userNameForComplete", m.getUserName());
			session.removeAttribute("certCode");
			viewName = "redirect:/member/enrollComplete";
		} else {
			ra.addFlashAttribute("result", "fail");
			ra.addFlashAttribute("message", "이미 가입된 회원이거나 잘못된 정보입니다.");
			viewName = "redirect:/member/enrollComplete";
		}

		return viewName;
	
	}
	
}