package com.newlearn.playground.mypage.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.newlearn.playground.classroom.model.vo.ClassJoin;
import com.newlearn.playground.classroom.model.vo.Classroom;
import com.newlearn.playground.classroom.service.ClassroomService;
import com.newlearn.playground.common.Utils;
import com.newlearn.playground.common.model.vo.Image;
import com.newlearn.playground.member.model.vo.Member;
import com.newlearn.playground.mypage.model.vo.Mypage;
import com.newlearn.playground.mypage.model.vo.Subscription;
import com.newlearn.playground.mypage.service.MypageService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class MypageController {
	private final ServletContext application; 
	private final MypageService mypageService;
	private final ClassroomService classService;
	private final SimpMessagingTemplate messagingTemplate;
	
	@GetMapping("/{mypageNo}")
	public String myPage(@PathVariable("mypageNo") int mypageNo, 
			@RequestParam(name = "from", defaultValue = "mypage") String from,
			@RequestParam(name = "to", defaultValue = "guestbook") String to, 
			Authentication auth, HttpSession session, Model model) {
		
		Member userDetails = (Member)auth.getPrincipal();
		model.addAttribute("userDetails", userDetails);
		
		// 첫 회원 마이페이지 등록
		Mypage mypage = mypageService.getMypageByMypageNo(mypageNo);
		if (mypage == null) {
			int result = mypageService.newMemberMypage(mypageNo);
			if (result == 0) throw new RuntimeException("마이페이지 생성 실패..!");
			mypage = mypageService.getMypageByMypageNo(mypageNo);
		}
		model.addAttribute("mypage", mypage);
		
		// subscription 정보가 없는 경우
		Subscription subs = mypageService.getSubscription(userDetails.getUserNo()+"");
		if (subs == null) {
			int result = mypageService.newMemberSubscription(userDetails.getUserNo());
			if (result == 0) throw new RuntimeException("subscription 테이블 데이터 추가 실패");
		}
		
		// 슬라이딩 이미지 정리 후 로딩
		Utils.fileDelete(mypageNo, application, mypageService, "image");
		List<Image> imgList = mypageService.getSlidingImgList(mypageNo);
		List<String> imgNameList = imgList.stream().map(img -> img.getChangeName()).collect(Collectors.toList());
		model.addAttribute("imgNameList", imgNameList);
		
		// 클래스룸 데이터
		model.addAttribute("classList", classService.getClasslist(mypageNo));
		
		// div container 비동기 로딩을 위한 데이터
		model.addAttribute("to", to);
		model.addAttribute("from", from);
		model.addAttribute("mypageNo", mypageNo);
		model.addAttribute("mypage", mypage);
		
		// 권한 제거 (나갈 때)
		Member loginUser = (Member)auth.getPrincipal();
		if (mypageNo == loginUser.getUserNo()) {
			if (session.getAttribute("classRole") != null) {
				if (session.getAttribute("classRole").equals("teacher")) {
					List<GrantedAuthority> filteredAuths = auth.getAuthorities().stream()
							.filter(a -> !a.getAuthority().equals("ROLE_TEACHER"))
							.collect(Collectors.toList());
					Authentication newAuth2 = new UsernamePasswordAuthenticationToken(auth.getPrincipal(), auth.getCredentials(), filteredAuths);
					SecurityContextHolder.getContext().setAuthentication(newAuth2);
				}			
			}
			session.removeAttribute("classNo");
			session.removeAttribute("className");
			session.removeAttribute("classRole");			
		}
		return "mypage/mypage";
	}
	
	@ResponseBody
	@PostMapping("/createClass")
	public int createClass(String className, String classCode, int userNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("className", className);
		map.put("classCode", classCode);
		map.put("userNo", userNo);
		int result = mypageService.createClass(map);
		return result;
	}
	
	@PostMapping("/exitClass")
	public String exitClassroom(@RequestParam Map<String, String> paramMap, RedirectAttributes ra) {
		Classroom c = classService.getClassroom(Integer.parseInt(paramMap.get("classNo")));
		if (!c.getClassName().equals(paramMap.get("classNameEntered"))) {
			ra.addFlashAttribute("alertMsg", "클래스명이 일치하지 않습니다. 다시 확인해주세요.");
			return "redirect:/mypage/" + paramMap.get("mypageNo");
		}
		int result = classService.exitClass(paramMap);
		if (result == 1) {
			ra.addFlashAttribute("alertMsg", "정상적으로 클래스룸을 탈퇴했습니다.");
		} else {
			ra.addFlashAttribute("alertMsg", "클래스룸을 탈퇴하던 중 에러가 발생하였습니다.");
		}
		return "redirect:/mypage/" + paramMap.get("mypageNo");
	}
	
	@PostMapping("/joinClass")
	public String joinClassroom(@RequestParam Map<String, String> paramMap, Authentication auth, RedirectAttributes ra) {
		Classroom c = classService.getClassByClasscode(paramMap.get("classCodeEntered"));
		if (c == null) {
			ra.addFlashAttribute("alertMsg", "클래스코드가 일치하는 클래스룸이 없습니다. 다시 확인해주세요.");
			return "redirect:/mypage/" + paramMap.get("mypageNo");
		}
		System.out.println("class: " + c);
		paramMap.put("classNo", c.getClassNo()+"");
		int result = classService.joinClass(paramMap);
		if (result == 1) {
			ra.addFlashAttribute("alertMsg", "정상적으로 클래스룸에 참가했습니다.");
			Map <String, Object> message = new HashMap<>();
			message.put("className", c.getClassName());
			message.put("userNo", ((Member)auth.getPrincipal()).getUserNo());
			message.put("userName", ((Member)auth.getPrincipal()).getUsername());
			messagingTemplate.convertAndSend("/topic/class/" + c.getClassNo(), message);
		} else {
			ra.addFlashAttribute("alertMsg", "클래스룸 참가 중 에러가 발생했습니다.");
		}
		return "redirect:/mypage/" + paramMap.get("mypageNo");
	}
	
	@GetMapping("/imgSlider")
	public String imgSlider(@RequestParam int mypageNo, Model model) {
		Map <String, List<Image>> slidingImgMap = new HashMap<>();
		slidingImgMap.put("slidingImgList", mypageService.getSlidingImgList(mypageNo));
		model.addAttribute("slidingImg", slidingImgMap);
		model.addAttribute("mypageNo", mypageNo);
		return "mypage/imgSlider";
	}
	
	@PostMapping("/imgSlider")
	public String imgSliderUpload(@RequestParam int mypageNo, RedirectAttributes ra,
			@RequestParam(value="upfile", required=false) List<MultipartFile> upfiles) {
		List<Image> imgList = new ArrayList<>();
		for (MultipartFile upfile : upfiles) {
			if (upfile.isEmpty()) {
				continue;
			}
			String changeName = Utils.getChangeName(upfile, application, "image", mypageNo);
			Image img = new Image();
			img.setChangeName(changeName);
			img.setOriginName(upfile.getOriginalFilename());
			imgList.add(img);
		}
		int result = mypageService.imgSliderUpload(mypageNo, imgList); 
		if (result == 0) { 
			ra.addFlashAttribute("alertMsg", "슬라이딩 이미지 추가/변경 실패");
		} else {
			ra.addFlashAttribute("alertMsg", "슬라이딩 이미지 추가/변경 성공");
		}
		return "redirect:/mypage/" + mypageNo;
	}
	
	@ResponseBody
	@GetMapping("/deleteSlidingImg")
	public Map <String, String> deleteSlidingImg(@RequestParam int imgNo) {
		Map <String, String> response = new HashMap<>();
		int result = mypageService.deleteSlidingImg(imgNo);
		if (result == 1) {
			response.put("response", "삭제 성공 ^_^");
		} else {
			response.put("response", "삭제 실패 ㅠ.ㅠ");
		}
		return response;
	}
	
	@GetMapping("/classNotiMod")
	@ResponseBody
	public ClassJoin classNotiModal(@RequestParam Map<String, Object> paramMap) {
		return classService.getClassJoin(paramMap);
	}
	
	@GetMapping("/notiSetMod")
	public String notiSettingModal(@RequestParam String mypageNo, Model model) {
		Subscription subscription = mypageService.getSubscription(mypageNo);
		List<Classroom> classroomList = classService.getClasslist(Integer.parseInt(mypageNo));
		model.addAttribute("subscription", subscription);
		model.addAttribute("classroomList", classroomList);
		return "mypage/notiSetMod";
	}
	
	@PostMapping("/notiSetForm")
	public String notiSettingForm(@RequestParam(required = false) List<String> generalNoti, RedirectAttributes ra,
			@RequestParam(required = false) List<String> classNoti, @RequestParam(required = false) Integer classNo, 
			@RequestParam int userNo) {
		Map <String, Object> paramMap = new HashMap<>();
		paramMap.put("generalNoti", generalNoti);
		paramMap.put("classNoti", classNoti);
		paramMap.put("classNo", classNo);
		paramMap.put("userNo", userNo);
		int result = mypageService.modifySubscription(paramMap);
		if (result == 1) {
			ra.addFlashAttribute("alertMsg", "알림설정 변경사항이 정상적으로 수정되었습니다.");
		} else {
			ra.addFlashAttribute("alertMsg", "알림설정 변경에 실패했습니다.");
		}
		return "redirect:/mypage/" + userNo;
	}
	
}
