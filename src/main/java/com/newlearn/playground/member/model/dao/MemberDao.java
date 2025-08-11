package com.newlearn.playground.member.model.dao;

import java.util.HashMap;

import com.newlearn.playground.member.model.vo.Member;

public interface MemberDao {

	Member loginMember(Member m);

	int insertMember(Member m);

	int idCheck(String userId);
	

//	int updateMember(Member m);
//	void updateMemberChagePwd();
//	HashMap<String, Object> selectOne(String userId);


	String findId(String userName, String ssn);

	int updatePassword(String userId, String newPassword);


	String findUserForPasswordReset(String userName, String ssn, String email);

	int emailCheck(String email);

}
