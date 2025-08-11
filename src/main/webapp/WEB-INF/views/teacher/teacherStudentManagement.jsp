<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="description" content="선생님 전용 페이지" />
<meta name="author" content="한종윤" />
<title>학생 관리</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="icon" href="https://cdn-icons-png.flaticon.com/16/1998/1998614.png">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/teacher/teacher_common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/teacher/teacher_student_management.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">
		<div class="content">
			<h1>학생 관리</h1>

			<table class="table">
				<thead class="table-light">
					<tr>
						<th>회원 번호</th>
						<th>이름</th>
						<th>아이디</th>
						<th>이메일</th>
						<th>클래스 가입일</th>
						<th>계정 상태</th>
						<th>비고</th>
					</tr>
				</thead>
				<tbody class="table-border-bottom-0">
					<!-- 각 학생 행 -->
					<c:if test="${not empty studentList }">
						<c:forEach var="student" items="${studentList }">
							<tr class="att-row">
								<td>${student.userNo }</td>
								<td>${student.userName }</td>
								<td>${student.userId }</td>
								<td>${student.email }</td>
								<td><fmt:formatDate value="${student.classJoinDate }" pattern="yyyy-MM-dd"/></td>
								<td>
									<c:if test="${student.memberStatus == 'Y' }">정상</c:if>
									<c:if test="${student.memberStatus == 'N' }"><b style="color:red">정지됨</b></c:if>
								</td>
								<td>
									<button class="manage-button">보기</button>
									<div class="dropdown">
										<div>마이페이지 보기</div>
										<div>메세지</div>
										<div>추방</div>
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
	// 각 "보기" 버튼 클릭 시 드롭다운 열기
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

	// 클릭 시 드롭다운 닫기
	document.addEventListener('click', () => {
	    document.querySelectorAll('.dropdown').forEach(menu => {
	        menu.classList.remove('show');
	    });
	});

	const stompClient = Stomp.over(new SockJS(contextPath + "/stomp"));

	// 드랍다운 클릭시 이벤트 실행
	$(document).on('click', '.dropdown > div', function(e) {
	    // 현재 클릭한 드롭다운 메뉴의 tr 찾기
	    let $tr = $(this).closest('tr');
	    // 예시: tr에서 학생 이름 가져오기
	    let userNo = $tr.find('td').eq(0).text();
		let userName = $tr.find('td').eq(1).text();
		let userId = $tr.find('td').eq(2).text();

	    // 클릭한 메뉴(프로필 보기, 메시지, 추방 등) 텍스트
	    let selectedMenu = $(this).text();

	    // 여기에 원하는 로직 추가!
	    e.stopPropagation();

		if (selectedMenu === "마이페이지 보기") {
			console.log("마이페이지 보기 클릭");
			location.href = "${pageContext.request.contextPath}/mypage/" + userNo;
		} else if (selectedMenu === "메세지") {
			console.log("메세지 클릭");
			const message = prompt("전송할 메세지를 입력해주세요.");

			if (message && message.trim() !== "") {
				const payload = {
					sender: userName,
					content: message
				};
				stompClient.send("/app/sendToUser/" + userNo, {}, JSON.stringify(payload));
			}
		} else if (selectedMenu === "추방") {
			console.log("추방 클릭");
			let reallyKick = confirm("정말로 추방하시겠습니까?");

			if (reallyKick) {
				$.ajax({
					url: "${pageContext.request.contextPath}/teacher/studentKick",
					type: "POST",
					data: {
						classNo,
						userNo
					},
					success: function(res) {
						console.log(res);
						alert("추방되었습니다.");
						location.href = "${pageContext.request.contextPath}/teacher/studentManage/${classNo}";
					},
					error: function(error) {
						console.log(error);
						alert("추방에 실패했습니다.")
					}
				});
			}
		}
	});
</script>
</html>