// stomp서비스 실습
// 관리자가 알람내용을 입력 후 "보내기" 버튼 클릭시 모든 사용자에게 알림 내용이 출력되도록 설정
//     - 클라이언트는 전달받은 메시지를 alertify라이브러리를 이용하여 출력
//     - 구독 url은 /topic/notice로 설정
//     - 사용자가 어떤페이지에 있던 알람을 받을 수 있도록 설정
// const stompClient = Stomp.over(new SockJS(contextPath + "/stomp"));

// stompClient.connect({}, function(e) {
//     console.log(e);
//     // 현재 클라이언트가 구독중인 url 목록들을 전달.
//     stompClient.subscribe("/topic/notice", function(message) {
//         // message.body가 본문
//         const chatMessage = JSON.parse(message.body);
//         alertify.alert("공지사항", chatMessage);
//         console.log(chatMessage);
//         console.log(message);
//         console.log(e);
//     });

//     // 입장 메세지 서버로 전송
//     // stompClient.send("/app/notice", {}, JSON.stringify({
//     //     message: noticeInput.val
//     // }));
// });
const sendNoticeBtn = document.querySelector("#send-notice-btn");

sendNoticeBtn.onclick = function() {
    // 
    const noticeInput = document.querySelector("#notice");

    stompClient.send("/app/**", {}, JSON.stringify({
        message: noticeInput.val
    }));
};