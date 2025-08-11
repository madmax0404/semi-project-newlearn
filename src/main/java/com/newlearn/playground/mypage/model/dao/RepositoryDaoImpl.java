package com.newlearn.playground.mypage.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.mypage.model.vo.UploadFile;

@Repository
public class RepositoryDaoImpl implements RepositoryDao {
	@Autowired
	private SqlSessionTemplate session;
	
	@Override
	public List<com.newlearn.playground.mypage.model.vo.Repository> getRepoList(int mypageNo) {
		return session.selectList("repo.getRepoList", mypageNo);
	}

	@Override
	public com.newlearn.playground.mypage.model.vo.Repository getRepoByRepoNo(int repoNo) {
		return session.selectOne("repo.getRepoByRepoNo", repoNo);
	}

	@Override
	public int insertFile(UploadFile uf) {
		return session.insert("repo.insertFile", uf);
	}

	@Override
	public List<UploadFile> getFileList(Map<String, Object> paramMap) {
		return session.selectList("repo.getFileList", paramMap);
	}

	@Override
	public List<UploadFile> searchFileList(PageInfo pi, Map<String, Object> paramMap) {
		paramMap.put("offset", (pi.getCurrentPage()-1) * pi.getBoardLimit());
		paramMap.put("limit", pi.getBoardLimit());
		return session.selectList("repo.searchFileList", paramMap);
	}

	@Override
	public List<UploadFile> getAllFileList(PageInfo pi, Map<String, Object> paramMap) {
		paramMap.put("offset", (pi.getCurrentPage()-1) * pi.getBoardLimit());
		paramMap.put("limit", pi.getBoardLimit());
		return session.selectList("repo.getAllFileList", paramMap);
	}

	@Override
	public int moveFolder(Map<String, Object> paramMap) {
		return session.update("repo.moveFoler", paramMap);
	}

	@Override
	public int editFile(Map<String, String> paramMap) {
		return session.update("repo.editFile", paramMap);
	}

	@Override
	public int deleteFiles(Map<String, Object> paramMap) {
		return session.update("repo.deleteFiles", paramMap);
	}

	@Override
	public int newFolder(Map<String, String> paramMap) {
		return session.insert("repo.newFolder", paramMap);
	}

	@Override
	public long getAllFileSize(int mypageNo) {
		return session.selectOne("repo.getAllFileSize", mypageNo);
	}

	@Override
	public long maxStorage(int mypageNo) {
		return session.selectOne("repo.maxStorage", mypageNo);
	}

	@Override
	public int getAllFileCnt(Map<String, Object> paramMap) {
		return session.selectOne("repo.getAllFileCnt", paramMap);
	}

	@Override
	public List<UploadFile> getFileListWithPaging(PageInfo pi, Map<String, Object> paramMap) {
		paramMap.put("offset", (pi.getCurrentPage()-1) * pi.getBoardLimit());
		paramMap.put("limit", pi.getBoardLimit());
		return session.selectList("repo.getFileListWithPaging", paramMap);
	}

	@Override
	public int searchFileCnt(Map<String, Object> paramMap) {
		return session.selectOne("repo.searchFileCnt", paramMap);
	}

	@Override
	public UploadFile getFileByFileNo(int fileNo) {
		return session.selectOne("repo.getFileByFileNo", fileNo);
	}

}
