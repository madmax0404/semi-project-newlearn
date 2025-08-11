package com.newlearn.playground.chat.controller;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.newlearn.playground.chat.model.service.ChattingRoomListService;
import com.newlearn.playground.chat.model.vo.ChatImageDTO;
import com.newlearn.playground.chat.model.vo.ChatMessage;
import com.newlearn.playground.chat.model.vo.ChatMessageDTO;
import com.newlearn.playground.chat.model.vo.ChattingRoom;
import com.newlearn.playground.chat.model.vo.ChattingRoomDTO;
import com.newlearn.playground.chat.model.vo.FriendDTO;
import com.newlearn.playground.common.Utils;
import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.common.template.Pagination;
import com.newlearn.playground.member.model.vo.Member;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/chat")
public class ChattingMainController {
	
	@Autowired
	private ChattingRoomListService crs;
	
	@Autowired
	private ServletContext application;
	
	// 메인화면
	// 친구 목록
	@GetMapping("/main")
	public String chatMain(
//		@RequestParam(value="currentPate", defaultValue="1") int currentPage, // 은성이의 똥코드 (페이징처리 1)
		Authentication auth,
		Model model
		) {
		
		// 로그인 기능 추가 후 주석 해제.
		Member member = (Member)auth.getPrincipal();
		int userNo = member.getUserNo();
		//int userNo = 3;
		
		// 친구 목록 조회 후 리스트에 담기
		List<FriendDTO> memberList = crs.selectFriendList(userNo);
		model.addAttribute("memberList",memberList);
		
		// 채팅방 목록 조회 후 리스트에 담기
		List<ChattingRoom> chattingRoomList = crs.selectChattingRoomList(userNo);
		model.addAttribute("chattingRoomList",chattingRoomList);
		
		// 은성이의 똥코드 (페이징처리 2)
//		int listCount = crs.selectListCount(userNo);
//		int pageLimit = 10;
//		int roomLimit = 10;
//		
//		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, roomLimit);
//
//		List<ChattingRoom> list = crs.selectList(pi,userNo);
//		
//		model.addAttribute("pi",pi);
//		model.addAttribute("list",list);
		
		return "chat/chatMain";
	}

	/* 
	 * 채팅방 생성
	 */
	@ResponseBody
	@PostMapping("/createRoom")
	public Map<String,Object> createRoom(
			ChattingRoomDTO room,
			@RequestParam List<Integer> selectFriendList,
			Authentication auth
			) {
		Map<String,Object> response = new HashMap<>();
		
		log.debug("room {}",room);
		 // 로그인 기능 추가 후 주석 해제.
		 Member member = (Member)auth.getPrincipal();
		 int userNo = member.getUserNo();
		//int userNo = 3;
		
		Map<String, Object> createRoomInf = new HashMap<>();
		createRoomInf.put("userNo", userNo);
		createRoomInf.put("chatTitle", room.getChatTitle());
		createRoomInf.put("chatPublic", room.getChatPublic());
		createRoomInf.put("chatPw", room.getChatPw());
		createRoomInf.put("selectFriendList", selectFriendList);
		
		int result = crs.createRoom(createRoomInf);
		if(result > 0) {
			response.put("success",true);
			response.put("message", "채팅방 생성 성공");
		}else {
			response.put("success",false);
			response.put("message", "채팅방 생성 실패");
		}
		return response;
	}

	@GetMapping("/chatRoomJoin/{chatRoomNo}")
	public String chatRoomJoin(@PathVariable int chatRoomNo , Authentication auth , Model model) {
		// 1. 채팅방 참여정보 추가
		//   - insertUserJoin 재활용
		//  userNo , chatRoomNo
		Map<String, Object> param = new HashMap<>();
		param.put("chatRoomNo", chatRoomNo);
		 // 로그인 기능 추가 후 주석 해제.
		Member member = (Member)auth.getPrincipal();
		int userNo = member.getUserNo();
		String userName = member.getUserName();
//		int userNo = 3;
//		String userName = "심은성";
		
		param.put("userNo", userNo);// 추후 반드시 수정
		model.addAttribute("userName",userName);
		model.addAttribute("userNo",userNo); // 내채팅 남의채팅 확인용
		
		int result = crs.insertUserJoin(param);
		
		// 2. 참여자 정보 불러오기
		List<FriendDTO> memberList = crs.selectRoomMembers(param);
		model.addAttribute("memberList",memberList);
		
		List<FriendDTO> friendList = crs.selectFriendList(userNo);
		model.addAttribute("friendList",friendList);
		
		// 3. 채팅정보 불러오기
		List<ChatMessageDTO> chatMessageList = crs.chatMessageList(param);
		model.addAttribute("chatMessageList",chatMessageList);
		
		// 4. 공지게시글 조회
		ChatMessageDTO noti = chatMessageList.stream()
		.filter( cm -> cm.getIsNoti().equals("Y") && cm.getNotiDate() != null)
		.sorted( (cm1,cm2) -> cm2.getNotiDate().compareTo(cm1.getNotiDate()) ) 
		.findFirst()
		.orElseGet(() -> new ChatMessageDTO());
		model.addAttribute("notification" ,noti);
		
		// 5. 현재 채팅방 정보 조회
		ChattingRoomDTO chatInfo = crs.selectChatRoom(param);
		model.addAttribute("chatInfo", chatInfo);
		log.debug("chatInfo : {}",chatInfo);
		
		return "chat/chatRoom";
	}
	
	@PostMapping("/upload")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> handleFileUpload(@RequestParam("file") MultipartFile file, ChatMessage cm) throws IOException {
		log.debug("cm : {}",cm);
		// 1. file을 웹서버에 업로드
		String changeName = Utils.saveFile2(file, application, "chat_img");
		
		// 2. file을 테이블에 업로드
		ChatImageDTO dto = new ChatImageDTO();
		dto.setChangeName(changeName);
		dto.setOriginName(file.getOriginalFilename());
		
		cm.setContent("<img src='"+application.getContextPath()+changeName+"'/>");
		int result = crs.insertChatImage(dto, cm);
		
		if(result == 0) {
			return ResponseEntity.internalServerError().build();
		}
		
		// 3. file이 저장된 경로와 이름을 반환
		Map<String, Object> data = new HashMap<>();
		data.put("fileUrl", changeName);  // 공유할 URL
		data.put("messageNo", cm.getMessageNo());  // 공유할 URL
	    return ResponseEntity.ok().body(data);
	}
	
	@PostMapping("/roomExit/{chatRoomNo}")
	public String roomExit(
			@PathVariable int chatRoomNo,
			Authentication auth
			) {
		
		// 채팅방 나가기
		Member m  = (Member) auth.getPrincipal();
		
		Map<String, Object> param = new HashMap<>();
		param.put("chatRoomNo",chatRoomNo);
		param.put("userNo", m.getUserNo());
		
		int result = crs.roomExit(param);
		
		if(result == 0) {
			throw new RuntimeException("채팅방 나가기 실패");
		}
		return "redirect:/chat/main";
	}
	
	// 은성이의 똥코드 (채팅방 수정)
//	@PostMapping("/updateRoom/{chatRoomNo}")
//	@ResponseBody
//	public Map<String,Object> updateRoom(
//			@PathVariable int chatRoomNo,
//			ChattingRoomDTO roomInfo,
//			@RequestParam(value="selectFriendList", required = false) List<Integer> selectFriendList,
//			Authentication auth			
//			){
//		Map<String, Object> response = new HashMap<>();
//		Member member = (Member)auth.getPrincipal();
//		int userNo = member.getUserNo();
//		
//		
//		
//		
//		return response;
//	}
}