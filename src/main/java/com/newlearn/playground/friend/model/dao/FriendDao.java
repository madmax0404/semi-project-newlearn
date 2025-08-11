package com.newlearn.playground.friend.model.dao;

import java.util.List;
import java.util.Map;

import com.newlearn.playground.member.model.vo.Member;

public interface FriendDao {

	int send(int userNo, int friendUserNo);

	
	int updateAccept(int friendUserNo, int userNo);
	
	int insertAccept(int userNo, int friendUserNo);
	
	int reject(int userNo, int friendUserNo);

	int deleteFriend(int userNo, int friendUserNo);
	
	List<Member> FriendList(int userNo);

	List<Member> requestList(int userNo);
	

	String updatefavorite(int userNo, int friendUserNo);

	List<Member> favList(int userNo);

	String hide(int userNo, int friendUserNo);

	List<Member> hideList(int userNo);

	 List<Map<String, Object>> reFriendList(int userNo);

	List<Member> searchMember(int userNo, String keyword);

	


	



	

}
