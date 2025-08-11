<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원가입 결과</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/assets/vendor/css/core.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/assets/vendor/css/theme-default.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/assets/vendor/css/pages/page-auth.css" />
<!-- 기존 애니메이션 css -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/enrollComplete.css">
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
	background-color: transparent;
	margin: 0;
	position: relative;
	top: 15px;
	z-index: -1
}

.step-line.active {
	background-color: transparent;
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

.icon-wrapper {
	display: flex;
	justify-content: center;
}

.authentication-inner {
	max-width: 600px;
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
						<div class="step-label">약관동의</div>
					</div>
					<div class="step-line active"></div>
					<div class="step active">
						<div class="step-circle">2</div>
						<div class="step-label">정보입력</div>
					</div>
					<div class="step-line active"></div>
					<div class="step active">
						<div class="step-circle">3</div>
						<div class="step-label">가입완료</div>
					</div>
				</div>

				<div class="card">
					<%-- 2. card-body에 text-center 클래스를 추가하여 아이콘과 텍스트를 가운데 정렬 --%>
					<div class="card-body text-center">

						<c:set var="result" value="${empty result ? 'success' : result}" />

						<c:choose>
							<%-- 가입 성공 케이스 --%>
							<c:when test="${result == 'success'}">
								<div class="icon-wrapper">
									<svg class="checkmark" xmlns="http://www.w3.org/2000/svg"
										viewBox="0 0 52 52">
                            <circle class="checkmark-circle" cx="26"
											cy="26" r="25" fill="none" />
                            <path class="checkmark-check" fill="none"
											d="M14.1 27.2l7.1 7.2 16.7-16.8" />
                        </svg>
								</div>
								<h4 class="mb-2">회원가입 완료</h4>
								<p class="mb-4">
									<strong>${userNameForComplete}</strong>님의 회원가입을 축하합니다!
								</p>
								<a href="${pageContext.request.contextPath}/member/login"
									class="btn btn-primary d-grid w-100">로그인 바로가기</a>
							</c:when>

							<%-- 가입 실패 케이스 --%>
							<c:otherwise>
								<div class="icon-wrapper">
									<svg class="failmark" xmlns="http://www.w3.org/2000/svg"
										viewBox="0 0 52 52">
                            <circle class="failmark-circle" cx="26"
											cy="26" r="25" fill="none" />
                            <path class="failmark-check"
											d="M16 16 36 36 M36 16 16 36" fill="none" />
                        </svg>
								</div>
								<h4 class="mb-2 text-danger">회원가입 실패</h4>
								<c:choose>
									<c:when test="${not empty message}">
										<p class="mb-4">${message}</p>
									</c:when>
									<c:otherwise>
										<p class="mb-4">이미 계정이 존재하는 사용자 정보입니다.</p>
									</c:otherwise>
								</c:choose>
								<a href="${pageContext.request.contextPath}/security/insert"
									class="btn btn-primary d-grid w-100">다시 시도</a>
							</c:otherwise>
						</c:choose>

					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>

