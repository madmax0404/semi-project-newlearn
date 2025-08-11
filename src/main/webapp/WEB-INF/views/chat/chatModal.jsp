<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!-- <div id="create-room-modal">
	<form:form action="/chat/createRoom" method="post"
		id="create-room-form">
		<div class="modal-name">
			<span>채팅방 만들기</span>
		</div>
		<div class="room-title">방 제목 입력</div>
		<input type="text" name="chatTitle" class="input-room-title">
		<div class="open-close-password">

			<div class="open-close">
				<div class="choice-open-close">공개 여부</div>
				<span class="open-room">공개<input type="radio"
					name="chatPublic" class="open-radio" value="Y" checked></span> <span
					class="close-room">비공개<input type="radio" name="chatPublic"
					class="close-radio" value="N"></span>

			</div>

			<div class="password">
				<div>비밀번호</div>
				<input type="password" name="chatPw" class="input-room-password">
			</div>

		</div>
		<div class="member-plus">대화 상대 초대</div>
		<div class="search-name">
			<span>이름 검색</span><input type="text" name="searchFriend"
				class="input-friend-name">

		</div>
		<div class="friend-choice">
			<c:choose>
				<c:when test="${empty friendList}">
					<ul>
						<li>친구가 없습니다.</li>
					</ul>
				</c:when>
				<c:otherwise>
					<ul>
						<c:forEach items="${friendList}" var="friend">
							<li class="friend-inf-checkbox" data-user-no="${friend.userNo}"
								id="${friend.userName }"><label
								for="selectFriend-${friend.userNo}">
									<div class="friend-picture">${friend.changeName}</div>
									<div class="friend-name-ps">
										<div class="friend-name">${friend.userName}</div>
										<div class="friend-ps">${friend.statusMessage}</div>
									</div> <input type="checkbox" name="select-friend-list" value="${friend.userNo}" id="selectFriend-${friend.userNo}">
							</label></li>
						</c:forEach>
					</ul>
				</c:otherwise>
			</c:choose>
		</div>
		<div class="go-back">
			<input type="button" value="취소"> <input type="button"
				value="확인" class="create-room-btn">
		</div>
		</form:form>
	</div> -->
<div class="container-create">
	<div id="create-room-modal">
		<form id="create-room-form">
		<div class="modal-name">채팅방 만들기</div>
		<div class="change-title">방 제목</div>
		<input type="text" name="chatTitle" class="input-room-title" placeholder="채팅방 20자">
		
		<div class="change-open-close">
			<div class="choice-open-close">
				<div class="open-close">공개 여부</div>
				<span class="room-open">공개<input type="radio" name="chatPublic" class="radioPublicY" value="Y" checked></span>
				<span class="room-close">비공개<input type="radio" name="chatPublic" class="radioPublicN" value="N"></span>
			</div>
			<div class="password" id="chatPwGroup">
				<div>비밀번호</div>
				<input type="password" name="chatPw" class="input-room-password">
			</div>
		</div>
		
		<div class="member-plus">대화 상대 초대</div>
		<div class="search-name">
			<span>이름 검색</span>
			<input type="text" name="searchFriend" class="input-friend-name">
		</div>
		
		<div class="friend-list">
			<div class="friend-choice">
				<c:choose>
			<c:when test="${empty memberList}">
				<ul>
					<li>친구가 없습니다.</li>
				</ul>
			</c:when>
			<c:otherwise>
				<ul>
					<c:forEach items="${memberList}" var="member">
						<li class="friend-inf-checkbox" data-user-no="${member.userNo}"><label
							for="selectFriend-${member.userNo}">
								<div class="friend-picture">${member.changeName}</div>
								<div class="friend-name-ps">
									<div class="friend-name">${member.userName}</div>
									<div class="friend-ps">${member.statusMessage}</div>
								</div><input type="checkbox" name="selectFriendList" value="${member.userNo}" id="selectFriend-${member.userNo}">
						</label></li>
					</c:forEach>
				</ul>
			</c:otherwise>
		</c:choose>
			</div>
		</div>
		<div class="go-back">
			<input type="button" value="취소">
			<input type="button" value="확인" class="create-room-btn">
		</div>
		</form>
	</div>
</div>