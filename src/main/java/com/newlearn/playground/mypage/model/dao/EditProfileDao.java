package com.newlearn.playground.mypage.model.dao;

import com.newlearn.playground.member.model.vo.Member;
import com.newlearn.playground.mypage.model.vo.Mypage;

public interface EditProfileDao {

	int editProfileMember(Member loginUser);

	int editProfileMypage(Mypage mypage);

}
