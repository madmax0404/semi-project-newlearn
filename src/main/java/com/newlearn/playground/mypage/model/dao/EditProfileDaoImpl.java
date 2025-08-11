package com.newlearn.playground.mypage.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.member.model.vo.Member;
import com.newlearn.playground.mypage.model.vo.Mypage;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class EditProfileDaoImpl implements EditProfileDao {
	private final SqlSessionTemplate session;

	@Override
	public int editProfileMember(Member loginUser) {
		return session.update("editProfile.editProfileMember", loginUser);
	}

	@Override
	public int editProfileMypage(Mypage mypage) {
		return session.update("editProfile.editProfileMypage", mypage);
	}
}
