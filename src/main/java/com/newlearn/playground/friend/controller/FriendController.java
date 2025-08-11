package com.newlearn.playground.friend.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.newlearn.playground.friend.model.service.FriendService;
import com.newlearn.playground.member.model.vo.Member;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/friend")
@RequiredArgsConstructor
public class FriendController {

	@Autowired
	private FriendService friendService;
	@Autowired
	private SimpMessagingTemplate messagingTemplate;
	
	
	@GetMapping("/myFriendList")
	public String defaultFriendPage(HttpSession session, Model model) {
	    Member loginUser = (Member) session.getAttribute("loginUser");
	    List<Member> friends = friendService.getFriendList(loginUser.getUserNo());
	    model.addAttribute("friendList", friends);

	    return "friend/myFriendList";
	}
	


	
	// 친구 목록 리스트 조회
	@ResponseBody
	@GetMapping("/reFriendList")
	public  List<Map<String, Object>> reFriendList(HttpSession session) {
		Member loginUser = (Member) session.getAttribute("loginUser");
		return friendService.getRefavList(loginUser.getUserNo());
			
		}
	
	// 즐겨찾기 리스트
	@ResponseBody
	@GetMapping("/favList")
	public List<Member> favList(HttpSession session) {
		Member loginUser = (Member) session.getAttribute("loginUser");
		return friendService.getfavList(loginUser.getUserNo());
			
		}
	
	// 숨긴친구 리스트
	@ResponseBody
	@GetMapping("/hideList")
	public List<Member> hideList(HttpSession session){
		Member loginUser = (Member) session.getAttribute("loginUser");
		return friendService.gethideList(loginUser.getUserNo());
		}
	
	
	// 요청받은 친구 목록 리스트
	@ResponseBody
	@GetMapping("/requestList")
	public List<Member> requestList(HttpSession session) {
		Member loginUser = (Member) session.getAttribute("loginUser");
		return friendService.getrequestList(loginUser.getUserNo());
		
		}
	

	// 친구요청 보내기
	@PostMapping("/send")
	@ResponseBody
	public String sendRequest(@RequestParam int friendUserNo, HttpSession session) {
		Member loginUser = (Member) session.getAttribute("loginUser"); 
	    int userNo = loginUser.getUserNo();
		int result = friendService.send(userNo, friendUserNo);
		System.out.println("UPDATE 결과 행 수: " + result);
		//return result > 0 ? "success" : "fail"; 
		
		 if (result > 0) {
	        // WebSocket으로 친구요청 알림 전송
	        Map<String, Object> payload = new HashMap<>(); 
	        payload.put("userNo", userNo);
	        payload.put("userName", loginUser.getUserName());
	        payload.put("email", loginUser.getEmail()); 

		        // 친구 요청 받은 사용자에게 알림 전송
		        messagingTemplate.convertAndSend("/topic/friendRequest/" + friendUserNo, payload);
		        System.out.println("🔔 친구요청 알림 전송 대상: " + friendUserNo);
		        System.out.println("📦 payload: " + payload);

		        return "success";
		    } else {
		        return "fail";
		    }
	}
	

	// 친구 요청 수락
	@PostMapping("/accept")
	@ResponseBody
	public String acceptRequest(@RequestParam int friendUserNo, HttpSession session) {
	    Member me = (Member) session.getAttribute("loginUser"); // 수락한 사람(나)
	    int userNo = me.getUserNo();                             // 수락자 번호

	    int result = friendService.accept(friendUserNo, userNo); // (요청자, 수락자) 순서 그대로 사용 중

	    if (result > 0) {
	        // 요청 보낸 사람 개인 토픽으로 "수락됨" 알림 전송
	        Map<String, Object> payload = new HashMap<>();
	        payload.put("type", "ACCEPT");
	        payload.put("userNo", me.getUserNo());       // 수락한 사람 번호
	        payload.put("userName", me.getUserName());   // 수락한 사람 이름
	        payload.put("email", me.getEmail());         // 수락한 사람 이메일(원하면)

	        messagingTemplate.convertAndSend("/topic/friendAccept/" + friendUserNo, payload);
	        return "success";
	    }
	    return "fail";
	}

	// 친구요청 거절
	@PostMapping("/reject")
	@ResponseBody
	public String rejectRequest(@RequestParam int friendUserNo, HttpSession session) {
		int userNo = ((Member) session.getAttribute("loginUser")).getUserNo();
		int result =  friendService.reject(friendUserNo, userNo);
		//System.out.println("UPDATE 결과 행 수: " + result);
		return result > 0 ? "success" : "fail"; 
	}

	// 친구 삭제
	@ResponseBody
	@PostMapping("/deleteBtn")
	public String deleteFriend(@RequestParam int friendUserNo, HttpSession session) {
		int userNo = ((Member) session.getAttribute("loginUser")).getUserNo();
		int result1 =  friendService.deleteFriend(userNo,friendUserNo);
		int result2 = friendService.deleteFriend(friendUserNo,userNo); // 양방향 삭제
		
	    return (result1 + result2 > 0) ? "success" : "fail";
		
		
	}

	

	// 즐겨찾기 기능
	@ResponseBody
	@PostMapping("/favoritBtn")
	public String favoritBtn(@RequestParam int friendUserNo, HttpSession session ) {
		Member loginUser = (Member) session.getAttribute("loginUser");
		int userNo = loginUser.getUserNo();
		return friendService.favoriteBtn(userNo, friendUserNo);
		
	}

	
	// 친구 숨기기 기능
	@PostMapping("/hide")
	@ResponseBody
	public String toggleHide(@RequestParam int friendUserNo, HttpSession session) {
	    Member loginUser = (Member) session.getAttribute("loginUser");
	    int userNo = loginUser.getUserNo();
	    return  friendService.hide(userNo, friendUserNo); 

	   
	}
	
	// 유저 검색기능
	@ResponseBody
	@GetMapping("/searchMember")
	public List<Member> searchMember(@RequestParam String keyword, HttpSession session){
		int userNo =((Member) session.getAttribute("loginUser")).getUserNo();
		return friendService.searchMember(userNo, keyword);
		
	}
	
	
}





















