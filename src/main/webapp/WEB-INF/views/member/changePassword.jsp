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
<title>비밀번호 변경</title>
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

.form-text {
	font-size: 0.875em;
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
						<div class="step-label">정보변경</div>
					</div>
					<div class="step-line"></div>
					<div class="step">
						<div class="step-circle">3</div>
						<div class="step-label">변경완료</div>
					</div>
				</div>

				<div class="card">
					<div class="card-body">
						<h4 class="mb-2 text-center">비밀번호 재설정</h4>

						<form:form modelAttribute="member" id="resetPwForm"
							action="${pageContext.request.contextPath}/member/resetPassword"
							method="post">
							<input type="hidden" name="${_csrf.parameterName}"
								value="${_csrf.token}" />

							<div class="mb-3 form-password-toggle">
								<label class="form-label" for="new-password">새 비밀번호</label>
								<div class="input-group input-group-merge">
									<form:password path="userPwd" id="new-password"
										class="form-control" placeholder="영문, 숫자, 특수문자 포함 7~20자" />
									<span class="input-group-text cursor-pointer"><i
										class="bx bx-hide"></i></span>
								</div>
								<div id="pw-feedback" class="form-text"></div>
							</div>

							<div class="mb-3 form-password-toggle">
								<label class="form-label" for="confirm-password">비밀번호 확인</label>
								<div class="input-group input-group-merge">
									<input type="password" id="confirm-password"
										class="form-control" name="confirmPassword"
										placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;">
									<span class="input-group-text cursor-pointer"><i
										class="bx bx-hide"></i></span>
								</div>
								<div id="pw-confirm-feedback" class="form-text"></div>
							</div>

							<button type="submit" id="next-btn" class="btn btn-primary w-100">다음</button>
						</form:form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script
		src="${pageContext.request.contextPath}/resources/assets/vendor/libs/jquery/jquery.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/assets/vendor/libs/popper/popper.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/assets/vendor/js/bootstrap.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/assets/js/main.js"></script>

	<script>
		$(document)
				.ready(
						function() {
							// CSRF 토큰을 모든 AJAX 요청에 자동으로 포함시키는 설정
							const token = $("meta[name='_csrf']").attr(
									"content");
							const header = $("meta[name='_csrf_header']").attr(
									"content");
							$.ajaxSetup({
								beforeSend : function(xhr) {
									if (header && token) {
										xhr.setRequestHeader(header, token);
									}
								}
							});

							const $newPw = $('#new-password');
							const $confirmPw = $('#confirm-password');
							const $pwFeedback = $('#pw-feedback');
							const $pwConfirmFeedback = $('#pw-confirm-feedback');

							let debounceTimer; // 타이머

							// 새 비밀번호 유효성 검사
							$newPw
									.on(
											'keyup',
											function() {
												clearTimeout(debounceTimer);

												const userPw = $newPw.val();
												const pwRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&^])[A-Za-z\d$@$!%*#?&^]{7,20}$/;

												// 형식 검사
												if (!pwRegex.test(userPw)) {
													$pwFeedback
															.text(
																	'비밀번호는 영문, 숫자, 특수문자를 포함하여 7~20자여야 합니다.')
															.css('color', 'red');
													return; // 만약 형식이 맞지 않으면 끝이니 리턴
												}

												// 형식은 맞다면 서버에 비밀번호 동일 여부 검사를 요청
												debounceTimer = setTimeout(
														function() {
															$
																	.ajax({
																		url : '${pageContext.request.contextPath}/member/checkSamePassword',
																		type : 'POST',
																		data : {
																			newPassword : userPw
																		},
																		success : function(
																				response) {
																			// 검사 결과에 따라 메시지 표시
																			if (response.isSame) {
																				$pwFeedback
																						.text(
																								'기존 비밀번호와 동일합니다.')
																						.css(
																								'color',
																								'red');
																			} else {
																				$pwFeedback
																						.text(
																								'사용 가능한 비밀번호입니다.')
																						.css(
																								'color',
																								'green');
																			}
																		},
																		error : function() {
																			$pwFeedback
																					.text(
																							'검사 중 오류가 발생했습니다.')
																					.css(
																							'color',
																							'red');
																		}
																	});
														}, 500); // 0.5초
											});

							// 비밀번호 일치 확인 (기존 코드와 동일)
							$newPw.add($confirmPw).on(
									'keyup',
									function() {
										const newPw = $newPw.val();
										const confirmPw = $confirmPw.val();

										if (confirmPw.length > 0) {
											if (newPw === confirmPw) {
												$pwConfirmFeedback.text(
														'비밀번호가 일치합니다.').css(
														'color', 'green');
											} else {
												$pwConfirmFeedback.text(
														'비밀번호가 일치하지 않습니다.')
														.css('color', 'red');
											}
										} else {
											$pwConfirmFeedback.text('');
										}
									});

							// 페이지 로드 시, 서버에서 보낸 에러 메시지 팝업 (기존 코드와 동일)
							const message = "${message}";
							if (message) {
								alert(message);
							}
						});
	</script>

	<script>
		// 페이지 로드 시, 서버에서 보낸 에러 메시지가 있는지 확인하고 팝업으로 띄웁니다.
		const message = "${message}";
		if (message) {
			alert(message);
		}
	</script>
</body>
</html>