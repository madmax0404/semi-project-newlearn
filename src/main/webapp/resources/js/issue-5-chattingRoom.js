/*
    채팅방 설정
*/
/*
    채팅방 설정 컨트롤러
*/

const {userNo, userName, chatRoomNo, contextPath, stompClient } =  window.chatConfig; 
import {
  updateMessage,
  enrollNoti,
  deleteChatMessage,
} from './issue-5-stomp.js';

$(document).ready(function () {
    $('#set-room-controller').css('display', 'none');

    $('#container #friend .room_set_button').on('click', function(event){
        event.stopPropagation();
        $('#set-room-controller').css({
            top: event.pageY + 'px',
            left: event.pageX + 'px',
            display: 'flex'
        });
    });

    $(document).on('click',function() {
        $('#set-room-controller').css('display','none');
    });

    $('#set-room-controller').on('click',function(event) {
        event.stopPropagation();
    });
});
/*
    채팅방 수정 모달
*/
$(document).ready(function () {
    // 모달 숨김
    $('.container-fluid').hide();
    // 버튼 클릭 시 모달 보이기
    $('#set-room-controller .set-room').on('click', function () {
        $('.container-fluid').fadeIn();
        $('.container-fluid .radioPublicY').prop('checked',true);
        $('.container-fluid .change-password').hide(); // 비밀번호창 숨김
        $('.container-fluid .input-room-password').prop('required', false); // 비밀번호 필드 필수 속성 제거
        $('.container-fluid input[name="select-friend-list"]').prop('checked', false); // 친구 선택 초기화
        
        $('.container-fluid input[name="chatPublic"]').change(function() {
            if ($(this).val() === 'N') {
                // 비공개 선택 시
                $('.container-fluid .change-password').show();
                $('.container-fluid .input-room-password').prop('required', true);
            } else {
                // 공개 선택 시
                $('.container-fluid .change-password').hide();
                $('.container-fluid .input-room-password').val(''); // 비밀번호 초기화
                $('.container-fluid .input-room-password').prop('required', false); // 필수 속성 제거
            }
        });
    });
    // 취소 버튼
    $('.container-fluid .go-back input:nth-child(1)').on('click', function () {
        $('.container-fluid').fadeOut();
    });

    // 은성이의 똥코드 (채팅방 설정) -> AJAX
    $('.container-fluid .set-room-btn').on('click', function(){
        var chatTitle = $('.container-fluid .input-change-title').val().trim();
        var chatPublic = $('.container-fluid input[name="chatPublic"]').val();
        var chatPassword = $('.container-fluid .input-change-password').val();
        var selectedFriends = $('.container-fluid input[name="selectFriendList"]:checked').length;
        
        // if(chatTitle ===  && chatPublic === && chatPassword === && selectedFriends === && ){
        //     alert("수정사항이 없습니다.");
        //     return;
        // }
        
        var formData = $('.container-fluid #set-room-form').serialize();
        $.ajax({
            url: contextPath + "/chat/updateRoom/",
            type: "POST",
            data: formData,
            dataType: "json",
            success:function(response){
                if(response.result === 'success'){
                    alert(response.message);
                }

            },
            error:function(xhr,status,error){

            }
        });

        $('.container-fluid').fadeOut();
    });
});

/*
    채팅방 신고 모달
*/
$(document).ready(function () {
    $('.modal-overlay').hide();

    $('#set-room-controller .report-room').on('click', function () {
        $('.modal-overlay').fadeIn();
    });

    $('.modal-overlay .go-back input:nth-child(1)').on('click', function () {
        $('.modal-overlay').fadeOut();
    });
});

/*
    채팅 컨트롤러
*/
/*
    내채팅
*/
$(document).ready(function () {
    const $mychattingoptionController =  $('#mychattingoption-controller');
    $mychattingoptionController.css('display', 'none');

    const handler = function(event, html){
        event.preventDefault();
        event.stopPropagation();
        $mychattingoptionController.empty(); // 내부 비워주기

        const messageNo = $(this).data("cm-no");
        const content = $(this).find(".js-content").html();
        const message = {content, messageNo}; 

        $mychattingoptionController.html(html);
        
        $mychattingoptionController
        .find(".chatting-notice")
        .click(function(){
            enrollNoti(message);
        })
        
        $mychattingoptionController
        .find(".chatting-modify")
        .click(() => {
            $("textarea[name=content]").focus().val(content);
            $("#send-btn").css('display','none');
            $("#update-btn").show();
            const sendBtn = document.querySelector("#update-btn");
            sendBtn.onclick = updateMessage.bind(this);
        })

        $mychattingoptionController
        .find(".chatting-delete")
        .click(() => {
            deleteChatMessage(message);
        })

        $('#mychattingoption-controller').css({
            top: event.pageY + 'px',
            left: event.pageX + 'px',
            display: 'flex'
        });
    }
    
    //const common = `<div class="chatting-reply">답장</div><div class="line"></div><div class="chatting-notice">공지</div><div class="line"></div>`;
    const common = `<div class="chatting-notice">공지</div>`;

    const html1 = `<div class="chatting-modify">수정</div><div class="line"></div>${common}<div class="line"></div><div class="chatting-delete">삭제</div>`;
    // const html2 = `${common}<div class="chatting-report">신고</div>`;
    const html2 = `${common}`;
    // const html3 = `<div class="img-download">다운로드</div><div class="line"></div>${common}<div class="chatting-report">신고</div>`;
    const html3 = `${common}<div class="line"></div>`;
    $(document).on('contextmenu', '.my-chat' , function(e){ handler.bind(this)(e , html1)} );
    $(document).on('contextmenu', '.other-chat' , function(e){handler.bind(this)(e , html2)} );
    $(document).on('contextmenu', '.other-chat-img-file' ,function(e){ handler.bind(this)(e , html3)} );

    $(document).on('click',function() {
        $mychattingoptionController .css('display','none');
    });

    $mychattingoptionController .on('click',function(event) {
        event.stopPropagation();
    });

});

/*
    공지 컨트롤러
*/
$(document).ready(function(){
    $('#chattingnotice-controller').css('display','none');

    $('.chatting-main .chatting-notice-top').on('contextmenu',function(event){
        event.preventDefault();
        event.stopPropagation();
        $('#chattingnotice-controller').css({
            top: event.pageY + 'px',
            left: event.pageX + 'px',
            display: 'flex'});
    });

    $(document).on('click',function(){
        $('#chattingnotice-controller').css('display','none');
    });

    $('#chattingnotice-controller').on('click',function(event){
        event.stopPropagation();
    });

    $('#chattingnotice-controller .chatting-view').on('click',function(){
        const notiMsgNo = $("#notification").data("cm-no");
        const notiMsg = $(`.chatting-text[data-cm-no="${notiMsgNo}"]`);
        if(notiMsg.length > 0) {
            document.querySelector(".chatting-main").scrollTop = notiMsg[0].offsetTop -100; // -100은 실행결과 보고 조정
        }
        $('#chattingnotice-controller').css('display','none');
    });

    // 은성이의 똥코드 13 공지 삭제 버튼 누르면 공지 숨기기 (성공! 했지만 다시 바꾸자)
    $('#chattingnotice-controller .chatting-delete').on('click',function(){
        $('.chatting-notice-top').hide();
    });
});

$(document).ready(function(){
    $("#set-room-controller .exit-room").click(function(){
        $("#roomExit").submit();
    })
})