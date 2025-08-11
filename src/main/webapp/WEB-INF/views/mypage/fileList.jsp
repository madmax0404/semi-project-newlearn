<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>파일 목록 및 관리</title>
</head>
<body>

<!-- 현재 폴더 표시 -->
<div class="current-folder">
    <c:choose>
        <c:when test="${not empty repo}">
            <strong>현재 폴더 :</strong> ${repo.dirName}
        </c:when>
        <c:otherwise>
            <strong>전체 파일 목록</strong>
        </c:otherwise>
    </c:choose>
</div>

<!-- 권한이 있을 경우 보여지는 조작 버튼들 -->
<c:if test="${mypageNo eq loginUser.userNo}">
    <div class="file-actions">
        <button type="button" id="move-files" class="btn action-btn">이동</button>
        <button type="button" id="delete-files" class="btn action-btn">삭제</button>
        <button id="new-folder" class="btn primary-btn">새 폴더 생성</button>
        <div class="visibility-toggle">
        <c:choose>
            <c:when test="${visibility eq 'public'}">
                <button type="button" class="btn btn-primary"
                    onclick="loadContent('storage', '', 'private', '${type}', '${repo.repoNo}')">
                    비공개 파일목록
                </button>
            </c:when>
            <c:otherwise>
                <button type="button" class="btn btn-primary"
                    onclick="loadContent('storage', '', 'public', '${type}', '${repo.repoNo}')">
                    공개 파일목록
                </button>
            </c:otherwise>
        </c:choose>
    </div>
    </div>
</c:if>

<!-- 파일 이동 모달 -->
<div id="move-file-modal" class="mymodal">
    <div class="modal-content">
        <h3>파일 이동</h3>
        <form:form id="move-file-form" action="${pageContext.request.contextPath}/mypage/storage/move" method="post">
            <input type="hidden" name="fileNos" id="move-fileNos"/>
            <div class="folder-selection">
                <label>이동할 폴더 선택 :</label>
                <span id="selectedFolder"></span>
            </div>

            <nav class="move-repo-list">
                <c:forEach var="repo" items="${repoList}">
                    <c:set var="displayOption" value="${repo.level == 1 ? 'block' : 'none'}"/>
                    <div class="move-repo-item lvl-${repo.level} prn-${repo.parentRepoNo}" 
                         style="padding-left: ${repo.level * 12}px; display: ${displayOption};">
                        <button type="button" 
                                class="move-repo-btn btn" 
                                data-repo-level="${repo.level}" 
                                data-repo-no="${repo.repoNo}"
                                data-dirname="${repo.dirName}">
                            ${repo.dirName}
                        </button>
                    </div>
                </c:forEach>
            </nav>

            <input type="hidden" name="folderNo" id="move-folderNo"/>
            <input type="hidden" name="userNo" value="${loginUser.userNo}"/>
            <button type="submit" class="btn primary-btn">이동</button>
        </form:form>
    </div>
</div>

<!-- 파일 삭제 모달 -->
<div id="delete-file-modal" class="mymodal">
    <div class="modal-content">
        <h3>파일 삭제 확인</h3>
        <p>정말로 선택한 모든 파일을 삭제하시겠습니까?</p>
        <form:form id="delete-file-form" action="${pageContext.request.contextPath}/mypage/storage/delete" method="post">
            <input type="hidden" name="fileNos" id="delete-fileNos"/>
            <input type="hidden" name="userNo" value="${loginUser.userNo}"/>
            <button type="submit" class="btn danger-btn">삭제</button>
        </form:form>
    </div>
</div>

<!-- 파일 수정 모달 -->
<div id="edit-file-modal" class="mymodal">
    <div class="modal-content">
        <form:form action="${pageContext.request.contextPath}/mypage/storage/edit" method="post">
            <p><strong>선택된 파일 :</strong> <span id="selectedFile"></span></p>

            <label for="newFileName">새 파일명</label>
            <input type="text" id="newFileName" name="newFileName" class="form-control" required />

            <fieldset>
                <legend>공개 여부</legend>
                <label><input type="radio" name="visibility" value="public" /> 공개</label>
                <label><input type="radio" name="visibility" value="private" /> 비공개</label>
            </fieldset>

            <input type="hidden" name="fileNo" id="edit-fileNo" />
            <input type="hidden" name="userNo" value="${loginUser.userNo}" />

            <button type="submit" class="btn primary-btn">수정</button>
        </form:form>
    </div>
