package com.newlearn.playground.member.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.newlearn.playground.member.model.service.MemberService;
import com.newlearn.playground.member.model.validator.MemberValidator;
import com.newlearn.playground.member.model.vo.Member;

@Controller
@SessionAttributes({ "loginUser" })
public class MemberController {

	@Autowired
	private MemberService mService;

	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;
	
	@Autowired
	private MemberValidator memberValidator;
	
	@InitBinder("member")
	public void initBinder(WebDataBinder binder) {
		binder.addValidators(memberValidator);
	}
	
	// 로그인 페이지
	@RequestMapping(value = "/member/login", method = RequestMethod.GET)
	public String loginMember() {
		return "member/login";
	}

	// 회원가입 약관 페이지
	@GetMapping("/member/agree")
	public String agreeForm() {
		return "member/agree";
	}

	// 회원가입 완료/실패 페이지로
	@GetMapping("/member/enrollComplete")
	public String enrollComplete() {
		return "member/enrollComplete";
	}

	// 아이디 중복 확인 기능 (AJAX)
	@ResponseBody
	@GetMapping("/member/idCheck")
	public String idCheck(@RequestParam("checkId") String userId) {
		int result = mService.idCheck(userId);
		return "" + result;
	}

	// 회원가입 이메일 인증코드 발송 기능 (AJAX)
	@ResponseBody
	@PostMapping("/member/emailCert")
	public String sendEmail(String email, HttpSession session) {
		String certCode = mService.sendEmail(email);
		session.setAttribute("certCode", certCode);
		session.setMaxInactiveInterval(180);
		return certCode;
	}

	// 아이디 찾기 페이지
	@GetMapping("/member/findId")
	public String findIdForm() {
		return "member/findId";
	}

	// 아이디 찾기 요청 처리
	@PostMapping("/member/findId")
	public String findId(@RequestParam("userName") String userName, @RequestParam("ssn1") String ssn1,
			@RequestParam("ssn2") String ssn2, Model model) {

		String ssn = ssn1 + "-" + ssn2;
		String foundId = mService.findId(userName, ssn);

		model.addAttribute("foundId", foundId);
		return "member/findId_Result";
	}

	// 비밀번호 찾기 페이지
	@GetMapping("/member/findPassword")
	public String findPasswordForm() {
		return "member/findPassword";
	}

	// 비밀번호 찾기: 사용자 정보 확인 및 이메일 발송 기능 (AJAX)
	@ResponseBody
	@PostMapping("/member/checkUserAndSendEmail")
	public Map<String, Object> checkUserAndSendEmail(@RequestParam("userName") String userName,
			@RequestParam("ssn") String ssn, @RequestParam("email") String email) {

		Map<String, Object> response = new HashMap<>();
		String userId = mService.findUserForPasswordReset(userName, ssn, email);

		if (userId != null) {
			String certCode = mService.sendEmail(email);
			response.put("success", true);
			response.put("certCode", certCode);
		} else {
			response.put("success", false);
		}
		return response;
	}

	// 비밀번호 찾기: 인증 후 새 비밀번호 입력 페이지로 이동
	@PostMapping("/member/findPassword")
	public String findPassword(@RequestParam("userName") String userName, @RequestParam("ssn1") String ssn1,
			@RequestParam("ssn2") String ssn2, @RequestParam("userEmailId") String emailId,
			@RequestParam("userEmailDomain") String emailDomain, HttpSession session) {

		String ssn = ssn1 + "-" + ssn2;
		String email = emailId + "@" + emailDomain;
		String userId = mService.findUserForPasswordReset(userName, ssn, email);

		if (userId != null) {
			session.setAttribute("userIdForReset", userId);
			return "redirect:/member/resetPasswordForm";
		} else {
			return "redirect:/member/findPassword";
		}
	}

	@GetMapping("/member/resetPasswordForm")
	public String resetPasswordForm(Model model) {
		model.addAttribute("member", new Member());
		return "member/changePassword";
	}

	@PostMapping("/member/resetPassword")
	public String resetPassword(@Validated @ModelAttribute("member") Member member, BindingResult bindingResult,
			HttpSession session, RedirectAttributes rttr) {

		if (bindingResult.hasFieldErrors("userPwd")) {

			rttr.addFlashAttribute("message", "비밀번호는 영문, 숫자, 특수문자를 포함하여 7~20자여야 합니다.");
			return "redirect:/member/resetPasswordForm";
		}

		String userId = (String) session.getAttribute("userIdForReset");
		String newPassword = member.getUserPwd();

		if (userId == null) {
			rttr.addFlashAttribute("message", "세션이 만료되었습니다. 다시 시도해주세요.");
			return "redirect:/member/findPassword";
		}

		Member m = new Member();
		m.setUserId(userId);
		Member currentUser = mService.loginMember(m);

		if (currentUser == null) {
			rttr.addFlashAttribute("message", "사용자 정보가 존재하지 않습니다.");
			return "redirect:/member/findPassword";
		}

		String oldPasswordHash = currentUser.getUserPwd();

		if (bcryptPasswordEncoder.matches(newPassword, oldPasswordHash)) {
			rttr.addFlashAttribute("message", "기존과 동일한 비밀번호로는 변경할 수 없습니다.");
			return "redirect:/member/resetPasswordForm";
		}

		mService.updatePassword(userId, newPassword);
		session.removeAttribute("userIdForReset");
		return "redirect:/member/changePasswordComplete";
	}

	@GetMapping("/member/changePasswordComplete")
	public String passwordChangeComplete() {
		return "member/changePasswordComplete";
	}

	@ResponseBody
	@PostMapping("/member/checkSamePassword")
	public Map<String, Object> checkSamePassword(@RequestParam("newPassword") String newPassword, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		String userId = (String) session.getAttribute("userIdForReset");

		boolean isSame = false;
		if (userId != null && newPassword != null && !newPassword.isEmpty()) {
			Member m = new Member();
			m.setUserId(userId);
			Member currentUser = mService.loginMember(m);
			if (currentUser != null && currentUser.getUserPwd() != null) {
				isSame = bcryptPasswordEncoder.matches(newPassword, currentUser.getUserPwd());
			}
		}
		response.put("isSame", isSame);
		return response;
	}

	/*
	 * @GetMapping("/member/myPage") public String myPage() { return
	 * "member/myPage"; }
	 */
}