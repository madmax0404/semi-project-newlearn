<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!-- 채팅방 설정/신고/나가기 컨트롤러 -->
<div id="set-room-controller">
	<div class="set-room">설정</div>
	<div class="line"></div>
	<div class="exit-room">나가기</div>
	<!-- <div class="line"></div>
	<div class="report-room">신고</div> -->
</div>

<!-- 채팅방 설정 모달 (방장 or 멤버) -->
<div class="container-fluid">
	<div id="set-room-modal">
	<form:form id="set-room-form" modelAttribute="chatInfo" method="post" action="${pageContext.request.contextPath }/chat/updateChatRoom">
		<div class="modal-name">채팅방 설정</div>
		<div class="change-title">방 제목</div>
		<form:input path="chatTitle" type="text" class="input-change-title" placeholder="채팅방 20자" />
		
		<div class="change-open-close">
			<div class="choice-open-close">
				<div class="open-close">공개 여부</div>
				<span class="room-open">공개
					<form:radiobutton path="chatPublic" value="Y" class="radioPublicY" />
				</span>
				<span class="room-close">비공개
					<form:radiobutton path="chatPublic" value="N" class="radioPublicN" />
				</span>
			</div>
			<div class="change-password" id="chatPwGroup">
				<div>비밀번호</div>
				<form:password path="chatPw" id="user-pw" class="input-change-password"/>
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
			<c:when test="${empty friendList}">
				<ul>
					<li>친구가 없습니다.</li>
				</ul>
			</c:when>
			<c:otherwise>
				<ul>
					<c:forEach items="${friendList}" var="friend">
						<li class="friend-inf-checkbox" data-user-no="${friend.userNo}"><label
							for="selectFriend-${friend.userNo}">
								<div class="friend-picture">${friend.changeName}</div>
								<div class="friend-name-ps">
									<div class="friend-name">${friend.userName}</div>
									<div class="friend-ps">${friend.statusMessage}</div>
								</div> <input type="checkbox" name="selectFriendList"
								value="${friend.userNo}" id="selectFriend-${friend.userNo}"
								${chatInfo.selectFriendList.contains(friend.userNo) ? 'checked':'' }
								>
						</label></li>
					</c:forEach>
				</ul>
			</c:otherwise>
		</c:choose>
			</div>
		</div>
		<div class="go-back">
			<input type="button" value="취소">
			<input type="button" value="확인" class="set-room-btn" onclick="">
		</div>
		</form:form>
	</div>
</div>

<!-- 채팅방 신고 모달 -->
<div class="modal-overlay">
	<div id="reportroom-modal">
		<div class="modal-name">신고</div>
		<div class="report-reason">신고 사유</div>
		<div class="reasons">
			<div class="reason1">
				<input type="checkbox" name="" id="reason1">
				<span>욕설/공격적인 언어 사용</span>
			</div>
			<div class="reason2">
				<input type="checkbox" name="" id="reason2">
				<span>혐오발언</span>
			</div>
			<div class="reason3">
				<input type="checkbox" name="" id="reason3">
				<span>음란물 유포</span>
			</div>
			<div class="reason4">
				<input type="checkbox" name="" id="reason4">
				<span>불법 정보(도박/사행성)</span>
			</div>
			<div class="reason5">
				<input type="checkbox" name="" id="reason5">
				<span>기타</span>
			</div>
			<div class="reason-detail">
				<textarea name="" id="reason-detail" placeholder="신고 사유"></textarea>
			</div>
		</div>
		<div class="go-back">
			<input type="button" value="취소">
			<input type="button" value="신고">
		</div>
	</div>
</div>
<div id="mychattingoption-controller">

</div>

<!--
	공지 컨트롤러
-->
<div id="chattingnotice-controller">
	<div class="chatting-view">보기</div>
	<div class="line"></div>
	<div class="chatting-delete">삭제</div>
</div>