package com.newlearn.playground.teacher.controller;

import java.beans.PropertyEditorSupport;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.newlearn.playground.common.Utils;
import com.newlearn.playground.member.model.vo.Member;
import com.newlearn.playground.teacher.model.service.TeacherService;
import com.newlearn.playground.teacher.model.vo.Student;
import com.newlearn.playground.teacher.model.vo.TeacherAssignment;
import com.newlearn.playground.teacher.model.vo.TeacherAttendance;
import com.newlearn.playground.teacher.model.vo.TeacherClass;
import com.newlearn.playground.teacher.model.vo.TeacherReport;
import com.newlearn.playground.teacher.model.vo.TeacherUploadFile;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/teacher")
@RequiredArgsConstructor
public class TeacherController {
	private final ServletContext application;
	private final TeacherService tService;
	private ObjectMapper mapper = new ObjectMapper();
	
//	@InitBinder
//	public void initBinder(WebDataBinder binder) {
//	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
//	    dateFormat.setLenient(false);
//	    binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
//	}
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
	    binder.registerCustomEditor(Date.class, new PropertyEditorSupport() {
	        private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

	        @Override
	        public void setAsText(String text) throws IllegalArgumentException {
	            if (text == null || text.isEmpty()) {
	                setValue(null);
	                return;
	            }

	            try {
	                // Try parsing as timestamp
	                long millis = Long.parseLong(text);
	                setValue(new Date(millis));
	            } catch (NumberFormatException e) {
	                try {
	                    // Try parsing as formatted date
	                    setValue(dateFormat.parse(text));
	                } catch (ParseException pe) {
	                    throw new IllegalArgumentException("Could not parse date: " + text, pe);
	                }
	            }
	        }
	    });
	}
	
	@GetMapping("/main/{classNo}")
	public String teacherMain(
			@PathVariable("classNo") int classNo,
			Model model,
			Authentication auth
			) {
		model.addAttribute("classNo", classNo);
		TeacherClass tc = tService.getTeacherClass(classNo);
		model.addAttribute("tc", tc);
		Member loginUser = (Member)auth.getPrincipal(); 
		
		if (tc.getTeacherNo() != loginUser.getUserNo()) {
	        // 403 Forbidden, 혹은 권한 없음 페이지 이동
	        throw new AccessDeniedException("해당 클래스의 선생님만 접근할 수 있습니다.");
	    }
		
		return "teacher/teacherMain";
	}
	
	@GetMapping("/attManage/{classNo}")
	public String attManage(
			Model model,
			@PathVariable("classNo") int classNo,
			@RequestParam(required=false) String selectedDate
			) {
		if (selectedDate == null) {
			Date today = new Date();
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			selectedDate = format.format(today);
		}
		
		List<Student> studentList = tService.getStudentList(classNo);
		
		Map<String, Object> attMap = new HashMap<>();
		attMap.put("classNo", classNo);
		attMap.put("selectedDate", selectedDate);
		
		List<TeacherAttendance> attList = tService.getAttList(attMap);
		
		model.addAttribute("attList", attList);
		
		int totalStudentNum = studentList.size();
		int attNum = 0;
		int absentNum = 0;
		int lateNum = 0;
		int earlyLeaveNum = 0;
		for (int i = 0; i < attList.size(); i++) {
			if (attList.get(i).getAttStatus().equals("출석")) {
				attNum++;
			} else if (attList.get(i).getAttStatus().equals("결석")) {
				absentNum++;
			} else if (attList.get(i).getAttStatus().equals("지각")) {
				lateNum++;
			} else if (attList.get(i).getAttStatus().equals("조퇴")) {
				earlyLeaveNum++;
			}
		}
		
		model.addAttribute("totalStudentNum", totalStudentNum);
		model.addAttribute("attNum", attNum);
		model.addAttribute("absentNum", absentNum);
		model.addAttribute("lateNum", lateNum);
		model.addAttribute("earlyLeaveNum", earlyLeaveNum);
		model.addAttribute("classNo", classNo);
		model.addAttribute("selectedDate", selectedDate);
		
		return "teacher/teacherAttendanceManagement";
	}
	
	@PostMapping("/attendance/update")
	@ResponseBody
	public int attendanceUpdate(
			int userNo,
			int classNo,
			String attStatusForUpdate,
			int attNo
			) {
		Map<String, Object> map = new HashMap<>();
		map.put("userNo", userNo);
		map.put("classNo", classNo);
		map.put("attStatusForUpdate", attStatusForUpdate);
		map.put("attNo", attNo);
		
		return tService.attendanceUpdate(map);
	}
	
	@PostMapping("/attendance/noteUpdate")
	@ResponseBody
	public int attendanceNoteUpdate(
			int attNo,
			String note
			) {
		Map<String, Object> map = new HashMap<>();
		map.put("attNo", attNo);
		map.put("note", note);
		
		return tService.attendanceNoteUpdate(map);
	}
	
	@GetMapping("/studentManage/{classNo}")
	public String studentManage(
			Model model,
			@PathVariable("classNo") int classNo
			) {
		List<Student> studentList = tService.getStudentList(classNo);
		model.addAttribute("studentList", studentList);
		model.addAttribute("classNo", classNo);
		
		return "teacher/teacherStudentManagement";
	}
	
	@PostMapping("/studentKick")
	@ResponseBody
	public int studentKick(
			int classNo,
			int userNo
			) {
		Map<String, Object> map = new HashMap<>();
		map.put("classNo", classNo);
		map.put("userNo", userNo);
		
		return tService.studentKick(map);
	}
	
