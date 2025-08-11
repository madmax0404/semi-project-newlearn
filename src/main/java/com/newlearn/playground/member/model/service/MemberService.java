package com.newlearn.playground.member.model.service;

import java.util.HashMap;

import com.newlearn.playground.member.model.vo.Member;

public interface MemberService {
	
    String sendEmail(String email);

	Member loginMember(Member m);

	int insertMember(Member m);

	int idCheck(String userId);
	
//	int updateMember(Member m);

//	HashMap<String, Object> selectOne(String userId);

	String findId(String userName, String ssn);

	int updatePassword(String userId, String newPassword);
	
	String findUserForPasswordReset(String userName, String ssn, String email);

	// 아이디 중복 체크
	  //  int idCheck(String checkId);

}
