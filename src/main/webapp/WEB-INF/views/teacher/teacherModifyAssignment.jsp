<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="description" content="선생님 전용 페이지" />
	<meta name="author" content="한종윤" />
	<title>과제 수정</title>
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<link rel="icon" href="https://cdn-icons-png.flaticon.com/16/1998/1998614.png">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/teacher/teacher_common.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/teacher/teacher_create_assignment.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div class="container">
    	<form:form modelAttribute="teacherAssignment" class="card shadow" id="assignment-create-form" method="post" action="${pageContext.request.contextPath}/teacher/${classNo }/assignment/update"
    	enctype="multipart/form-data">
	        <div class="fieldset card shadow bg-transparent border text-primary">
	            <legend>제목</legend>
                <form:input path="assignmentTitle" id="title" class="form-control" required="required" value="${ta.assignmentTitle}" />
	        </div>
            <div class="fieldset card shadow bg-transparent border text-primary">
                <legend>내용</legend>
                <form:textarea path="assignmentDetails" id="content" class="form-control" required="required" />
            </div>
            <div class="fieldset card shadow bg-transparent border text-primary" id="submit-date-fieldset">
                <legend>제출 기한</legend>
                <div>
                    시작일: <input type="datetime-local" name="startDate" id="start-date" class="form-control" value="<fmt:formatDate value='${ta.startDate}' pattern='yyyy-MM-dd\'T\'HH:mm'/>">
                </div>
                <div>
                    종료일: <input type="datetime-local" name="endDate" id="end-date" class="form-control" value="<fmt:formatDate value='${ta.endDate}' pattern='yyyy-MM-dd\'T\'HH:mm'/>">
                </div>
            </div>
            <div class="fieldset card shadow bg-transparent border text-primary">
                <legend>첨부파일</legend>
                <input type="file" name="upfile" id="upfile" class="form-control">
                <br>
                이전 파일명: <span>${originName }</span>
                <p style="color:red">주의사항: 여러 파일을 올릴 때는 압축해서 파일 하나로 올려주세요.</p>
            </div>
			<input type="text" name="className" value="${className}" hidden />
            <input type="text" name="classRole" value="${classRole}" hidden />
            <div class="btn-box">
	            <button type="button" id="submit-button" class="btn btn-outline-primary">과제 수정</button>
	            <button type="button" id="delete-btn" class="btn btn-outline-primary">과제 삭제</button>
            </div>
    	</form:form>
    </div>
</body>
<script>
	const assignmentNo = "${ta.assignmentNo}";
	const ta = JSON.parse('${jsonTa}');
	const className = "${className}";
	const classRole = "${classRole}";
	$("#content").val("${ta.assignmentDetails}");
	const fileNo = "${ta.fileNo}";
	
	$("#submit-button").on("click", function() {
		const formData = new FormData();
		const fileInput = document.getElementById("upfile");
		const file = fileInput.files[0];
		if (file) {
	        formData.append("upfile", file);
	    }
		
		// 폼의 다른 값들도 FormData에 추가
	    formData.append("assignmentNo", ta.assignmentNo);
	    formData.append("classNo", ta.classNo);
	    formData.append("assignmentTitle", $("#title").val());
	    formData.append("assignmentDetails", $("#content").val());
	    formData.append("createDate", ta.createDate);
	    formData.append("startDate", $("#start-date").val());
	    formData.append("endDate", $("#end-date").val());
		formData.append("className", className);
		formData.append("classRole", classRole);
		formData.append("fileNo", fileNo);
		
		$.ajax({
			url: "${pageContext.request.contextPath}/teacher/${classNo }/assignment/update",
			type: "POST",
			data: formData,
			processData: false,
			contentType: false,
			success: function(res) {
				console.log(res);
				if (res > 0) {
					alert("수정 성공.");
					location.href = "${pageContext.request.contextPath}/teacher/assignmentManage/" + classNo;
				} else {
					alert("수정 실패.");
				}
			},
			error: function(error) {
				console.log(error);
				alert("수정 실패.");
			}
		});
	});
	
	$("#delete-btn").on("click", function() {
		let bool = confirm("정말 삭제하시겠습니까?");
		
		if (bool) {
			$.ajax({
				url: "${pageContext.request.contextPath}/teacher/${classNo }/assignment/delete",
				data: {
					assignmentNo,
					className,
					classRole
				},
				success: function(res) {
					console.log(res);
					if (res > 0) {
						alert("삭제에 성공했습니다.");
						location.href = "${pageContext.request.contextPath}/teacher/assignmentManage/" + classNo;
					} else {
						alert("삭제에 실패했습니다.");
					}
				},
				error: function(error) {
					console.log(error);
					alert("삭제에 실패했습니다.");
				}
			});
		}
	});
</script>
</html>




