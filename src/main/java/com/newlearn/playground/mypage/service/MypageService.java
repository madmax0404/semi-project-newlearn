package com.newlearn.playground.mypage.service;

import java.util.List;
import java.util.Map;

import com.newlearn.playground.common.model.vo.Image;
import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.mypage.model.vo.Guestbook;
import com.newlearn.playground.mypage.model.vo.Mypage;
import com.newlearn.playground.mypage.model.vo.Subscription;

public interface MypageService {

	List<Guestbook> loadGuestbook(PageInfo pi, Map<String, Object> paramMap);

	int guestbookHide(int guestbookNo);

	int guestbookDelete(int guestbookNo);

	int guestbookInsert(Guestbook g);

	Mypage getMypageByMypageNo(int mypageNo);

	int getMontlyAttCnt(Map<String, String> paramMap);

	Subscription getSubscription(String userNo);

	int modifySubscription(Map<String, Object> paramMap);

	List<Image> getSlidingImgList(int mypageNo);

	int imgSliderUpload(int mypageNo, List<Image> imgList);

	int deleteSlidingImg(int imgNo);

	Image getImgByChangeName(String changeName);

	int newMemberMypage(int mypageNo);

	int createClass(Map<String, Object> map);

	int newMemberSubscription(int userNo);

	int guestbookCnt(Map<String, Object> paramMap);

}
