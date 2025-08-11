<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/issue-5-chattingFriendList.css"/>

<div id="friend">
	<c:if test="${ empty param.chatRoom }">
		<div id="friend-top">
			<div>친구목록</div>
			<div>(${fn:length(memberList)}명)</div>
			<button>채팅방 만들기</button>
		</div>
	</c:if>
	<c:if test="${not empty param.chatRoom }">
		<div class="room_title">방 제목</div> <!-- 현재 채팅방 제목 바인딩..-->
	    <div class="room_inf">
	        <div class="room_member">참여자</div>
	        <div class="room_member_count">${fn:length(memberList)}명</div>
	        <div class="room-noti" data-status="${chattingRoom.roomNoti}">
				<c:choose>
					<c:when test="${chattingRoom.roomNoti == 'Y'}"><button class="room-alarm-Y"><i class="fas fa-bell"></i></button></c:when>
					<c:otherwise><button class="room-alarm-N"><i class="fas fa-bell-slash"></i></button></c:otherwise>
				</c:choose>
			</div>
	        <button class="room_set_button" title="채팅방 설정"><i class="fas fa-bars"></i></button>
	    </div>
	</c:if>
    
	<div id="friend-mid">
		<c:choose>
			<c:when test="${empty memberList}">
				<ul>
					<li>친구가 없습니다.</li>
				</ul>
			</c:when>
			<c:otherwise>
				<ul>
					<c:forEach items="${memberList}" var="member" varStatus="status">
						<li class="friend-inf" data-user-no="${member.userNo}">
							<div class="friend-picture">
								<c:choose>
									<c:when test="${not empty member.changeName}">
										<img src="${member.changeName}" alt="${member.userName}">
									</c:when>
									<c:otherwise>
										${member.userName.substring(0, 1).toUpperCase()}
									</c:otherwise>
								</c:choose>
							</div>
							<div class="friend-name-ps">
								<div class="friend-name">${member.userName}</div>
								<div class="friend-ps">${member.statusMessage}</div>
							</div>
						</li>
					</c:forEach>
				</ul>
			</c:otherwise>
		</c:choose>
	</div>
</div>