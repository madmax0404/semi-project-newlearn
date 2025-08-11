package com.newlearn.playground.friend.model.service;

import java.util.List;
import java.util.Map;

import com.newlearn.playground.member.model.vo.Member;

public interface FriendService {

	int send(int userNo, int friendUserNo);

	int accept(int userNo, int friendUserNo);

	int reject(int userNo, int friendUserNo);

	int deleteFriend(int userNo, int friendUserNo);

	List<Member> getFriendList(int userNo);

	List<Member> getrequestList(int userNo);

	String favoriteBtn(int userNo, int friendUserNo);

	List<Member> getfavList(int userNo);

	String hide(int userNo, int friendUserNo);

	List<Member> gethideList(int userNo);

	 List<Map<String, Object>> getRefavList(int userNo);

	List<Member> searchMember(int userNo, String keyword);

	

	

	

}
