<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<div class="top-side">
	<div class="shared-calendar">
		<jsp:include page="/WEB-INF/views/event/calendar.jsp" />
	</div>
	<div class="right-side">
		<div class="monthly-attendance">
			<h3>클래스룸 별 출석률</h3>
			<select id="classroomAtt" name="classroomAttItem"
				data-date="${selectedDate}">
				<option value="">--클래스룸 선택--</option>
				<c:forEach var="classroom" items="${classroomList}">
					<option value="${classroom.classNo}">${classroom.className}</option>
				</c:forEach>
			</select>
			<div id="classAttMod"></div>
		</div>
		<h2>${selectedDate}</h2>
		<h4>공개 개인일정</h4>
		<c:forEach var="event" items="${publicPersonal}">
			<div class="event-item">
				<span><fmt:formatDate value="${event.startDate}"
						pattern="h : mm a" /> - <fmt:formatDate value="${event.endDate}"
						pattern="h : mm a" /> | ${event.eventName} : ${event.content}</span>
				<c:if test="${mypageNo eq loginUser.userNo}">
					<div class="button-group">
						<button class="modal-btn" data-dmltype="edit"
							data-eventno="${event.eventNo}">수정</button>
						<form:form
							action="${pageContext.request.contextPath}/event/deletePersonal"
							method="get">
							<input type="hidden" name="eventNo" value="${event.eventNo}" />
							<input type="hidden" name="mypageNo" value="${mypageNo}" />
							<button type="submit">삭제</button>
						</form:form>
					</div>
				</c:if>
			</div>
		</c:forEach>
		<c:if test="${mypageNo eq loginUser.userNo}">
			<h4>비공개 개인일정</h4>
			<c:forEach var="event" items="${privatePersonal}">
				<div class="event-item">
					<span><fmt:formatDate value="${event.startDate}"
							pattern="h : mm a" /> - <fmt:formatDate value="${event.endDate}"
							pattern="h : mm a" /> | ${event.eventName} : ${event.content}</span>
					<c:if test="${mypageNo eq loginUser.userNo}">
						<div class="button-group">
							<button class="modal-btn" data-dmltype="edit"
								data-eventno="${event.eventNo}">수정</button>
							<form:form
								action="${pageContext.request.contextPath}/event/deletePersonal"
								method="get">
								<input type="hidden" name="eventNo" value="${event.eventNo}" />
								<input type="hidden" name="mypageNo" value="${mypageNo}" />
								<button type="submit">삭제</button>
							</form:form>
						</div>
					</c:if>
				</div>
			</c:forEach>
			비공개 처리된 일정은 클래스룸 캘린더 집계에 반영되지 않습니다!
			<button class="modal-btn new-personal-btn" data-dmltype="create" data-eventno="0">새 개인일정 추가</button>
		</c:if>
		<div class="modal-position"></div>
	</div>
</div>