</div>

<!-- 파일 리스트 -->
<div class="file-list">
    <table class="file-table">
        <thead>
            <tr>
                <th style="width: 5%"><input type="checkbox" id="select-all-checkbox" /></th>
                <th style="width: 35%">파일명</th>
                <th style="width: 20%">업로드 날짜</th>
                <th style="width: 15%">파일 크기</th>
                <th style="width: 25%">작업</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="file" items="${fileList}">
                <tr>
                    <td><input type="checkbox" name="file-selection" value="${file.fileNo}" /></td>
                    <td>${file.originName}</td>
                    <td>${file.createDate}</td>
                    <td>${file.fileSize} 바이트</td>
                    <td>
                        <button type="button" class="btn btn-secondary"
                            onclick="location.href='${pageContext.request.contextPath}/mypage/storage/fileDownload/${file.fileNo}?mypageNo=${mypageNo}'">
                            다운로드
                        </button>
                        <c:if test="${mypageNo eq loginUser.userNo}">
                            <button type="button" class="btn btn-secondary file-edit"
                                    data-dmltype="edit"
                                    data-fileno="${file.fileNo}"
                                    data-filename="${file.originName}">
                                수정
                            </button>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>


<!-- 페이지네이션 -->
<c:if test="${not empty fileList}">
    <nav id="pagingArea" aria-label="페이지 네비게이션">
        <ul class="pagination">
            <c:if test="${pi.currentPage eq 1}">
                <li class="page-item disabled">
                    <span class="page-link">Previous</span>
                </li>
            </c:if>
            <c:if test="${pi.currentPage ne 1}">
                <li class="page-item">
                    <a class="page-link" href="javascript:void(0);" 
                       onclick="loadContent('storage', ${pi.currentPage - 1}, '${visibility}', '${type}', '${repo.repoNo}')">
                        Previous
                    </a>
                </li>
            </c:if>

            <c:forEach var="i" begin="${pi.startPage}" end="${pi.endPage}">
                <li class="page-item ${pi.currentPage == i ? 'active' : ''}">
                    <a class="page-link" href="javascript:void(0);"
                       onclick="loadContent('storage', ${i}, '${visibility}', '${type}', '${repo.repoNo}')">
                        ${i}
                    </a>
                </li>
            </c:forEach>

            <c:if test="${pi.currentPage eq pi.maxPage}">
                <li class="page-item disabled">
                    <span class="page-link">Next</span>
                </li>
            </c:if>
            <c:if test="${pi.currentPage ne pi.maxPage}">
                <li class="page-item">
                    <a class="page-link" href="javascript:void(0);"
                       onclick="loadContent('storage', ${pi.currentPage + 1}, '${visibility}', '${type}', '${repo.repoNo}')">
                        Next
                    </a>
                </li>
            </c:if>
        </ul>
    </nav>
</c:if>

<!-- 새 폴더 생성 및 파일 업로드 -->
<div id="new-folder-modal" class="mymodal">
    <div class="modal-content">
        <c:if test="${not empty repo}">
            <p><strong>현재 폴더 위치 :</strong> ${repo.dirName}</p>
        </c:if>
        <form:form id="new-folder-form" action="${pageContext.request.contextPath}/mypage/storage/new" method="post">
            <label for="dirName">새로운 폴더 이름 :</label>
            <input type="text" id="dirName" name="dirName" required class="form-control" />
            <input type="hidden" name="userNo" value="${loginUser.userNo}" />
            <c:if test="${not empty repo}">
                <input type="hidden" name="parentRepo" value="${repo.repoNo}" />
            </c:if>
            <button type="submit" class="btn primary-btn">생성</button>
        </form:form>
    </div>
</div>

<c:if test="${mypageNo eq loginUser.userNo}">
    <c:if test="${not empty repo}">
        <div class="upload-file">
            <form:form action="${pageContext.request.contextPath}/mypage/storage/insert"
                       id="uploadForm" method="post" enctype="multipart/form-data">
                <label for="upfile">파일 선택 :</label>
                <input type="file" id="upfile" class="form-control" name="upfile" multiple required />
                <input type="hidden" name="repoNo" value="${repo.repoNo}" />
                <button type="submit" class="btn primary-btn">파일 업로드</button>
            </form:form>
        </div>
    </c:if>
</c:if>

</body>
</html>