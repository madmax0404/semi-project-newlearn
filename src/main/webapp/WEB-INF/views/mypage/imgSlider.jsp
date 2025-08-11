<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<form:form modelAttribute="slidingImg" id="slidingImgForm"
action="${pageContext.request.contextPath}/mypage/imgSlider" 
method="post" enctype="multipart/form-data">
	<c:forEach var="img" items="${slidingImg.slidingImgList}" varStatus="status">
		<tr>
	        <th><label for="image${status.index + 1}">기존 이미지${status.index + 1}</label></th>
	        <td><div class="input-wrapper">
		        <img src="${pageContext.request.contextPath}/resources/uploads/image/${mypageNo}/${img.changeName}"
		        class="preview" style="width:100px; height:100px;" id="imgPrev${status.index + 1}" style="display: none;"/>
		        <button type="button" class="changeImgBtn" data-img-id="${status.index + 1}" data-img-no="${img.imgNo}">사진 변경</button>
		        <button type="button" class="deleteImgBtn" data-img-id="${status.index + 1}" data-img-no="${img.imgNo}">사진 삭제</button>
		        <input type="file" name="upfile" class="form-control inputImage" accept="images/*" id="img${status.index + 1}"
		        style="display: none;">
	        </div></td>
	    </tr>
	</c:forEach>
	<c:set var="buttonClickCnt" value="1"/>
	<button type="button" id="newImgUpload" data-click-cnt="${buttonClickCnt}" 
	data-img-size="${slidingImg.slidingImgList.size()}">+</button>
	<div id="newUploads"></div>
	<input type="hidden" name="mypageNo" value="${mypageNo}"/>
	<button type="submit" id="confirmBtn">확인</button>
</form:form>