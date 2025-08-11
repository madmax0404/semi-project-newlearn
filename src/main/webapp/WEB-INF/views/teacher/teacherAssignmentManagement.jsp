<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="description" content="선생님 전용 페이지" />
	<meta name="author" content="한종윤" />
	<title>과제 관리</title>
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<link rel="icon" href="https://cdn-icons-png.flaticon.com/16/1998/1998614.png">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/teacher/teacher_common.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/teacher/teacher_assignment_management.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">
		<div class="content">
			<div class="title-and-create">
				<div></div>
				<h1 id="title">과제 관리</h1>
				<button id="create" class="btn btn-outline-primary">과제 생성</button>			
			</div>

			<table class="table">
				<thead class="table-light">
					<tr>
						<th>과제 번호</th>
						<th>과제 이름</th>
						<th>생성일</th>
						<th>시작일</th>
						<th>종료일</th>
					</tr>
				</thead>
				<tbody class="table-border-bottom-0">
					<!-- 각 과제 행 -->
					<c:if test="${not empty aList }">
						<c:forEach var="assignment" items="${aList }">
							<tr class="tbody-row">
								<td>${assignment.assignmentNo }</td>
								<td><a href="${pageContext.request.contextPath}/teacher/${classNo}/assignment/modify/${assignment.assignmentNo}">${assignment.assignmentTitle }</a></td>
								<td><fmt:formatDate value="${assignment.createDate }" pattern="yyyy-MM-dd"/></td>
								<td><fmt:formatDate value="${assignment.startDate }" pattern="yyyy-MM-dd"/></td>
								<td><fmt:formatDate value="${assignment.endDate }" pattern="yyyy-MM-dd"/></td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		</div>		
	</div>
</body>
<script>
	// 과제를 생성하면 다시 과제 관리 페이지로 리다이렉트 한다.
	$("#create").on("click", function() {
		// 과제 생성 페이지로 이동시킨다.
		location.href = "${pageContext.request.contextPath}/teacher/${classNo}/assignment/create";
	});
</script>
</html>