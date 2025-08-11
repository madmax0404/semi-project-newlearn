<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<div class="storage-wrapper">
	<div class="left-side">
		<div class="repo-list">
			<button id="all-files-btn">전체문서함</button>
			<c:forEach var="repo" items="${repoList}">
				<c:set var="displayOption" value="${repo.level == 1 ? 'block' : 'none'}"/>
				<div class="repo-item lvl-${repo.level} prn-${repo.parentRepoNo}" 
				style="padding-left: ${repo.level * 10}px; display: ${displayOption};">
					<button class="repo-btn" data-repo-level="${repo.level}" data-repo-no="${repo.repoNo}">
					${repo.dirName}</button>
				</div>
			</c:forEach>
		</div>
		내 저장소 사용량 : ${allFileSize} bytes / ${maxStorage} bytes
		<div class="search-file">
			<form id="searchForm">
	            <div class="select">
	                <select class="custom-select" name="selection">
	                    <option value="fileName">파일명</option>
	                    <option value="dirName">폴더명</option>
	                    <option value="fileAndDir">파일명+폴더명</option>
	                </select>
	            </div>
	            <div class="text">
	                <input type="text" class="form-control" name="keyword"/>
	            </div>
	            <button type="submit" class="search-Btn">검색</button>
	        </form>
		</div>
	</div>
	<div class="storage-main-body">
		<!-- 비동기식으로 form 요청 보내서 받아온 데이터 출력하는 곳 -->
		<jsp:include page="/WEB-INF/views/mypage/fileList.jsp" />
	</div>
</div>