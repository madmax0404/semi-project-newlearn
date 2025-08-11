<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/alertify.min.css"/>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/default.min.css"/>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/semantic.min.css"/>

<head>
	<style>
		* {
			box-sizing: border-box;
		}
		
		.header {
			display: flex;
			justify-content: space-between;
			align-items: center;
			padding: 10px 20px;
			margin: 10px;
			border-radius: 10px;
			background-color: white;
			height: 180px;
		}
		
		.header>div {
			flex: 1;
		}
		
		#left {
			text-align: left;
			display: flex;
		}

		.title-new h1 {
			color: rgb(156, 46, 156);
		}

		.title-learn h1 {
			color: black;
		}
		
		#center {
			text-align: center;
		}
		
		#right {
			flex: 1;
			text-align: right;
			/* 내부 요소들 세로로 쌓기 */
			display: flex;
			flex-direction: column;
			justify-content: center; /* 세로 가운데 정렬 */
			align-items: flex-end; /* 오른쪽 정렬 */
			gap: 8px; /* 버튼 사이 간격 */
		}
		
		#change-class-modal {
			display:none; 
		    position:absolute; 
		    background:#fff; 
		    border:1px solid #333; 
		    padding:10px; 
		    box-shadow: 2px 2px 10px rgba(0,0,0,0.2);
		    z-index: 1000;
		    max-width: 200px;
		}
		
		#change-class-list a {
		    display: block;
		    padding: 5px 0;
		    color: #007bff;
		    text-decoration: none;
		    cursor: pointer;
		    text-align: center;
		}
		  
		#change-class-list a:hover {
		    text-decoration: underline;
		}
	</style>
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/css/core.css" class="template-customizer-core-css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/css/theme-default.css" class="template-customizer-theme-css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/css/demo.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/libs/apex-charts/apex-charts.css" />
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
	<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
	
	
	
	<meta id="_csrf" name="_csrf" content="${_csrf.token}"/>
	<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body>
	<script>
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		$(document).ready(function() {
			$.ajaxSetup({
				headers: {
					'X-CSRF-TOKEN': $('meta[name="_csrf"]').attr('content')
				}
			});
		});
	</script>
	<%-- <sec:authentication property="principal"/>
   	<sec:authentication property="authorities"/> --%>
	<div class="header shadow">
		<div id="left">
			<div class="title-new">
				<h1>new</h1>
			</div>
			&emsp;
			<div class="title-learn">
				<h1>Learn();</h1>
			</div>
		</div>
		<div id="center">
			<c:if test="${not empty mypage}">
				<a href="${pageContext.request.contextPath}/mypage/${mypage.mypageNo}"><h2>${mypage.mypageName}</h2></a>
			</c:if>
			<c:if test="${empty mypage}">
				<a href="${pageContext.request.contextPath}/class/${classNo}"><h2>${className}</h2></a>
			</c:if>
			<c:if test="${classRole eq 'teacher' }">
				<a href="${pageContext.request.contextPath}/teacher/main/${classNo}">선생님페이지</a>
			</c:if>
		</div>
		<div id="right">
			<c:if test="${empty mypage}">
				<button id="change-class" class="btn btn-outline-primary">클래스룸 변경</button>
				<div id="change-class-modal">
					<div id="change-class-list"></div>
				</div>
			</c:if>
			
			<form action="${pageContext.request.contextPath}/member/logout" method="post" style="margin: 0;">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				<button type="submit" class="btn btn-outline-primary">로그아웃</button>
			</form>
		</div>
	</div>

<script>
	const contextPath = '${pageContext.request.contextPath}';
	const userNo = '${loginUser.userNo}';
	const classNo = '${classNo}';
</script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/header.js"></script>

</body>