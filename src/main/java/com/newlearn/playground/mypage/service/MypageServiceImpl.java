package com.newlearn.playground.mypage.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.newlearn.playground.common.model.vo.Image;
import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.mypage.model.dao.MypageDao;
import com.newlearn.playground.mypage.model.vo.Guestbook;
import com.newlearn.playground.mypage.model.vo.Mypage;
import com.newlearn.playground.mypage.model.vo.Subscription;

@Service
public class MypageServiceImpl implements MypageService {

	@Autowired
	private MypageDao mypageDao;
	
	@Override
	public List<Guestbook> loadGuestbook(PageInfo pi, Map<String, Object> paramMap) {
		return mypageDao.loadGuestbook(pi, paramMap);
	}

	@Override
	public int guestbookHide(int guestbookNo) {
		return mypageDao.guestbookHide(guestbookNo);
	}

	@Override
	public int guestbookDelete(int guestbookNo) {
		return mypageDao.guestbookDelete(guestbookNo);
	}

	@Override
	public int guestbookInsert(Guestbook g) {
		return mypageDao.guestbookInsert(g);
	}

	@Override
	public Mypage getMypageByMypageNo(int mypageNo) {
		return mypageDao.getMypageByMypageNo(mypageNo);
	}

	@Override
	public int getMontlyAttCnt(Map<String, String> paramMap) {
		return mypageDao.getMontlyAttCnt(paramMap);
	}

	@Override
	public Subscription getSubscription(String userNo) {
		return mypageDao.getSubscription(userNo);
	}

	@Override
	@Transactional(rollbackFor = {Exception.class})
	public int modifySubscription(Map<String, Object> paramMap) {
		int genNoti = mypageDao.modifySubscription(paramMap);
		if (genNoti == 0) {
			throw new RuntimeException("사용자별 알림 설정 실패");
		}
		if (paramMap.get("classNo") == null) return genNoti;
		int classNoti = mypageDao.modifyClassSubscription(paramMap);
		if (classNoti == 0) {
			throw new RuntimeException("클래스별 알림 설정 실패");
		}
		return 1;
	}

	@Override
	public List<Image> getSlidingImgList(int mypageNo) {
		return mypageDao.getSlidingImgList(mypageNo);
	}

	@Override
	@Transactional(rollbackFor = {Exception.class})
	public int imgSliderUpload(int mypageNo, List<Image> imgList) {
		int result = 0;
		if (imgList.isEmpty()) {
			return result;
		}
		for (Image img : imgList) {
			result = mypageDao.imgUpload(img);
			if (result == 0) {
				throw new RuntimeException("이미지 업로드 실패");
			}
			Map <String, Object> paramMap = new HashMap<>();
			paramMap.put("mypageNo", mypageNo);
			paramMap.put("img", img);
			result = mypageDao.mypageImgUpload(paramMap);
			if (result == 0) {
				throw new RuntimeException("마이페이지 이미지 업로드 실패");
			}
		}
		return result;
	}

	@Override
	public int deleteSlidingImg(int imgNo) {
		return mypageDao.deleteSlidingImg(imgNo);
	}

	@Override
	public Image getImgByChangeName(String changeName) {
		return mypageDao.getImgByChangeName(changeName);
	}

	@Override
	public int newMemberMypage(int mypageNo) {
		return mypageDao.newMemberMypage(mypageNo);
	}

	@Override
	@Transactional
	public int createClass(Map<String, Object> map) {
		int result = mypageDao.createClass(map);
		result = mypageDao.joinClassAsTeacher(map);
		return result;
	}

	@Override
	public int newMemberSubscription(int userNo) {
		return mypageDao.newMemberSubscription(userNo);
	}

	@Override
	public int guestbookCnt(Map <String, Object> paramMap) {
		return mypageDao.guestbookCnt(paramMap);
	}

}
