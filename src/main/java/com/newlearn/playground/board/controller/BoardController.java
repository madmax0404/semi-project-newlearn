package com.newlearn.playground.board.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.newlearn.playground.board.model.service.AssignmentService;
import com.newlearn.playground.board.model.service.AssignmentSubmissionService;
import com.newlearn.playground.board.model.service.BoardService;
import com.newlearn.playground.board.model.service.ReplyService;
import com.newlearn.playground.board.model.vo.Assignment;
import com.newlearn.playground.board.model.vo.AssignmentSubmission;
import com.newlearn.playground.board.model.vo.Board;
import com.newlearn.playground.board.model.vo.BoardExt;
import com.newlearn.playground.board.model.vo.BoardFile;
import com.newlearn.playground.board.model.vo.Reply;
import com.newlearn.playground.classroom.model.vo.ClassJoin;
import com.newlearn.playground.classroom.service.ClassroomService;
import com.newlearn.playground.common.Utils;
import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.common.template.Pagination;
import com.newlearn.playground.member.model.vo.Member;
import com.newlearn.playground.teacher.model.vo.TeacherReport;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@RequestMapping("/board")
@Slf4j
public class BoardController {

	private final BoardService boardService;

	private final ReplyService replyService;

	private final AssignmentService assignmentService;

	private final ClassroomService classRoomService;

	private final AssignmentSubmissionService assignmentSubmissionService;

	private final ServletContext application;

	private final ResourceLoader resourceLoader;

