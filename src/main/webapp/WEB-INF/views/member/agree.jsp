<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원가입 - 약관동의</title>
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

.terms-box {
	height: 130px;
	overflow-y: auto;
	border: 1px solid #d9dee3;
	border-radius: .375rem;
	padding: 1rem;
	background-color: #f5f5f9;
	font-size: .8rem;
	line-height: 1.6
}

.terms-box .terms-title {
	font-weight: bold;
	margin-bottom: 10px
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
					<div class="step-line"></div>
					<div class="step">
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
						<p class="mb-4 text-center">서비스 이용을 위해 약관에 동의해주세요</p>

						<form id="agreeForm"
							action="${pageContext.request.contextPath}/security/insert"
							method="get">

							<div class="mb-3">
								<div class="terms-box">
									<p class="terms-title">(필수) 이용약관</p>
									<p>여러분을 환영합니다. new Learn(이하 '뉴런'이라 함) 이용에 앞서서 감사드립니다. 본 약관은
										뉴런의 다양한 서비스를 이용하는 여러분과 뉴런이 서비스를 이용함에 있어 필요한 권리, 의무 및 책임사항,
										이용조건 및 절차 등 기본적인 사항을 규정하고 있으므로, 조금만 시간을 내서 주의 깊게 읽어주시기 바랍니다...</p>
								</div>
								<div class="form-check mt-2">
									<input class="form-check-input required-agree" type="checkbox"
										name="terms" id="terms-1"> <label
										class="form-check-label" for="terms-1">이용약관에 동의합니다.</label>
								</div>
							</div>

							<div class="mb-3">
								<div class="terms-box">
									<p class="terms-title">(필수) 개인정보 수집 및 이용</p>
									<p>개인정보처리방침은 다음과 같은 중요한 의미를 가지고 있습니다. 뉴런이 어떤 정보를 수집하고, 수집한
										정보를 어떻게 사용하며, 필요에 따라 누구와 이를 공유('위탁 또는 제공')하며, 이용이 끝난 정보를 언제,
										어떻게 파기하는지 등 '개인정보' 전반에 걸친 사항을 투명하게 알려드립니다...</p>
								</div>
								<div class="form-check mt-2">
									<input class="form-check-input required-agree" type="checkbox"
										name="terms" id="terms-2"> <label
										class="form-check-label" for="terms-2">개인정보 수집 및 이용에
										동의합니다.</label>
								</div>
							</div>

							<div class="mb-3">
								<div class="terms-box">
									<p class="terms-title">(선택) 마케팅 정보 수신</p>
									<p>뉴런은 여러분의 사전 동의를 받은 경우에 한하여, 여러분이 서비스 이용 과정에서 제공한 개인정보를
										활용하여 마케팅 및 프로모션 목적으로 문자, 이메일, 푸시 알림 등을 통해 다양한 정보를 제공할 수 있습니다.
										본 동의는 선택 사항이며, 동의하지 않으셔도 서비스의 기본 기능 이용에는 아무런 제약이 없습니다.</p>
								</div>
								<div class="form-check mt-2">
									<input class="form-check-input optional-agree" type="checkbox"
										name="terms" id="terms-3"> <label
										class="form-check-label" for="terms-3">마케팅 정보 수신에
										동의합니다.</label>
								</div>
							</div>

							<hr class="my-4">

							<div
								class="mb-3 d-flex justify-content-between align-items-center">
								<div class="form-check">
									<input class="form-check-input" type="checkbox" id="agreeAll">
									<label class="form-check-label" for="agreeAll"> 모든 약관에
										동의합니다. </label>
								</div>
								<button type="submit" class="btn btn-primary" id="nextBtn"
									disabled>다음</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
document.addEventListener('DOMContentLoaded', function(){
    const agreeAll = document.getElementById('agreeAll');
    const requiredCheckboxes = document.querySelectorAll('.required-agree');
    const allCheckboxes = document.querySelectorAll('input[name="terms"]');
    const nextBtn = document.getElementById('nextBtn');

    function updateNextButton() {
        const allRequiredChecked = Array.from(requiredCheckboxes).every(checkbox => checkbox.checked);
        nextBtn.disabled = !allRequiredChecked;
    }

    agreeAll.addEventListener('change', function(){
        allCheckboxes.forEach(checkbox => {
            checkbox.checked = this.checked;
        });
        updateNextButton();
    });

    allCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function(){
            const allChecked = Array.from(allCheckboxes).every(cb => cb.checked);
            agreeAll.checked = allChecked;
            updateNextButton();
        });
    });
    updateNextButton();
});

</script>

</body>
</html>