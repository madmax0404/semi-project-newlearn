<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="modal-content">
	<form:form action="${pageContext.request.contextPath}/mypage/notiSetForm" method="post">
		<h3>계정별 알림설정</h3>
		<div id="accNotiMod" class="notiModCheckbox">
			<label><input type="checkbox" name="generalNoti" value="guestbook"
				<c:if test="${subscription.guestbookNoti == 'Y'}">checked</c:if>/>방명록</label><br>
			<label><input type="checkbox" name="generalNoti" value="chatting"
				<c:if test="${subscription.chatNoti == 'Y'}">checked</c:if>/>채팅</label><br>
			<label><input type="checkbox" name="generalNoti" value="friendReq"
				<c:if test="${subscription.friendRequestNoti == 'Y'}">checked</c:if>/>친구요청</label><br>
			<label><input type="checkbox" name="generalNoti" value="classInvi"
				<c:if test="${subscription.classInvitationNoti == 'Y'}">checked</c:if>/>클래스초대</label><br>
		</div>
		<h3>클래스룸별 알림설정</h3>
		<select id="classroomItem" name="classroomItem">
			<option value="">--클래스룸 선택--</option>
			<c:forEach var="classroom" items="${classroomList}">
				<option value="${classroom.classNo}">${classroom.className}</option>
			</c:forEach>
		</select>
		<div id="classNotiMod" class="notiModCheckbox"></div>
		<input type="hidden" name="userNo" value="${loginUser.userNo}"/>
		<button type="submit">저장</button>
	</form:form>
</div>