	// 빈 날짜문자열 null로 변환하는 메서드
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		binder.registerCustomEditor(java.util.Date.class,
				new CustomDateEditor(new SimpleDateFormat("yyyy-MM-dd"), true));
	}

	// 게시판 조회
	@GetMapping("/list/{category}")
	public String categoryBoardList(@PathVariable("category") String category,
			@RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
			@RequestParam Map<String, Object> paramMap, @RequestParam("classNo") int classNo, Authentication auth,
			Model model) {
		Member loginUser = (Member) auth.getPrincipal();

		// classno 조회
		ClassJoin classInfo = classRoomService.getClassJoinByUserNo(loginUser.getUserNo(), classNo);
		int classNoo = classInfo.getClassNo();

		// 카테고리 설정
		paramMap.put("category", category);
		paramMap.put("deleted", "N");
		paramMap.put("classNo", classNoo);
		paramMap.put("onlyMy", false);

//		if ("A".equals(category) && "ROLE_USER".equals(loginUser.getUserRole())) {
//			paramMap.put("onlyMy", true);
//			paramMap.put("userNo", loginUser.getUserNo());
//		} else {
//			paramMap.put("onlyMy", false);
//		}

		// 페이징 계산
		int listCount = boardService.selectListCount(paramMap);
		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, 10, 10);

		int startRow = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
		int endRow = startRow + pi.getBoardLimit() - 1;

		paramMap.put("startRow", startRow);
		paramMap.put("endRow", endRow);

		// 데이터 조회
		List<Board> list = boardService.selectList(pi, paramMap);

		// 뷰에 전달
		model.addAttribute("list", list);
		model.addAttribute("pi", pi);
		model.addAttribute("param", paramMap);
		model.addAttribute("category", category);
		model.addAttribute("loginUser", loginUser);

		return "main";
	}

	// 글쓰기 화면 이동 (전체게시판에서 - category 없음)
	@GetMapping("/insert")
	public String enrollFormWithoutCategory(Model model, @RequestParam("classNo") int classNo, Authentication auth) {
		model.addAttribute("board", new Board()); // category 설정 안함

		int userNo = ((Member) auth.getPrincipal()).getUserNo();
		ClassJoin classInfo = classRoomService.getClassJoinByUserNo(userNo, classNo);
		List<Assignment> assignments = assignmentService.getAssignmentsWithFileByClassNo(classInfo.getClassNo());

		model.addAttribute("assignments", assignments);

		return "board/boardEnrollForm";
	}

	// 글쓰기 화면 이동 (GET)
	@GetMapping("/insert/{category}")
	public String enrollForm(@PathVariable("category") String category, @RequestParam("classNo") int classNo,
			Authentication auth, RedirectAttributes ra, HttpSession session, Model model) {
		// 권한 검사
		if ("N".equals(category)) {
			String classRole = (String) session.getAttribute("classRole");

			if (!"teacher".equals(classRole)) {
				ra.addFlashAttribute("msg", "공지사항은 선생님만 작성할 수 있습니다.");
				return "redirect:/board/list/N?classNo=" + classNo;
			}
		}

		Board board = new Board();
		board.setCategory(category); // 카테고리 설정

		model.addAttribute("board", board);
		model.addAttribute("category", category);
		model.addAttribute("classNo", classNo);

		if ("A".equals(category)) {
			int userNo = ((Member) auth.getPrincipal()).getUserNo();
			ClassJoin classInfo = classRoomService.getClassJoinByUserNo(userNo, classNo);

			List<Assignment> assignments = assignmentService.getAssignmentsWithFileByClassNo(classInfo.getClassNo());
			model.addAttribute("assignments", assignments);
		}

		return "board/boardEnrollForm";
	}

	// 글쓰기
	@PostMapping("/insert/{category}")
	public String insertBoard(@PathVariable("category") String category, @ModelAttribute Board board,
			@RequestParam(value = "assignmentNo", required = false) Integer assignmentNo,
			@RequestParam(value = "upfile", required = false) List<MultipartFile> upfiles,
			@RequestParam("classNo") int classNo, Authentication auth, RedirectAttributes ra,
			HttpServletRequest request, HttpSession session) {
		if ("N".equals(category)) {
			String classRole = (String) session.getAttribute("classRole");

			if (!"teacher".equals(classRole)) {
				ra.addFlashAttribute("msg", "공지사항은 선생님만 작성할 수 있습니다.");
				return "redirect:/board/list/N?classNo=" + classNo;
			}
		}

		// 로그인한 사용자 정보 등록(
		if (auth != null && auth.isAuthenticated()) {
			Member loginUser = (Member) auth.getPrincipal();
			board.setUserNo(String.valueOf(loginUser.getUserNo()));

			ClassJoin classInfo = classRoomService.getClassJoinByUserNo(loginUser.getUserNo(), classNo);
			board.setClassNo(classInfo.getClassNo());

		} else {
			ra.addFlashAttribute("msg", "로그인 후 이용해주세요.");
			return "redirect:/login"; // 또는 메인 페이지로 리다이렉트
		}
		board.setCategory(category);

		// 썸네일
		String thumbnail = extractThumbnailFromContent(board.getBoardContent());
		board.setThumbnail(thumbnail); // Board DTO에 저장 (DB에도 넣을 것!)

		// 업로드 파일 처리
		List<BoardFile> fileList = new ArrayList<>();
		int level = 0;
		if (upfiles != null) {
			for (MultipartFile upfile : upfiles) {
				if (upfile.isEmpty())
					continue;

				String changeName = Utils.saveFile(upfile, request.getServletContext(), category);

				BoardFile file = new BoardFile();
				file.setOriginName(upfile.getOriginalFilename());
				file.setChangeName(changeName);
				file.setFileLevel(level++);
				fileList.add(file);
			}
		}

		// 게시글 + 이미지 + 과제 포함 여부에 따라 서비스 분기 처리
		int result = 0;
		if ("A".equals(category)) {
			// 1. 게시글 저장 (PK 리턴)
			int boardNo = boardService.insertBoardReturnBoardNo(board, fileList);

			// 2. 과제 제출 테이블 저장 (assignment_submission)
			AssignmentSubmission sub = AssignmentSubmission.builder().assignmentNo(assignmentNo)
					.userNo(Integer.parseInt(board.getUserNo())).boardNo(boardNo).submissionDate(new Date()).build();
			result = boardService.insertAssignmentSubmission(sub);
		} else {
			// 일반 게시판
			result = boardService.insertBoard(board, fileList);
		}

		// 메시지 및 리턴
		if (result > 0) {
			ra.addFlashAttribute("msg", "게시글이 등록되었습니다.");
		} else {
			ra.addFlashAttribute("msg", "게시글 등록에 실패했습니다.");
		}
		return "redirect:/board/list/" + category + "?classNo=" + classNo;
	}

	// 게시글 상세보기
	@GetMapping("/detail/{category}/{boardNo}")
	public String boardDetail(@PathVariable("category") String category, @PathVariable("boardNo") int boardNo,
			@RequestParam(value = "classNo", required = false) Integer classNo, Authentication auth, Model model,
			@CookieValue(value = "readBoardNo", required = false) String readBoardNoCookie, HttpServletRequest req,
			HttpServletResponse res, RedirectAttributes ra) {

		// 게시글 조회
		BoardExt board = boardService.selectBoard(boardNo);
		if (board == null) {
			throw new RuntimeException("게시글이 존재하지 않습니다.");
		}

		// 과제 게시판 권한 체크 (작성자 본인 or ROLE_TEACHER만 허용)
		if ("A".equals(category) && auth != null && auth.isAuthenticated()) {
			Member loginUser = (Member) auth.getPrincipal();

			boolean isTeacher = auth.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_TEACHER"));
			boolean isOwner = board.getUserNo().equals(String.valueOf(loginUser.getUserNo()));

			if (!isTeacher && !isOwner) {
				ra.addFlashAttribute("msg", "해당 게시글을 볼 권한이 없습니다.");
				return "redirect:/board/list/" + category + "?classNo=" + classNo;
			}
		}

		int userNo = -1;
		if (auth != null && auth.isAuthenticated()) {
			userNo = ((Member) auth.getPrincipal()).getUserNo();
		}
		// 본인이 작성한 글이 아닌 경우에만 조회수 증가
		if (!String.valueOf(userNo).equals(board.getUserNo())) {
			boolean increase = false;

			if (readBoardNoCookie == null) {
				// 첫 조회
				increase = true;
				readBoardNoCookie = boardNo + "";
			} else {
				// 기존에 본 게시글인지 확인
				List<String> list = Arrays.asList(readBoardNoCookie.split("/"));
				if (!list.contains(String.valueOf(boardNo))) {
					increase = true;
					readBoardNoCookie += "/" + boardNo;
				}

			}
			if (increase) {
				int result = boardService.increaseCount(boardNo);
				if (result > 0) {
					board.setViewCount(board.getViewCount() + 1); // 조회수 반영

					Cookie newCookie = new Cookie("readBoardNo", readBoardNoCookie);
					newCookie.setPath(req.getContextPath());
					newCookie.setMaxAge(60 * 60); // 1시간
					res.addCookie(newCookie);
				}
			}
		}

		// 댓글 목록 조회
		List<Reply> replyList = replyService.selectReplyList(boardNo);
		// 추천수 카운트
		int likeCount = boardService.selectLikeCount(boardNo);
		// 첨부파일 조회
		List<BoardFile> fileList = boardService.selectFilesByBoardNo(boardNo);

		// 공통 Model 데이터 전달
		model.addAttribute("category", category);
		model.addAttribute("board", board);
		model.addAttribute("replyList", replyList);
		model.addAttribute("likeCount", likeCount);
		model.addAttribute("fileList", fileList);
		model.addAttribute("classNo", classNo);
		// 과제 게시판일 경우 과제 정보도 전달
		if ("A".equals(category)) {
			Assignment assignment = assignmentService.getAssignmentByBoardNo(boardNo);
			model.addAttribute("assignment", assignment);

			AssignmentSubmission submission = assignmentSubmissionService.getSubmissionByBoardNo(boardNo);
			model.addAttribute("assignmentSubmission", submission);

			return "board/assignmentDetail"; // 과제 상세 JSP
		}

		return "board/boardDetailView"; // 일반 게시판 상세 JSP
	}

	@PostMapping("/like/{boardNo}")
	@ResponseBody
	public ResponseEntity<?> likeBoard(@PathVariable int boardNo, Authentication auth) {
		// 1. 로그인 체크
		if (auth == null || !auth.isAuthenticated()) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
		}
		// 2. 로그인 사용자 번호 추출
		int userNo = ((Member) auth.getPrincipal()).getUserNo();

		// 3. 중복 추천 확인
		boolean alreadyLiked = boardService.hasUserLiked(boardNo, userNo);
		if (alreadyLiked) {
			return ResponseEntity.status(HttpStatus.CONFLICT).body("이미 추천하셨습니다.");
		}
		// 4. 추천 등록
		int result = boardService.insertBoardLike(boardNo, userNo);
		if (result <= 0) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("추천 등록에 실패했습니다.");
		}
		// 추천수증가
		boardService.increaseBoardLike(boardNo);
		// 5. 최신 추천 수 조회
		int likeCount = boardService.selectLikeCount(boardNo);
		Map<String, Object> response = new HashMap<>();
		response.put("newLikeCount", likeCount);
		// 6. 클라이언트에 추천 수 응답
		return ResponseEntity.ok(response);
	}

	// 썸네일 추출
	private String extractThumbnailFromContent(String content) {
		if (content == null)
			return null;
		java.util.regex.Matcher m = java.util.regex.Pattern.compile("<img[^>]+src=[\"']([^\"']+)[\"'][^>]*>")
				.matcher(content);
		if (m.find()) {
			return m.group(1); // 첫 번째 이미지의 src 반환
		}
		return null;
	}

	// 1. 이미지 업로드 ajax 처리
	@PostMapping("/uploadImage")
	@ResponseBody
	public String uploadSummernoteImage(@RequestParam("file") MultipartFile file, HttpServletRequest request) {
		// 저장 경로 지정 (ex: /resources/upload/board/)
		String savePath = request.getServletContext().getRealPath("/resources/upload/board/");
		// 저장 폴더 없으면 생성
		java.io.File dir = new java.io.File(savePath);
		if (!dir.exists())
			dir.mkdirs();

		String originName = file.getOriginalFilename();
		String ext = originName.substring(originName.lastIndexOf("."));
		String changeName = System.currentTimeMillis() + "_" + (int) (Math.random() * 10000) + ext;

		java.io.File targetFile = new java.io.File(savePath, changeName);
		try {
			file.transferTo(targetFile);
		} catch (Exception e) {
			e.printStackTrace();
			// 실패 시 기본이미지/에러이미지 반환 가능 (아니면 "" 반환)
			return "";
		}
		// 웹에서 접근 가능한 경로 리턴
		String fileUrl = request.getContextPath() + "/resources/upload/board/" + changeName;
		return fileUrl;
	}

	// 게시글 수정 폼 진입 (카테고리별 분기)
	@GetMapping("/update/{category}/{boardNo}")
	public String updateForm(@PathVariable("category") String category, @PathVariable("boardNo") int boardNo,
			Model model) {

		// 일반(공지/자유/질문)
		if (!"A".equals(category)) {
			BoardExt board = boardService.selectBoard(boardNo);

			List<BoardFile> fileList = boardService.selectFilesByBoardNo(boardNo);

			model.addAttribute("board", board);
			model.addAttribute("fileList", fileList);
			model.addAttribute("category", category);

			return "board/boardUpdateForm";
		}
		// 과제제출
		else {
			BoardExt board = boardService.selectBoard(boardNo);
			AssignmentSubmission assignmentSubmission = assignmentSubmissionService.getSubmissionByBoardNo(boardNo);
			Assignment assignment = assignmentService.getAssignmentByBoardNo(boardNo);
			List<BoardFile> fileList = boardService.selectFilesByBoardNo(boardNo);

			model.addAttribute("board", board);
			model.addAttribute("assignmentSubmission", assignmentSubmission);
			model.addAttribute("assignment", assignment);
			model.addAttribute("fileList", fileList);
			model.addAttribute("category", category);

			return "board/assignmentUpdateForm";
		}
	}

	// 게시글 수정 처리 (카테고리별 분기)
	@PostMapping("/update/{category}/{boardNo}")
	public String updateBoard(@ModelAttribute Board board,
			@RequestParam(value = "upfile", required = false) List<MultipartFile> upfiles,
			@RequestParam(value = "assignmentNo", required = false) Integer assignmentNo,
			@RequestParam("classNo") int classNo, HttpServletRequest request, RedirectAttributes ra, Model model) {

		String category = board.getCategory();
		board.setClassNo(classNo);
		// 썸네일 재설정 (본문 이미지가 바뀌었을 수 있음)
		String thumbnail = extractThumbnailFromContent(board.getBoardContent());
		board.setThumbnail(thumbnail);

		int result = 0;
		// 일반게시판 수정
		if (!"A".equals(category)) {
			result = boardService.updateBoard(board, upfiles, request);
		}
		// 과제제출 게시판 수정
		else {
			// board 정보, assignmentNo, 파일 처리 등 넘김
			result = assignmentSubmissionService.updateAssignmentSubmission(board, upfiles, request, assignmentNo);
		}

		if (result > 0) {
			ra.addFlashAttribute("msg", "게시글이 수정되었습니다.");
			return "redirect:/board/detail/" + category + "/" + board.getBoardNo() + "?classNo=" + classNo;
		} else {
			model.addAttribute("msg", "게시글 수정에 실패했습니다.");
			return "error/errorPage";
		}
	}

	// 게시글 삭제
	@GetMapping("/delete/{boardNo}")
	public String deleteBoard(@PathVariable int boardNo, @RequestParam("classNo") int classNo,
			@RequestParam("category") String category) {
		boardService.deleteBoard(boardNo);
		return "redirect:/board/list/" + category + "?classNo=" + classNo;
	}

	// 신고하기
	@PostMapping("/report")
	@ResponseBody
	public Map<String, Object> reportBoard(@RequestBody TeacherReport report, Authentication auth) {
		Map<String, Object> map = new HashMap<>();
		// 로그인 여부 확인
		if (auth != null && auth.isAuthenticated()) {
			Member loginUser = (Member) auth.getPrincipal();
			report.setReporterUserNo(loginUser.getUserNo());

			if (report.getReportType() != null && report.getReportType().equals("BOARD")) {
				// 사용자가 속한 클래스 조회 (신고 대상 게시글의 클래스 기준)
				// 📌 report.getRefNo()는 게시글 번호(board_no)
				Board board = boardService.selectBoard(report.getRefNo());
				if (board == null) {
					map.put("result", "invalid_board");
					return map;
				}

				int classNo = board.getClassNo(); // 게시글에 연결된 클래스 번호 가져오기
				report.setClassNo(classNo); // 실제로 신고 내용에 클래스 번호 세팅
			}

		} else {
			map.put("result", "unauthorized");
			return map;
		}
		// 신고 시간 및 상태 설정
		report.setReportTime(new Date());
		report.setReportStatus("N");
		// 허용된 타입 검사
		if (!Arrays.asList("BOARD", "REPLY").contains(report.getReportType())) {
			map.put("result", "invalid_type");
			return map;
		}
		// DB 등록
		int result = boardService.insertBoardReport(report);
		map.put("result", result > 0 ? "success" : "fail");

		return map;
	}

}
