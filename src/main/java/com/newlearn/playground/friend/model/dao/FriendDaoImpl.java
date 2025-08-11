package com.newlearn.playground.friend.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.member.model.vo.Member;


@Repository
public class FriendDaoImpl implements FriendDao{
	
	@Autowired
	private SqlSessionTemplate session;

	@Override
	public int send(int userNo, int friendUserNo) {
		return session.insert("friend.send", Map.of("userNo", userNo, "friendUserNo", friendUserNo));
	
	}

	@Override
	public int updateAccept(int friendUserNo, int userNo) {
		return session.update("friend.updateAccept", Map.of("userNo", userNo,"friendUserNo", friendUserNo));
	}
	
	@Override
	public int insertAccept(int userNo, int friendUserNo) {
		return session.insert("friend.insertAccept", Map.of("userNo", userNo,"friendUserNo", friendUserNo));
	}

	

	@Override
	public int reject(int userNo, int friendUserNo) {
		return session.update("friend.reject", Map.of("userNo", userNo, "friendUserNo", friendUserNo));
		
	}
	
	
	@Override
	public List<Member> FriendList(int userNo) {
		
		return session.selectList("FriendList", userNo);
	}

	@Override
	public List<Member> requestList(int userNo) {
		return session.selectList("requestList", userNo);
	}

	

	@Override
	public String updatefavorite(int userNo, int friendUserNo) {
		Map<String, Object> params = Map.of("userNo", userNo, "friendUserNo", friendUserNo);
		session.update("friend.favorite", params);
		 return session.selectOne("friend.selectFav", params);
		
	}

	@Override
	public List<Member> favList(int userNo) {
		return session.selectList("friend.favList",userNo);
	}
	
	@Override
	public String hide(int userNo, int friendUserNo) { 
		 Map<String, Object> params = Map.of("userNo", userNo, "friendUserNo", friendUserNo);
		 session.update("friend.hide", params);
		 return session.selectOne("friend.selectHide", params);
			    
	}
	

	@Override
	public List<Member> hideList(int userNo) {
		return session.selectList("friend.hideList", userNo);
	}

	@Override
	public  List<Map<String, Object>> reFriendList(int userNo) {
		return session.selectList("friend.reFriendList",userNo);
	}


	@Override
	public int deleteFriend(int userNo, int friendUserNo) {
		return session.update("friend.deleteFriend", Map.of("userNo", userNo,"friendUserNo", friendUserNo));
		
	}

	@Override
	public List<Member> searchMember(int userNo, String keyword) {
		
		return session.selectList("friend.serchMember", Map.of("userNo",userNo, "keyword",keyword));
	}

	


	

}
