<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>new Learn();</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board/boardenrollform.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/calendar.css" type="text/css" />
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+" crossorigin="anonymous"></script>
</head>

<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="content">
		<div class="sidebar-left card shadow">
			<div class="mini-profile">
				<span>${loginUser.userName}님 환영합니다</span> <span>입실시간: <c:if test="${not empty attendance.entryTime}">
						<fmt:formatDate value="${attendance.entryTime}" pattern="h : mm a" />
					</c:if> <c:if test="${empty attendance.entryTime}">아직 안함</c:if>
				</span>
			</div>
			<div class="mypage-and-entry">
				<form action="${pageContext.request.contextPath}/mypage/${loginUser.userNo}" method="get">
					<button type="submit" class="btn btn-primary">마이페이지</button>
				</form>
				<button type="button" data-toggle="modal" data-target="#exampleModal" class="btn btn-primary">입실</button>
			</div>
			<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="exampleModalLabel">입실코드 입력</h5>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<form:form method="post" action="${pageContext.request.contextPath}/class/entry">
							<div class="modal-body">
								<input type="text" name="attEntryCode" required="required" />
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
								<button type="submit" class="btn btn-primary">확인</button>
							</div>
						</form:form>
					</div>
				</div>
			</div>

			<div class="friend-list">
				<div class="list-header">
					<h5>즐겨찾기</h5>
					<div class="list-btns">
						<button class="btn rounded-pill btn-secondary btn-xs">친구관리</button>
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

		<div class="board card shadow">

			<form id="writeForm" action="${pageContext.request.contextPath}/board/insert/${category}" method="post" enctype="multipart/form-data" class="board-write-form">
				<sec:csrfInput />
				<input type="hidden" name="classNo" value="${classNo}" />
				<!-- 카테고리 선택 -->
				<div class="form-group">
					<label for="category">카테고리</label>
					<select name="category" id="category" onchange="toggleForm(this.value)" required <c:if test="${not empty category}">disabled</c:if>>
						<option value="">선택</option>
						<option value="N" <c:if test="${board.category eq 'N'}">selected</c:if>>공지사항</option>
						<option value="F" <c:if test="${board.category eq 'F'}">selected</c:if>>자유게시판</option>
						<option value="A" <c:if test="${board.category eq 'A'}">selected</c:if>>과제제출</option>
						<option value="Q" <c:if test="${board.category eq 'Q'}">selected</c:if>>질문게시판</option>
					</select>
					<c:if test="${not empty category}">
						<input type="hidden" name="category" value="${category}" />
					</c:if>
				</div>

				<!-- 일반 글쓰기 폼 -->

				<div id="defaultForm" style="display: ${category eq 'A' ? 'none' : 'block'};">
					<div class="form-group">
						<label for="title">제목</label>
						<input type="text" name="boardTitle" id="title" required>
					</div>

					<div class="form-group">
						<label for="content">내용</label>
						<textarea name="boardContent" id="boardContent" class="summernote" rows="10" required></textarea>
					</div>

					<div class="form-group">
						<label for="upfile">파일 첨부 (최대 3개)</label>
						<input type="file" name="upfile" id="upfile" multiple onchange="previewFiles(this)" />
						<div id="image-preview"></div>
					</div>
				</div>
				<!-- 과제 제출 폼 -->


				<div id="assignmentForm" style="display: ${category eq 'A' ? 'block' : 'none'};">
					<div class="form-group">
						<label for="assignmentSelect">과제 제목</label>
						<select id="assignmentSelect" onchange="fillAssignmentInfo(this)">
							<option value="">과제 선택</option>
							<c:forEach var="a" items="${assignments}">
								<option value="${a.assignmentNo}" data-details="${a.assignmentDetails}" data-start="<fmt:formatDate value='${a.startDate}' pattern='yyyy-MM-dd' />" data-end="<fmt:formatDate value='${a.endDate}' pattern='yyyy-MM-dd' />" data-file="${a.uploadFile != null ? a.uploadFile.changeName : ''}">${a.assignmentTitle}</option>
							</c:forEach>
						</select>
					</div>
					<div class="form-group">
						<label for="description">과제 설명</label>
						<textarea name="assignmentDetails" id="description" rows="7"></textarea>
					</div>
					<div class="form-group form-row">
						<div class="form-col">
							<label for="startDate">시작일</label>
							<input type="date" name="startDate" id="startDate">
						</div>
						<div class="form-col">
							<label for="endDate">마감일</label>
							<input type="date" name="endDate" id="endDate">
						</div>
					</div>
					<div class="form-group">
						<label>첨부파일</label>
						<div id="assignmentFileInfo">
							<span id="assignmentFileName">첨부파일 없음</span>
							<a id="assignmentFileDownload" href="#" style="display: none;" download>다운로드</a>
						</div>
					</div>
					<div class="form-group">
						<label for="assignmentTitleInput">제목</label>
						<input type="text" name="boardTitle" id="assignmentTitleInput" required placeholder="제목을 입력하세요">
					</div>

					<div class="form-group">
						<label for="assignmentContent">제출 내용</label>
						<textarea name="boardContent" id="assignmentContent" class="summernote" rows="7" placeholder="여기에 제출할 내용을 입력하세요"></textarea>
					</div>
					<div class="form-group">
						<label for="upfileA">파일 첨부 (최대 3개)</label>
						<input type="file" name="upfile" id="upfileA" multiple onchange="previewFiles(this)" />
						<div id="image-preview"></div>
					</div>
				</div>

				<!-- 버튼 영역 -->
				<div style="display: flex; gap: 12px;">
					<button type="submit" class="submit-btn">등록</button>
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
				<form:form id="dateForm" action="${contextPath}/event/calendar" method="get">
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
					<form action="${contextPath}/event/detail/${event.eventNo}" method="get">
						<button type="submit">상세보기</button>
					</form>
				</c:forEach>
			</div>

			<hr />

			<div class="imperium-context-engine">
				<img src="${contextPath}/resources/assets/img/ai/the_aquila_transparent.png" alt="For The Emperor" style="height: 80px;">
				<h4>Imperium Context Engine(ICE)</h4>
				<pre>ChatGPT & Gemini</pre>
				<button class="btn btn-warning">
					<a href="${contextPath}/ai/main">AI 사용하기</a>
				</button>
			</div>
		</div>
	</div>
	<c:if test="${not empty sessionScope.loginUser}">
		<c:set var="userRole" value="${sessionScope.loginUser.userRole}" />
	</c:if>
	<script>
	function toggleForm(category) {
	    const defaultForm = document.getElementById('defaultForm');
	    const assignmentForm = document.getElementById('assignmentForm');
	    const boardContent = document.getElementById('boardContent');
	    const assignmentContent = document.getElementById('assignmentContent');
	    const assignmentDetails = document.getElementById('description');
	    const upfile = document.getElementById('upfile');
	    const upfileA = document.getElementById('upfileA');
	    const assignmentSelect = document.getElementById('assignmentSelect');
	    const boardTitleDefault = document.getElementById('title');
	    const boardTitleAssignment = document.getElementById('assignmentTitleInput');

	    if (category === 'A') {
	        // 과제 제출 폼 활성화
	    	if (defaultForm) defaultForm.style.display = 'none';
	        if (assignmentForm) assignmentForm.style.display = 'block';
	        // name 충돌 방지
	        if (boardContent) boardContent.removeAttribute('name');
	        if (assignmentContent) assignmentContent.setAttribute('name', 'boardContent');
	        if (boardTitleDefault) boardTitleDefault.removeAttribute('name');
	        if (boardTitleAssignment) boardTitleAssignment.setAttribute('name', 'boardTitle');
	        // required 설정
	        if (boardContent) boardContent.removeAttribute('required');
	        if (assignmentContent) assignmentContent.setAttribute('required', 'required');
	        if (assignmentDetails) assignmentDetails.setAttribute('required', 'required');
	        // 파일 제한 제거
	        if (upfileA) upfileA.removeAttribute('accept');
	        // assignment select 설정
	        if (assignmentSelect) {
	            assignmentSelect.setAttribute('required', 'required');
	            assignmentSelect.setAttribute('name', 'assignmentNo');
	            if (boardTitleDefault) boardTitleDefault.removeAttribute('required');
	            if (boardTitleAssignment) boardTitleAssignment.setAttribute('required', 'required');
	        }
	    } else {
	    	// 일반 글쓰기 폼 활성화
	    	if (defaultForm) defaultForm.style.display = 'block';
	        if (assignmentForm) assignmentForm.style.display = 'none';
	    	// name 충돌 방지
	        if (boardContent) boardContent.setAttribute('name', 'boardContent');
	        if (assignmentContent) assignmentContent.removeAttribute('name');
	        if (boardTitleDefault) boardTitleDefault.setAttribute('name', 'boardTitle');
	        if (boardTitleAssignment) boardTitleAssignment.removeAttribute('name');
	    	// required 설정
	        if (boardContent) boardContent.setAttribute('required', 'required');
	        if (assignmentContent) assignmentContent.removeAttribute('required');
	        if (assignmentDetails) assignmentDetails.removeAttribute('required');
	        // 파일 제한 제거
	        if (upfile) upfile.removeAttribute('accept');
	        // assignment select 제거
	        if (assignmentSelect) {
	            assignmentSelect.removeAttribute('required');
	            assignmentSelect.removeAttribute('name');
	            if (boardTitleDefault) boardTitleDefault.setAttribute('required', 'required');
	            if (boardTitleAssignment) boardTitleAssignment.removeAttribute('required');
	        }
	    }
	}
	
	  // summernote 초기화
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
	
	 // 서버로 이미지 업로드 후 에디터에 삽입
    function sendFile(file, editor) {
        var data = new FormData();
        data.append('file', file);

        $.ajax({
            url: '${pageContext.request.contextPath}/board/uploadImage', // (Controller에서 이 경로 매핑)
            type: 'POST',
            data: data,
            contentType: false,
            processData: false,
            success: function(url) {
                // 성공시 에디터에 이미지 삽입
                $(editor).summernote('insertImage', url);
            },
            error: function(e) {
                alert('이미지 업로드에 실패했습니다.');
            }
        });
    }
	
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

		function confirmCancel() {
		    if (confirm("정말 글쓰기를 취소하시겠습니까?")) {
		        history.back();
		    }
		}
	
		// 과제게시판에서 글쓰기시 자동으로 과제폼 생성
		window.onload = function () {
    const categorySelect = document.getElementById('category');
    if (categorySelect) {
        const selectedCategory = categorySelect.value;
        toggleForm(selectedCategory); // 선택된 값 기준으로 폼 초기화
    }
};
	
		// 전체게시판에서만 동적 action 변경
		<c:if test="${empty category}">
		document.getElementById('writeForm').addEventListener('submit', function(e) {
		    var cat = document.getElementById('category').value;
		    if (!cat) {
		        alert("카테고리를 선택하세요!");
		        e.preventDefault();
		        return false;
		    }
		    this.action = '${pageContext.request.contextPath}/board/insert/' + cat;
		});
		</c:if>
		
		// 과제게시판 제목 선택시 시작일,마감일, 과제설명 자동 맵핑
		function fillAssignmentInfo(select) {
			const selectedOption = select.options[select.selectedIndex]; // 🔹 선언 추가됨
		    document.getElementById('description').value = selectedOption.getAttribute('data-details') || "";
		    document.getElementById('startDate').value = selectedOption.getAttribute('data-start') || "";
		    document.getElementById('endDate').value = selectedOption.getAttribute('data-end') || "";
		    document.getElementById('assignmentTitleInput').value = selectedOption.text;
		    
		 // 첨부파일 처리
			const fileName = selectedOption.dataset.file;
			const fileNameSpan = document.getElementById("assignmentFileName");
			const downloadLink = document.getElementById("assignmentFileDownload");

			if (fileName && fileName !== '') {
				fileNameSpan.innerText = fileName;
				downloadLink.href = '${pageContext.request.contextPath}/resources/upload/assignment/' + fileName;
				downloadLink.style.display = 'inline';
			} else {
				fileNameSpan.innerText = '첨부파일 없음';
				downloadLink.style.display = 'none';
			}
		}
		// 공지사항은 선생님만 가능
		<c:if test="${empty category}">
		    document.getElementById('category').addEventListener('change', function () {
		        const selected = this.value;
		        const classRole = '${classRole}';
		
		        if (selected === 'N' && classRole !== 'teacher') {
		            alert("공지사항 글쓰기는 선생님만 가능합니다.");
		            this.value = '';
		            toggleForm('');
		        }
		    });
		</c:if>
		
    </script>


</body>

</html>






