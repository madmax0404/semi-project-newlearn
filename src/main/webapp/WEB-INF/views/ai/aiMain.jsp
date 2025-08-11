<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="description" content="AI를 이용할 수 있는 페이지" />
    <meta name="author" content="한종윤" />
    <title>AI 모음 페이지</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/ai-main.css"/>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
    <link rel="icon" href="${pageContext.request.contextPath}/resources/assets/img/favicon/favicon.ico">

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
      rel="stylesheet"
    />

    <!-- Core CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/css/demo.css" />

    <!-- Vendors CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/libs/apex-charts/apex-charts.css" />

    <!-- Helpers -->
    <script src="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/vendor/js/helpers.js"></script>

    <!--! Template customizer & Theme config files MUST be included after core stylesheets and helpers.js in the <head> section -->
    <!--? Config:  Mandatory theme config file contain global vars & default theme options, Set your preferred theme option in this file.  -->
    <script src="${pageContext.request.contextPath}/resources/assets/bootstrap/assets/js/config.js"></script>
</head>
<body>
    <div class="img-wrapper">
        <img src="${pageContext.request.contextPath}/resources/assets/img/ai/the_emperor_protects_modified.png" alt="The Emperor Protects" id="main-image">
    </div>

    <div class="content-wrapper">
        <div class="content">
            <div class="side-nav">
                <div id="new-chat" class="">
                    <img src="${pageContext.request.contextPath}/resources/assets/img/ai/brand-warhammer.svg" alt="Praise the Omnissiah" style="height: 70px;">
                    <span class="app-brand-text demo menu-text fw-bold ms-2" style="color: #384551;">새 채팅</span>
                </div>
                <br>
                <ul id="side-session-list" style="padding-left: 10px; padding-right: 10px;">
                	<c:if test="${not empty aiChatSessionsList }">
                		<c:forEach var="aiChatSession" items="${aiChatSessionsList }">
                			<li class="ai-chat-sessions-list">
                				<div class="ai-chat-sessions-list-title" data-session-no="${aiChatSession.sessionNo }"
                				data-model-no="${aiChatSession.modelNo }">
		                			${aiChatSession.title }
                				</div>
	               				<button type="button" class="btn rounded-pill btn-xs btn-outline-primary session-delete-btn"
	               				data-session-no="${aiChatSession.sessionNo }"
	               				>삭제</button>                				
                			</li>
                		</c:forEach>
                	</c:if>
                </ul>
            </div>
            <div class="main-view">
                <div class="main-view-top">
                    <select name="ai-models-dropdown" class="form-select color-dropdown" id="ai-models-dropdown">
                        <c:forEach var="ai" items="${aiList }" varStatus="i">
                            <c:if test="${i.index == 0 }">
                                <option value="${ai.modelNo }" selected>${ai.modelName }</option>
                            </c:if>
                            <c:if test="${i.index != 0 }">
                                <option value="${ai.modelNo }">${ai.modelName }</option>
                            </c:if>
                        </c:forEach>
                    </select>
                    <button id="back-btn" class="btn btn-outline-primary">나가기</button>
                </div>
                <div class="answer-area">
                    <div id="answer-box" class="">
                        
                    </div>
                </div>
                <div class="main-view-bottom">
                    <div class="input-area">
                        <div class="text-input-area">
                            <textarea name="prompt" id="prompt" class=""></textarea>
                        </div>
                        <button id="prompt-send-btn" class="btn btn-primary">
                            전송
                        </button>
                        <%-- <button id="test-btn">테스트</button> --%>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<script>
    function autoResize(textarea) {
        // Reset height to auto to get accurate scrollHeight
        textarea.style.height = 'auto';
        
        // Set height to scrollHeight (content height)
        textarea.style.height = textarea.scrollHeight + 'px';
    }

    let sessionNo = 0;
    let numPromptsSent = 0;
    let modelNo = $("option:selected").val();
    let modelName = $("option:selected").text();
    
    $("select[name='ai-models-dropdown']").on("change", function() {
    	modelNo = $("option:selected").val();
        console.log(modelNo);
        modelName = $("option:selected").text();
        const newElement = $("<div class='model-change-message'></div>").text("모델 변경: " + modelName);
        $("#answer-box").append(newElement);
        newElement[0].scrollIntoView({ behavior: 'smooth', block: 'start' });
    });

    // Apply to all auto-resize textareas
    document.querySelector('#prompt').addEventListener('input', function() {
        autoResize(this);
    });

    $("#prompt-send-btn").on("click", function() {
        //
        const prompt = $("#prompt").val();
        if (!(prompt && prompt.trim() !== "")) {
            $("#prompt").val("");
            return;
        }

        $("#answer-box").append($("<div class='prompt-bubble'></div>").text(prompt));
        let newElement = $("<div class='waiting-bubble'></div>").text("AI가 대답하는 중입니다...");
        $("#answer-box").append(newElement);
        newElement[0].scrollIntoView({ behavior: 'smooth', block: 'start' });

        $.ajax({
            url: "${pageContext.request.contextPath}/ai/getPrompt/" + modelNo,
            data: {
                prompt,
                sessionNo
            },
            //dataType: "html",
            success: function(result) {
                $(".waiting-bubble").remove();
                let newElement = $("<div class='model-response'></div>").html(result.content);
                $("#answer-box").append(newElement);
                newElement[0].scrollIntoView({ behavior: 'smooth', block: 'start' });
                if (sessionNo == 0 && numPromptsSent == 0) {
                    refreshSessionList();
                }
                numPromptsSent++;
                sessionNo = parseInt(result.sessionNo);
            },
            error: function(error) {
                console.log(error);
            }
        });
        
        $("#prompt").val("");
    });

    $("#new-chat").on("click", function() {
        sessionNo = 0;
        $("#answer-box").empty();
        numPromptsSent = 0;
    })
	
    $("#side-session-list").on("click", ".ai-chat-sessions-list-title", function() {
        if ($(this).hasClass("clicked")) {
            return;
        }
        // 다른 li의 clicked 클래스 다 지움
        $(".ai-chat-sessions-list-title").removeClass("clicked");
        $(".ai-chat-sessions-list-title").addClass("text-gray-900");
        $(this).removeClass("text-gray-900");
        // 클릭한 li만 clicked 클래스 추가
        $(this).addClass("clicked");

        sessionNo = $(this).data("session-no");
        modelNo = $(this).data("model-no");
    	$("select[name='ai-models-dropdown']").val(modelNo);

        // 서버에 해당 sessionNo의 히스토리 불러오기 요청
        $.ajax({
            url: "${pageContext.request.contextPath}/ai/getChatHistory",
            data: {
                sessionNo
            },
            success: function(result) {
                $("#answer-box").empty();
                for (let i = 0; i < result.length; i++) {
                    
                    if (result[i].role === 'user') {
                        $("#answer-box").append($("<div class='prompt-bubble'></div>").text(result[i].content));
                    }

                    if (result[i].role === 'assistant') {
                        $("#answer-box").append(result[i].content);
                    }
                }
            },
            error: function(error) {
                console.log(error);
            }
        });
    });

    // 예: 새 대화 생성 or 채팅방 리스트 갱신 필요할 때!
    function refreshSessionList() {
        $.get("${pageContext.request.contextPath}/ai/sessionListFragment", function(html) {
            // <ul id="side-session-list">로 감싸는 걸 추천!
            $("#side-session-list").html(html);
        });
    }

    $("#back-btn").on("click", function() {
        location.href = "${pageContext.request.contextPath}/class/${classNo}"
    });
    
    $("#side-session-list").on("click", ".session-delete-btn", function() {
    	let bool = confirm("정말 삭제하시겠습니까?");
    	
    	if (bool) {
	    	const sessionNo = $(this).data("session-no");
	    	
	    	$.ajax({
	    		url: "${pageContext.request.contextPath}/ai/sessionDelete",
	    		data: {
	    			sessionNo
	    		},
	    		success: function(res) {
	    			console.log(res);
	    			if (res > 0) {
		    			refreshSessionList();
	    			}
	    		},
	    		error: function(error) {
	    			console.log(error);
	    		}
	    	});    		
    	}    	
    });
</script>
</html>