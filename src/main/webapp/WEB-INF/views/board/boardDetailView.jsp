<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>new Learn();</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board/boarddetailview.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/calendar.css" type="text/css" />
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="content">
		<!-- 왼쪽 사이드바 -->
		<div class="sidebar-left card shadow">
			<div class="mini-profile">
				<span>${loginUser.userName}님 환영합니다</span> <span>입실시간: <c:if test="${not empty attendance.entryTime}">
						<fmt:formatDate value="${attendance.entryTime}" pattern="h : mm a" />
					</c:if> <c:if test="${empty attendance.entryTime}">아직 안함</c:if>
				</span>
			</div>

			<div class="mypage-and-entry">
				<form action="${contextPath}/mypage/${loginUser.userNo}" method="get">
					<button type="submit" class="btn btn-primary">마이페이지</button>
				</form>
				<button type="button" data-toggle="modal" data-target="#exampleModal" class="btn btn-primary">입실</button>
			</div>

			<!-- 입실 모달 -->
			<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="exampleModalLabel">입실코드 입력</h5>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<form:form method="post" action="${contextPath}/class/entry">
							<div class="modal-body">
								<input type="text" name="attEntryCode" required />
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
								<button type="submit" class="btn btn-primary">확인</button>
							</div>
						</form:form>
					</div>
				</div>
			</div>

			<!-- 친구 및 채팅 -->
			<div class="friend-list">
				<div class="list-header">
					<h5>즐겨찾기</h5>
					<div class="list-btns">
						<button class="btn rounded-pill btn-secondary btn-xs">
							<a href="${pageContext.request.contextPath}/friend/myFriendList">친구관리</a>
						</button>
					</div>
				</div>
				<h5>일반</h5>
			</div>

			<div class="chatroom-list">
				<div class="list-header">
					<h5>전체채팅</h5>
					<div class="list-btns">
						<button class="btn rounded-pill btn-secondary btn-xs">새채팅</button>
						<button class="btn rounded-pill btn-secondary btn-xs">채팅방관리</button>
					</div>
				</div>
				<h5>그룹채팅</h5>
				<h5>개인채팅</h5>
			</div>
		</div>
		<!-- 메인 상세 -->
		<div class="board card shadow">
			<div class="board-detail-area">
				<c:if test="${board.deleted eq 'N' }">
					<div class="board-detail-title">${board.boardTitle}</div>				
				</c:if>
				<c:if test="${board.deleted eq 'Y' }">
					<div class="board-detail-title">${board.boardTitle} <b style="color:red;">[삭제됨]</b></div>
				</c:if>
				<div class="board-detail-meta">
					<span>작성자</span><span>${board.userName}</span> <span>작성일</span><span><fmt:formatDate value="${board.createDate}" pattern="yyyy-MM-dd HH:mm:ss" /></span> <span>조회수</span><span>${board.viewCount}</span> <span>추천수</span><span>${likeCount}</span>
				</div>

				<div class="board-detail-content">${board.boardContent}</div>
				<div class="detail-actions-row">
					<div class="recommend-center">
						<form id="likeForm" style="display: inline;">
							<button type="button" class="recommend-btn" onclick="recommendBoard(${board.boardNo})">
								<img src="${pageContext.request.contextPath}/resources/files/assignment/추천.png" alt="추천" style="width: 55px; vertical-align: middle;"> <span id="likeCount" style="color: #e91e63; font-size: 40px; font-weight: bold;">&nbsp;${likeCount}</span>
							</button>
						</form>
					</div>
					<span class="action-links">
						<c:if test="${loginUser.userNo == board.userNo or classRole == 'teacher' }">
							<a href="${pageContext.request.contextPath}/board/update/${category}/${board.boardNo}">수정&nbsp;&nbsp;&nbsp;/ </a> 
							<a href="${pageContext.request.contextPath}/board/delete/${board.boardNo}?category=${board.category}&classNo=${classNo}" onclick="return confirm('정말 삭제하시겠습니까?');">삭제&nbsp;&nbsp;&nbsp;/ </a>						
						</c:if> 
						<a href="javascript:void(0);" onclick="openReportModal(${board.boardNo}, ${board.userNo})">신고</a>
					</span>
				</div>
				<div class="board-detail-attachments">
					<div class="attachment-title">첨부파일</div>
					<div class="attachment-list">
						<c:forEach var="file" items="${fileList}">
							<a href="${pageContext.request.contextPath}${file.changeName}" download="${file.originName}" class="attachment-item">
								<c:choose>
									<c:when test="${file.originName.endsWith('.jpg')
						                         || file.originName.endsWith('.jpeg')
						                         || file.originName.endsWith('.png')
						                         || file.originName.endsWith('.gif')
						                         || file.originName.endsWith('.bmp')}">
										<img src="${pageContext.request.contextPath}${file.changeName}" alt="${file.originName}" class="attachment-thumb" />
										<div class="attachment-filename">${file.originName}</div>
									</c:when>
									<c:otherwise>
										<img src="${pageContext.request.contextPath}/resources/files/assignment/file-icon.png" alt="기본파일" class="attachment-default-icon">
										<div class="attachment-filename">${file.originName}</div>
									</c:otherwise>
								</c:choose>
							</a>
						</c:forEach>
					</div>
				</div>
				<!-- 댓글 영역 -->
				<div class="reply-area">
					<div class="reply-section-title">
						댓글 <span style="color: #e91e63;" id="replyCount"></span>
					</div>
					<div class="reply-list" id="replyListArea">
						<!-- JS가 댓글 리스트를 여기에 그림 -->
					</div>
					<div class="reply-form-area">
						<form action="${pageContext.request.contextPath}/reply/insert" method="post" id="replyForm">
							<input type="hidden" id="replyBoardNo" value="${board.boardNo}" />
							<textarea id="replyContent" name="replyContent" rows="3" placeholder="댓글을 입력하세요..."></textarea>
							<button type="submit" class="reply-submit-btn">댓글 등록</button>
						</form>
					</div>
				</div>
			</div>
		</div>
		<!-- 오른쪽 사이드바 -->
		<div class="sidebar-right card shadow">
			<div class="notification">
				<h4>새 알림 5건</h4>
				<p>친구 김성겸 님이 늦잠자는중...</p>
				<p>읽지 않은 메세지 12건</p>
				<p>게시판에 새 글이 있습니다</p>
				<p>방명록에 새 글이 있습니다</p>
				<p>제출해야 할 과제가 있습니다</p>
			</div>
			<div class="shared-calendar">
				<form:form id="dateForm" action="${pageContext.request.contextPath}/event/calendar" method="get">
					<input type="hidden" name="classNo" value="${classNo}" />
					<jsp:include page="/WEB-INF/views/event/calendar.jsp" />
				</form:form>
			</div>
			<div class="upcoming-events">
				<h4>UPCOMING EVENTS</h4>
				<c:forEach var="event" items="${upcomingEvents}">
					<p>
						<fmt:formatDate value="${event.startDate}" pattern="M월 d일 EEEE h : mm a" />
					</p>
					<pre>${event.eventName} (${eventWithMemberCnt[event]}명 참여중...)</pre>
					<form action="${pageContext.request.contextPath}/event/detail/${event.eventNo}" method="get">
						<button type="submit">상세보기</button>
					</form>
				</c:forEach>
			</div>
			<br>
			<hr>
			<div class="imperium-context-engine">
				<img src="${pageContext.request.contextPath}/resources/assets/img/ai/the_aquila_transparent.png" alt="For The Emperor" style="height: 80px;">
				<h4>Imperium Context Engine(ICE)</h4>
				<pre>ChatGPT & Gemini</pre>
				<button class="btn btn-warning">
					<a href="${pageContext.request.contextPath}/ai/main">AI 사용하기</a>
				</button>
			</div>
		</div>
	</div>

	<!-- 신고 모달 -->
	<div id="reportModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 999;">
		<div style="width: 400px; margin: 10% auto; background: #fff; padding: 20px; border-radius: 8px;">
			<h4>신고하기</h4>
			<input type="hidden" id="reportType" value="">
			<input type="hidden" id="reportRefNo">
			<input type="hidden" id="reportedUserNo">
			<input type="hidden" id="reportClassNo" value="${board.classNo}" />
			<textarea id="reportContent" rows="5" placeholder="신고 사유를 입력하세요..." style="width: 100%;"></textarea>
			<div style="margin-top: 10px; text-align: right;">
				<button onclick="submitReport()" style="color: white !important">확인</button>
				<button onclick="closeReportModal()" style="color: white !important">취소</button>
			</div>
		</div>
	</div>

	<script>
		function recommendBoard(boardNo) {
		    $.ajax({
		        url: '${pageContext.request.contextPath}/board/like/' + boardNo,
		        type: 'POST',
		        success: function(data) {
		            $('#likeCount').text(data.newLikeCount);
		        },
		        error: function(xhr, status, error) {
		            if (xhr.status == 409) {
		                alert("이미 추천하셨습니다.");
		            } else {
		                alert("추천 실패: " + xhr.responseText);
		            }
		        }
		    });
		}
		
		
		// 댓글
		$(document).ready(function() {
		    loadReplyList();
		
		    // 댓글 등록 (AJAX)
		    $('#replyForm').submit(function(e) {
		        e.preventDefault();
		
		        let replyData = {
		            boardNo: $('#replyBoardNo').val(),
		            content: $('#replyContent').val()
		        };
		
		        $.ajax({
		            url: '${pageContext.request.contextPath}/reply/insert',
		            type: 'POST',
		            data: JSON.stringify(replyData),
		            contentType: 'application/json; charset=UTF-8',
		            success: function(res) {
		                if (res.result === 'success') {
		                    $('#replyContent').val('');
		                    loadReplyList(); // 댓글 새로고침
		                } else {
		                    alert('댓글 등록 실패');
		                }
		            }
		        });
		    });
		
		    // 댓글 목록 불러오기 (AJAX)
		    function loadReplyList() {
		        let boardNo = $('#replyBoardNo').val();
		        $.ajax({
		            url: '${pageContext.request.contextPath}/reply/list/' + boardNo,
		            type: 'GET',
		            dataType: 'json',
		            success: function(list) {
		                let html = '';
		                list.forEach(function(reply) {
		                    html += `
		                        <div class="reply-item" data-reply-no="\${reply.replyNo}" data-user-no="\${reply.userNo}" data-class-no="${board.classNo}">
		                            <div class="reply-main">
		                                <div class="reply-meta">
		                                    <strong>\${reply.userName || reply.userNo}</strong> · 
		                                    \${reply.createDate ? new Date(reply.createDate).toLocaleString() : ''}
		                                </div>
		                                <div class="reply-content-text">\${reply.content || "(내용 없음)"}</div>
		                                <textarea class="reply-edit-textarea" style="display:none;">\${reply.content}</textarea>
		                            </div>
		                            <div class="reply-actions">
		                                <a href="#" class="edit-btn">수정&nbsp;&nbsp;&nbsp;/</a> 
		                                <a href="#" class="save-btn" style="display:none;">저장&nbsp;&nbsp;&nbsp;/</a> 
		                                <a href="#" class="delete-btn">삭제&nbsp;&nbsp;&nbsp;/</a> 
		                                <a href="javascript:void(0);" class="reply-report-btn" data-reply-no="\${reply.replyNo}" data-user-no="\${reply.userNo}" data-class-no="${board.classNo}">신고</a>
		                            </div>
		                        </div>
		                    `;
		                });
		                $('#replyListArea').html(html);
		                $('#replyCount').text(list.length);
		            }
		        });
		    }
		
		    // 이벤트 위임: 수정 버튼 클릭
		    $('#replyListArea').on('click', '.edit-btn', function(e) {
		        e.preventDefault();
		        const replyItem = $(this).closest('.reply-item');
		        replyItem.find('.reply-content-text').hide();
		        replyItem.find('.reply-edit-textarea').show();
		        replyItem.find('.edit-btn').hide();
		        replyItem.find('.save-btn').show();
		    });
		
		    // 저장 버튼 클릭 → AJAX 댓글 수정 요청
		    $('#replyListArea').on('click', '.save-btn', function(e) {
		        e.preventDefault();
		        const replyItem = $(this).closest('.reply-item');
		        const replyNo = replyItem.data('reply-no');
		        const newContent = replyItem.find('.reply-edit-textarea').val().trim();
		
		        if (newContent === '') {
		            alert("댓글 내용을 입력해주세요.");
		            return;
		        }
		
		        $.ajax({
		            url: '${pageContext.request.contextPath}/reply/update',
		            type: 'POST',
		            contentType: 'application/json',
		            data: JSON.stringify({ replyNo: replyNo, content: newContent }),
		            success: function(res) {
		                if (res.result === 'success') {
		                    replyItem.find('.reply-content-text').text(newContent).show();
		                    replyItem.find('.reply-edit-textarea').hide();
		                    replyItem.find('.edit-btn').show();
		                    replyItem.find('.save-btn').hide();
		                    alert("댓글이 수정되었습니다.");
		                } else {
		                    alert("댓글 수정은 본인만 가능합니다.");
		                }
		            }
		        });
		    });
		
		    // 삭제 버튼 클릭 → AJAX 댓글 삭제 요청
		    $('#replyListArea').on('click', '.delete-btn', function(e) {
		        e.preventDefault();
		        if (!confirm("정말 댓글을 삭제하시겠습니까?")) return;
		
		        const replyItem = $(this).closest('.reply-item');
		        const replyNo = replyItem.data('reply-no');
		
		        $.ajax({
		            url: '${pageContext.request.contextPath}/reply/delete/' + replyNo,
		            type: 'POST',
		            success: function(res) {
		            	if (res.result === 'success') {
		                    alert("댓글이 삭제되었습니다.");
		                    loadReplyList();
		                } else if (res.result === 'unauthorized') {
		                    alert("로그인이 필요합니다.");
		                } else {
		                    alert("댓글 삭제는 본인만 가능합니다.");
		                }
		            }
		        });
		    });
		});
		
		let reportTarget = {
				  boardNo: null,
				  reportedUserNo: null
				};

				// 신고 버튼 클릭 시 모달 오픈
				function openReportModal(boardNo, reportedUserNo) {
				  $('#reportType').val('BOARD'); // 반드시 설정
				  $('#reportRefNo').val(boardNo); // 게시글 번호
				  $('#reportedUserNo').val(reportedUserNo);
				  $('#reportContent').val('');
				  $('#reportModal').show();
				}

				// 모달 닫기
				function closeReportModal() {
				  document.getElementById("reportModal").style.display = "none";
				}

				// 신고 전송
				function submitReport() {
				  const content = $('#reportContent').val().trim();
				  if (!content) {
				    alert("신고 사유를 입력해주세요.");
				    return;
				  }

				  const urlParams = new URLSearchParams(window.location.search);
				  const classNo = urlParams.get('classNo'); 
				  const reportLink = window.location.pathname.replace('/new-learn', '') + (classNo ? '?classNo=' + classNo : '');
				  
				  const reportData = {
				    reportType: $('#reportType').val(), // 'BOARD' or 'REPLY'
				    refNo: $('#reportRefNo').val(),
				    reportedUserNo: $('#reportedUserNo').val(),
				    reportContent: content,
				    link: reportLink,
				    classNo: $('#reportClassNo').val()
				  };
				  $.ajax({
				    url: '${pageContext.request.contextPath}/board/report',
				    type: 'POST',
				    contentType: 'application/json',
				    data: JSON.stringify(reportData),
				    success: function(res) {
				      if (res.result === 'success') {
				        alert("신고가 접수되었습니다.");
				        closeReportModal();
				      } else if (res.result === 'unauthorized') {
				        alert("로그인이 필요합니다.");
				      } else {
				        alert("신고 처리에 실패했습니다.");
				      }
				    },
				    error: function() {
				      alert("서버 오류가 발생했습니다.");
				    }
				  });
				}
				// 댓글 신고 시 호출되는 함수
				function openReplyReportModal(replyNo, reportedUserNo, classNo) {
				  $('#reportType').val('REPLY');
				  $('#reportRefNo').val(replyNo);
				  $('#reportedUserNo').val(reportedUserNo);
				  $('#reportContent').val('');
				  $('#reportModal').show();
				  $('#reportClassNo').val(classNo);
				}
				
				// 댓글 신고 버튼 클릭 이벤트
				$('#replyListArea').on('click', '.reply-report-btn', function(e) {
				  e.preventDefault();
				  const replyItem = $(this).closest('.reply-item');
				  const replyNo = replyItem.data('reply-no');
				  const reportedUserNo = replyItem.data('user-no');
				  const classNo = replyItem.data('class-no');
				  console.log("댓글 신고 classNo:", classNo);
				  openReplyReportModal(replyNo, reportedUserNo, classNo);
				});
	</script>
</body>
</html>
