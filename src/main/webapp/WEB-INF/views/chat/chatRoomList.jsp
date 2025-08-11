<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<link rel="stylesheet" 
	href="${pageContext.request.contextPath}/resources/css/issue-5-chattingRoomList.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<div id="room-list">
	<div id="room-list-top">
		<div>채팅방 목록</div>
	</div>
	<div id="room-list-sub">
		<ul>
			<li>방 제목</li>
			<li>개설자</li>
			<li>참여자 수</li>
			<li>공개여부</li>
			<li>알림</li>
		</ul>
	</div>
	<div id="room-list-mid">
		<c:choose>
			<c:when test="${empty chattingRoomList}">
				<ul>
					<li>채팅방이 없습니다.</li>
				</ul>
			</c:when>
			<c:otherwise>
				<ul>
					<c:forEach items="${chattingRoomList}" var="chattingRoom">
						<li id="${chattingRoom.chatTitle}">
							<div class="creater-picture">
								<c:choose>
									<c:when test="${not empty chattingRoom.changeName}">
										<img src="${chattingRoom.changeName}" alt="Profile">
									</c:when>
									<c:otherwise>
										${chattingRoom.userName.substring(0, 1).toUpperCase()}
									</c:otherwise>
								</c:choose>
							</div>
							<div class="room-title">${chattingRoom.chatTitle}</div>
							<div class="no-read-chat">새소식</div>
							<button class="room-enter" onclick="moveChatRoom(${chattingRoom.chatRoomNo})">참여</button>
							<div class="creater-name">${chattingRoom.userName}</div>
							<div class="member-count">${chattingRoom.participantCount} 명</div>
							<div class="open-close" data-status="${chattingRoom.chatPublic}">
								<c:choose>
									<c:when test="${chattingRoom.chatPublic == 'Y'}"><i class="fas fa-lock-open"></i></c:when>
									<c:otherwise><i class="fas fa-lock"></i></c:otherwise>
								</c:choose>
							</div>
							<div class="room-noti" data-status="${chattingRoom.roomNoti}">
								<c:choose>
									<c:when test="${chattingRoom.roomNoti == 'Y'}"><button class="room-alarm-Y"><i class="fas fa-bell"></i></button></c:when>
									<c:otherwise><button class="room-alarm-N"><i class="fas fa-bell-slash"></i></button></c:otherwise>
								</c:choose>
							</div>
						</li>
					</c:forEach>
				</ul>
			</c:otherwise>
		</c:choose>
	</div>
	<!--페이징 처리기능 -->
	<!-- <div id="pagingArea">
		<ul class="pagination">
			<c:if test="${pi.currentPage eq 1 }">
				<li class="page-item"><a class="page-link">Previous</a></li>
			</c:if>
			<c:if test="${pi.currentPage ne 1 }">
				<li class="page-item"><a class="page-link"
					href="${url}${pi.currentPage -1}${searchParam}">Previous</a></li>
			</c:if>
			<c:forEach var="i" begin="${pi.startPage }" end="${pi.endPage }">
				<li class="page-item"><a class="page-link"
					href="${url}${i}${searchParam}">${i}</a></li>
			</c:forEach>
			<c:if test="${pi.currentPage eq pi.maxPage }">
				<li class="page-item"><a class="page-link">Next</a></li>
			</c:if>
			<c:if test="${pi.currentPage ne pi.maxPage }">
				<li class="page-item"><a class="page-link"
					href="${url}${pi.currentPage +1}${searchParam}">Next</a></li>
			</c:if>
		</ul>
	</div> -->

	<!-- 채팅방 검색 기능 -->
	<!-- <div id="room-list-bottom">
		<select id="search-type" class="search-type" name="searchType">
			<option name="search-type" value="title">제목</option>
			<option name="search-type" value="member">참여자</option>
		</select> 
		<input class="keyword" type="search" name="keyword" placeholder="검색어를 입력하세요..."> 
		<input class="search" type="submit" name="search" value="검색">
	</div> -->
</div>