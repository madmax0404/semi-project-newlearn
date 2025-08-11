<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="description" content="선생님 전용 페이지" />
<meta name="author" content="한종윤, 조성모" />
<title>출결 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/teacher/teacher_common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/teacher/teacher_attendance_management.css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="icon" href="https://cdn-icons-png.flaticon.com/16/1998/1998614.png">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">
		<div class="content">
			<h1>출결 관리</h1>
			<div class="date-select">
				<input type="date" name="date" value="${selectedDate}">
			</div>

			<div class="status-summary">
				<div>출석 ${attNum }/${totalStudentNum }</div>
				<div>결석 ${absentNum }/${totalStudentNum }</div>
				<div>지각 ${lateNum }/${totalStudentNum }</div>
				<div>조퇴 ${earlyLeaveNum }/${totalStudentNum }</div>
			</div>

			<table class="table">
				<thead class="table-light">
					<tr>
						<th>회원 번호</th>
						<th>이름</th>
						<th>출석현황</th>
						<th>입실시간</th>
						<th>퇴실시간</th>
						<th>비고</th>
						<th>관리</th>
					</tr>
				</thead>
				<tbody class="table-border-bottom-0">
					<!-- 각 학생 행 -->
					<c:if test="${not empty attList }">
						<c:forEach var="attendance" items="${attList }">
							<tr class="att-row" data-att-no="${attendance.attNo}">
								<td>${attendance.userNo }</td>
								<td>${attendance.userName }</td>
								<td>${attendance.attStatus }</td>
								<td><fmt:formatDate value="${attendance.entryTime }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
								<td><fmt:formatDate value="${attendance.exitTime }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
								<td><input type="text" value="${attendance.note }" class="att-note-input form-control" placeholder="엔터로 업데이트"></td>
								<td>
									<button class="manage-button">출석 관리</button>
									<div class="dropdown">
										<div>출석</div>
										<div>결석</div>
										<div>지각</div>
										<div>조퇴</div>
										<div>미출석</div>
									</div>
								</td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		</div>
	</div>
</body>
<script>
	let selectedDate = "${selectedDate}";
	
	// 각 "출석 관리" 버튼 클릭 시 드롭다운 열기
	document.querySelectorAll('.manage-button').forEach(button => {
	    button.addEventListener('click', function (e) {
	        // 모든 드롭다운 닫기
	        document.querySelectorAll('.dropdown').forEach(menu => {
	            menu.classList.remove('show');
	        });
	
	        // 현재 버튼 옆 드롭다운 열기
	        const dropdown = this.nextElementSibling;
	        dropdown.classList.toggle('show');
	
	        e.stopPropagation();
	    });
	});
	
	// 바깥 시 드롭다운 닫기
	document.addEventListener('click', () => {
	    document.querySelectorAll('.dropdown').forEach(menu => {
	        menu.classList.remove('show');
	    });
	});
	
	$(document).on('click', '.dropdown > div', function(e) {
	    // 현재 클릭한 드롭다운 메뉴의 tr 찾기
	    let $tr = $(this).closest('tr');
		let attNo = $tr.data("att-no");
	    // 예시: tr에서 학생 이름 가져오기
	    let userNo = $tr.find('td').eq(0).text();
	    let userName = $tr.find('td').eq(1).text();
	    let attStatus = $tr.find('td').eq(2).text();

	    // 클릭한 메뉴(출석, 결석 등) 텍스트
	    let attStatusForUpdate = $(this).text();

	    // 여기에 원하는 로직 추가!
	    e.stopPropagation();
	    
	    if (attStatus !== attStatusForUpdate) {
		    $.ajax({
				url: "${pageContext.request.contextPath}/teacher/attendance/update",
				type: "POST",
				data: {
					userNo,
					classNo,
					attStatusForUpdate,
					attNo
				},
				success: function(res) {
					location.href = "${pageContext.request.contextPath}/teacher/attManage/${classNo}?selectedDate=" + selectedDate;
				},
				error: function(error) {
					console.log("error");
					console.log(error);
				}
			});
	    }
	});

	$(".att-note-input").on("keypress", function(event) {
		if (event.key === "Enter") {
			let attNo = $(this).closest('tr').data("att-no");
			let note = $(this).val();

			$.ajax({
				url: "${pageContext.request.contextPath}/teacher/attendance/noteUpdate",
				type: "POST",
				data: {
					attNo,
					note
				},
				success: function(res) {
					location.href = "${pageContext.request.contextPath}/teacher/attManage/${classNo}?selectedDate=" + selectedDate;
				},
				error: function(error) {
					console.log("error");
					console.log(error);
					alert("비고 업데이트 실패.");
				}
			})
		}
	});

	$("input[type=date][name=date]").on("change", function() {
		selectedDate = $(this).val();
        console.log("날짜 바뀜:", selectedDate);

		location.href = "${pageContext.request.contextPath}/teacher/attManage/${classNo}?selectedDate=" + selectedDate;
	});
</script>
</html>









