<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:forEach var="aiChatSession" items="${aiChatSessionsList}">
	<li class="ai-chat-sessions-list">
		<div class="ai-chat-sessions-list-title"
			data-session-no="${aiChatSession.sessionNo }"
			data-model-no="${aiChatSession.modelNo }">
			${aiChatSession.title }</div>
		<button type="button"
			class="btn rounded-pill btn-xs btn-outline-primary session-delete-btn"
			data-session-no="${aiChatSession.sessionNo }">삭제</button>
	</li>
</c:forEach>