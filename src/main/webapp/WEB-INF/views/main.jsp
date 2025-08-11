<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>new Learn();</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/calendar.css" type="text/css" />
<link rel="icon" href="https://cdn-icons-png.flaticon.com/16/1998/1998614.png">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+" crossorigin="anonymous"></script>

</head>

<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<c:set var="contextPath" value="${pageContext.request.contextPath}" />
	<sec:authentication property="principal" var="loginUser" />
	<sec:authentication property="principal.userNo" var="myLoginUserNo" />
	<sec:authentication property="authorities" var="myAuthorities" />

	<div class="content">
		<!-- 왼쪽 사이드바 -->
		<div class="sidebar-left card shadow">
			<div class="mini-profile">
				<span>${loginUser.userName}님 환영합니다</span> <span>입실시간: <c:if test="${not empty attendance.entryTime}">
						<fmt:formatDate value="${attendance.entryTime}" pattern="h : mm a" />
					</c:if> <c:if test="${empty attendance.entryTime}">아직 안함</c:if>
				</span>
			</div>

			<div class="friend-chatting-list">
				<a href="${pageContext.request.contextPath}/friend/myFriendList"><button class="btn rounded-pill btn-secondary btn-xs">친구관리</button></a>
				<a href="${pageContext.request.contextPath}/chat/main"><button class="btn rounded-pill btn-secondary btn-xs" id="chat-page-btn">채팅방관리</button></a>
			</div>
			<div class="mypage-and-entry">
				<form action="${contextPath}/mypage/${loginUser.userNo}" method="get">
					<button type="submit" class="btn btn-primary">마이페이지</button>
				</form>
				<button type="button" data-toggle="modal" data-target="#exampleModal" class="btn btn-primary">입실</button>
			</div>

			<!-- 입실 모달 -->
			<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">

					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="exampleModalLabel">입실코드 입력</h5>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<form:form method="post" action="${pageContext.request.contextPath}/class/entry">
							<div class="modal-body">
								<input type="hidden" name="classNo" value="${classNo}"/>
								<input type="text" name="attEntryCode" required="required" />
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
								<button type="submit" class="btn btn-primary">확인</button>
							</div>
						</form:form>
					</div>
				</div>
			</div>

			<hr>
			<div class="imperium-context-engine">
				<img src="${pageContext.request.contextPath}/resources/assets/img/ai/the_aquila_transparent.png" alt="For The Emperor" style="height: 80px;">
				<h4>Imperium Context Engine(ICE)</h4>
				<pre>ChatGPT & Gemini</pre>
				<button class="btn btn-warning">
					<a href="${pageContext.request.contextPath}/ai/main">AI 사용하기</a>
				</button>
			</div>

			<!-- 친구 및 채팅 -->
			<!-- <div class="friend-list">
				<div class="list-header">
					<h5>즐겨찾기</h5>
					<div class="list-btns">
						<button class="btn rounded-pill btn-secondary btn-xs">
							<a href="${pageContext.request.contextPath}/friend/myFriendList">친구관리</a>
						</button>
					</div>
				</div>
				<h5>일반</h5>
			</div>

			<div class="chatroom-list">
				<div class="list-header">
					<h5>전체채팅</h5>
					<div class="list-btns">
						<button class="btn rounded-pill btn-secondary btn-xs">새채팅</button>
						<a href="${pageContext.request.contextPath}/chat/main"><button class="btn rounded-pill btn-secondary btn-xs" id="chat-page-btn">채팅방관리</button></a>
					</div>
				</div>
				<h5>그룹채팅</h5>
				<h5>개인채팅</h5>
			</div> -->
		</div>

		<!-- 게시판 영역 -->
		<div class="board card shadow">
			<!-- 카테고리 탭 -->
			<div class="board-category">
				<ul>
					<li><a href="${pageContext.request.contextPath}/board/list/all?classNo=${classNo}">&nbsp;&nbsp;전체게시판&nbsp;&nbsp;</a></li>
					<li><a href="${pageContext.request.contextPath}/board/list/N?classNo=${classNo}">&nbsp;&nbsp;공지사항&nbsp;&nbsp;</a></li>
					<li><a href="${pageContext.request.contextPath}/board/list/F?classNo=${classNo}">&nbsp;&nbsp;자유게시판&nbsp;&nbsp;</a></li>
					<li><a href="${pageContext.request.contextPath}/board/list/A?classNo=${classNo}">&nbsp;&nbsp;과제제출&nbsp;&nbsp;</a></li>
					<li><a href="${pageContext.request.contextPath}/board/list/Q?classNo=${classNo}">&nbsp;&nbsp;질문게시판&nbsp;&nbsp;</a></li>
				</ul>
				<ul>
					<li><a href="${contextPath}/beerStore">맥주창고</a></li>
				</ul>
			</div>

			<!-- 게시글 목록 -->
			<div class="board-list table">
				<table class="board-table">
					<thead class="table-light">
						<tr>
							<th class="col-img"></th>
							<c:if test="${category eq 'all'}">
								<th class="col-category">카테고리</th>
							</c:if>
							<th class="col-title">제목</th>
							<th class="col-writer">글쓴이</th>
							<th class="col-date">등록일</th>
							<th class="col-views">조회수</th>
							<th class="col-likes">추천수</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="board" items="${list}">
							<c:choose>
								<c:when test="${board.category eq 'A'}">
									<c:choose>
										<c:when test="${board.userNo == myLoginUserNo or fn:contains(myAuthorities, 'ROLE_TEACHER')}">
											<tr onclick="movePage('${board.boardNo}', '${board.category}', '${board.classNo}')" style="cursor: pointer;">
										</c:when>
										<c:otherwise>
											<tr style="cursor: not-allowed; color: gray;" onclick="return false;">
										</c:otherwise>
									</c:choose>
								</c:when>

								<c:otherwise>
									<tr onclick="movePage('${board.boardNo}', '${board.category}', '${board.classNo}')" style="cursor: pointer;">
								</c:otherwise>
							</c:choose>

							<td class="col-img">
								<c:choose>
									<c:when test="${not empty board.thumbnail}">
										<img src="${board.thumbnail}" alt="썸네일" style="width: 70px; height: 70px; object-fit: cover; border-radius: 6px;" />
									</c:when>
									<c:otherwise>
										<img src="${pageContext.request.contextPath}/resources/files/assignment/no-image.png" alt="이미지 없음" style="width: 70px; height: 70px; object-fit: cover; border-radius: 6px; opacity: 0.5;" />
									</c:otherwise>
								</c:choose>
							</td>

							<c:if test="${category eq 'all'}">
								<td class="col-category">
									<c:choose>
										<c:when test="${board.category eq 'N'}">공지</c:when>
										<c:when test="${board.category eq 'F'}">자유</c:when>
										<c:when test="${board.category eq 'A'}">과제</c:when>
										<c:when test="${board.category eq 'Q'}">질문</c:when>
										<c:otherwise>기타</c:otherwise>
									</c:choose>
								</td>
							</c:if>

							<td class="col-title">${board.boardTitle}</td>
							<td class="col-writer">${board.userName}</td>
							<td class="col-date">
								<fmt:formatDate value="${board.createDate}" pattern="yyyy-MM-dd" />
								<br />
								<fmt:formatDate value="${board.createDate}" pattern="HH:mm:ss" />
							</td>
							<td class="col-views">${board.viewCount}</td>
							<td class="col-likes">${board.likeCount}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<!-- 검색 및 글쓰기 -->
			<div class="search-write-wrap">
				<form class="search-form" id="searchForm" method="get" action="/new-learn/board/list/${category}">
					<input type="hidden" name="classNo" value="${classNo}" />
					<select class="search-select" name="condition">
						<option value="writer" ${param.condition eq 'writer' ? 'selected' : ''}>작성자</option>
						<option value="title" ${param.condition eq 'title' ? 'selected' : ''}>제목</option>
						<option value="content" ${param.condition eq 'content' ? 'selected' : ''}>내용</option>
						<option value="titleAndContent" ${param.condition eq 'titleAndContent' ? 'selected' : ''}>제목+내용</option>
					</select>
					<input type="text" class="search-input" name="keyword" value="${param.keyword}" />
					<button type="submit" class="search-button">검색</button>
				</form>

				<div class="write-btn">
					<c:choose>
						<c:when test="${not empty category && category eq 'N'}">
							<c:if test="${sessionScope.classRole == 'teacher'}">
								<a href="${pageContext.request.contextPath}/board/insert/${category}?classNo=${classNo}">
									<button type="button">글쓰기</button>
								</a>
							</c:if>
						</c:when>
						<c:when test="${not empty category && category ne 'all'}">
							<a href="${pageContext.request.contextPath}/board/insert/${category}?classNo=${classNo}">
								<button type="button">글쓰기</button>
							</a>
						</c:when>
						<c:otherwise>
							<a href="${pageContext.request.contextPath}/board/insert?classNo=${classNo}">
								<button type="button">글쓰기</button>
							</a>
						</c:otherwise>
					</c:choose>
				</div>
			</div>

			<!-- 페이징 -->
			<c:set var="url" value="${pageContext.request.contextPath}/board/list/${category}?currentPage=" />
			<c:set var="searchParam" value="" />
			<c:if test="${not empty param.condition}">
				<c:set var="searchParam" value="&condition=${param.condition}&keyword=${param.keyword}" />
			</c:if>

			<div id="pagingArea" style="margin-top: 20px;">
				<ul class="pagination">

					<c:if test="${pi.currentPage eq 1 }">
						<li class="page-item"><a class="page-link">&lt;&lt;&lt;</a></li>
					</c:if>
					<c:if test="${pi.currentPage ne 1}">
						<li class="page-item"><a class="page-link" href="${url}${pi.currentPage - 1}${searchParam}&classNo=${classNo}">&lt;&lt;&lt;</a></li>
					</c:if>

					<c:forEach var="i" begin="${pi.startPage }" end="${pi.endPage }">
						<li class="page-item"><a class="page-link" href="${url}${i}${searchParam}&classNo=${classNo}">${i}</a></li>
					</c:forEach>
					<c:if test="${pi.currentPage eq pi.maxPage }">
						<li class="page-item"><a class="page-link">&gt;&gt;&gt;</a></li>
					</c:if>

					<c:if test="${pi.currentPage ne pi.maxPage }">
						<li class="page-item"><a class="page-link" href="${url}${i}${searchParam}&classNo=${classNo}">&gt;&gt;&gt;</a></li>
					</c:if>
				</ul>
			</div>

		</div>

		<div class="sidebar-right card shadow">
			<div class="notification">
				<h4>새 알림 5건</h4>
				<p>친구 김성겸 님이 늦잠자는중...</p>
				<p>읽지 않은 메세지 12건</p>
				<p>게시판에 새 글이 있습니다</p>
				<p>방명록에 새 글이 있습니다</p>
				<p>제출해야 할 과제가 있습니다</p>
			</div>
			<div class="shared-calendar">
				<form:form id="dateForm" action="${pageContext.request.contextPath}/event/calendar" method="get">
					<input type="hidden" name="classNo" value="${classNo}" />
					<jsp:include page="/WEB-INF/views/event/calendar.jsp" />
				</form:form>
			</div>
			<div class="upcoming-events">
				<h4>UPCOMING EVENTS</h4>
				<c:forEach var="event" items="${upcomingEvents}">
					<p>
						<fmt:formatDate value="${event.startDate}" pattern="M월 d일 EEEE h : mm a" />
					</p>
					<pre>${event.eventName} (${eventWithMemberCnt[event]}명 참여중...)</pre>
					<form action="${pageContext.request.contextPath}/event/detail" method="get">
						<input type="hidden" name="eventNo" value="${event.eventNo}"/>
						<button type="submit">상세보기</button>
					</form>
				</c:forEach>
			</div>
		</div>
	</div>

	<script>
		// 게시글 클릭시 상세보기 이동
		function movePage(boardNo, category, classNo) {
			location.href = "${pageContext.request.contextPath}/board/detail/"
					+ category + "/" + boardNo + "?classNo=" + classNo;
		}
		// 캘린더 클릭 시 이벤트페이지 이동
		function onDateClick(date) {
			const form = document.getElementById("dateForm");
			document.getElementById("selectedDate").value = date;
			form.submit();
		}

		//공유이벤트가 존재하는 날짜에 배경색 지정
		const sharedEventCss = JSON.parse('${sharedEventCss}');
		console.log(sharedEventCss);
		for ( let date in sharedEventCss) {
			const cell = document.querySelector('td[data-date="' + date + '"]');
			if (cell) {
				cell.style.backgroundColor = 'yellow';
			}
		}

		<c:if test="${not empty entryMsg}">
		alert("${entryMsg}");
		</c:if>
	</script>
</body>
</html>
