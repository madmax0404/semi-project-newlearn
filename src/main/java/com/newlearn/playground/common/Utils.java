package com.newlearn.playground.common;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletContext;

import org.springframework.web.multipart.MultipartFile;

import com.newlearn.playground.common.model.vo.Image;
import com.newlearn.playground.mypage.service.MypageService;

public class Utils {
	// 파일 또는 이미지 업로드를 위해 이름변경
	public static String getChangeName(MultipartFile upfile, ServletContext application, String type, int mypageNo) {
		String webPath = "/resources/uploads/"+type+"/"+mypageNo+"/";
		String serverFolderPath = application.getRealPath(webPath);
		File dir = new File(serverFolderPath);
		// 첫 업로드
		if (!dir.exists()) {
			dir.mkdirs();
		}
		String originName = upfile.getOriginalFilename();
		String currentTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
		int random = (int)(Math.random() * 90000 + 10000);
		String ext = originName.substring(originName.lastIndexOf("."));
		String changeName = currentTime + random + ext;
		try {
			upfile.transferTo(new File(serverFolderPath + changeName));
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return changeName;
	}
	
	public static void fileDelete(int mypageNo, ServletContext application, MypageService mypageService, String type) {
		String path = "/resources/uploads/"+type+"/"+mypageNo+"/";
		File file = new File(application.getRealPath(path));
		if (file.exists()) {
			File[] files = file.listFiles();
			if (files != null) {
				for (File f : files) {
					Image img = mypageService.getImgByChangeName(f.getName());
					if (img == null) {
						f.delete();
					}
				}
			}
		}
	}
	
	public static String XSSHandling(String content) {
        if(content != null) {
        	content = content.replaceAll("&", "&amp;");
        	content = content.replaceAll("<", "&lt;");
        	content = content.replaceAll(">", "&gt;");
            content = content.replaceAll("\"", "&quot;");
        }
        return content;
    }
	
    public static String newLineHandling(String content) {
        return content.replaceAll("(\r\n|\r|\n|\n\r)", "<br>");
    }
    
    public static String newLineClear(String content) {
        return content.replaceAll("<br>","\n");
    }
	
	////////////////////////////////////////////////////////////////////////////////////
	
	// 파일 저장 함수
	// 파일을 저장하면서, 파일명을 수정하고 수정된 파일명을 반환한다.
	public static String saveFile(MultipartFile upfile, ServletContext application, String boardCode) {
		// 첨부파일을 저장할 저장경로 획득
		String webPath = "/resources/images/board/" + boardCode + "/";
		// getRealPath(경로)
		// - 실제 서버의 파일 시스템 경로를 절대경로로 반환하는 메서드.
		// ex) c:/SpringWorkspace/spring-project/...
		String serverFolderPath = application.getRealPath(webPath);
		System.out.println(serverFolderPath);
		
		// 저장경로가 존재하지 않는다면 생성
		File dir = new File(serverFolderPath);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		
		// 랜덤한 파일명 생성
		String originName = upfile.getOriginalFilename(); // 파일의 원본명
		String currentTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
		int random = (int)(Math.random() * 90000 + 10000); // 5자리 랜덤값
		String ext = originName.substring(originName.lastIndexOf("."));
		String changeName = currentTime + random + ext;
		
		// 서버에 파일을 업로드
		try {
			upfile.transferTo(new File(serverFolderPath + changeName));
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
		}
		
		// 파일명 반환
		return webPath + changeName;
	}
	
	public static String saveFile2(MultipartFile upfile, ServletContext application, String tableName) {
		// 첨부파일을 저장할 저장경로 획득
		String webPath = "/resources/files/" + tableName + "/";
		// getRealPath(경로)
		// - 실제 서버의 파일 시스템 경로를 절대경로로 반환하는 메서드.
		// ex) c:/SpringWorkspace/spring-project/...
		String serverFolderPath = application.getRealPath(webPath);
		System.out.println(serverFolderPath);
		
		// 저장경로가 존재하지 않는다면 생성
		File dir = new File(serverFolderPath);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		
		// 랜덤한 파일명 생성
		String originName = upfile.getOriginalFilename(); // 파일의 원본명
		String currentTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
		int random = (int)(Math.random() * 90000 + 10000); // 5자리 랜덤값
		String ext = originName.substring(originName.lastIndexOf("."));
		String changeName = currentTime + random + ext;
		
		// 서버에 파일을 업로드
		try {
			upfile.transferTo(new File(serverFolderPath + changeName));
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
		}
		
		// 파일명 반환
		return webPath + changeName;
	}
	
}