//	@GetMapping("/boardManage/{classNo}")
//	public String boardManage() {
//		return "teacher/teacherBoardManagement";
//	}
//	
//	@GetMapping("/noticeManage/{classNo}")
//	public String noticeManage() {
//		return "teacher/teacherNoticeManagement";
//	}
	
	@GetMapping("/assignmentManage/{classNo}")
	public String assignmentManage(
			@PathVariable("classNo") int classNo,
			Model model
			) {
		// 업무 로직
		// 1. 해당 클래스의 assignment list 를 가져온다.
		List<TeacherAssignment> aList = tService.getAssignmentList(classNo);
		model.addAttribute("aList", aList);
		model.addAttribute("classNo", classNo);
		
		return "teacher/teacherAssignmentManagement";
	}
	
	@GetMapping("/{classNo}/assignment/create")
	public String assignmentCreate(
			@PathVariable("classNo") int classNo,
			Model model,
			@ModelAttribute TeacherAssignment ta
			) {
		model.addAttribute("classNo", classNo);
		model.addAttribute("ta", ta);
		
		return "teacher/teacherCreateAssignment";
	}
	
	@PostMapping("/{classNo}/assignment/insert")
	public String assignmentInsert(
			@PathVariable("classNo") int classNo,
			@ModelAttribute TeacherAssignment ta,
			Model model,
			@RequestParam(value = "upfile", required = false) MultipartFile upfile,
			Authentication auth
			) {
		Member loginUser = (Member)auth.getPrincipal();
		model.addAttribute("classNo: ", classNo);
		ta.setClassNo(classNo);
		
		// 업무로직
		// 1. assignment 테이블에 행 추가하고 pk값 반환.
		// 2. 만약 upfile이 비어있지 않다면,
		//    web 서버에 첨부파일 저장 & upload_file에 파일 경로 저장.
		
		int result = tService.insertAssignment(ta);
		
		if (!upfile.isEmpty()) {
			//
			String changeName = Utils.saveFile2(upfile, application, "assignment");
			TeacherUploadFile tuf = new TeacherUploadFile();
			tuf.setChangeName(changeName);
			tuf.setOriginName(upfile.getOriginalFilename());
			tuf.setFileSize(upfile.getSize());
			tuf.setSource("assignment");
			tuf.setSourceNo(ta.getAssignmentNo());
			tuf.setUserNo(loginUser.getUserNo());
			result = tService.uploadFile(tuf);
			ta.setFileNo(tuf.getFileNo());
			result = tService.updateAssignment(ta);
		}
		
		return "redirect:/teacher/assignmentManage/" + classNo;
	}
	
	@GetMapping("/{classNo}/assignment/modify/{assignmentNo}")
	public String assignmentModify(
			@PathVariable("classNo") int classNo,
			@PathVariable("assignmentNo") int assignmentNo,
			Model model,
			@ModelAttribute TeacherAssignment ta
			) {
		ta = tService.getAssignment(ta);
		
		if (ta.getFileNo() != 0) {
			int fileNo = ta.getFileNo();
			TeacherUploadFile tuf = tService.getTeacherUploadFile(fileNo);
			model.addAttribute("originName", tuf.getOriginName());
		}
		
		try {
			String jsonTa = mapper.writeValueAsString(ta);
			model.addAttribute("jsonTa", jsonTa);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		model.addAttribute("ta", ta);
		
		return "teacher/teacherModifyAssignment";
	}
	
	@PostMapping("/{classNo}/assignment/update")
	@ResponseBody
	public int updateAssignment(
			@ModelAttribute TeacherAssignment ta,
			@RequestParam(value = "upfile", required = false) MultipartFile upfile,
			Authentication auth
			) {
		Member loginUser = (Member)auth.getPrincipal();
		int result = 0;
		if (upfile != null) {
			//
			String changeName = Utils.saveFile2(upfile, application, "assignment");
			TeacherUploadFile tuf = new TeacherUploadFile();
			tuf.setChangeName(changeName);
			tuf.setOriginName(upfile.getOriginalFilename());
			tuf.setFileSize(upfile.getSize());
			tuf.setSource("assignment");
			tuf.setSourceNo(ta.getAssignmentNo());
			tuf.setUserNo(loginUser.getUserNo());
			result = tService.uploadFile(tuf);
			ta.setFileNo(tuf.getFileNo());
		}
		result = tService.updateAssignment(ta);
		
		return result;
	}
	
	@GetMapping("/{classNo}/assignment/delete")
	@ResponseBody
	public int deleteAssignment(
			Model model,
			@PathVariable("classNo") int classNo,
			int assignmentNo
			) {
		model.addAttribute("classNo", classNo);
		
		return tService.deleteAssignment(assignmentNo);
	}
	
	@GetMapping("/updateEntryCode")
	@ResponseBody
	public Map<String, Object> updateEntryCode(
			int classNo,
			String entryCode			
			) {
		// 업무 로직
		// 1. 해당 클래스의 entry_code 를 업데이트 한다. 테이블명: class
		Map<String, Object> map = new HashMap<>();
		map.put("classNo", classNo);
		map.put("entryCode", entryCode);
		
		int result = 0;
		if (entryCode.length() > 5) {
			map.put("result", "입실코드는 5자 이하여야 합니다.");
			return map;
		}
		
		result = tService.updateEntryCode(map);
		map.put("result", "입실코드 생성/수정 완료.");
		
		return map;
	}
	
	@GetMapping("/updateClassName")
	@ResponseBody
	public Map<String, Object> updateClassName(
			int classNo,
			String className
			) {
		Map<String, Object> map = new HashMap<>();
		map.put("classNo", classNo);
		map.put("className", className);
		
		int result = tService.updateClassName(map);
		
		if (result > 0) {
			map.put("result", "클래스명 변경 성공.");
		} else {
			map.put("result", "클래스명 변경 실패.");
		}		
		
		return map;
	}
	
	@GetMapping("/updateClassCode")
	@ResponseBody
	public Map<String, Object> updateClassCode(
			int classNo,
			String classCode
			) {
		Map<String, Object> map = new HashMap<>();
		map.put("classNo", classNo);
		map.put("classCode", classCode);
		
		if (classCode.length() > 8) {
			map.put("result", "클래스룸 초대 코드는 8자리 이하이어야 합니다.");
			return map;
		}
		
		int result = tService.updateClassCode(map);
		
		if (result > 0) {
			map.put("result", "클래스룸 초대 코드 변경 성공.");
		} else {
			map.put("result", "클래스룸 초대 코드 변경 실패.");
		}
		
		return map;
	}
	
	@GetMapping("/reportManage/{classNo}")
	public String reportManage(
			@PathVariable("classNo") int classNo,
			Model model
			) {
		List<TeacherReport> reportList = tService.getReportList(classNo);
		model.addAttribute("reportList", reportList);
		model.addAttribute("classNo", classNo);
		
		return "teacher/teacherReportManagement";
	}
	
	@GetMapping("/updateReportStatus")
	@ResponseBody
	public int updateReportStatus(
			int reportNo,
			String reportStatus
			) {
		Map<String, Object> map = new HashMap<>();
		map.put("reportNo", reportNo);
		if (reportStatus.equals("N")) {
			map.put("reportStatus", "Y");			
		} else {
			map.put("reportStatus", "N");
		}
		
		return tService.updateReportStatus(map);
	}
	
	// 나중에 할일
	// 신고에서 정렬
}









