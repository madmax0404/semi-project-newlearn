// ============================
// 전체 모달 숨김
// ============================
$(document).ready(function () {
    // 모든 모달 초기 상태 숨김
    $('.container-create').hide();
    $('#friend-profile-modal').hide();
    $('#together-class').hide();
    $('#set-room-controller').hide();
    $('#set-room-modal-creater').hide();
    $('#set-room-modal-member').hide();
    $('#report-room-modal').hide();
});

// ============================
// 채팅방 만들기 모달창 제어
// ============================
$('#friend-top button').on('click', function (event) {
    event.stopPropagation();

    $('.container-create').fadeIn();
    
    // 모달 열 때 폼 초기화
    $("#create-room-form")[0].reset();
    $(".container-create .input-room-title").val("") // 방 제목 초기화
    $(".container-create .radioPublicY").prop("checked", true); // 공개 라디오 버튼 선택
    $(".container-create .password").hide(); // 비밀번호창 숨김
    $('.container-create .input-room-password').prop('required', false); // 비밀번호 필드 필수 속성 제거
    $('.container-create input[name="select-friend-list"]').prop('checked', false); // 친구 선택 초기화

    // 공개/비공개 라디오 버튼 변경 시 비밀번호 입력창 표시/숨김
    $('.container-create input[name="chatPublic"]').change(function() {
        if ($(this).val() === 'N') {
            // 비공개 선택 시
            $('.container-create .password').show();
            $('.container-create .input-room-password').prop('required', true);
        } else {
            // 공개 선택 시
            $('.container-create .password').hide();
            $('.container-create .input-room-password').val(''); // 비밀번호 초기화
            $('.container-create .input-room-password').prop('required', false); // 필수 속성 제거
        }
    });

});

// 채팅방 만들기 취소 버튼 클릭 시 모달 닫기 및 폼 초기화
$('.container-create .go-back input:nth-child(1)').on('click', function () {
    $('.container-create').fadeOut();
    // 모달 닫을 때 폼 필드 초기화
    $("#create-room-form")[0].reset();
    $(".container-create .password").hide();
    $(".container-create .radioPublicY").prop("checked", true);
    $('.container-create input[name="select-friend-list"]').prop("checked", false);
    $('.container-create .input-room-password').prop('required', false);
});

