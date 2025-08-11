<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>

<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog">
   		<div class="modal-content">
   			<div class="modal-header">
       			<h5 class="modal-title" id="exampleModalLabel">Personal Event Form</h5>
       			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
       				<span aria-hidden="true">&times;</span>
       			</button>
   			</div>
   			<c:if test="${not empty event}">
	   			<form:form modelAttribute="event" method="post" action="${pageContext.request.contextPath}/event/personal">
	   				<input type="hidden" name="userNo" value="${loginUser.userNo}"/>
	       			<div class="modal-body">
		       			<form:input path="eventNo" type="hidden"/>
	           			제목 <form:input type="text" path="eventName" required="required"/><br>
					    장소 <form:input type="text" path="place" required="required"/><br>
					    시작시간 <form:input type="datetime-local" path="startDate" required="required"/><br>
					    종료시간 <form:input type="datetime-local" path="endDate" required="required"/><br>
					    세부내용 <form:textarea path="content" required="required"/><br>
					    공개설정 
					    <form:radiobutton path="visibility" value="Y"/>공개
					    <form:radiobutton path="visibility" value="N"/>비공개
	       			</div>
	       			<div class="modal-footer">
	           			<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	           			<c:choose>
	           				<c:when test="${event.eventName == null}">
	           					<form:input path="type" type="hidden" value="insert" />
			           			<button type="submit" class="btn btn-primary">추가</button>
	           				</c:when>
	           				<c:otherwise>
	           					<form:input path="type" type="hidden" value="update" />
			           			<button type="submit" class="btn btn-primary">수정</button>
	           				</c:otherwise>
	           			</c:choose>
	       			</div>
	   			</form:form>
	   		</c:if>
   		</div>
	</div>
</div>