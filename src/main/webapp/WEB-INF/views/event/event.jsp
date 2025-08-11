<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>공유이벤트 페이지</title>
	
	<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+" crossorigin="anonymous"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/event.css" type="text/css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/calendar.css" type="text/css" />
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="content">
		<div class="left-side">
			<div class="shared-calendar">
				<form:form id="dateForm" action="${pageContext.request.contextPath}/event/calendar" method="get">
					<input type="hidden" name="classNo" value="${classNo}"/>
					<jsp:include page="/WEB-INF/views/event/calendar.jsp" />
				</form:form>
			</div>
			<h1>${selectedDate}</h1>
			
			<h4>전체 이벤트</h4>
			<!-- 이벤트 리스트 출력 (DB에서 받아온 리스트 사용) -->
			<div id="shared-events">
			
			</div>
			<c:forEach var="event" items="${sharedEvents}">
				<a href="${pageContext.request.contextPath}/event/detail?eventNo=${event.eventNo}&classNo=${classNo}">
				${event.userName} | ${event.eventName} 
				(<fmt:formatDate value="${event.startDate}" pattern="h : mm a"/>)</a>
			</c:forEach>
			<!-- 새 이벤트 추가 버튼 -->
			<form action="${pageContext.request.contextPath}/event/new" method="get">
				<input type="hidden" name="selectedDate" value="${selectedDate}"/>
				<input type="hidden" name="classNo" value="${classNo}"/>
				<button type="submit" class="btn btn-primary btn-sm mt-2">이벤트 추가</button>

			</form>
			
			<h4>개인 이벤트</h4>
			<!-- db에서 event 테이블 event_type 컬럼 personal인 데이터 조회 -->
			<c:forEach var="event" items="${personalEvents}">
				<a href="${pageContext.request.contextPath}/event/detail?eventNo=${event.eventNo}&classNo=${classNo}">
				${event.userName} | ${event.eventName} 
				(<fmt:formatDate value="${event.startDate}" pattern="h : mm a"/>)</a>
			</c:forEach>
			<!-- 새 이벤트 추가 버튼 -->
			<form action="${pageContext.request.contextPath}/mypage/${loginUser.userNo}" method="get">
				<input type="hidden" name="to" value="event">
				<input type="hidden" name="from" value="event">
				<button type="submit" class="btn btn-primary btn-sm mt-2">개일일정 추가</button>

			</form>
		</div>
		<div class="main-body">
			<!-- 이벤트 폼 -->
			<c:if test="${not empty event}">
				<div class="event-form-wrapper">
					<form:form id="eventForm" modelAttribute="event" method="post"
		            action="${pageContext.request.contextPath}/event/newShared">
		            	<form:input path="eventNo" type="hidden"/>
		            	<form:input path="userNo" type="hidden" value="${loginUser.userNo}"/>
		            	<form:input path="classNo" type="hidden" value="${classNo}"/>
		            	<form:input path="eventType" type="hidden" value="SHARED"/>
		                제목<form:input path="eventName" placeholder="이벤트 제목을 입력하세요" required="true"/>
				        장소<form:input path="place" placeholder="어디서 만날까요?" required="true"/>
				        시작시간<form:input path="startDate" type="datetime-local" required="true"/>
				        종료시간<form:input path="endDate" type="datetime-local" required="true"/>
				        모집인원<form:input path="numPpl" type="number" required="true"/>
				        모집기한<form:input path="joinDeadline" type="datetime-local" required="true"/>
				        세부내용<form:textarea path="content" placeholder="뭐 하고 놀까요?" required="true"/>
			            <div align="center">
			            	<c:if test="${event.eventName == null}"> <!-- 새 이벤트 추가 -->
			            		<button type="reset">초기화</button>
			            		<button type="submit">이벤트 생성</button>
			            	</c:if>
			            	<c:if test="${event.eventName != null}"> <!-- 이벤트 상세보기 -->
			            		<c:choose>
			            			<c:when test="${event.userNo == loginUser.userNo}"> <!-- 내 이벤트 (수정 / 삭제) -->
					                	<button type="button" onclick="submitTo('${pageContext.request.contextPath}/event/update')">이벤트 수정</button>
						                <c:if test="${event.eventType eq 'SHARED'}">
						                	<button type="button" onclick="submitTo('${pageContext.request.contextPath}/event/deleteShared')">이벤트 삭제</button>
						                </c:if>
						                <c:if test="${event.eventType eq 'PERSONAL'}">
						                	<button type="button" onclick="submitTo('${pageContext.request.contextPath}/event/deletePersonal')">이벤트 삭제</button>
						                </c:if>
			            			</c:when>
			            			<c:otherwise>										<!-- 내 이벤트 아님 (참여) -->
			            				<c:if test="${event.eventType eq 'SHARED'}">
			            					<button type="button" onclick="submitTo('${pageContext.request.contextPath}/event/join')">이벤트 참여</button>
			            					<button type="button" onclick="submitTo('${pageContext.request.contextPath}/event/exit')">이벤트 나가기</button>
			            				</c:if>
			            			</c:otherwise>
			            		</c:choose>
			            	</c:if>
			            </div>
			        </form:form>
		        </div>
	        </c:if>
		</div>
	</div>
</body>
<c:if test="${not empty alertMsg}">
	<script>alert("${alertMsg}");</script>
</c:if>
<script>
	function onDateClick(date) {
	   	const form = document.getElementById("dateForm");
	    document.getElementById("selectedDate").value = date;
	    form.submit();
	}
	
	function submitTo(url) {
		const form = document.getElementById("eventForm");
		form.action = url;
		if (confirm("정말요?")) {
			form.submit();
		} else {
			alert("취소되었습니다.");
		}
	}
	
	// 이벤트 갯수 받아와서 최대값 구하기
	const personalEventCss = JSON.parse('${personalEventCss}');
	let max = 0;
	for (let date in personalEventCss) {
		if (personalEventCss[date] > max) {
			max = personalEventCss[date];
		}
	}
	
	// 이벤트 갯수를 바탕으로 캘린더에 css 입히기
	for (let date in personalEventCss) {
		let cnt = personalEventCss[date];
		const opacity = (max == 0 ? 0 : cnt/max);
		const cell = document.querySelector('td[data-date="' + date + '"]');
		if (cell) {
			cell.style.backgroundColor = 'rgba(30, 144, 255, ' + opacity + ')';
			if (opacity > 0.5) {
				cell.style.color = '#fff';
			}
		}
	}
</script>
</html>