<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>chattingRoom</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/issue-5-chattingRoom.css"/>
   <%--  <sec:csrfInput/>
	<meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
 --%>
 <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
    <div id="container">
        <div class="main">
        	<jsp:include page="/WEB-INF/views/chat/chatFriendList.jsp">
        		<jsp:param value="1" name="chatRoom"/>
        	</jsp:include>
        	
            <div class="chatting-area">
                <div class="chatting-main">
                    <ul>
                    	<!-- 공지 메세지 -->
                        <div class="chatting-notice-top">공지<div id="notification" data-cm-no="${notification.messageNo}">${notification.content}</div></div>
                        <c:forEach var="cm" items="${chatMessageList}" varStatus="status">
                        	<c:set var="achmisAttent">
                        		<c:if test="${ not empty cm.attachment}">chatting-img-file</c:if>
                        	</c:set>
                        	<!-- 내 채팅 -->
                        	<c:if test="${userNo eq cm.userNo}">
	                        	<li class="chatting-text my-chat ${isAttachment }" data-cm-no="${cm.messageNo}" ><span class="js-content">${cm.content}</span></li>
                        	</c:if>
                        	<!-- 다른 사람 채팅 -->
	                        <c:if test="${userNo ne cm.userNo}">
		                        <li class="chatting-text other-chat ${isAttachment }" data-cm-no="${cm.messageNo}">
		                        	<img src="${pageContext.request.contextPath}/resources/main/bono.jpg" alt="${cm.userName}">
		                        	<div class="other-chat-content">
		                        		<p>${cm.userName}</p>
		                        		<p class="js-content">${cm.content}</p>
		                        	</div>
		                        </li>
	                        </c:if>
                        </c:forEach>
                        <!-- 타이핑 인디케이터 (선택사항) -->
                        <!-- <div class="typing-indicator">누군가가 입력중...</div> -->
                    </ul>
                </div>
                
                <div class="forwoard-main">
                    <div class="forward-text">
                        <textarea id="chatting-textarea" name="content" class="text" 
                                placeholder="메시지를 입력하세요..." rows="1"></textarea>
                    </div>
                    <div class="forward-img-file">
                        <!-- <button class="gallery" type="button" title="갤러리">갤러리</button> -->
                        <button class="file" type="button" title="파일" onclick="document.getElementById('uploadFile').click()">파일</button>
                        <!-- <button class="search" type="button" title="검색">검색</button> -->
                        <button class="forward" id="send-btn" type="button" title="전송">전송</button>
                        <button class="forward" id="update-btn" type="button" title="수정" style="display:none;">수정</button>
                        <button class="forward" id="reply-btn" type="button" title="답장" style="display:none;">답장</button>                        
                    </div>
                </div>
            </div>
        </div>
    </div>
    	
    <form:form action="${pageContext.request.contextPath}/chat/roomExit/${chatRoomNo}" method="post" id="roomExit">
    </form:form>
    <input type="file" id="uploadFile" style="display:none;"/>
 	<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
    <script>
    	// 채팅 설정을 위한 전역변수 등록
    	//const userNo = '${userNo}';
    	//const userName = '${userName}';
    	//const chatRoomNo = '${chatRoomNo}';
    	//const contextPath = '${pageContext.request.contextPath}';
        // stompClient 연결 설정
    	//const stompClient = Stomp.over(new SockJS(contextPath + "/stomp"));
        
        // 변수명 충돌 수정
    	window.chatConfig = {
		    userNo: '${userNo}',
		    userName: '${userName}',
		    chatRoomNo: '${chatRoomNo}',
		    contextPath: '${pageContext.request.contextPath}',
		    stompClient : Stomp.over(new SockJS('${pageContext.request.contextPath}/stomp'))
		};
	</script>
    
    <script src="${pageContext.request.contextPath}/resources/js/issue-5-chattingRoom.js" type="module"></script>
    <script src="${pageContext.request.contextPath}/resources/js/issue-5-stomp.js" type="module"></script>    
    <jsp:include page="/WEB-INF/views/chat/chatSettingModal.jsp"></jsp:include>
</body>
</html>