// 채팅방 만들기 확인 버튼 클릭 (AJAX 제출)
$(".container-create .create-room-btn").on("click", function(){
    // 폼 유효성 검사
    var chatTitle = $(".container-create .input-room-title").val().trim();
    if(chatTitle === ''){
        alert("채팅방 제목을 입력해주세요.");
        $(".container-create .input-room-title").focus();
        return;
    }

    var chatPublic = $(".container-create input[name='chatPublic']:checked").val();
    if(chatPublic === 'N'){
        var chatPw = $(".container-create .input-room-password").val().trim();
        if(chatPw === ''){
            alert("비공개 채팅방 비밀번호를 입력해주세요.");
            $(".container-create .input-room-password").focus();
            return;
        }
    }
    
    var selectedFriends = $(".container-create input[name='selectFriendList']:checked").length;
    console.log(selectedFriends);
    if(selectedFriends === 0){
        alert("한 명 이상의 대화상대를 초대해주세요.");
        return;
    }

    // 폼 데이터 직렬화 (유효성 검사 통과 후)
    var formData = $(".container-create #create-room-form").serialize();
    // AJAX 요청
    $.ajax({
        // 중요: chatAppContextPath 변수는 JSP 파일 내 <script> 태그에서
        url: chatAppContextPath+"/chat/createRoom",
        type: "POST",
        data: formData,
        dataType: "json",
        success: function(response){
            if(response.success){
                alert(response.message);
                $(".container-create").fadeOut(); // 모달 닫기
                $("#create-room-form")[0].reset(); // 폼 필드 초기화
                $(".container-create .password").hide(); // 비밀번호 필드 숨김
                $(".container-create .radioPublicY").prop("checked",true); // 공개 라디오 버튼 선택
                $(".container-create input[name='selectFriendList']").prop("checked",false); // 친구 선택 초기화
                
                location.reload();
                //refreshChatRoomList(); // 채팅방 목록 업데이트 호출
            } else {
                alert("채팅방 생성 실패 : " + response.message);
            }
        },
        error: function(xhr, status, error){
            console.error("AJAX Error : ", status, error, xhr.responseText);
            var errorMessage = "알 수 없는 오류가 발생했습니다.";
            if (xhr.responseJSON && xhr.responseJSON.message) {
                errorMessage = xhr.responseJSON.message;
            } else if (xhr.responseText) {
                errorMessage += "\n서버 응답: " + xhr.responseText;
            }
            alert("채팅방 생성 중 오류가 발생했습니다. : " + errorMessage);
        }
    });
});

    // ============================
    // 2. 채팅방 목록 동적 업데이트 함수
    // ============================
    function refreshChatRoomList(){
        // 중요: loginUserNo 변수는 JSP 파일 내 <script> 태그에서
        // var loginUserNo = ${sessionScope.loginMember.userNo}; 와 같이 선언되어야 합니다.
        // 현재는 JSP에 해당 선언이 없으므로, 임시로 하드코딩된 값을 사용합니다.
        // 실제 배포 시에는 반드시 수정되어야 합니다.
        var loginUserNo = 3; 
        
        // loginUserNo가 JSP에서 문자열로 넘어올 경우를 대비하여 숫자로 변환
        if (typeof loginUserNo === 'string' && !isNaN(parseInt(loginUserNo))) {
            loginUserNo = parseInt(loginUserNo);
        }

        $.ajax({
            url: chatAppContextPath+"/chat/main",
            type: "GET",
            data: { userNo: loginUserNo }, // 사용자 번호 전달
            dataType: "html", // HTML 응답을 기대
            success: function(html){
                // 받은 전체 HTML에서 id="room-list-mid"인 요소의 내용을 추출하여 현재 페이지에 삽입
                var newChatRoomListContent = $(html).find("#room-list-mid").html();
                $("#room-list-mid").html(newChatRoomListContent);
                console.log("채팅방 목록 업데이트 완료");
            },
            error: function(xhr, status, error){
                console.error("채팅방 목록 업데이트 실패 : ", status, error, xhr.responseText);
                alert("채팅방 목록을 불러오는데 실패했습니다.");
            }
        });
    }

    // ============================
    // 3. 친구 프로필 모달 (이벤트 위임 사용)
    // ============================
    // #friend-mid 내부에 동적으로 생성될 수 있는 .friend-inf-checkbox에 대해 이벤트 위임
    $('#friend-mid').on('click', '.friend-inf-checkbox', function (event) { // 클래스 이름 수정 반영
        event.stopPropagation();
        $('#friend-profile-modal').css({
            top: event.pageY + 'px',
            left: event.pageX + 'px',
        }).fadeIn();
        // TODO: 여기에 클릭된 친구의 정보를 AJAX로 가져와서 모달에 채우는 로직 추가
    });

    // 친구 프로필 모달의 '뒤로가기' 버튼 클릭 시 모달 닫기
    $('#friend-profile-modal .back input').on('click', function () {
        $('#friend-profile-modal').fadeOut();
    });

    // ============================
    // 4. 함께하는 클래스 모달 (이벤트 위임 사용)
    // ============================
    // #friend-profile-modal 내부에 있는 .option1 button 클릭 시
    $('#friend-profile-modal').on('click', '.option1 button', function (event) {
        event.stopPropagation();
        $('#together-class').css({
            top: event.pageY + 'px',
            left: event.pageX + 'px'
        }).fadeIn();
    });

    // ============================
    // 5. 채팅방 설정 컨트롤러 모달 (이벤트 위임 사용)
    // ============================
    // #room-list-mid 내부에 동적으로 생성될 수 있는 .room-set-btn에 대해 이벤트 위임
    $('#room-list-mid').on('click', 'li .room-set-btn', function (event) { // 클래스 이름 수정 반영
        event.stopPropagation();
        $('#set-room-controller').css({
            top: event.pageY + 'px',
            left: event.pageX + 'px'
        }).fadeIn();
        // TODO: 여기에 해당 채팅방의 정보 (예: 방장 여부)를 가져와서 컨트롤러 내용을 구성하는 로직 추가
    });


    // ============================
    // 6. 방장/멤버 설정 모달 (이벤트 위임 사용)
    // ============================
    // #set-room-controller 내부에 있는 .set-room 클릭 시
    $('#set-room-controller').on('click', '.set-room', function () {
        // 실제 방장인지 아닌지에 따라 모달을 선택적으로 띄워야 합니다.
        // 이 부분은 서버에서 받아온 채팅방 정보에 따라 조건부로 처리해야 합니다.
        // 예를 들어, var isCreater = true; // 서버 응답에서 받아온 값
        // if (isCreater) {
        //      $('#set-room-modal-creater').fadeIn();
        // } else {
             $('#set-room-modal-member').fadeIn(); // 임시로 멤버 모달만 띄움
        // }
    });

    // 멤버 설정 모달의 '뒤로가기' 버튼 클릭 시 모달 닫기
    $('#set-room-modal-member .go-back input:nth-child(1)').on('click', function () {
        $('#set-room-modal-member').fadeOut();
    });

    // 방장 설정 모달의 '뒤로가기' 버튼 클릭 시 모달 닫기
    $('#set-room-modal-creater .go-back input:nth-child(1)').on('click', function () {
        $('#set-room-modal-creater').fadeOut();
    });


    // ============================
    // 7. 채팅방 신고 모달 (이벤트 위임 사용)
    // ============================
    // #set-room-controller 내부에 있는 .report-room 클릭 시
    $('#set-room-controller').on('click', '.report-room', function () {
        $('#report-room-modal').fadeIn();
    });

    // 채팅방 신고 모달의 '뒤로가기' 버튼 클릭 시 모달 닫기
    $('#report-room-modal .go-back input:nth-child(1)').on('click', function () {
        $('#report-room-modal').fadeOut();
    });

    // ============================
    // 8. 문서 클릭 시 모달 닫기 공통 로직
    // ============================
    // 여러 모달에 대한 닫기 로직을 한 번에 처리
    $(document).on('click', function (event) {
        // 클릭된 요소가 모달 영역 내부 또는 모달을 여는 버튼/컨트롤러의 자식이 아닌 경우에만 닫기
        const modals = [
            '#friend-profile-modal',
            '#together-class',
            '#set-room-controller',
            '#set-room-modal-creater',
            '#set-room-modal-member',
            '#report-room-modal'
        ];

        let clickedInsideModal = false;
        for (let i = 0; i < modals.length; i++) {
            if ($(event.target).closest(modals[i]).length) {
                clickedInsideModal = true;
                break;
            }
        }

        // 모달을 여는 버튼/컨트롤러 클릭은 모달을 닫지 않도록 예외 처리
        const openTriggers = [
            '#friend-top button', // 채팅방 만들기 버튼
            '#friend-mid .friend-inf-checkbox', // 친구 프로필 모달 트리거 (클래스 이름 수정 반영)
            '#friend-profile-modal .option1 button', // 함께하는 클래스 트리거
            '#room-list-mid li .room-set-btn', // 채팅방 설정 컨트롤러 트리거 (클래스 이름 수정 반영)
            '#set-room-controller .set-room', // 설정 모달 트리거
            '#set-room-controller .report-room' // 신고 모달 트리거
        ];

        let clickedOnTrigger = false;
        for (let i = 0; i < openTriggers.length; i++) {
            if ($(event.target).closest(openTriggers[i]).length) {
                clickedOnTrigger = true;
                break;
            }
        }

        if (!clickedInsideModal && !clickedOnTrigger) {
            // 모든 모달 닫기
            $('#friend-profile-modal').fadeOut();
            $('#together-class').fadeOut();
            $('#set-room-controller').fadeOut();
            $('#set-room-modal-creater').fadeOut();
            $('#set-room-modal-member').fadeOut();
            $('#report-room-modal').fadeOut();
        }
    });


