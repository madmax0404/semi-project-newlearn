<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="description" content="선생님 전용 페이지" />
    <meta name="author" content="한종윤, 조성모" />
	<title>선생님 페이지</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/teacher/teacher_main.css">
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<link rel="icon" href="https://cdn-icons-png.flaticon.com/16/1998/1998614.png">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">
		<div class="form-group">
			<label>오늘의 입실코드</label> <input type="text" placeholder="오늘의 입실코드를 입력하세요" id="entry-code" value="${tc.entryCode }" class="form-control">
			<button id="entry-code-create-btn" class="btn btn-primary">생성/수정</button>
			<button id="entry-code-copy-btn" class="btn btn-primary">복사</button>
		</div>

		<div class="form-group">
			<label>클래스명 변경</label> <input type="text" value="${tc.className }" id="class-name" class="form-control">
			<button id="class-name-change-btn" class="btn btn-primary">변경</button>
		</div>

		<div class="form-group">
			<label>클래스룸 초대 코드</label> <input type="text" value="${tc.classCode }" id="class-code" class="form-control">
			<button id="class-code-change-btn" class="btn btn-primary">변경</button>
			<button id="class-code-copy-btn" class="btn btn-primary">복사</button>
		</div>

		<div class="button-grid">
			<div class="icon-button shadow" id="att-manage-btn">
				<img src="${pageContext.request.contextPath}/resources/assets/img/출결관리.png" width="40px"><span>출결 관리</span>
			</div>
			<div class="icon-button shadow" id="student-manage-btn">
				<img src="${pageContext.request.contextPath}/resources/assets/img/학생관리.png" width="40px"><span>학생 관리</span>
			</div>
			<div class="icon-button shadow" id="assignment-manage-btn">
				<img src="${pageContext.request.contextPath}/resources/assets/img/과제관리.png" width="40px"><span>과제 관리</span>
			</div>
			<div class="icon-button shadow" id="report-manage-btn">
				<img src="${pageContext.request.contextPath}/resources/assets/img/report.png" width="40px"><span>신고 관리</span>
			</div>
		</div>
	</div>
</body>
<script>
	// 페이지 이동 버튼들
	$("#att-manage-btn").on("click", function() {
		location.href = "${pageContext.request.contextPath}/teacher/attManage/${classNo}";
	});
	$("#student-manage-btn").on("click", function() {
		location.href = "${pageContext.request.contextPath}/teacher/studentManage/${classNo}";
	});
	$("#assignment-manage-btn").on("click", function() {
		location.href = "${pageContext.request.contextPath}/teacher/assignmentManage/${classNo}";
	});
	$("#report-manage-btn").on("click", function() {
		location.href = "${pageContext.request.contextPath}/teacher/reportManage/${classNo}";
	});
	
	$("#entry-code-copy-btn").on("click", function() {
		const entryCode = $("#entry-code").val();
		navigator.clipboard.writeText(entryCode)
		  .then(() => alert("복사 성공!"))
		  .catch(err => {
			  console.error("복사 실패!", err);
			  alert("복사 실패!");
			  });
	});
	
	$("#entry-code-create-btn").on("click", function() {
		const entryCode = $("#entry-code").val();
		
		if (entryCode == "") {
			alert("입실코드를 입력해주세요.");
		} else {
			$.ajax({
				url: "${pageContext.request.contextPath}/teacher/updateEntryCode",
				type: "GET",
				data: {
					classNo,
					entryCode
				},
				success: function(res) {
					console.log(res);
					alert(res.result);
				},
				error: function(error) {
					console.log(error);
					alert("입실코드 생성/수정 실패.");
				}
			});
		}
	});
	
	$("#class-code-change-btn").on("click", function() {
		const classCode = $("#class-code").val();
		
		$.ajax({
			url: "${pageContext.request.contextPath}/teacher/updateClassCode",
			type: "GET",
			data: {
				classNo,
				classCode
			},
			success: function(res) {
				console.log(res);
				alert(res.result);
			},
			error: function(error) {
				console.log(error);
				alert("클래스룸 초대 코드 변경 실패.");
			}
		});
	});
	
	$("#class-name-change-btn").on("click", function() {
		const className = $("#class-name").val();
		
		$.ajax({
			url: "${pageContext.request.contextPath}/teacher/updateClassName",
			type: "GET",
			data: {
				classNo,
				className
			},
			success: function(res) {
				console.log(res);
				alert(res.result);
			},
			error: function(error) {
				console.log(error);
				alert("클래스명 변경 실패.");
			}
		});
	});
	
	$("#class-code-copy-btn").on("click", function() {
		const classCode = $("#class-code").val();
		
		navigator.clipboard.writeText(classCode)
		  .then(() => alert("복사 성공!"))
		  .catch(err => {
			  console.error("복사 실패!", err);
			  alert("복사 실패!");
			  });
	});
</script>
</html>









