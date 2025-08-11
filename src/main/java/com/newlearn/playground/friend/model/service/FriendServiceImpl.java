package com.newlearn.playground.friend.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.newlearn.playground.friend.model.dao.FriendDao;
import com.newlearn.playground.member.model.vo.Member;

@Service
public class FriendServiceImpl implements FriendService {
	
	@Autowired
	private FriendDao friendDao;
	

	@Override
	 public int send(int userNo, int friendUserNo) {
		return friendDao.send(userNo, friendUserNo);
    }
	

	@Override
	public int accept(int userNo, int friendUserNo) {
		int result1 = friendDao.updateAccept(friendUserNo, userNo);
		int result2 = friendDao.insertAccept(userNo, friendUserNo);	
		System.out.println("UPDATE 결과 행 수: " + result1);
		System.out.println("Insert 실행 결과: " + result2);
		 return result1 + result2;
		
	}

	@Override
	public int reject(int userNo, int friendUserNo) {
        return friendDao.reject(userNo, friendUserNo);
    }

	@Override
	public int deleteFriend(int userNo, int friendUserNo) {
		int result1 = friendDao.deleteFriend(friendUserNo, userNo);      
	    int result2 = friendDao.deleteFriend(userNo, friendUserNo); 
	    System.out.println("UPDATE 결과 행 수: " + result1);
		System.out.println("Insert 실행 결과: " + result2);
	    return result1 + result2;
		
	}


	@Override
	public List<Member> getFriendList(int userNo) {
		return friendDao.FriendList(userNo);
		
	}


	@Override
	public List<Member> getrequestList(int userNo) {
		return friendDao.requestList(userNo);
	}


	@Override
	public String favoriteBtn(int userNo, int friendUserNo) {
		return friendDao.updatefavorite(userNo,friendUserNo);
		
	}


	@Override
	public List<Member> getfavList(int userNo) {
		return friendDao.favList(userNo);
	}


	@Override
	public String hide(int userNo, int friendUserNo) {
		 return friendDao.hide(userNo, friendUserNo);
	}
	


	@Override
	public List<Member> gethideList(int userNo) {
		
		return friendDao.hideList(userNo);
	}


	@Override
	public  List<Map<String, Object>> getRefavList(int userNo) {
		return friendDao.reFriendList(userNo);
	}


	@Override
	public List<Member> searchMember(int userNo, String keyword) {
		
		return friendDao.searchMember(userNo, keyword);
	}


	


	


}
