<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
<title>아이디 찾기</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/assets/vendor/css/core.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/assets/vendor/css/theme-default.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/assets/vendor/css/pages/page-auth.css" />

<style>
.progress-indicator {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100%;
	max-width: 500px;
	margin-bottom: 1.5rem;
}

.step {
	display: flex;
	flex-direction: column;
	align-items: center;
	text-align: center;
	position: relative;
	flex-shrink: 0
}

.step-line {
	flex-grow: 1;
	height: 2px;
	background-color: #e0e0e0;
	margin: 0;
	position: relative;
	top: 15px;
	z-index: -1
}

.step-line.active {
	background-color: #696cff
}

.step-circle {
	width: 30px;
	height: 30px;
	border-radius: 50%;
	background-color: white;
	border: 2px solid #adb5bd;
	margin-bottom: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: bold;
	color: #adb5bd
}

.step.active .step-circle {
	background-color: #696cff;
	border-color: #696cff;
	color: white
}

.step-label {
	font-size: 14px;
	color: #868e96;
	margin-top: 8px
}

.step.active .step-label {
	color: #566a7f;
	font-weight: bold
}
</style>

</head>
<body>

	<div class="container-xxl">
		<div class="authentication-wrapper authentication-basic container-p-y">
			<div class="authentication-inner">

				<div class="progress-indicator">
					<div class="step active">
						<div class="step-circle">1</div>
						<div class="step-label">본인확인</div>
					</div>
					<div class="step-line"></div>
					<div class="step">
						<div class="step-circle">2</div>
						<div class="step-label">확인완료</div>
					</div>
				</div>

				<jsp:include page="_member-verification-form.jsp">
					<jsp:param name="actionUrl"
						value="${pageContext.request.contextPath}/member/findId" />
				</jsp:include>

			</div>
		</div>
	</div>

</body>
</html>