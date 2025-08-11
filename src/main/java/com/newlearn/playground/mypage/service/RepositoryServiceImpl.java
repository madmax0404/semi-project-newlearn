package com.newlearn.playground.mypage.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.mypage.model.dao.RepositoryDao;
import com.newlearn.playground.mypage.model.vo.Repository;
import com.newlearn.playground.mypage.model.vo.UploadFile;

@Service
public class RepositoryServiceImpl implements RepositoryService {
	@Autowired
	private RepositoryDao repoDao;

	@Override
	public List<Repository> getRepoList(int mypageNo) {
		return repoDao.getRepoList(mypageNo);
	}

	@Override
	public Repository getRepoByRepoNo(int repoNo) {
		return repoDao.getRepoByRepoNo(repoNo);
	}

	@Override
	public int insertFile(UploadFile uf) {
		return repoDao.insertFile(uf);
	}

	@Override
	public List<UploadFile> getFileList(Map<String, Object> paramMap) {
		return repoDao.getFileList(paramMap);
	}

	@Override
	public List<UploadFile> searchFileList(PageInfo pi, Map<String, Object> paramMap) {
		return repoDao.searchFileList(pi, paramMap);
	}

	@Override
	public List<UploadFile> getAllFileList(PageInfo pi, Map<String, Object> paramMap) {
		return repoDao.getAllFileList(pi, paramMap);
	}

	@Override
	public int moveFolder(Map<String, Object> paramMap) {
		return repoDao.moveFolder(paramMap);
	}

	@Override
	public int editFile(Map<String, String> paramMap) {
		return repoDao.editFile(paramMap);
	}

	@Override
	public int deleteFiles(Map<String, Object> paramMap) {
		return repoDao.deleteFiles(paramMap);
	}

	@Override
	public int newFolder(Map<String, String> paramMap) {
		return repoDao.newFolder(paramMap);
	}

	@Override
	public long getAllFileSize(int mypageNo) {
		return repoDao.getAllFileSize(mypageNo);
	}

	@Override
	public long maxStorage(int mypageNo) {
		return repoDao.maxStorage(mypageNo);
	}

	@Override
	public int getAllFileCnt(Map<String, Object> paramMap) {
		return repoDao.getAllFileCnt(paramMap);
	}

	@Override
	public List<UploadFile> getFileListWithPaging(PageInfo pi, Map<String, Object> paramMap) {
		return repoDao.getFileListWithPaging(pi, paramMap);
	}

	@Override
	public int searchFileCnt(Map<String, Object> paramMap) {
		return repoDao.searchFileCnt(paramMap);
	}

	@Override
	public UploadFile getFileByFileNo(int fileNo) {
		return repoDao.getFileByFileNo(fileNo);
	}
}
