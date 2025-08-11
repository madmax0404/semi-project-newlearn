package com.newlearn.playground.mypage.service;

import java.util.List;
import java.util.Map;

import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.mypage.model.vo.Repository;
import com.newlearn.playground.mypage.model.vo.UploadFile;

public interface RepositoryService {

	List<Repository> getRepoList(int mypageNo);

	Repository getRepoByRepoNo(int repoNo);

	int insertFile(UploadFile uf);

	List<UploadFile> searchFileList(PageInfo pi, Map<String, Object> paramMap);

	List<UploadFile> getAllFileList(PageInfo pi, Map<String, Object> paramMap);

	List<UploadFile> getFileList(Map<String, Object> paramMap);

	int moveFolder(Map<String, Object> paramMap);

	int editFile(Map<String, String> paramMap);

	int deleteFiles(Map<String, Object> paramMap);

	int newFolder(Map<String, String> paramMap);

	long getAllFileSize(int mypageNo);

	long maxStorage(int mypageNo);

	int getAllFileCnt(Map<String, Object> paramMap);

	List<UploadFile> getFileListWithPaging(PageInfo pi, Map<String, Object> paramMap);

	int searchFileCnt(Map<String, Object> paramMap);

	UploadFile getFileByFileNo(int fileNo);

}
