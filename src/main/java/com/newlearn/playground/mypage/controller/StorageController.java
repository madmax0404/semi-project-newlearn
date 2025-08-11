package com.newlearn.playground.mypage.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.ServletContext;

import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.newlearn.playground.common.Utils;
import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.common.template.Pagination;
import com.newlearn.playground.member.model.vo.Member;
import com.newlearn.playground.mypage.model.vo.Mypage;
import com.newlearn.playground.mypage.model.vo.Repository;
import com.newlearn.playground.mypage.model.vo.UploadFile;
import com.newlearn.playground.mypage.service.MypageService;
import com.newlearn.playground.mypage.service.RepositoryService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage/storage")
public class StorageController {
	private final ServletContext application; 
	private final MypageService mypageService;
	private final RepositoryService repoService;
	private final ResourceLoader resourceLoader;

	@GetMapping
	public String loadStorage(@RequestParam Map <String, Object> paramMap, 
			@RequestParam(value="currentPage", defaultValue="1") int currentPage, 
			@RequestParam(value="visibility", defaultValue="public") String visibility,
			@RequestParam(value="type", defaultValue="") String type, Model model) {
		int mypageNo = Integer.parseInt((String)paramMap.get("mypageNo"));
		paramMap.put("visibility", visibility);
		int listcount = 0;
		PageInfo pi = null;
		List<UploadFile> fileList = null;
		if (type.equals("repo")){
			listcount = repoService.getFileList(paramMap).size();
			pi = Pagination.getPageInfo(listcount, currentPage, 10, 5);
			fileList = repoService.getFileListWithPaging(pi, paramMap);
			int repoNo = Integer.parseInt((String)paramMap.get("sourceNo"));
			model.addAttribute("repo", repoService.getRepoByRepoNo(repoNo));
		} else {
			listcount = repoService.searchFileCnt(paramMap);
			pi = Pagination.getPageInfo(listcount, currentPage, 10, 5); // pageLimit, boardLimit
			fileList = repoService.searchFileList(pi, paramMap);
		}
		List<Repository> repoList = repoService.getRepoList(mypageNo);
		long allFileSize = repoService.getAllFileSize(mypageNo);
		long maxStorage = repoService.maxStorage(mypageNo);
		model.addAttribute("repoList", repoList);
		model.addAttribute("allFileSize", allFileSize);
		model.addAttribute("maxStorage", maxStorage);
		model.addAttribute("mypageNo", mypageNo);
		model.addAttribute("visibility", visibility);
		model.addAttribute("listcount", listcount);
		model.addAttribute("pi", pi);
		model.addAttribute("fileList", fileList);
		model.addAttribute("type", type);
		if (type.equals("load")) {
			return "mypage/storage";
		}
		return "mypage/fileList";
	}
	
	@PostMapping("/insert")
	public String insertFile(@RequestParam int repoNo, @RequestParam(value="upfile") List<MultipartFile> upfiles, 
			Authentication auth, RedirectAttributes ra) {
		Member userDetails = (Member)auth.getPrincipal();
		int userNo = userDetails.getUserNo();
		Repository repo = repoService.getRepoByRepoNo(repoNo);
		Mypage mypage = mypageService.getMypageByMypageNo(repo.getMypageNo());
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("source", "repository");
		paramMap.put("sourceNo", repoNo);
		List<UploadFile> ufList = repoService.getFileList(paramMap);
		long totalStorage = 0; // 바이트단위
		if (!ufList.isEmpty()) {
			for (UploadFile uf : ufList) {
				totalStorage += uf.getFileSize();
			}
		}
		for (MultipartFile upfile : upfiles) {
			if (totalStorage + upfile.getSize() > mypage.getMaxStorage()) {
				ra.addFlashAttribute("alertMsg", "파일을 업로드 할 수 있는 최대용량을 초과했스빈다.");
				return "redirect:/mypage/"+userNo+"?to=storage";
			}
			UploadFile uf = new UploadFile();
			String changeName = Utils.getChangeName(upfile, application, "file", repo.getMypageNo());
			uf.setChangeName(changeName);
			uf.setOriginName(upfile.getOriginalFilename());
			//uf.setRepoNo(repoNo);
			uf.setFileSize(upfile.getSize());
			uf.setSource("repository");
			uf.setSourceNo(repoNo);
			uf.setUserNo(userNo);
			int result = repoService.insertFile(uf);
			if (result != 1) {
				throw new RuntimeException("파일 업로드 실패");
			}
		}
		ra.addFlashAttribute("alertMsg", "파일 업로드 성공");
		return "redirect:/mypage/"+userNo+"?to=storage";
	}
	
