<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypage.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/storage.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/filelist.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/guestbook.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mp-calendar.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/calendar.css" type="text/css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
<style>
    .input-wrapper {
        display: flex;
        align-items: center;
        gap: 8px;
    }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
    <div class="content">
        <div class="left-side">
            <div class="profile">
                <h1>${mypage.userName}</h1>
                <h4>${mypage.statusMessage}</h4>
                <c:if test="${mypage.mypageNo eq loginUser.userNo}">
                    <button id="editProfileBtn" class="btn-primary-custom">프로필 수정</button>
                    <div id="editProfileMod" class="mymodal">
                        <div class="modal-content">
                            <h3>내 정보 변경을 위해 현재 비밀번호를 확인해주세요.</h3>
                            <form:form id="pwConfirm" action="${pageContext.request.contextPath}/mypage/editProfile" method="get">
                                비밀번호 입력 : <input type="password" id="currentPw" name="currentPw"/>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit">확인</button>
                            </form:form>
                        </div>
                    </div>
                </c:if>
            </div>
            <div class="classroom-list">
                <div class="classroom-list-top">
                    <h3>내 클래스룸</h3>
                </div>
                <c:forEach var="classroom" items="${classList}" varStatus="status">
                    <div class="classroom-item">
                        <span class="class-name">${classroom.className}</span>
                        <c:if test="${mypage.mypageNo eq loginUser.userNo}">
                            <div class="classroom-btn-group">
                                <button class="go-to-class-btn" data-class-no="${classroom.classNo }" onclick="location.href = '${pageContext.request.contextPath}/class/${classroom.classNo}'">이동</button>
                                <button class="exit-class-btn openExit" data-index="${status.index}">탈퇴</button>
                            </div>
                        </c:if>
                    </div>  
                    <div class="mymodal exitClass" data-index="${status.index}">
                        <div class="modal-content">
                            <h2>정말로 클래스룸을 탈퇴하시겠습니까?</h2>
                            <p>확인을 위해 "${classroom.className}"을/를 입력하세요.</p>
                            <form:form action="${pageContext.request.contextPath}/mypage/exitClass" method="post">
                                <input type="text" name="classNameEntered"/>
                                <input type="hidden" name="classNo" value="${classroom.classNo}"/>
                                <input type="hidden" name="userNo" value="${loginUser.userNo}"/>
                                <input type="hidden" name="mypageNo" value="${mypage.mypageNo}"/>
                                <button type="submit" class="closeExit" data-index="${status.index}">탈퇴</button>
                            </form:form>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${mypage.mypageNo eq loginUser.userNo}">
                    <div class="classroom-action-buttons">
                        <button id="open-modal-btn">생성</button>
                        <!-- 클래스룸 생성 모달 -->
                        <div class="modal-bg" id="create-modal-bg">
                            <div class="modal-box">
                                <div class="modal-title">클래스룸 생성</div>
                                <form class="modal-form" id="classroom-form">
                                    <label for="classroom-name">클래스룸 이름</label>
                                    <input type="text" id="classroom-name" name="classroomName" maxlength="32" placeholder="예: KH 자바스터디 G반" required>
                                   
                                    <label for="classroom-code">입장 코드</label>
                                    <input type="text" id="classroom-code" name="classroomCode" maxlength="8" placeholder="클래스 입장 코드(8자리)" required>


                                    <div class="modal-btns">
                                        <button type="button" class="modal-btn cancel" id="cancel-modal-btn">취소</button>
                                        <button type="button" class="modal-btn" id="create-btn">생성</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <button id="openJoin">참가</button>
                    </div>
                    <div id="joinClass" class="mymodal">
                        <div class="modal-content">
                            <h4>참가할 클래스룸 코드 입력</h4>
                            <form:form action="${pageContext.request.contextPath}/mypage/joinClass" method="post">
                                <input type="text" name="classCodeEntered"/>
                                <input type="hidden" name="userNo" value="${loginUser.userNo}"/>
                                <input type="hidden" name="mypageNo" value="${mypage.mypageNo}"/>
                                <button type="submit" id="closeJoin">참가</button>
                            </form:form>
                        </div>
                    </div>
                </c:if>
            </div>
            <c:if test="${mypage.mypageNo eq loginUser.userNo}">
                <button id="notiSetting">알림설정</button>
                <div id="notiSettingModal" class="mymodal"></div>
            </c:if>
        </div>
        <div class="main-body">
            <div class="sliders-container">
                <c:if test="${imgNameList.size() <= 3}">
                    <c:if test="${imgNameList.size() > 0}">
                        <div class="slider">
                            <img src="${pageContext.request.contextPath}/resources/uploads/image/${mypage.mypageNo}/${imgNameList[0]}"/>
                        </div>
                    </c:if>
                    <c:if test="${imgNameList.size() > 1}">
                        <div class="slider">
                            <img src="${pageContext.request.contextPath}/resources/uploads/image/${mypage.mypageNo}/${imgNameList[1]}"/>
                        </div>
                    </c:if>
                    <c:if test="${imgNameList.size() > 2}">
                        <div class="slider">
                            <img src="${pageContext.request.contextPath}/resources/uploads/image/${mypage.mypageNo}/${imgNameList[2]}"/>
                        </div>
                    </c:if>
                </c:if>
                <c:if test="${imgNameList.size() > 3}">
                    <div class="slider" data-simple-slider>
                        <c:forEach var="img" items="${imgNameList}" begin="2">
                            <img src="${pageContext.request.contextPath}/resources/uploads/image/${mypage.mypageNo}/${img}"/>
                        </c:forEach>
                    </div>
                    <div class="slider" data-simple-slider>
                        <c:forEach var="img" items="${imgNameList}" begin="1">
                            <img src="${pageContext.request.contextPath}/resources/uploads/image/${mypage.mypageNo}/${img}"/>
                        </c:forEach>
                    </div>
                    <div class="slider" data-simple-slider>
                        <c:forEach var="img" items="${imgNameList}" begin="0">
                            <img src="${pageContext.request.contextPath}/resources/uploads/image/${mypage.mypageNo}/${img}"/>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
            <!-- 탭 버튼 (NEW) -->
            <div class="tab-buttons">
                <button onclick="loadContent('guestbook','','Y')">방명록</button>
                <button onclick="loadContent('calendar')">내 캘린더</button>
                <button onclick="loadContent('storage','','public','load')">내 저장소</button>
                <c:if test="${mypage.mypageNo eq loginUser.userNo}">
                    <button id="slidingImgBtn">배경사진 추가/변경</button>
                </c:if>
            </div>
            <div class="container">
                <!-- 방명록 / 캘린더 / 저장소 -->
            </div>
        </div>
    </div>
</body>
<script>
    const mpNo = '${mypage.mypageNo}';
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/simple-slider/1.0.0/simpleslider.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/mypage.js"></script>
<c:choose>
    <c:when test="${to eq 'event'}">
        <c:choose>
            <c:when test="${from eq 'event'}">
                <script>
                    loadContent('calendar', "", function() {
                        const calendarBtn = document.querySelector(".new-personal-btn");
                        if (calendarBtn) {
                            calendarBtn.click();
                        } else {
                            console.warn("버튼을 찾을 수 없습니다.");
                        }
                    });
                </script>
            </c:when>
            <c:otherwise>
                <script>
                    loadContent('calendar');
                </script>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:when test="${to eq 'storage'}">
        <script>
            loadContent('storage','','public','load');
        </script>
    </c:when>
    <c:otherwise>
        <script>
            loadContent('guestbook','','Y');
        </script>
    </c:otherwise>
</c:choose>
<c:if test="${not empty alertMsg}">
    <script>alert("${alertMsg}");</script>
</c:if>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+" crossorigin="anonymous"></script>
</html>
