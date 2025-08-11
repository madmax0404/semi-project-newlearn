<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>아이디 찾기 결과</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/assets/vendor/css/core.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/assets/vendor/css/theme-default.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/assets/vendor/css/pages/page-auth.css" />

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/find-id-result.css">

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
}

.step-line {
	flex-grow: 1;
	height: 2px;
	background-color: #e0e0e0;
	margin-top: 15px;
}

.step-line.active {
	background-color: #696cff;
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
	color: #adb5bd;
}

.step.active .step-circle {
	background-color: #696cff;
	border-color: #696cff;
	color: white;
}

.step-label {
	font-size: 14px;
	color: #868e96;
	margin-top: 8px;
}

.step.active .step-label {
	color: #566a7f;
	font-weight: bold;
}

.icon-wrapper {
	display: flex;
	justify-content: center;
	margin-bottom: 1.5rem;
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
					<div class="step-line active"></div>
					<div class="step active">
						<div class="step-circle">2</div>
						<div class="step-label">확인완료</div>
					</div>
				</div>


				<div class="card">
					<div class="card-body text-center">
						<c:choose>
							<%-- 아이디를 찾았을 경우 --%>
							<c:when test="${not empty foundId}">
								<div class="icon-wrapper">
									<svg class="checkmark" xmlns="http://www.w3.org/2000/svg"
										viewBox="0 0 52 52">
                    <circle class="checkmark-circle" cx="26" cy="26"
											r="25" fill="none" />
                    <path class="checkmark-check" fill="none"
											d="M14.1 27.2l7.1 7.2 16.7-16.8" />
                </svg>
								</div>
								<h4 class="mb-2 text-center">본인 확인 완료</h4>
								<p class="mb-3">
									회원님의 아이디는 <strong>${foundId}</strong> 입니다.
								</p>

								<p class="mb-4">
									회원 정보 확인 및 수정은 마이페이지에서 가능합니다.
								</p>

								<a href="${pageContext.request.contextPath}/member/login"
									class="btn btn-primary w-100">로그인 바로가기</a>
							</c:when>

							<%-- 아이디를 못 찾았을 경우 --%>
							<c:otherwise>
								<div class="icon-wrapper">
									<svg class="failmark" xmlns="http://www.w3.org/2000/svg"
										viewBox="0 0 52 52">
                    <circle class="failmark-circle" cx="26" cy="26"
											r="25" fill="none" />
                    <path class="failmark-check"
											d="M16 16 36 36 M36 16 16 36" fill="none" />
                </svg>
								</div>
								<h4 class="mb-2 text-danger text-center">본인 확인 실패</h4>
								<p class="mb-4">일치하는 회원 정보를 찾을 수 없습니다.</p>
								<a href="${pageContext.request.contextPath}/member/findId"
									class="btn btn-secondary w-100">다시 시도</a>
							</c:otherwise>
						</c:choose>

					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>

