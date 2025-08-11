<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="card">
	<div class="card-body">
		<div class="app-brand justify-content-center">
			<span class="app-brand-text demo text-body fw-bolder">new
				Learn();</span>
		</div>
		<h4 class="mb-2 text-center">본인 확인</h4>
		<p class="mb-4 text-center">회원가입 시 입력한 정보를 입력해주세요</p>

		<form id="verificationForm" action="${param.actionUrl}" method="post">
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}">

			<div class="mb-3">
				<label for="user-name" class="form-label">이름</label> <input
					type="text" class="form-control" id="user-name" name="userName">
			</div>

			<div class="mb-3">
				<label class="form-label">주민등록번호</label>
				<div class="d-flex align-items-center">
					<input type="text" id="ssn1" name="ssn1" class="form-control"
						maxlength="6"> <span class="mx-2">-</span> <input
						type="password" id="ssn2" name="ssn2" class="form-control"
						maxlength="1"> <span class="mx-2">●●●●●●</span>
				</div>
			</div>

			<div class="mb-3">
				<label for="emailId" class="form-label">이메일 주소</label>
				<div class="input-group">
					<input type="text" class="form-control" id="emailId"
						name="userEmailId"> <span class="input-group-text">@</span>
					<input type="text" class="form-control" id="emailDomain"
						name="userEmailDomain">
					<button type="button" id="email-cert-btn"
						class="btn btn-outline-primary">인증코드 발송</button>
				</div>
			</div>

			<div class="mb-3">
				<label for="emailCert" class="form-label">인증코드</label>
				<div class="input-group">
					<input type="text" class="form-control" id="emailCert"
						name="emailCert">
					<button type="button" id="email-cert-check-btn"
						class="btn btn-outline-primary">확인</button>
				</div>
				<small id="email-cert-feedback" class="form-text"
					style="height: 1em; display: block;"></small>
			</div>

			<div class="mt-4">
				<button type="submit" id="next-btn"
					class="btn btn-primary d-grid w-100" disabled>다음</button>
			</div>
		</form>
	</div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
	$(document)
			.ready(
					function() {
						let serverCertCode = "";
						let isEmailCertified = false;
						const $nextBtn = $('#next-btn');
						const $emailCertFeedback = $('#email-cert-feedback');

						$('#email-cert-btn')
								.on(
										'click',
										function() {
											const userName = $('#user-name')
													.val();
											const ssn1 = $('#ssn1').val();
											const ssn2 = $('#ssn2').val();
											const emailId = $('#emailId').val();
											const emailDomain = $(
													'#emailDomain').val();

											if (!userName || !ssn1 || !ssn2
													|| !emailId || !emailDomain) {
												alert('이름, 주민등록번호, 이메일을 모두 입력해주세요.');
												return;
											}

											const userSsn = ssn1 + '-' + ssn2;
											const userEmail = emailId + '@'
													+ emailDomain;

											$emailCertFeedback.text(
													'인증코드를 발송중입니다...').css(
													'color', 'gray');
											$(this).prop('disabled', true);

											$
													.ajax({
														url : '${pageContext.request.contextPath}/member/checkUserAndSendEmail',
														type : 'POST',
														data : {
															userName : userName,
															ssn : userSsn,
															email : userEmail,
															"${_csrf.parameterName}" : "${_csrf.token}" // CSRF 토큰 추가
														},
														success : function(
																response) {
															if (response.success) {
																$emailCertFeedback
																		.text(
																				'인증코드가 발송되었습니다. 이메일을 확인해주세요.')
																		.css(
																				'color',
																				'green');
																serverCertCode = response.certCode;
															} else {
																$emailCertFeedback
																		.text(
																				'입력하신 정보와 일치하는 회원이 없습니다.')
																		.css(
																				'color',
																				'red');
															}
														},
														error : function() {
															$emailCertFeedback
																	.text(
																			'인증코드 발송에 실패했습니다. 다시 시도해주세요.')
																	.css(
																			'color',
																			'red');
														},
														complete : function() {
															$('#email-cert-btn')
																	.prop(
																			'disabled',
																			false);
														}
													});
										});

						$('#email-cert-check-btn')
								.on(
										'click',
										function() {
											const userCertCode = $('#emailCert')
													.val().trim();
											isEmailCertified = (serverCertCode !== "" && userCertCode === serverCertCode);

											if (isEmailCertified) {
												$emailCertFeedback.text(
														'인증되었습니다.').css(
														'color', 'green');
												$nextBtn
														.prop('disabled', false);
											} else {
												$emailCertFeedback.text(
														'인증코드가 일치하지 않습니다.')
														.css('color', 'red');
												isEmailCertified = false;
												$nextBtn.prop('disabled', true);
											}
										});

						$('#verificationForm').on('submit', function(e) {
							if (!isEmailCertified) {
								alert('이메일 인증을 먼저 완료해주세요.');
								e.preventDefault();
							}
						});
					});
</script>
