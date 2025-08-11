<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>chattingRoomList</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/issue-5-chattingRoomList.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/issue-5-chattingFriendList.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/issue-5-chattingRoom.css"/>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	var chatAppContextPath = "${pageContext.request.contextPath}";

	// 현재 로그인된 사용자의 userNo를 JavaScript 변수로 설정
	// 팀 프로젝트 진행을 위해 임시로 하드코딩
	var loginUserNo = '${sessionScope.loginMember.userNo}';
	if (typeof loginUserNo === 'undefined' || loginUserNo === null
			|| loginUserNo === '') {
		loginUserNo = 3; // 임시 userNo 3으로 설정
	}
	loginUserNo = parseInt(loginUserNo);
</script>

</head>
<body>
	<div id="container">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
		<div id="mid">
			<!-- 채팅방 친구 목록  -->
			<jsp:include page="/WEB-INF/views/chat/chatFriendList.jsp"></jsp:include>
			<!-- 채팅방 목록 -->
			<jsp:include page="/WEB-INF/views/chat/chatRoomList.jsp"></jsp:include>
		</div>
	</div>

	<!-- 채팅방 만들기 모달 -->
	<jsp:include page="/WEB-INF/views/chat/chatModal.jsp"></jsp:include>
	<!-- 친구정보 모달 -->
	<!-- <jsp:include page="/WEB-INF/views/chat/friendModal.jsp"></jsp:include> -->
	<!-- 채팅방신고 모달 -->
	<!-- <jsp:include page="/WEB-INF/views/chat/chatReportModal.jsp"></jsp:include> -->
	<script src="${pageContext.request.contextPath}/resources/js/issue-5-chattingRoomList.js"></script>
</body>
</html>