<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<div id="friend-profile-modal">
	<div class="profile-picture">사진</div>
	<div class="profile-name">이름</div>
	<div class="profile-ps">상태메세지</div>
	<div class="profile-option">
		<div class="option1">
			<button class="button1">함께하는 클래스 2개</button>
		</div>
		<div class="option2">
			<button class="button2">1:1 채팅</button>
		</div>
	</div>
	<div class="back">
		<button class="button3">닫기</button>
	</div>
</div>

<div id="together-class">
	<ul>
		<li>               
			<div>백엔드클래스</div>                
			<div class="line"></div>            
		</li>
		<li>               
			<div>프론트엔드클래스</div>                
			<div class="line"></div>            
		</li>
	</ul>
</div>
