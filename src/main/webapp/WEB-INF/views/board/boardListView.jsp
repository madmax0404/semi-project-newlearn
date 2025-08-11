<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>new Learn();</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/calendar.css" type="text/css" />
<link rel="icon" href="https://cdn-icons-png.flaticon.com/16/1998/1998614.png">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="content">
		<div class="sidebar-left" style="background-color: yellow;">
			<div class="mini-profile">
				<!--<sec:authorize access="isAuthenticated()">
					<span><sec:authentication property="principal.username"/></span>				
				</sec:authorize>-->
				<span>님 환영합니다</span> <span>입실시간 9 : 03 AM</span>
			</div>
			<form action="${pageContext.request.contextPath}/mypage" method="get">
				<button type="submit">마이페이지</button>
			</form>
			<button>입실</button>
			<div class="friend-list">
				<h4>즐겨찾기</h4>
				<h4>일반</h4>
				<button>친구관리</button>
			</div>
			<div class="chatroom-list">
				<h4>전체채팅</h4>
				<h4>그룹채팅</h4>
				<h4>개인채팅</h4>
				<button>채팅방관리</button>
				<button>새채팅</button>
			</div>
		</div>

		<div class="board" >
			<div class="board-category">
				<ul>
					<li><a href="${pageContext.request.contextPath}">전체게시판</a></li>
					<li><a href="${pageContext.request.contextPath}/board/list/N?classNo=${classNo}">공지사항</a></li>
					<li><a href="${pageContext.request.contextPath}/board/list/F?classNo=${classNo}">자유게시판</a></li>
					<li><a href="${pageContext.request.contextPath}/board/list/A?classNo=${classNo}">과제제출</a></li>
					<li><a href="${pageContext.request.contextPath}/board/list/Q?classNo=${classNo}">질문게시판</a></li>
				</ul>
				<button>맥주창고</button>
			</div>
			<div class="board-list">
				<table class="board-table">
					<thead>
						<tr>
							<th class="col-img">이미지</th>
							<th class="col-title">제목</th>
							<th class="col-writer">글쓴이</th>
							<th class="col-date">등록일</th>
							<th class="col-views">조회</th>
							<th class="col-likes">추천</th>
						</tr>
					</thead>
					<!-- 동적 요소 생성 후 바인딩 -->
					<tbody>
						<c:forEach var="board" items="${list}">
							<tr onclick="movePage('${board.boardNo}')" style="cursor: pointer;">
								<td class="col-img">이미지</td>
								<td class="col-title">${board.boardTitle }</td>
								<td class="col-writer">${board.userName }</td>
								<td class="col-date">
									<fmt:formatDate value="${board.createDate}" pattern="yyyy-MM-dd" />
									<br />
									<fmt:formatDate value="${board.createDate}" pattern="HH:mm:ss" />
								</td>
								<td class="col-views">${board.viewCount }</td>
								<td class="col-likes">${board.likeCount }</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<!-- 검색 및 글쓰기 -->
			<div class="search-write-wrap">
				<form class="search-form" id="searchForm" method="get" action="${pageContext.request.contextPath}/board/list/${category}">
					<select class="search-select" name="condition">
						<option value="writer" <c:if test="${param.condition eq 'writer'}">selected</c:if>>작성자</option>
						<option value="title" <c:if test="${param.condition eq 'title'}">selected</c:if>>제목</option>
						<option value="content" <c:if test="${param.condition eq 'content'}">selected</c:if>>내용</option>
						<option value="titleAndContent" <c:if test="${param.condition eq 'titleAndContent'}">selected
							</c:if>>제목+내용</option>
					</select>
					<input type="text" class="search-input" name="keyword" value="${param.keyword}" />
					<button type="submit" class="search-button">검색</button>
				</form>

				<div class="write-btn">
					<c:choose>
						<c:when test="${not empty category && category ne 'all'}">
							<a href="${pageContext.request.contextPath}/board/insert/${category}">
								<button type="button">글쓰기</button>
							</a>
						</c:when>
						<c:otherwise>
							<a href="${pageContext.request.contextPath}/board/insert">
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
						<li class="page-item"><a class="page-link" href="${url}${pi.currentPage - 1}${searchParam}">&lt;&lt;&lt;</a></li>
					</c:if>

					<c:forEach var="i" begin="${pi.startPage }" end="${pi.endPage }">
						<li class="page-item"><a class="page-link" href="${url}${i}${searchParam}">${i}</a></li>
					</c:forEach>
					<c:if test="${pi.currentPage eq pi.maxPage }">
						<li class="page-item"><a class="page-link">&gt;&gt;&gt;</a></li>
					</c:if>

					<c:if test="${pi.currentPage ne pi.maxPage }">
						<li class="page-item"><a class="page-link" href="${url}${pi.currentPage +1}${searchParam}">&gt;&gt;&gt;</a></li>
					</c:if>
				</ul>
			</div>

		</div>

		<div class="sidebar-right" style="background-color: skyblue;">
			<div class="notification">
				<h4>새 알림 5건</h4>
				<p>친구 김성겸 님이 늦잠자는중...</p>
				<p>읽지 않은 메세지 12건</p>
				<p>게시판에 새 글이 있습니다</p>
				<p>방명록에 새 글이 있습니다</p>
				<p>제출해야 할 과제가 있습니다</p>
			</div>
			<div class="shared-calendar">
				<jsp:include page="/WEB-INF/views/event/calendar.jsp" />
			</div>
			<div class="upcoming-events">
				<h4>UPCOMING EVENTS</h4>
				<p>7월 10일 목요일 6 : 00 PM</p>
				<pre>세미프로젝트 2조 회식 (6명 참여중...)</pre>
				<button>상세보기</button>
			</div>
			<div class="ai-help">
				<h4>ASK ANYTHING!</h4>
				<pre>ChatGPT     Gemini     Claude</pre>
				<p>질문을 입력하세요</p>
				<button>
					<a href="${pageContext.request.contextPath}/ai/main">AI 사용하기</a>
				</button>
			</div>
		</div>
	</div>

	<script>
	    // 게시글 클릭시 상세보기 이동
		function movePage(bno) {
	        var category = '${category}'; 
	        location.href = "${pageContext.request.contextPath}/board/detail/" + category + "/" + bno;
	    }
	</script>


</body>

</html>

