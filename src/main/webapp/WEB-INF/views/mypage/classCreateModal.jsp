<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>클래스룸 생성 모달 예시</title>
    <style>
        /* 모달 배경 */
        .modal-bg {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0, 0, 0, 0.4);
            justify-content: center;
            align-items: center;
        }

        .modal-bg.active {
            display: flex;
        }

        /* 모달 박스 */
        .modal-box {
            background: #fff;
            padding: 32px 24px 24px 24px;
            border-radius: 18px;
            box-shadow: 0 6px 32px rgba(0, 0, 0, 0.16);
            min-width: 340px;
            max-width: 90vw;
            animation: modalShow 0.24s cubic-bezier(0.55, 0.11, 0.4, 0.94);
        }

        @keyframes modalShow {
            0% {
                opacity: 0;
                transform: scale(0.97);
            }

            100% {
                opacity: 1;
                transform: scale(1);
            }
        }

        .modal-title {
            font-size: 1.4em;
            font-weight: 700;
            margin-bottom: 18px;
            color: #2062bf;
            letter-spacing: 0.5px;
        }

        .modal-form label {
            display: block;
            margin: 14px 0 3px 2px;
            font-size: 1em;
            font-weight: 600;
        }

        .modal-form input {
            width: 100%;
            padding: 8px 10px;
            font-size: 1.08em;
            border-radius: 8px;
            border: 1.5px solid #dde3ef;
            margin-bottom: 6px;
            transition: border 0.2s;
        }

        .modal-form input:focus {
            border-color: #2062bf;
            outline: none;
        }

        .modal-btns {
            text-align: right;
            margin-top: 20px;
        }

        .modal-btn {
            padding: 8px 20px;
            border: none;
            border-radius: 7px;
            font-size: 1em;
            font-weight: 600;
            margin-left: 8px;
            background: #2062bf;
            color: #fff;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.10);
            transition: background 0.18s;
        }

        .modal-btn.cancel {
            background: #bdbdbd;
        }

        .modal-btn:active {
            background: #104075;
        }
    </style>
</head>

<body style="background: #f8fafd;">
	<c:if test="${mypage.mypageNo eq loginUser.userNo}">
    <button id="open-modal-btn"
        style="padding:14px 32px;border-radius:13px;background:#2062bf;color:#fff;font-weight:700;font-size:1.1em;box-shadow:0 4px 18px rgba(32,98,191,0.10);border:none;cursor:pointer;">생성</button>
	</c:if>

    <!-- 모달 구조 -->
    <div class="modal-bg" id="create-modal-bg">
        <div class="modal-box">
            <div class="modal-title">클래스룸 생성</div>
            <form class="modal-form" id="classroom-form">
                <label for="classroom-name">클래스룸 이름</label>
                <input type="text" id="classroom-name" name="classroomName" maxlength="32"
                    placeholder="예: KH 자바스터디 G반" required>

                <label for="classroom-code">입장 코드</label>
                <input type="text" id="classroom-code" name="classroomCode" maxlength="8"
                    placeholder="클래스 입장 코드(8자리)" required>

                <div class="modal-btns">
                    <button type="button" class="modal-btn cancel" id="cancel-modal-btn">취소</button>
                    <button type="button" class="modal-btn" id="create-btn">생성</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // 모달 열기
        $("#open-modal-btn").on("click", function () {
            $("#create-modal-bg").addClass("active");
            $("#classroom-name").focus();
        });

        // 모달 닫기
        $("#cancel-modal-btn, .modal-bg").on("click", function (e) {
            // 배경 클릭 시만 닫히도록
            if (e.target === this)
                $("#create-modal-bg").removeClass("active");
        });

        // 폼 제출 처리
        $("#create-btn").on("click", function (e) {
            e.preventDefault();
            const className = $("#classroom-name").val().trim();
            const classCode = $("#classroom-code").val().trim();
            let url = window.location.pathname; // "/new-learn/mypage/113"
            let userNo = url.split('/').filter(Boolean).pop(); // "113"
            console.log(userNo); // 결과: "113"
            console.log(className);
            console.log(classCode);

            if (!className || !classCode) {
                alert("모든 값을 입력하세요!");
                return;
            }
            // 여기서 AJAX 등 서버에 전송 가능
            alert("클래스룸 이름: " + className + "\n입장 코드: " + classCode);

            $("#create-modal-bg").removeClass("active");
            // $(this)[0].reset();

            $.ajax({
                url: "${pageContext.request.contextPath}/mypage/createClass",
                type: "POST",
                data: {
                    className,
                    classCode,
                    userNo
                },
                // beforeSend: function(xhr) {
                //     xhr.setRequestHeader(window.csrf.header, window.csrf.token);
                // },
                success: function(res) {
                    console.log(res);
                    if (res > 0) {
                        alert("클래스 생성 성공.");
                    } else {
                        alert("클래스 생성 실패.");
                    }
                },
                error: function(error) {
                    console.log(error);
                    alert("클래스 생성 실패.");
                }
            });
        });
    </script>
</body>

</html>