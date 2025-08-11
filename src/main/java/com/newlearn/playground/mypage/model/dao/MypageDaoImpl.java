package com.newlearn.playground.mypage.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.common.model.vo.Image;
import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.mypage.model.vo.Guestbook;
import com.newlearn.playground.mypage.model.vo.Mypage;
import com.newlearn.playground.mypage.model.vo.Subscription;

@Repository
public class MypageDaoImpl implements MypageDao {

	@Autowired
	private SqlSessionTemplate session;
	
	@Override
	public List<Guestbook> loadGuestbook(PageInfo pi, Map<String, Object> paramMap) {
		paramMap.put("offset", (pi.getCurrentPage()-1) * pi.getBoardLimit());
		paramMap.put("limit", pi.getBoardLimit());
		return session.selectList("guestbook.loadGuestbook", paramMap);
	}

	@Override
	public int guestbookHide(int guestbookNo) {
		return session.update("guestbook.guestbookHide", guestbookNo);
	}

	@Override
	public int guestbookDelete(int guestbookNo) {
		return session.update("guestbook.guestbookDelete", guestbookNo);
	}

	@Override
	public int guestbookInsert(Guestbook g) {
		return session.insert("guestbook.guestbookInsert", g);
	}

	@Override
	public Mypage getMypageByMypageNo(int mypageNo) {
		return session.selectOne("mypage.getMypageByMypageNo", mypageNo);
	}

	@Override
	public int getMontlyAttCnt(Map<String, String> paramMap) {
		return session.selectOne("mypage.getMontlyAttCnt", paramMap);
	}

	@Override
	public Subscription getSubscription(String userNo) {
		return session.selectOne("mypage.getSubscription", userNo);
	}

	@Override
	public int modifySubscription(Map<String, Object> paramMap) {
		return session.update("mypage.modifySubscription", paramMap);
	}

	@Override
	public int modifyClassSubscription(Map<String, Object> paramMap) {
		return session.update("mypage.modifyClassSubscription", paramMap);
	}

	@Override
	public List<Image> getSlidingImgList(int mypageNo) {
		return session.selectList("mypage.getSlidingImgList", mypageNo);
	}

	@Override
	public int imgUpload(Image img) {
		return session.insert("mypage.imgUpload", img);
	}

	@Override
	public int mypageImgUpload(Map<String, Object> paramMap) {
		return session.insert("mypage.mypageImgUpload", paramMap);
	}

	@Override
	public int deleteSlidingImg(int imgNo) {
		return session.delete("mypage.deleteSlidingImg", imgNo);
	}

	@Override
	public Image getImgByChangeName(String changeName) {
		return session.selectOne("mypage.getImgByChangeName", changeName);
	}

	@Override
	public int newMemberMypage(int mypageNo) {
		return session.insert("mypage.newMemberMypage", mypageNo);
	}

	@Override
	public int createClass(Map<String, Object> map) {
		return session.insert("mypage.createClass", map);
	}

	@Override
	public int joinClassAsTeacher(Map<String, Object> map) {
		return session.insert("mypage.joinClassAsTeacher", map);
	}

	@Override
	public int newMemberSubscription(int userNo) {
		return session.insert("mypage.newMemberSubscription", userNo);
	}

	@Override
	public int guestbookCnt(Map <String, Object> paramMap) {
		return session.selectOne("guestbook.guestbookCnt", paramMap);
	}

}
