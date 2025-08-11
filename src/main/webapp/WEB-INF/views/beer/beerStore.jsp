<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="description" content="맥주창고 메뉴" />
    <meta name="author" content="한종윤" />
    <title>맥주창고</title>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
    <link rel="icon" href="https://cdn-icons-png.flaticon.com/16/1998/1998614.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/beer/beer.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div class="content">
        <img src="${pageContext.request.contextPath}/resources/assets/img/beer/beer.jpg" alt="맥창메뉴" id="beer-menu">
    </div>
</body>
<script>
    
</script>
</html>