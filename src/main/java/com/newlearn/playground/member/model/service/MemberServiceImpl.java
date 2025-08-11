package com.newlearn.playground.member.model.service;

import java.util.HashMap;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.newlearn.playground.member.model.dao.MemberDao;
import com.newlearn.playground.member.model.vo.Member;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	private JavaMailSender mailSender;

	@Autowired
	private MemberDao memberDao;

	// 비밀번호 암호화
	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;

	@Override
	public Member loginMember(Member m) {
		return memberDao.loginMember(m);
	}

	@Override
	public int insertMember(Member m) {
		if (memberDao.idCheck(m.getUserId()) > 0) { // db에 저장 전 아이디 중복 여부 확인
			return 0; // 만약 아이디가 존재한다면 컷
		}

		if (memberDao.emailCheck(m.getEmail()) > 0) {
			return 0; // 이미 가입된 이메일이라면 컷 }
		}

		m.setUserPwd(bcryptPasswordEncoder.encode(m.getUserPwd())); // db저장 전 암호화된 비번으로 변경
		int result = memberDao.insertMember(m);

		return result;
	}

	/*
	 * @Override public int updateMember(Member m) { return
	 * memberDao.updateMember(m); }
	 */

	@Override
	public int idCheck(String userId) {
		return memberDao.idCheck(userId);
	}

	/*
	 * @Override public HashMap<String, Object> selectOne(String userId) { return
	 * memberDao.selectOne(userId); }
	 */

	// 이메일 인증코드 생성 및 발송
	@Override
	public String sendEmail(String email) {

		// 6자리 랜덤 인증코드 생성
		String certCode = "";
		for (int i = 0; i < 6; i++) {
			certCode += (int) (Math.random() * 10);
		}

		// MimeMessage 객체를 이용해 이메일 내용 생성
		MimeMessage message = mailSender.createMimeMessage();

		try {
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

			helper.setFrom("newlearnnewlearn@gmail.com"); // 나중에 실제 이메일 값으로 대체 email.properties 가서 하기
			helper.setTo(email); // 받는 사람 이메일 주소
			helper.setSubject("[new Learn();] 인증번호입니다."); // 이메일 제목

			// HTML 형식의 본문
			String htmlContent = "<h1>[new Learn] 인증번호</h1>";
			htmlContent += "<p>요청하신 인증번호는 다음과 같습니다.</p>";
			htmlContent += "<div style='background-color:#f0f0f0; padding:20px; text-align:center;'>";
			htmlContent += "<h2 style='font-size:24px; color:#333;'>" + certCode + "</h2>";
			htmlContent += "</div>";
			htmlContent += "<p>이 인증번호를 인증코드란에 입력해주세요.</p>";

			helper.setText(htmlContent, true);

			// 이메일 발송
			mailSender.send(message);

		} catch (MessagingException e) {
			e.printStackTrace();
		}

		return certCode;
	}

	@Override
	public String findId(String userName, String ssn) {
		return memberDao.findId(userName, ssn);
	}

	@Override
	public int updatePassword(String userId, String newPassword) {
		String encryptedPassword = bcryptPasswordEncoder.encode(newPassword);

		return memberDao.updatePassword(userId, encryptedPassword);
	}

	@Override
	public String findUserForPasswordReset(String userName, String ssn, String email) {
		return memberDao.findUserForPasswordReset(userName, ssn, email);
	}
}
