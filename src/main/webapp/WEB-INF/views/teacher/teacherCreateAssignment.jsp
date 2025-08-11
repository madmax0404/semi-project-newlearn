<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="description" content="선생님 전용 페이지" />
	<meta name="author" content="한종윤" />
	<title>과제 생성</title>
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<link rel="icon" href="https://cdn-icons-png.flaticon.com/16/1998/1998614.png">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/teacher/teacher_common.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/teacher/teacher_create_assignment.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div class="container">
    	<form:form modelAttribute="teacherAssignment" id="assignment-create-form" class="card shadow" method="post" action="${pageContext.request.contextPath}/teacher/${classNo }/assignment/insert"
    	enctype="multipart/form-data">
	        <div class="fieldset card shadow bg-transparent border text-primary">
	            <legend>제목</legend>
                <form:input path="assignmentTitle" id="title" required="required" class="form-control" />
	        </div>
            <div class="fieldset card shadow bg-transparent border text-primary">
                <legend>내용</legend>
                <form:textarea path="assignmentDetails" id="content" required="required" class="form-control"/>
            </div>
            <div class="fieldset card shadow bg-transparent border text-primary" id="submit-date-fieldset">
                <legend>제출 기한</legend>
                <div>
                    시작일: <input type="datetime-local" name="startDate" id="start-datetime" class="form-control" required="required">
                </div>
                <div>
                    종료일: <input type="datetime-local" name="endDate" id="end-datetime" class="form-control" required="required">
                </div>
            </div>
            <div class="fieldset card shadow bg-transparent border text-primary">
                <legend>첨부파일</legend>
                <input type="file" name="upfile" id="upfile" class="form-control">
                <p style="color:red">주의사항: 여러 파일을 올릴 때는 압축해서 파일 하나로 올려주세요.</p>
            </div>
            <button type="submit" id="submit-button" class="btn btn-outline-primary">과제 생성</button>
    	</form:form>
    </div>
</body>
</html>