package com.newlearn.playground.member.model.validator;

import java.util.regex.Pattern;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.newlearn.playground.member.model.vo.Member;

@Component
public class MemberValidator implements Validator {

	@Override
	public boolean supports(Class<?> clazz) {
		return Member.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		Member member = (Member) target;
		String userId = member.getUserId();
		String userPwd = member.getUserPwd();
		String userName = member.getUserName();
		String phone = member.getPhone();

		// 아이디 유효성 검사
		if (userId != null && !userId.trim().isEmpty()) {
			if (userId.length() < 7 || userId.length() > 15) {
				errors.rejectValue("userId", "length", "아이디는 7~15자 사이로 입력해주세요.");
			}
			if (!userId.matches("^[a-zA-Z0-9]+$")) {
				errors.rejectValue("userId", "pattern", "아이디는 영문자와 숫자로만 구성되어야 합니다.");
			}
		}

		// 비밀번호 유효성 검사 (값이 있을 때만)
		if (userPwd != null && !userPwd.trim().isEmpty()) {
			String pwRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&^])[A-Za-z\\d$@$!%*#?&^]{7,20}$";
			if (!Pattern.matches(pwRegex, userPwd)) {
				errors.rejectValue("userPwd", "pattern", "비밀번호는 영문, 숫자, 특수문자를 포함하여 7~20자여야 합니다.");
			}
		}

		// 이름 유효성 검사 (값이 있을 때만, 그리고 비어있는지)
		if (userName != null && userName.trim().isEmpty()) {
			errors.rejectValue("userName", "empty", "이름을 입력해주세요.");
		}

		// 전화번호 유효성 검사 (값이 있을 때만)
		if (phone != null && !phone.trim().isEmpty()) {
			if (!phone.matches("^[0-9]{11}$")) {
				errors.rejectValue("phone", "pattern", "전화번호는 '-'를 제외한 11자리 숫자여야 합니다.");
			}
		}
	}
}