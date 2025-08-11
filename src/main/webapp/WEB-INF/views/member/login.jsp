<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/vendor/css/core.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/vendor/css/theme-default.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/demo.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/vendor/css/pages/page-auth.css" />
</head>
<body>

<div class="container-xxl">
  <div class="authentication-wrapper authentication-basic container-p-y">
    <div class="authentication-inner">
      <div class="card">
        <div class="card-body">
            <div class="app-brand justify-content-center">
                <span class="app-brand-text demo text-body fw-bolder">new Learn();</span>
            </div>
            <form id="loginForm" class="mb-3" action="${pageContext.request.contextPath}/member/login" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="mb-3">
                    <label for="userId" class="form-label">ID</label>
                    <input type="text" class="form-control" id="userId" name="userId" placeholder="Enter your ID">
                </div>
                
                <div class="mb-3 form-password-toggle">
                    <label class="form-label" for="userPwd">Password</label>
                    <div class="input-group input-group-merge">
                        <input type="password" id="userPwd" class="form-control" name="userPwd" placeholder="············">
                    </div>
                </div>
                
                <div class="mb-3">
                	<div class="form-check">
                		<input class="form-check-input" type="checkbox" id="remember-me" name="remember-me">
                        <label class="form-check-label" for="remember-me"> 로그인 상태 유지 </label>
                	</div>
                </div>

                <div class="mb-3">
                    <button class="btn btn-primary d-grid w-100" type="submit">LOGIN</button>
                </div>
            </form>

            <p class="text-center">
                <a href="${pageContext.request.contextPath}/member/findId">아이디 찾기</a> |
                <a href="${pageContext.request.contextPath}/member/findPassword">비밀번호 찾기</a> |
                <a href="${pageContext.request.contextPath}/member/agree">회원가입</a>
            </p>
        </div>
      </div>
    </div>
  </div>
</div>
	<script src="${pageContext.request.contextPath}/resources/assets/vendor/libs/jquery/jquery.js"></script>
    <script src="${pageContext.request.contextPath}/resources/assets/vendor/libs/popper/popper.js"></script>
    <script src="${pageContext.request.contextPath}/resources/assets/vendor/js/bootstrap.js"></script>

	<script src="${pageContext.request.contextPath}/resources/assets/vendor/js/helpers.js"></script>
    <script src="${pageContext.request.contextPath}/resources/assets/js/config.js"></script>
    <script src="${pageContext.request.contextPath}/resources/assets/js/main.js"></script>

	<!-- 모달 창 -->
	<div id="validationModal" class="modal-overlay">
		<div class="modal">
			<button class="close-btn" onclick="closeModal()">&times;</button>
			<div class="modal-message" id="modalMessage"></div>
			<button class="confirm-btn" onclick="closeModal()">확인</button>
		</div>
	</div>

	<script>
		document.addEventListener('DOMContentLoaded', function() {

			// Spring Security가 로그인 실패 시 URL에 붙여주는 'error' 파라미터를 확인
			const urlParams = new URLSearchParams(window.location.search);
			if (urlParams.has('error')) {
				showModal('아이디 또는 비밀번호가 올바르지 않습니다.');
			}

			const loginForm = document.getElementById('loginForm');
			loginForm.addEventListener('submit', function(e) {
				const userId = document.getElementById('userId').value.trim();
				const userPw = document.getElementById('userPwd').value.trim();

				// 화면단에서 빈 칸이 있는지 먼저 확인
				if (!userId || !userPw) {
					e.preventDefault(); // 폼 제출을 막음
					showModal('아이디 또는 비밀번호를 확인해주세요.');
				}
			});
		});

		// 모달 관련 함수
		function showModal(message) {
			document.getElementById('modalMessage').textContent = message;
			document.getElementById('validationModal').style.display = 'flex';
		}

		function closeModal() {
			document.getElementById('validationModal').style.display = 'none';
		}

		document.getElementById('validationModal').addEventListener('click',
				function(e) {
					if (e.target === this) {
						closeModal();
					}
				});

		document.addEventListener('keydown', function(e) {
			if (e.key === 'Escape') {
				closeModal();
			}
		});
	</script>
</body>
</html>