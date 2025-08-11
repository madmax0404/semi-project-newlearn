<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="size" value="${listcount-(pi.currentPage-1)*pi.boardLimit}"/>
<c:forEach var="guestbook" items="${gbList}">
    <div class="guestbook-entry">
        <table class="guestbook-table">
            <thead>
                <tr>
                    <th>NO.${size}</th>
                    <c:set var="size" value="${size - 1}"/>
                    <th>${guestbook.userName}</th>
                    <th><fmt:formatDate value="${guestbook.createDate}" pattern="M월 d일 EEEE h : mm a"/></th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="3">${guestbook.content}</td>
                </tr>
            </tbody>
        </table>

        <div class="guestbook-buttons">
            <!-- 답장 쓰기 -->
            <c:if test="${guestbook.userNo ne loginUser.userNo}">
			    <form action="${pageContext.request.contextPath}/mypage/${guestbook.userNo}" method="get">
			        <button type="submit">답장쓰러가기</button>
			    </form>
			</c:if>

            <!-- HIDE 버튼 -->
            <c:if test="${guestbook.mypageNo == loginUser.userNo && visibility == 'Y'}">
                <form:form action="${pageContext.request.contextPath}/mypage/guestbook/hide" method="post">
                    <input type="hidden" name="guestbookNo" value="${guestbook.guestbookNo}">
                    <input type="hidden" name="mypageNo" value="${mypageNo}"/>
                    <button type="submit">HIDE</button>
                </form:form>
            </c:if>

            <!-- DELETE 버튼 -->
            <c:if test="${guestbook.userNo == loginUser.userNo}">
                <form:form action="${pageContext.request.contextPath}/mypage/guestbook/delete" method="post">
                    <input type="hidden" name="guestbookNo" value="${guestbook.guestbookNo}">
                    <input type="hidden" name="mypageNo" value="${mypageNo}"/>
                    <button type="submit">DELETE</button>
                </form:form>
            </c:if>
        </div>
    </div>
</c:forEach>


<c:if test="${not empty gbList}">
	<nav id="pagingArea" aria-label="페이지 네비게이션">
	    <ul class="pagination">
	        <c:if test="${pi.currentPage eq 1}">
	            <li class="page-item disabled">
	                <a class="page-link">Previous</a>
	            </li>
	        </c:if>
	        <c:if test="${pi.currentPage ne 1}">
	            <li class="page-item">
	                <a class="page-link"
	                onclick="loadContent('guestbook', ${pi.currentPage - 1}, '${visibility}')">Previous</a>
	            </li>
	        </c:if>
	        <c:forEach var="i" begin="${pi.startPage}" end="${pi.endPage}">
	            <li class="page-item ${pi.currentPage == i ? 'active' : ''}">
	                <a class="page-link" onclick="loadContent('guestbook', ${i}, '${visibility}')">${i}</a>
	            </li>
	        </c:forEach>
	        <c:if test="${pi.currentPage eq pi.maxPage}">
	            <li class="page-item disabled">
	                <a class="page-link">Next</a>
	            </li>
	        </c:if>
	        <c:if test="${pi.currentPage ne pi.maxPage}">
	            <li class="page-item">
	                <a class="page-link" onclick="loadContent('guestbook', ${pi.currentPage + 1}, '${visibility}')">Next</a>
	            </li>
	        </c:if>
	    </ul>
	</nav>
</c:if>

<button type="button" class="btn btn-primary write-button" data-toggle="modal" data-target="#exampleModal">글쓰기</button>
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog">
   		<div class="modal-content">
   			<div class="modal-header">
       			<h5 class="modal-title" id="exampleModalLabel">새 방명록 글쓰기</h5>
       			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
       				<span aria-hidden="true">&times;</span>
       			</button>
   			</div>
   			<form:form method="post" action="${pageContext.request.contextPath}/mypage/guestbook/new">
     			<div class="modal-body">
     				<input type="hidden" name="mypageNo" value="${mypageNo}">
     				<input type="hidden" name="userNo" value="${loginUser.userNo}">
     				<input type="hidden" name="userName" value="${loginUser.userName}">
		    		내용 입력 : <textarea name="content" required="required"></textarea>
     			</div>
     			<div class="modal-footer">
         			<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
         			<button type="submit" class="btn btn-primary">확인</button>
     			</div>
   			</form:form>
   		</div>
	</div>
</div>
<c:if test="${mypageNo eq loginUser.userNo}">
	<c:choose>
		<c:when test="${visibility eq 'Y'}">
			<button type="button" class="btn btn-primary" onclick="loadContent('guestbook','','N')">비공개 게시글</button>
		</c:when>
		<c:otherwise>
			<button type="button" class="btn btn-primary" onclick="loadContent('guestbook','','Y')">공개 게시글</button>
		</c:otherwise>
	</c:choose>
</c:if>