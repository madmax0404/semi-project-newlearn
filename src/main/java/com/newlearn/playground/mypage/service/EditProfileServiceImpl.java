package com.newlearn.playground.mypage.service;

import java.util.Map;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.newlearn.playground.member.model.vo.Member;
import com.newlearn.playground.mypage.model.dao.EditProfileDao;
import com.newlearn.playground.mypage.model.vo.Mypage;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EditProfileServiceImpl implements EditProfileService {
	private final EditProfileDao dao;
	private final BCryptPasswordEncoder passwordEncoder;

	@Override
	@Transactional
	public int editProfile(Map<String, Object> map) {
		Member loginUser = (Member)map.get("loginUser");
		loginUser.setUserPwd(passwordEncoder.encode(loginUser.getUserPwd()));
		
		int result = dao.editProfileMember(loginUser);
		
		Mypage mypage = (Mypage)map.get("mypage");
		
		result = dao.editProfileMypage(mypage);
		
		return result;
	}
}
