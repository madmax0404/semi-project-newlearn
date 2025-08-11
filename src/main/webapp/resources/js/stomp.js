/**
 * stomp 동작방식
 * 1. 클라이언트가 SockJS를 이용하여 서버에 "연결요청"을 보냄.
 *  - 연결 수락시 서버는 Connected 프레임을 웹소켓을 통해 반환.
 * 2. 클라이언트는 서버와 연결 수립 후 구독중인 url을 전달.
 */

// 스톰프 클라이언트로 연결이 완료된 후 실행할 이벤트 핸들러.
// 현재 채팅방에 새로운 사용자가 입장 하거나, 사용자가 퇴장 하는 경우의 구독 url

stompClient.connect({}, function(e) {
    console.log(e);
    // 현재 클라이언트가 구독중인 url 목록들을 전달.
    stompClient.subscribe("/topic/room/" + chatRoomNo, function(message) {
        // message.body가 본문
        const chatMessage = JSON.parse(message.body);
        showMessage(chatMessage);
    });

    // 입장 메세지 서버로 전송
    stompClient.send("/app/chat/enter/" + chatRoomNo, {}, JSON.stringify({
        userName,
        chatRoomNo,
        userNo
    }));
});

function showMessage(message) {
    const li = document.createElement("li");
    const p = document.createElement("p");
    p.classList.add("chat");
    p.innerText = message.message;
    p.style.color = "gray";
    p.style.textAlign = "center";
    li.append(p);

    document.querySelector(".display-chatting").append(li);
}

const exitBtn = document.querySelector("#exit-btn");

exitBtn.onclick = function() {
    // 서버로 퇴장 메세지 전송
    // 1. CHAT_ROOM_JOIN 에서 한행의 데이터 삭제.
    // 2. 현재 채팅방에 참여자가 0명이라면 채팅방 삭제.
    // 3. 같은 방을 이용하는 모든 사용자에게 알림내용 전송.
    stompClient.send("/app/chat/exit/" + chatRoomNo, {}, JSON.stringify({
        userName,
        chatRoomNo,
        userNo
    }));

    stompClient.disconnect(function() {
        location.href = `${contextPath}/chat/chatRoomList`;
    });
};