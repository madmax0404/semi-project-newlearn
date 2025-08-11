<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="description" content="선생님 전용 페이지" />
<meta name="author" content="한종윤" />
<title>신고 관리</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="icon" href="https://cdn-icons-png.flaticon.com/16/1998/1998614.png">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/teacher/teacher_common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/teacher/teacher_report_management.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">
		<div class="content">
			<h1>신고 관리</h1>

			<table class="table">
				<thead class="table-light">
					<tr>
						<th>신고자 회원 번호</th>
						<th>신고자 이름</th>
						<th>피신고자 회원 번호</th>
						<th>피신고자 이름</th>
						<th>링크</th>
						<th>신고 내용</th>
						<th>신고 시간</th>
						<th>조치 상태</th>
					</tr>
				</thead>
				<tbody class="table-border-bottom-0">
					<c:if test="${not empty reportList }">
						<c:forEach var="report" items="${reportList }">
							<tr class="">
								<td>${report.reporterUserNo }</td>
								<td>${report.reporterUserName }</td>
								<td>${report.reportedUserNo }</td>
								<td>${report.reportedUserName }</td>
								<td><a href="${pageContext.request.contextPath}/${report.link.split("learn/")[1] }">${report.link.split("learn/")[1] }</a></td>
								<td>${report.reportContent }</td>
								<td><fmt:formatDate value="${report.reportTime }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
								<td>
									<c:if test="${report.reportStatus == 'N' }">
										<button class="manage-button not-done" data-report-no="${report.reportNo }"
										data-report-status="${report.reportStatus }">미조치</button>									
									</c:if>
									<c:if test="${report.reportStatus == 'Y' }">
										<button class="manage-button done" data-report-no="${report.reportNo }"
										data-report-status="${report.reportStatus }">조치</button>									
									</c:if>									
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
	$(".manage-button").on("click", function() {
		
		let reportNo = $(this).data("report-no");
		let reportStatus = $(this).data("report-status");
		
		let bool = confirm("조치 상태를 변경하시겠습니까?");
		
		if (bool) {
			$.ajax({
				url: "${pageContext.request.contextPath}/teacher/updateReportStatus",
				data: {
					reportNo,
					reportStatus
				},
				success: function(res) {
					console.log(res);
					if (res > 0) {
						alert("조치 상태 변경 완료.");
						location.href = "${pageContext.request.contextPath}/teacher/reportManage/${classNo}";
					} else {
						alert("조치 상태 변경 실패.");
					}
				},
				error: function(error) {
					console.log(error);
					alert("조치 상태 변경 실패.");
				}
			});
		}
	});
</script>
</html>









