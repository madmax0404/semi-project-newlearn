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
<title>회원가입 - 정보입력</title>
<%-- CSS 파일 경로 --%>
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
	margin: 0 auto 30px auto
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

.error {
	color: #ff3e1d;
	font-size: 0.875em;
	margin-top: 0.25rem;
}

.form-text {
	font-size: 0.875em;
	margin-top: 0.25rem;
	display: block;
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
					<div class="step-line"></div>
					<div class="step">
						<div class="step-circle">3</div>
						<div class="step-label">가입완료</div>
					</div>
				</div>

				<div class="card">
					<div class="card-body">
						<div class="app-brand justify-content-center">
							<span class="app-brand-text demo text-body fw-bolder">new
								Learn();</span>
						</div>
						<h4 class="mb-2 text-center">회원 정보 입력</h4>

						<form:form modelAttribute="member" id="enrollForm"
							action="${pageContext.request.contextPath}/security/insert"
							method="post">

							<div class="mb-3">
								<label for="user-id" class="form-label">아이디</label>
								<div class="input-group">
									<form:input path="userId" type="text" id="user-id"
										class="form-control" placeholder="아이디 7~15자" />
									<button type="button" id="idCheckBtn"
										class="btn btn-outline-primary">중복 확인</button>
								</div>
								<small id="id-feedback" class="form-text"></small>
								<form:errors path="userId" cssClass="error" />
							</div>

							<div class="mb-3 form-password-toggle">
								<label class="form-label" for="user-pw">비밀번호</label>
								<div class="input-group input-group-merge">
									<form:password path="userPwd" id="user-pw" class="form-control"
										placeholder="영문, 숫자, 특수문자 포함 7~20자" />
								</div>
								<small id="pw-feedback" class="form-text"></small>
								<form:errors path="userPwd" cssClass="error" />
							</div>

							<div class="mb-3 form-password-toggle">
								<label class="form-label" for="user-pw-confirm">비밀번호 확인</label>
								<div class="input-group input-group-merge">
									<input type="password" id="user-pw-confirm"
										class="form-control" name="userPwConfirm"
										placeholder="············">
								</div>
								<small id="pw-confirm-feedback" class="form-text"></small>
							</div>

							<div class="mb-3">
								<label for="user-name" class="form-label">이름</label>
								<form:input path="userName" type="text" id="user-name"
									class="form-control" />
								<small id="name-feedback" class="form-text"></small>
								<form:errors path="userName" cssClass="error" />
							</div>

							<div class="mb-3">
								<label class="form-label">주민등록번호</label>
								<div class="d-flex align-items-center">
									<input type="text" id="ssn1" name="ssn1" class="form-control"
										maxlength="6"> <span class="mx-2">-</span> <input
										type="password" id="ssn2" name="ssn2" class="form-control"
										maxlength="1"> <span class="mx-2">●●●●●●</span>
								</div>
								<small id="ssn-feedback" class="form-text"></small>
							</div>

							<div class="mb-3">
								<label for="phone" class="form-label">전화번호</label>
								<form:input path="phone" type="text" id="phone"
									class="form-control" placeholder="'-'제외 11자리 입력" />
								<small id="phone-feedback" class="form-text"></small>
								<form:errors path="phone" cssClass="error" />
							</div>

							<div class="mb-3">
								<label class="form-label">이메일 주소</label>
								<div class="input-group">
									<input type="text" id="emailId" name="emailId"
										class="form-control"> <span class="input-group-text">@</span>
									<input type="text" id="emailDomain" name="emailDomain"
										class="form-control">
									<button type="button" id="emailCertBtn"
										class="btn btn-outline-primary">인증코드 발송</button>
								</div>
							</div>

							<div class="mb-3">
								<label class="form-label">인증코드</label>
								<div class="input-group">
									<input type="text" id="emailCertInput" name="emailCert"
										class="form-control">
									<button type="button" id="emailCertCheckBtn"
										class="btn btn-outline-primary">확인</button>
								</div>
								<small id="email-cert-feedback" class="form-text"></small>
							</div>

							<div class="mt-4">
								<button type="submit"
									class="btn btn-primary d-grid w-100 btn-next" disabled>다음</button>
							</div>
						</form:form>
					</div>
				</div>
			</div>
		</div>
	</div>



	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script>
		$(document)
				.ready(
						function() {
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
							let isIdChecked = false;
							let isPwValid = false;
							let isPwConfirmValid = false;
							let isNameValid = false;
							let isSsnValid = false;
							let isPhoneValid = false;
							let isEmailCertValid = false;
							const $nextBtn = $('.btn-next');

							function checkAllValidation() {
								if (isIdChecked && isPwValid
										&& isPwConfirmValid && isNameValid
										&& isSsnValid && isPhoneValid
										&& isEmailCertValid) {
									$nextBtn.prop('disabled', false);
								} else {
									$nextBtn.prop('disabled', true);
								}
							}

							const $userId = $('#user-id');
							const $idFeedback = $('#id-feedback');
							const $idCheckBtn = $('#idCheckBtn');
							const $userPw = $('#user-pw');
							const $pwFeedback = $('#pw-feedback');
							const $userPwConfirm = $('#user-pw-confirm');
							const $pwConfirmFeedback = $('#pw-confirm-feedback');
							const $userName = $('#user-name');
							const $nameFeedback = $('#name-feedback');
							const $phone = $('#phone');
							const $phoneFeedback = $('#phone-feedback');
							const $ssn1 = $('#ssn1');
							const $ssn2 = $('#ssn2');
							const $ssnFeedback = $('#ssn-feedback');
							const $emailId = $('#emailId');
							const $emailDomain = $('#emailDomain');
							const $emailCertBtn = $('#emailCertBtn');
							const $emailCertInput = $('#emailCertInput');
							const $emailCertCheckBtn = $('#emailCertCheckBtn');
							const $emailCertFeedback = $('#email-cert-feedback');
							let serverCertCode = "";

							$userId.on('keyup', function() {
								isIdChecked = false;
								$idFeedback.text('');
								checkAllValidation();
							});

							$idCheckBtn
									.on(
											'click',
											function() {
												const userIdVal = $userId.val();
												const idRegex = /^[a-zA-Z0-9]{7,15}$/;
												if (!idRegex.test(userIdVal)) {
													alert('아이디는 영문, 숫자로만 7~15자 사이로 입력해주세요.');
													isIdChecked = false;
													checkAllValidation();
													return;
												}
												$
														.ajax({
															url : '${pageContext.request.contextPath}/member/idCheck',
															type : 'GET',
															data : {
																checkId : userIdVal
															},
															success : function(
																	result) {
																if (result == "0") {
																	$idFeedback
																			.text(
																					'사용 가능한 아이디입니다.')
																			.css(
																					'color',
																					'green');
																	isIdChecked = true;
																} else {
																	$idFeedback
																			.text(
																					'이미 사용 중인 아이디입니다.')
																			.css(
																					'color',
																					'red');
																	isIdChecked = false;
																}
																checkAllValidation();
															}
														});
											});

							$userPw
									.on(
											'keyup',
											function() {
												const userPwVal = $userPw.val();
												const pwRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&\^])[A-Za-z\d$@$!%*#?&\^]{7,20}$/;
												if (pwRegex.test(userPwVal)) {
													$pwFeedback.text(
															'사용 가능한 비밀번호입니다.')
															.css('color',
																	'green');
													isPwValid = true;
												} else {
													$pwFeedback
															.text(
																	'비밀번호는 영문, 숫자, 특수문자를 포함하여 7~20자여야 합니다.')
															.css('color', 'red');
													isPwValid = false;
												}
												$userPwConfirm.trigger('keyup');
												checkAllValidation();
											});

							$userPwConfirm
									.on(
											'keyup',
											function() {
												if ($userPwConfirm.val().length > 0) {
													if ($userPw.val() === $userPwConfirm
															.val()) {
														$pwConfirmFeedback
																.text(
																		'비밀번호가 일치합니다.')
																.css('color',
																		'green');
														isPwConfirmValid = true;
													} else {
														$pwConfirmFeedback
																.text(
																		'비밀번호가 일치하지 않습니다.')
																.css('color',
																		'red');
														isPwConfirmValid = false;
													}
												} else {
													$pwConfirmFeedback.text('');
													isPwConfirmValid = false;
												}
												checkAllValidation();
											});

							$userName.on('keyup', function() {
								isNameValid = $(this).val().trim() !== "";
								if (isNameValid) {
									$nameFeedback.text('').css('color', '');
								} else {
									$nameFeedback.text('이름을 입력해주세요.').css(
											'color', 'red');
								}
								checkAllValidation();
							});
							function validateSsn() {
								isSsnValid = $ssn1.val().trim().length === 6
										&& $ssn2.val().trim().length === 1;
								if ($ssn1.val().trim().length > 0
										|| $ssn2.val().trim().length > 0) {
									if (isSsnValid) {
										$ssnFeedback.text('올바른 형식입니다.').css(
												'color', 'green');
									} else {
										$ssnFeedback.text('주민등록번호 형식을 확인해주세요.')
												.css('color', 'red');
									}
								} else {
									$ssnFeedback.text('');
								}
								checkAllValidation();
							}
							$ssn1.on('keyup', validateSsn);
							$ssn2.on('keyup', validateSsn);

							$phone
									.on(
											'keyup',
											function() {
												const phoneVal = $(this).val()
														.trim();
												isPhoneValid = phoneVal.length === 11
														&& /^[0-9]+$/
																.test(phoneVal);
												if (phoneVal.length > 0) {
													if (isPhoneValid) {
														$phoneFeedback
																.text(
																		'올바른 형식입니다.')
																.css('color',
																		'green');
													} else {
														$phoneFeedback
																.text(
																		"전화번호는 '-'를 제외한 11자리 숫자여야 합니다.")
																.css('color',
																		'red');
													}
												} else {
													$phoneFeedback.text('');
												}
												checkAllValidation();
											});

							$emailCertBtn
									.on(
											'click',
											function() {
												const email = $emailId.val()
														+ '@'
														+ $emailDomain.val();
												if (!$emailId.val()
														|| !$emailDomain.val()) {
													alert('이메일을 모두 입력해주세요.');
													return;
												}
												const $feedback = $('#email-cert-feedback');
												$feedback.text(
														'인증코드를 발송중입니다...').css(
														'color', 'gray');
												$(this).prop('disabled', true);
												$
														.ajax({
															url : '${pageContext.request.contextPath}/member/emailCert',
															type : 'POST',
															data : {
																email : email
															},
															success : function(
																	certCode) {
																$feedback
																		.text('입력하신 이메일로 인증코드가 발송되었습니다.');
																$feedback
																		.css(
																				'color',
																				'green');
																serverCertCode = certCode;
															},
															error : function() {
																$feedback
																		.text('인증코드 발송에 실패했습니다. 다시 시도해주세요.');
																$feedback
																		.css(
																				'color',
																				'red');
															},
															complete : function() {
																$emailCertBtn
																		.prop(
																				'disabled',
																				false);
															}
														});
											});

							$emailCertInput.on('keyup', function() {
								isEmailCertValid = false;
								checkAllValidation();
							});
							$emailCertCheckBtn.on('click', function() {
								const userCertCode = $emailCertInput.val();
								if (serverCertCode !== ""
										&& userCertCode === serverCertCode) {
									$emailCertFeedback.text('인증되었습니다.').css(
											'color', 'green');
									isEmailCertValid = true;
								} else {
									$emailCertFeedback.text('인증코드가 일치하지 않습니다.')
											.css('color', 'red');
									isEmailCertValid = false;
								}
								checkAllValidation();
							});
						});
	</script>

</body>
</html>
