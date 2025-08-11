<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div id="report-room-modal">
	<div class="modal-name">채팅방 신고</div>
	<div class="report-reason">신고 사유</div>
	<div class="reasons">
		<div class="reason1">
			<input type="checkbox" name="reportReason" value="abuse"><span>욕설/공격젹인
				언어 사용</span>
		</div>
		<div class="reason2">
			<input type="checkbox" name="reportReason" value="hate_speech"><span>혐오발언</span>
		</div>
		<div class="reason3">
			<input type="checkbox" name="reportReason" value="obscenity"><span>음란물
				유포</span>
		</div>
		<div class="reason4">
			<input type="checkbox" name="reportReason" value="illegal_info"><span>불법
				정보(도박/사행성)</span>
		</div>
		<div class="reason5">
			<input type="checkbox" name="reportReason" value="etc"><span>기타</span>
		</div>
		<div class="reason-detail">
			<textarea placeholder="신고 사유" name="reportDetail"></textarea>
		</div>
	</div>
	<div class="go-back">
		<input type="button" value="닫기"><input type="button" value="신고">
	</div>
</div>