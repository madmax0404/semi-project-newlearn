const {userNo, userName, chatRoomNo, contextPath, stompClient } =  window.chatConfig; 
(function(){
    scrollTop();
})();

function scrollTop(){
    const display = document.querySelector(".chatting-main");
    // 채팅창 맨 아래로 내리기
    display.scrollTop = display.scrollHeight;
}

// 스톰프클라이언트 연결
stompClient.connect({}, function(e) {
    
    // 1. 현재 채팅방으로 전달되는 메세지
    stompClient.subscribe("/topic/chatroom/" + chatRoomNo, function(message) {
        const chatMessage = JSON.parse(message.body);
        showMessage(chatMessage);
    });

    stompClient.subscribe("/topic/chatroom/" + chatRoomNo+"/share-file", function(message) {
        const file = JSON.parse(message.body);
        showImg(file);
    });

    stompClient.subscribe("/topic/chatroom/" + chatRoomNo+"/notification", function(message) {
        const noti = JSON.parse(message.body);
        updateNoti(noti);
    });

    stompClient.subscribe("/topic/chatroom/" + chatRoomNo+"/update", function(message) {
        const chatMessage = JSON.parse(message.body);
        updateChat(chatMessage);
    });

    stompClient.subscribe("/topic/chatroom/" + chatRoomNo+"/delete", function(message) {
        const chatMessage = JSON.parse(message.body);
        deleteChat(chatMessage);
    });

    // 은성이의 똥코드 (채팅 답장)
    // stompClient.subscribe("/topic/chatRoom/" + chatRoomNo+"/reply", function(message) {
    //     const chatMessage = JSON.parse(message.body);
    //     replyChat(chatMessage);
    // })

    // 2. 기타 채팅방 관련 실시간 기능들 구독 필요.
});

// 채팅메인 형식 맞춘 후 다시.
function showMessage(message) {
    const li = document.createElement("li");
    li.classList.add('chatting-text');
    li.dataset.cmNo = message.messageNo
    if(message.userNo != userNo ){
        li.classList.add('other-chat');
        li.innerHTML = 
        `<img src="${contextPath}/resources/main/bono.jpg" alt="${message.userName}">
        <div class="other-chat-content">
        <p>${message.userName}</p>
        <p class="js-content">${message.content}</p>
        </div>`
    }else{
        li.classList.add('my-chat');
        li.innerHTML = 
        `<span class="js-content">${message.content}</span>`;
    }
    document.querySelector(".chatting-main ul").append(li);
}

function showImg(file){
    const li = document.createElement("li");
    li.classList.add('chatting-text');
     li.dataset.cmNo = file.messageNo
    if(file.userNo != userNo ){
        
        li.classList.add('other-chat');
        li.innerHTML = 
        `<img src="${contextPath}/resources/main/bono.jpg" alt="${file.userName}">
        <div class="other-chat-content">
        <p>${file.userName}</p>
        <p class='chat-img js-content'><img src='${contextPath + file.fileUrl}'/></p>
        </div>`
    }else{
        li.classList.add('my-chat');
        li.innerHTML = `<p class='chat-img js-content'><img src='${contextPath + file.fileUrl}'/></p>`;
    }
    document.querySelector(".chatting-main ul").append(li);
}

function updateNoti({content, messageNo}){
    $("#notification").html(content);
    $("#notification").attr("data-cm-no",messageNo)
}

function updateChat({content, messageNo}){
    $(`[data-cm-no=${messageNo}]`).find(".js-content").html(content);
    $(`#notification[data-cm-no=${messageNo}]`).html(content);
}

function deleteChat({messageNo}){
    $(`[data-cm-no=${messageNo}]:not(#notification)`).css("display","none");
    $(`#notification[data-cm-no=${messageNo}]`).html("");
}
// 은성이의 똥코드 (채팅 답장)
// function replyChat({content, messageNo}){

// }
const sendBtn = document.querySelector("#send-btn");
sendBtn.onclick = sendMessage;

// 채팅 메시지 보내기 기능
function sendMessage(){
    const text = document.querySelector("#chatting-textarea");

    const data = {
        chatRoomNo,
        userNo,
        content : text.value,
        userName
    }

    stompClient.send("/app/chat/sendMessage", {}, JSON.stringify(data));

    text.value="";
    setTimeout(() => {
        scrollTop();
    }, 100);
}

function updateMessage(){
    const text = document.querySelector("#chatting-textarea");
    const messageNo = $(this).data("cm-no");
    
    const message = {
        messageNo, 
        chatRoomNo,
        userNo,
        content : text.value,
        userName
    }

    stompClient.send("/app/chatMessage/" + message.messageNo+"/update", {}, JSON.stringify({
        ...message,
        userNo, 
        userName,
        chatRoomNo  
    }));

    text.value="";
    $("#send-btn").show();
    $("#update-btn").css('display','none');
}

document.getElementById("uploadFile").onchange = upload;

function upload() {
    // const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
    // const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

    const fileInput = document.getElementById("uploadFile");
    const file = fileInput.files[0];
    if (!file) return;

    const formData = new FormData();
    formData.append("file", file);
    formData.append("chatRoomNo", chatRoomNo); // 현재 채팅방 ID
    formData.append("userNo", userNo); // 현재 업로드한 유저

    $.ajax({
        url: contextPath+ "/chat/upload",  // Spring 파일 업로드 처리 컨트롤러
        type: "POST",
        data: formData,
        processData: false,
        contentType: false,
        // beforeSend: function(xhr) {
        //     xhr.setRequestHeader(csrfHeader, csrfToken);
        // },
        success: function(res) {
            console.log("업로드 성공");

            // 업로드 후 WebSocket으로 공유 알림 전송
            stompClient.send("/topic/chatroom/" + chatRoomNo+"/share-file", {}, JSON.stringify({
                userNo, 
                userName,
                messageNo : res.messageNo,
                fileUrl: res.fileUrl,  
            }));

            setTimeout(() => {
                scrollTop();
            }, 100);
        }
    });
}
/*
    채팅 찾기
*/
function searchMsg(){
    const keyword = $("#chatting-textarea").val();

    $.ajax({
        url: contextPath + "/chat/search",
        type: "GET",
        data:{
            chatRoomNo:chatRoomNo,
            keyword: keyword
        },
        success:function(result){
            if(result.length === 0){
                alert("검색 결과가 없습니다.");
                return;
            }
            currentIndex = 0;
            showNextResult(result);
        }
    });
};
function shewNextResult(searchResult){
    if(currentIndex >= searchResult.length){
        alert("검색 결과가 없습니다.");
        return;
    }
        
    let message = searchResult[currentIndex];
    currentIndex++;

    scrollToMessage(message.messageNo)

}

function enrollNoti(message){
    $('.chatting-notice-top').show(); // 은성이의 똥코드 (공지 항상 띄워놓게 다시 바꾸자)
    stompClient.send("/app/chatMessage/" + message.messageNo+"/notification", {}, JSON.stringify({
        ...message,
        userNo, 
        userName,
        chatRoomNo  
    }));
}

function updateChatContent(message){
    stompClient.send("/app/chatMessage/" + message.messageNo+"/update", {}, JSON.stringify({
        ...message,
        userNo, 
        userName,
        chatRoomNo  
    }));
}

function deleteChatMessage(message){
    stompClient.send("/app/chatMessage/" + message.messageNo+"/delete", {}, JSON.stringify({
        ...message,
        userNo, 
        userName,
        chatRoomNo  
    }));
}

export {
  sendMessage,
  updateMessage,
  upload,
  searchMsg,
  enrollNoti,
  updateChatContent,
  deleteChatMessage
};