	@PostMapping("/move")
	public String moveFolder(@RequestParam Map<String, Object> paramMap, RedirectAttributes ra) {
		List<Integer> fileNos = Arrays.stream(((String)paramMap.get("fileNos")).split(","))
										.map(Integer::parseInt)
										.collect(Collectors.toList());
		paramMap.put("fileNos", fileNos);
		int result = repoService.moveFolder(paramMap);
		if (result > 0) {
			ra.addFlashAttribute("alertMsg", "이동 성공");
		} else {
			ra.addFlashAttribute("alertMsg", "이동 실패");
		}
		return "redirect:/mypage/"+paramMap.get("userNo")+"?to=storage";
	}
	
	@PostMapping("/edit")
	public String editFile(@RequestParam Map<String,String> paramMap, RedirectAttributes ra) {
		paramMap.replace("newFileName", paramMap.get("newFileName").trim());
		int result = repoService.editFile(paramMap);
		if (result == 1) {
			ra.addFlashAttribute("alertMsg", "수정 성공");
		} else {
			ra.addFlashAttribute("alertMsg", "수정 실패");
		}
		return "redirect:/mypage/"+paramMap.get("userNo")+"?to=storage";
	}
	
	@PostMapping("/delete")
	public String deleteFiles(@RequestParam Map<String, Object> paramMap, RedirectAttributes ra) {
		List<Integer> fileNos = Arrays.stream(((String)paramMap.get("fileNos")).split(","))
						.map(Integer::parseInt)
						.collect(Collectors.toList());
		paramMap.put("fileNos", fileNos);
		int result = repoService.deleteFiles(paramMap);
		if (result > 0) {
			ra.addFlashAttribute("alertMsg", "삭제 성공");
		} else {
			ra.addFlashAttribute("alertMsg", "삭제 실패");
		}
		return "redirect:/mypage/"+paramMap.get("userNo")+"?to=storage";
	}
	
	@PostMapping("/new")
	public String newFolder(@RequestParam Map<String,String> paramMap, RedirectAttributes ra) {
		paramMap.replace("dirName", paramMap.get("dirName").trim());
		if (paramMap.get("dirName").isEmpty()) {
			ra.addFlashAttribute("alertMsg", "유효한 폴더명을 입력해주세요.");
			return "redirect:/mypage/"+paramMap.get("userNo")+"?to=storage";
		}
		int result = repoService.newFolder(paramMap);
		if (result == 1) {
			ra.addFlashAttribute("alertMsg", "생성 성공");
		} else {
			ra.addFlashAttribute("alertMsg", "생성 실패");
		}
		return "redirect:/mypage/"+paramMap.get("userNo")+"?to=storage";
	}
	
	@GetMapping("/fileDownload/{fileNo}")
	public ResponseEntity<Resource> fileDownload(@PathVariable("fileNo") int fileNo, @RequestParam int mypageNo) {
		UploadFile uf = repoService.getFileByFileNo(fileNo);
		if (uf == null) {
			return ResponseEntity.notFound().build();
		}
		String relativePath = "/resources/uploads/file/" + mypageNo + "/" + uf.getChangeName();
		String realPath = application.getRealPath(relativePath);
		File downFile = new File(realPath);
		if (!downFile.exists()) {
			return ResponseEntity.notFound().build();
		}
		Resource resource = resourceLoader.getResource("file:"+realPath);
		String filename = "";
		try {
			filename = new String(uf.getOriginName().getBytes("utf-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return ResponseEntity
			.ok()
			.header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_OCTET_STREAM_VALUE) 
			.header(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=" + filename) 
			.body(resource);
	}
	
}
