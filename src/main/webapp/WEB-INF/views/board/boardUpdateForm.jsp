<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정 | new Learn();</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board/boardupdateform.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/calendar.css" type="text/css" />
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="content">
		<!-- 왼쪽 사이드바 -->
		<div class="sidebar-left card shadow">
			<div class="mini-profile">
				<span>${loginUser.userName}님 환영합니다</span> <span>입실시간: <c:if test="${not empty attendance.entryTime}">
						<fmt:formatDate value="${attendance.entryTime}" pattern="h : mm a" />
					</c:if> <c:if test="${empty attendance.entryTime}">아직 안함</c:if>
				</span>
			</div>

			<div class="mypage-and-entry">
				<form action="${contextPath}/mypage/${loginUser.userNo}" method="get">
					<button type="submit" class="btn btn-primary">마이페이지</button>
				</form>
				<button type="button" data-toggle="modal" data-target="#exampleModal" class="btn btn-primary">입실</button>
			</div>

			<!-- 입실 모달 -->
			<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="exampleModalLabel">입실코드 입력</h5>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<form:form method="post" action="${contextPath}/class/entry">
							<div class="modal-body">
								<input type="text" name="attEntryCode" required />
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
								<button type="submit" class="btn btn-primary">확인</button>
							</div>
						</form:form>
					</div>
				</div>
			</div>

			<!-- 친구 및 채팅 -->
			<div class="friend-list">
				<div class="list-header">
					<h5>즐겨찾기</h5>
					<div class="list-btns">
						<button class="btn rounded-pill btn-secondary btn-xs">
						<a href="${pageContext.request.contextPath}/friend/myFriendList">친구관리</a>
						</button>
					</div>
				</div>
				<h5>일반</h5>
			</div>

			<div class="chatroom-list">
				<div class="list-header">
					<h5>전체채팅</h5>
					<div class="list-btns">
						<button class="btn rounded-pill btn-secondary btn-xs">새채팅</button>
						<button class="btn rounded-pill btn-secondary btn-xs">채팅방관리</button>
					</div>
				</div>
				<h5>그룹채팅</h5>
				<h5>개인채팅</h5>
			</div>
		</div>

		<!-- 메인 상세 -->
		<div class="board card shadow">
			<form id="updateForm" action="${pageContext.request.contextPath}/board/update/${category}/${board.boardNo}" method="post" enctype="multipart/form-data" class="board-write-form">
				<sec:csrfInput />

				<!-- 게시글 번호/카테고리 숨김 -->
				<input type="hidden" name="boardNo" value="${board.boardNo}" />
				<input type="hidden" name="category" value="${category}" />
				<input type="hidden" name="classNo" value="${board.classNo}" />

				<!-- 제목 -->
				<div class="form-group">
					<label for="boardTitle">제목</label>
					<input type="text" name="boardTitle" id="boardTitle" value="${board.boardTitle}" required />
				</div>

				<!-- 작성자 등 정보 -->
				<div class="board-detail-meta">
					<span>작성자</span><span>${board.userName}</span> <span>작성일</span> <span> <fmt:formatDate value="${board.createDate}" pattern="yyyy-MM-dd HH:mm:ss" />
					</span> <span>조회수</span><span>${board.viewCount}</span> <span>추천수</span><span>${likeCount}</span>
				</div>

				<!-- 본문 (Summernote 적용) -->
				<div class="form-group">
					<label for="boardContent">내용</label>
					<textarea name="boardContent" id="boardContent" class="summernote" rows="10" required>${board.boardContent}</textarea>
				</div>

				<!-- 파일첨부 -->
				<div class="form-group">
					<label for="upfile">파일 첨부 (최대 3개)</label>
					<input type="file" name="upfile" id="upfile" multiple onchange="previewFiles(this)" />
					<div id="image-preview"></div>
				</div>

				<!-- 기존 첨부파일 리스트 -->
				<c:if test="${not empty fileList}">
					<div class="board-detail-attachments">
						<div class="attachment-title">기존 첨부파일</div>
						<div class="attachment-list">
							<c:forEach var="file" items="${fileList}">
								<a href="${pageContext.request.contextPath}${file.changeName}" download="${file.originName}" class="attachment-item">
									<c:choose>
										<c:when test="${fn:endsWith(file.originName, '.jpg')
                                                or fn:endsWith(file.originName, '.jpeg')
                                                or fn:endsWith(file.originName, '.png')
                                                or fn:endsWith(file.originName, '.gif')
                                                or fn:endsWith(file.originName, '.bmp')}">
											<img src="${pageContext.request.contextPath}${file.changeName}" alt="${file.originName}" class="attachment-thumb" />
										</c:when>
										<c:otherwise>
											<img src="${pageContext.request.contextPath}/resources/files/assignment/file-icon.png" alt="file" class="attachment-default-icon" />
										</c:otherwise>
									</c:choose>
									<div class="attachment-filename">${file.originName}</div>
								</a>
							</c:forEach>
						</div>
					</div>
				</c:if>

				<!-- 버튼영역 -->
				<div style="display: flex; gap: 12px;">
					<button type="submit" class="submit-btn">수정완료</button>
					<button type="button" class="submit-btn" style="background-color: #b0bec5;" onclick="confirmCancel()">취소</button>
				</div>
			</form>
		</div>
		<!-- 오른쪽 사이드바 -->
		<div class="sidebar-right card shadow">
							<div class="notification">
								<h4>새 알림 5건</h4>
								<p>친구 김성겸 님이 늦잠자는중...</p>
								<p>읽지 않은 메세지 12건</p>
								<p>게시판에 새 글이 있습니다</p>
								<p>방명록에 새 글이 있습니다</p>
								<p>제출해야 할 과제가 있습니다</p>
							</div>
							<div class="shared-calendar">
								<form:form id="dateForm" action="${pageContext.request.contextPath}/event/calendar" method="get">
									<input type="hidden" name="classNo" value="${classNo}" />
									<jsp:include page="/WEB-INF/views/event/calendar.jsp" />
								</form:form>
							</div>
							<div class="upcoming-events">
								<h4>UPCOMING EVENTS</h4>
								<c:forEach var="event" items="${upcomingEvents}">
									<p>
										<fmt:formatDate value="${event.startDate}" pattern="M월 d일 EEEE h : mm a" />
									</p>
									<pre>${event.eventName} (${eventWithMemberCnt[event]}명 참여중...)</pre>
									<form action="${pageContext.request.contextPath}/event/detail/${event.eventNo}" method="get">
										<button type="submit">상세보기</button>
									</form>
								</c:forEach>
							</div>
							<br>
							<hr>
							<div class="imperium-context-engine">
								<img src="${pageContext.request.contextPath}/resources/assets/img/ai/the_aquila_transparent.png" alt="For The Emperor" style="height: 80px;">
								<h4>Imperium Context Engine(ICE)</h4>
								<pre>ChatGPT & Gemini</pre>
								<button class="btn btn-warning">
									<a href="${pageContext.request.contextPath}/ai/main">AI 사용하기</a>
								</button>
							</div>
						</div>
	</div>
	<script>
    // Summernote 에디터 적용
    $(document).ready(function() {
        $('.summernote').summernote({
            height: 300,
            lang: 'ko-KR',
            toolbar: [
                ['style', ['bold', 'italic', 'underline', 'clear']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['insert', ['picture']],
                ['view', ['fullscreen']]
            ],
            callbacks: {
                onImageUpload: function(files) {
                    for (let i = 0; i < files.length; i++) {
                        sendFile(files[i], this);
                    }
                }
            }
        });
    });

    // 이미지 업로드(서버전송 후 에디터 삽입)
    function sendFile(file, editor) {
        var data = new FormData();
        data.append('file', file);
        $.ajax({
            url: '${pageContext.request.contextPath}/board/uploadImage',
            type: 'POST',
            data: data,
            contentType: false,
            processData: false,
            success: function(url) {
                $(editor).summernote('insertImage', url);
            },
            error: function(e) {
                alert('이미지 업로드에 실패했습니다.');
            }
        });
    }

    // 파일 미리보기
    function previewFiles(input) {
        const preview = document.getElementById('image-preview');
        preview.innerHTML = "";

        const files = input.files;
        if (files.length > 3) {
            alert("최대 3개 파일만 첨부 가능합니다.");
            input.value = "";
            return;
        }

        Array.from(files).forEach(file => {
            const isImage = file.type.startsWith('image/');
            if (isImage) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    preview.appendChild(img);
                };
                reader.readAsDataURL(file);
            } else {
                const span = document.createElement("span");
                span.textContent = file.name;
                span.style.marginRight = '10px';
                span.style.color = '#555';
                preview.appendChild(span);
            }
        });
    }

    // 취소버튼
    function confirmCancel() {
        if (confirm("정말 수정작업을 취소하시겠습니까?")) {
            history.back();
        }
    }
</script>
</body>
</html>
