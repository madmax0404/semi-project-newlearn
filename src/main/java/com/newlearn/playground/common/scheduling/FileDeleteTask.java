package com.newlearn.playground.common.scheduling;

import java.io.File;
import java.util.List;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.newlearn.playground.board.model.service.BoardService;
import com.newlearn.playground.board.model.vo.BoardType;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class FileDeleteTask {
	@Autowired
	private BoardService bService;
	
	@Autowired
	private ServletContext application;
	/*
     * 파일 삭제 스케쥴러
     *  - 목표 : DB에는 존재하지 않으나 WEB-SERVER상에 존재하는 쓸모없는 파일을 삭제.
     * 업무로직
     * 1. 데이터베이스(board_img 테이블)에 등록된 모든 이미지 파일 경로 목록을 조회
     * 2. 모든 게시판 유형(boardType)을 조회하여, 각각의 게시판 디렉토리 경로를 탐색
     * 3. 해당 디렉토리에서 실제 서버에 존재하는 이미지 파일 목록 을 수집
     * 4. 각 파일이 DB에 등록되어 있는 파일인지 여부를 판단
     * 5. DB에 없는 파일(즉, 더 이상 사용되지 않는 파일)이라면 삭제 처리
     * 6. 유저활동량이 적은 매달 1일 4시에 실행되도록 설정
     */
//	@Scheduled(cron="0 0 4 1 * *")
//	public void fileDelete() {
//		// 1. 데이터베이스(board_img 테이블)에 등록된 모든 이미지 파일 경로 목록을 조회
////		List<String> dbFileList = bService.selectFileList();
//		
//		// 2. 모든 게시판 유형(boardType)을 조회하여, 각각의 게시판 디렉토리 경로를 탐색
//		List<BoardType> boardTypeList = bService.selectBoardTypeList();
//		
//		String path = "/resources/images/board/";
//		
//		for (BoardType bt : boardTypeList) {
//			String boardCd = bt.getBoardCd();
//			String pathAndBoardCd = path + boardCd + "/";
//			
//			File serverFiles = new File(application.getRealPath(pathAndBoardCd));
//			
//			for (String serverFile : serverFiles.list()) {
//				
//				String serverFileName = pathAndBoardCd + serverFile;
//				
//				if (!dbFileList.contains(serverFileName)) {
//					String absolutePath = application.getRealPath(serverFileName);
//					System.out.println("file to be delete: " + absolutePath);
//					File toDelete = new File(absolutePath);
//					System.out.println("deletion result: " + toDelete.delete());
//				}
//			}
//		}
//	}
	
}
