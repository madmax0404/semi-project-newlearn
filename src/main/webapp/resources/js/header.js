$(function() {
    const stompClient = Stomp.over(new SockJS(contextPath + "/stomp"));
    stompClient.connect({}, function() {
        stompClient.subscribe("/topic/newGb/" + userNo, function(message) {
            const m = JSON.parse(message.body);
            alertify.alert(m.userName + "님이 방명록을 남겼습니다.");
        });
        $.ajax({
            url: contextPath + '/getSubsUrl?userNo=' + userNo,
            method: 'GET',
            success: function(data) {
                for (const classNo of data.teacherSubs) {
                    if (classNo != null) {
                        stompClient.subscribe("/topic/classT/" + classNo, function(message) {
                            const m = JSON.parse(message.body);
                            alertify.alert(m.userName + "(이)가 " + m.className + " 클래스룸에 입실하였습니다.");
                        });
                    }
                }
                for (const classNo of data.classSubs) {
                    if (classNo != null) {
                        stompClient.subscribe("/topic/classE/" + classNo, function(message) {
                            const m = JSON.parse(message.body);
                            if (m.event.userNo != userNo) {
                                alertify.alert(m.class + " 클래스룸에 이벤트가 추가되었습니다.");
                            }
                        });
                        stompClient.subscribe("/topic/class/" + classNo, function(message) {
                            const m = JSON.parse(message.body);
                            if (m.userNo != userNo) {
                                alertify.alert(m.userName + "(이)가 " + m.className + " 클래스룸에 참여하였습니다.");
                            }
                        });
                    }
                }
                for (const eventNo of data.eventSubs) {
                    if (eventNo != null) {
                        stompClient.subscribe("/topic/eventU/" + eventNo, function(message) {
                            const m = JSON.parse(message.body);
                            if (m.userNo != userNo) {
                                alertify.alert(m.eventName + " 이벤트가 수정되었습니다.");
                            }
                        });
                        stompClient.subscribe("/topic/eventD/" + eventNo, function(message) {
                            const m = JSON.parse(message.body);
                            if (m.userNo != userNo) {
                                alertify.alert(m.eventName + " 이벤트가 삭제되었습니다.");
                            }
                        });
                    }
                }
            },
            error: function(xhr, status, error) {
                console.log('에러 발생:', error);
            }
        });
        stompClient.subscribe("/topic/teacher/" + userNo, function(message) {
            const data = JSON.parse(message.body);
            alertify.alert(data.sender, data.content);
        });
    });
});

$(document).on('click', '#change-class', function(e) {
    const mouseX = e.pageX;
    const mouseY = e.pageY;
    
    fetch(contextPath + '/class/list?userNo=' + userNo)
    .then(response => {
        if (!response.ok) throw new Error('에러 발생');
        return response.json();
    })
    .then(classrooms => {
        let html = '';
        classrooms.forEach(c => {
            if (c.classNo != classNo)
            html += `<a href="${contextPath}/class/${c.classNo}">${c.className}</a>`;
        });
        $('#change-class-list').html(html);

        const modalWidth = $('#change-class-modal').outerWidth();
        let left = mouseX - modalWidth;
        if (left < 0) left = 0;

        $('#change-class-modal').css({
            display: 'block',
            top: mouseY + 'px',
            left: left + 'px'
        });
    })  
    .catch(error => {
        console.log(error);
    });
});

$(document).on('click', function(e) {
    const target = $(e.target);
    if (!target.closest('#change-class-modal').length && !target.is('#change-class')) {
        $('#change-class-modal').hide();
    }
});