/*
    채팅방 만들기 모달창 내부 친구 이름 검색 기능
*/
$(document).ready(function(){
    $(".container-create .input-friend-name").on("input",function(){
        var searchName = $(this).val().toLowerCase(); // 사용자가 입력한 이름

        $(".container-create li").each(function(){
            var friendName = $(this).attr("id").toLowerCase(); // li의 id = userName
            if(friendName.includes(searchName)){
                $(this).show();
            }else{
                $(this).hide();
            }
        });

    });
});
function moveChatRoom(chatRoomNo){
    location.href = chatAppContextPath+"/chat/chatRoomJoin/"+chatRoomNo;
}

/*
    채팅방 검색 기능
*/
// $(document).ready(function(){
//     $("#room-list-bottom .keyword").on("input",function(){
//         var searchText = $(this).val().toLowerCase(); // 사용자가 입력한 keyword
//         var searchType = $("#room-list-bottom .search-type").val(); // 사용자가 선택한 searchType
//         if(searchType === "방제목"){
//             $("#room-list-bottom li").each(function(){
//                 var chatTitle = $(this).attr("id").toLowerCase();
//                 if(searchText.includes(chatTitle)){
//                     $(this).show();
//                 }else{
//                     $(this).hide();
//                 }
//             })
//         }else if(searchType === "참여자"){
//             $("#room-list-bottom li").each(function(){
//                 var userName = $(this).attr("class").toLowerCase();
//                 if(searchText.includes(userName)){
//                     $(this).show();
//                 }else{
//                     $(this).hide();
//                 }
//             })
//         }
//     })
// });