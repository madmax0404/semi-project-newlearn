<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="description" content="프로파일 수정 페이지" />
    <meta name="author" content="한종윤, 서혜림" />
    <title>프로필 수정 페이지</title>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
    <link rel="icon" href="${pageContext.request.contextPath}/resources/assets/img/favicon/favicon.ico">
    <meta id="_csrf" name="_csrf" content="${_csrf.token}"/>
	<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}"/>

    <!-- Fonts -->
    <!-- <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
      rel="stylesheet"
    /> -->

    <!-- Core CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/css/demo.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/vendor/css/pages/page-auth.css" />

    <!-- Vendors CSS -->
    <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/libs/apex-charts/apex-charts.css" /> -->

    <!-- Helpers -->
    <!-- <script src="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/js/helpers.js"></script> -->

    <!--! Template customizer & Theme config files MUST be included after core stylesheets and helpers.js in the <head> section -->
    <!--? Config:  Mandatory theme config file contain global vars & default theme options, Set your preferred theme option in this file.  -->
    <!-- <script src="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/js/config.js"></script> -->
    <style>
        .email-group {
            display: flex;
            align-items: center;
        }

        .form-group {
            margin: 10px;
        }
    </style>
</head>
<body>
    <script>
        $(function() {
            const email = "${loginUser.email}";
            $("#email-id").val(email.split("@")[0]);
            $("#email-domain").val(email.split("@")[1]);
        });
    </script>
    <div class="container-xxl">
        <div class="authentication-wrapper authentication-basic container-p-y">
            <div class="authentication-inner">
                <div class="card px-sm-6 px-0">
                    <div class="card-body">
                        <form:form modelAttribute="member" action="${pageContext.request.contextPath}/mypage/editProfile" method="post" class="form-control">
                            <div class="form-group">
                                <label for="user-id">아이디</label>
                                <div class="input-with-btn">
                                    <input type="text" id="user-id" name="userId" class="form-control" value="${loginUser.userId}">
                                    <button type="button" id="id-check-btn" class="btn btn-outline-dark" style="margin-top: 10px;">중복 확인</button>
                                </div>
                                <small id="id-feedback" class="form-text"></small>
                            </div>
                            <div class="form-group">
                                <label for="userPw">비밀번호</label>
                                <input type="password" id="user-pw" name="userPwd" placeholder="비밀번호, 문자, 숫자, 특수문자 포함 7~20자" class="form-control">
                                <small id="pw-feedback" class="form-text"></small>
                            </div>
                            <div class="form-group">
                                <label for="user-pw-confirm">비밀번호 확인</label>
                                <input type="password" id="user-pw-confirm" name="user-pw-confirm" class="form-control">
                                <small id="pw-confirm-feedback" class="form-text"></small>
                            </div>
                            <div class="form-group">
                                <label for="user-name">이름</label>
                                <input type="text" id="user-name" name="userName" class="form-control" value="${loginUser.userName}">
                            </div>
                            <div class="form-group">
                                <label for="phone">전화번호</label>
                                <input type="text" id="phone" name="phone" class="form-control" value="${loginUser.phone}">
                            </div>
                            <div class="form-group">
                                <label for="mypage-title">마이페이지 타이틀</label>
                                <input type="text" id="mypage-title" name="mypageName" class="form-control" value="${mypage.mypageName}">
                            </div>
                            <div class="form-group">
                                <label for="status-message">상태 메세지</label>
                                <input type="text" id="status-message" name="statusMessage" class="form-control" value="${mypage.statusMessage}">
                            </div>
                            <div class="form-group">
                                <label>이메일 주소</label>
                                <div class="email-group">
                                    <input type="text" id="email-id" name="email-id" class="form-control">
                                    <span>@</span>
                                    <input type="text" id="email-domain" name="email-domain" class="form-control">
                                    <input type="hidden" id="email" name="email">
                                    <script>
                                        $(function() {
                                            $("#email").val($("#email-id").val() + "@" + $("#email-domain").val());
                                        });
                                    </script>
                                </div>
                                <button type="button" id="email-cert-btn" class="btn btn-outline-dark" style="margin-top: 10px;">인증코드 발송</button>
                            </div>
                            <div class="form-group">
                                <label>인증코드</label>
                                <div class="input-with-btn">
                                    <input type="text" id="email-cert-input" name="email-cert-input" class="form-control">
                                    <button type="button" id="email-cert-check-btn" class="btn btn-outline-dark" style="margin-top: 10px;">인증코드 확인</button>
                                </div>
                                <small id="email-cert-feedback" class="form-text"></small>
                            </div>
                            <div class="form-group">
                                <input type="hidden" name="userNo" value="${loginUser.userNo}"/>
                            </div>
                            <div class="row" style="padding: 20px;">
                                <button type="submit" id="submit-btn" class="btn btn-primary btn-lg"><b>프로필 변경</b></button>
                            </div>
                        </form:form>
                    </div>
                </div>                
            </div>
        </div>
    </div>
</body>
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
                    let isPhoneValid = false;
                    let isEmailCertValid = false;
                    const $submitBtn = $('#submit-btn');
                    $submitBtn.prop('disabled', true);

                    function checkAllValidation() {
                        if (isPwValid
                                && isPwConfirmValid
                                && isEmailCertValid) {
                            $submitBtn.prop('disabled', false);
                        }
                    }

                    const $userId = $('#user-id');
                    const $idFeedback = $('#id-feedback');
                    const $idCheckBtn = $('#id-check-btn');
                    const $userPw = $('#user-pw');
                    const $pwFeedback = $('#pw-feedback');
                    const $userPwConfirm = $('#user-pw-confirm');
                    const $pwConfirmFeedback = $('#pw-confirm-feedback');
                    const $userName = $('#user-name');
                    const $phone = $('#phone');
                    const $emailId = $('#email-id');
                    const $emailDomain = $('#email-domain');
                    const $emailCertBtn = $('#email-cert-btn');
                    const $emailCertInput = $('#email-cert-input');
                    const $emailCertCheckBtn = $('#email-cert-check-btn');
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
                        checkAllValidation();
                    });
                    $phone
                            .on('keyup',
                                    function() {
                                        isPhoneValid = $(this).val()
                                                .trim().length === 11
                                                && /^[0-9]+$/.test($(
                                                        this).val());
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
                                                        console
                                                                .log(
                                                                        "서버로부터 받은 인증코드:",
                                                                        serverCertCode);
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
</html>
