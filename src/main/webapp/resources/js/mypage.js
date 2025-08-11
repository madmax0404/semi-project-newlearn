const modal = document.getElementById('joinClass');
const openBtn = document.getElementById('openJoin');
const closeBtn = document.getElementById('closeJoin');

document.querySelectorAll('.slider[data-simple-slider]').forEach(el => {
    simpleslider.getSlider(el);
});

if (mpNo == userNo) {
    openBtn.addEventListener('click', () => {
        modal.style.display = 'flex';
    });

    closeBtn.addEventListener('click', () => {
        modal.style.display = 'none';
    });
}

window.addEventListener('click', (e) => {
    if (e.target === modal) {
        modal.style.display = 'none';
    }
});

document.querySelectorAll('.openExit').forEach(button => {
    button.addEventListener('click', (e) => {
        const index = e.currentTarget.dataset.index;
        const modal = document.querySelector('.exitClass[data-index="' + index + '"]');
        if (modal) {
            modal.style.display = 'flex';
        }
    });
});

document.querySelectorAll('.exitClass').forEach(modal => {
    const closeBtn = modal.querySelector('.closeExit');
    closeBtn.addEventListener('click', function (e) {
        modal.style.display = 'none';
    });
});

document.querySelectorAll('.exitClass').forEach(modal => {
    modal.addEventListener('click', function(e) {
        if (e.target === modal) {
            modal.style.display = 'none';
        }
    });
});

function loadContent(type, pageNo, visibility, loadtype, sourceNo, cbFunction) {
    //debugger
    url = contextPath + '/mypage/' + type + '?mypageNo=' + mpNo + '&visibility=' + visibility;
    if (pageNo != undefined) url += '&currentPage=' + pageNo;
    if (type == 'storage') url += '&type=' + loadtype;
    if (loadtype == 'repo') url += '&sourceNo=' + sourceNo;
    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error('에러 발생');
            return response.text();
        })
        .then(html => {
            if (type == 'storage') {
                if (loadtype == 'load') {
                    document.querySelector(".container").innerHTML = html;
                } else {
                    document.querySelector(".storage-main-body").innerHTML = html;
                }
            } else {
                document.querySelector(".container").innerHTML = html;
            }
            if (typeof cbFunction === 'function') cbFunction();
        })
        .catch(error => {
            document.querySelector(".container").innerHTML = '<p>콘텐츠를 불러오지 못했습니다.</p>';
        });
}

function onDateClick(date) {
    fetch(contextPath + '/mypage/calendar?mypageNo=' + mpNo + '&date=' + date)
        .then(response => {
            if (!response.ok) throw new Error('에러 발생');
            return response.text();
        })
        .then(html => {
            document.querySelector(".container").innerHTML = html;
        })
        .catch(error => {
            document.querySelector(".container").innerHTML = '<p>콘텐츠를 불러오지 못했습니다.</p>';
        });
}

$(document).on('click', '.modal-btn', function() {
    const btn = $(this);
    const dmlType = btn.data('dmltype');
    const eventNo = btn.data('eventno');
    
    fetch(contextPath + '/mypage/modal/'+dmlType+'?eventNo='+eventNo)
    .then(response => {
        if (!response.ok) throw new Error('에러 발생');
        return response.text();
    })
    .then(html => {
        document.querySelector(".modal-position").innerHTML = html;
        new bootstrap.Modal(document.getElementById('exampleModal')).show();
    })  
    .catch(error => {
        document.querySelector(".modal-position").innerHTML = '<p>콘텐츠를 불러오지 못했습니다.</p>';
    });
});

$(document).on('submit', '#searchForm', function(e) {
    e.preventDefault();
    const selection = document.querySelector('select[name="selection"]').value;
    const keyword = document.querySelector('input[name="keyword"]').value;

    fetch(contextPath + '/mypage/storage?mypageNo=' + mpNo + "&keyword=" + keyword + "&selection=" + selection)
    .then(response => {
        if (!response.ok) throw new Error('에러 발생');
        return response.text();
    })
    .then(html => {
        document.querySelector(".storage-main-body").innerHTML = html;
    })
    .catch(error => {
        document.querySelector(".storage-main-body").innerHTML = '<p>콘텐츠를 불러오지 못했습니다.</p>';
    });
});

$(document).on('click', '.repo-btn', function() {
    const parentRepoNo = $(this).data('repo-no');
    const currentLevel = parseInt($(this).data('repo-level'));
    const nextLevel = currentLevel + 1;
    const target = $('.repo-item.lvl-'+nextLevel+'.prn-'+parentRepoNo);
    
    $('.repo-item').each(function() {
        const itemLevel = parseInt($(this).find('.repo-btn').data('repo-level'));
        if (itemLevel > currentLevel) {
            $(this).slideUp(200);            
        }
    });
    if (target.css("display") === "none") {
        target.slideDown(200);
    }
    fetch(contextPath + '/mypage/storage?mypageNo='+mpNo+'&sourceNo='+parentRepoNo+'&type=repo')
    .then(response => {
        if (!response.ok) throw new Error('에러 발생');
        return response.text();
    })
    .then(html => {
        document.querySelector(".storage-main-body").innerHTML = html;
    })
    .catch(error => {
        document.querySelector(".storage-main-body").innerHTML = '<p>콘텐츠를 불러오지 못했습니다.</p>';
    });
});

$(document).on('click', '.move-repo-btn', function() {
    const parentRepoNo = $(this).data('repo-no');
    const currentLevel = parseInt($(this).data('repo-level'));
    const nextLevel = currentLevel + 1;
    const target = $('.move-repo-item.lvl-'+nextLevel+'.prn-'+parentRepoNo);
    
    $('.move-repo-item').each(function() {
        const itemLevel = parseInt($(this).find('.move-repo-btn').data('repo-level'));
        if (itemLevel > currentLevel) {
            $(this).slideUp(200);            
        }
    });
    if (target.css("display") === "none") {
        target.slideDown(200);
    }
    document.querySelector("#selectedFolder").innerHTML = $(this).data('dirname');
    document.querySelector("#move-folderNo").value = parentRepoNo;
});

$(document).on('click', '#all-files-btn', function() {
    fetch(contextPath + '/mypage/storage?mypageNo=' + mpNo)
    .then(response => {
        if (!response.ok) throw new Error('에러 발생');
        return response.text();
    })
    .then(html => {
        document.querySelector(".storage-main-body").innerHTML = html;
    })
    .catch(error => {
        document.querySelector(".storage-main-body").innerHTML = '<p>콘텐츠를 불러오지 못했습니다.</p>';
    });
});

$(document).on('click', '#select-all-checkbox', function() {
    const isChecked = $(this).is(':checked');
    $('input[name="file-selection"]').prop('checked', isChecked);
});

$(document).on('click', '#move-files', function() {
    const filesCheckboxes = document.querySelectorAll('input[name="file-selection"]');
    const selectedFiles = Array.from(filesCheckboxes)
                                .filter(chk => chk.checked)
                                .map(chk => chk.value);
    if (selectedFiles.length === 0) {
        alert('이동할 파일을 하나 이상 선택하세요.');
        return;
    }
    document.querySelector("#move-fileNos").value = selectedFiles.join(',');
    document.querySelector("#move-file-modal").style.display = 'flex';
});

$(document).on('click', '.file-edit', function() {
    document.querySelector("#selectedFile").innerHTML = $(this).data('filename');
    document.querySelector("#edit-fileNo").value = $(this).data('fileno');
    document.querySelector("#edit-file-modal").style.display = 'flex';
});

$(document).on('click', '#delete-files', function() {
    const filesCheckboxes = document.querySelectorAll('input[name="file-selection"]');
    const selectedFiles = Array.from(filesCheckboxes)
                                .filter(chk => chk.checked)
                                .map(chk => chk.value);
    if (selectedFiles.length === 0) {
        alert('삭제할 파일을 하나 이상 선택하세요.');
        return;
    }
    document.querySelector("#delete-fileNos").value = selectedFiles.join(',');
    document.querySelector("#delete-file-modal").style.display = 'flex';
});

$(document).on('click', '#new-folder', function() {
    document.querySelector("#new-folder-modal").style.display = 'flex';
});

// $(document).on('click', '#notiSetting', function() {
//     document.querySelector("#notiSettingModal").style.display = 'flex';
//     fetch(contextPath + '/mypage/notiSetMod?mypageNo='+mpNo)
//     .then(response => {
//         if (!response.ok) throw new Error('에러 발생');
//         return response.text();
//     })
//     .then(html => {
//         document.querySelector("#notiSettingModal").innerHTML = html;
//     })
//     .catch(error => {
//         document.querySelector("#notiSettingModal").innerHTML = '<p>콘텐츠를 불러오지 못했습니다.</p>';
//     });
// });
$(document).on('click', '#notiSetting', function() {
    $("#notiSettingModal").css('display','flex');
    fetch(contextPath + '/mypage/notiSetMod?mypageNo='+mpNo)
      .then(r => { if(!r.ok) throw new Error(); return r.text(); })
      .then(html => { document.querySelector("#notiSettingModal").innerHTML = html; })
      .catch(() => { document.querySelector("#notiSettingModal").innerHTML = '<p>콘텐츠를 불러오지 못했습니다.</p>'; });
});

// 클래스룸 선택 시 알림 체크박스 로드 (교체)
$(document).off('change', '#classroomItem').on('change', '#classroomItem', function () {
  const classNo = this.value;
  const $panel = $('#classNotiMod');

  // 선택 해제 시 비우고 종료
  if (!classNo) { $panel.html('<p>클래스룸을 선택하세요.</p>'); return; }

  fetch(`${contextPath}/mypage/classNotiMod?classNo=${encodeURIComponent(classNo)}&userNo=${encodeURIComponent(mpNo)}`)
    .then(resp => {
      if (!resp.ok) throw new Error('bad status');
      return resp.json();
    })
    .then(res => {
      // 서버가 true/false 또는 'Y'/'N' 또는 필드명이 살짝 다른 경우까지 처리
      const pick = (obj, keys) => keys.find(k => Object.prototype.hasOwnProperty.call(obj, k));
      const yes = v => (v === 'Y' || v === 'y' || v === '1' || v === 1 || v === true);

      const aKey = pick(res, ['announcementNoti','accouncementNoti','noticeNoti']) || 'announcementNoti';
      const asgKey = pick(res, ['assignmentNoti','assignNoti']) || 'assignmentNoti';
      const shKey = pick(res, ['sharedEventNoti','shareEventNoti']) || 'sharedEventNoti';
      const pKey = pick(res, ['personalEventNoti','personalNoti']) || 'personalEventNoti';

      const a = yes(res[aKey]);
      const b = yes(res[asgKey]);
      const c = yes(res[shKey]);
      const d = yes(res[pKey]);

      const html = `
        <input type="hidden" name="classNo" value="${classNo}">
        <label><input type="checkbox" name="classNoti" value="announcement" ${a ? 'checked' : ''}> 공지사항</label><br>
        <label><input type="checkbox" name="classNoti" value="assignment" ${b ? 'checked' : ''}> 과제제출</label><br>
        <label><input type="checkbox" name="classNoti" value="sharedEvent" ${c ? 'checked' : ''}> 공유이벤트</label><br>
        <label><input type="checkbox" name="classNoti" value="personalEvent" ${d ? 'checked' : ''}> 개인일정</label><br>
      `;
      $panel.html(html);
    })
    .catch(err => {
      console.error('classNotiMod error:', err);
      $panel.html('<p>알림 정보를 불러오지 못했습니다.</p>');
    });
});


// $(document).on('change', '#classroomItem', function() {
//     classNo = document.querySelector("#classroomItem").value;
//     fetch(contextPath + '/mypage/classNotiMod?classNo='+classNo+'&userNo='+mpNo)
//     .then(response => {
//         if (!response.ok) throw new Error('에러 발생');
//         return response.json();
//     })
//     .then(res => {
//         let html = '<input type="hidden" name="classNo" value="'+classNo+'">';
//         html += `<label><input type="checkbox" name="classNoti" value="announcement" 
//             ${res.accouncementNoti == 'Y' ? 'checked' : ''}>공지사항</label><br>`;
//         html += `<label><input type="checkbox" name="classNoti" value="assignment" 
//             ${res.assignmentNoti == 'Y' ? 'checked' : ''}>과제제출</label><br>`;
//         html += `<label><input type="checkbox" name="classNoti" value="sharedEvent" 
//             ${res.sharedEventNoti == 'Y' ? 'checked' : ''}>공유이벤트</label><br>`;
//         html += `<label><input type="checkbox" name="classNoti" value="personalEvent" 
//             ${res.personalEventNoti == 'Y' ? 'checked' : ''}>개인일정</label><br>`;
//         document.querySelector("#classNotiMod").innerHTML = html;
//     })
//     .catch(error => {
//         document.querySelector("#classNotiMod").innerHTML = '<p>클래스룸을 선택해주세요.</p>';
//     });
// });

$(document).on('change', '#classroomAtt', function() {
    date = $(this).data('date');
    selectedClassNo = document.querySelector("#classroomAtt").value;
    fetch(contextPath + '/mypage/calendar/calcAttRate?mypageNo=' + mpNo + '&classNo=' + selectedClassNo
        + '&selectedDate=' + date)
    .then(response => {
        if (!response.ok) throw new Error('에러 발생');
        return response.json();
    })
    .then(res => {
        const formattedRate = res.monthlyAttRate.toFixed(2);
        const entryTime = formatTime(res.entryTime);
        const exitTime = (res.exitTime == "" ? "" : formatTime(res.exitTime));

        let html = `<p>${res.month}월 출석률 : ${formattedRate}%</p>`;
        html += `<p>${res.day}일 입실시간 ${entryTime}</p>`;
        html += `<p>${res.day}일 퇴실시간 ${exitTime}</p>`;
        document.querySelector("#classAttMod").innerHTML = html;
    })
    .catch(error => {
        document.querySelector("#classAttMod").innerHTML = '<p>클래스룸을 선택해주세요.</p>';
    });
});

function formatTime(datetimeStr) {
    if (!datetimeStr) return "-";
    const date = new Date(datetimeStr);
    return date.toLocaleTimeString('ko-KR', {
        hour: '2-digit',
        minute: '2-digit',
        hour12: true
    });
}

// 모달 창 닫기
window.addEventListener('click', e => {
    if (e.target === document.querySelector("#move-file-modal")) {
        document.querySelector("#move-file-modal").style.display = 'none';
        document.querySelector("#move-fileNos").value = "";
        document.querySelector("#selectedFolder").innerHTML = "";
        document.querySelector("#move-folderNo").value = "";
    }
    if (e.target === document.querySelector("#edit-file-modal")) {
        document.querySelector("#edit-file-modal").style.display = 'none';
        document.querySelector('input[name="newFileName"]').value = "";
        document.querySelectorAll('input[name="visibility"]').forEach(chk => chk.checked = false);
    }
    if (e.target === document.querySelector("#delete-file-modal")) {
        document.querySelector("#delete-file-modal").style.display = 'none';
        document.querySelector("#delete-fileNos").value = "";
    }
    if (e.target === document.querySelector("#new-folder-modal")) {
        document.querySelector("#new-folder-modal").style.display = 'none';

    }
    if (e.target === document.querySelector("#notiSettingModal")) {
        document.querySelector("#notiSettingModal").style.display = 'none';
    }
    if (e.target === document.querySelector("#editProfileMod")) {
        document.querySelector("#editProfileMod").style.display = 'none';
        document.querySelector("#currentPw").value = "";
    }
    if (e.target === document.querySelector("#slidingImgMod")) {
        document.querySelector("#slidingImgMod").style.display = 'none';
    }
});

$(document).on('click', '#editProfileBtn', function() {
    document.querySelector("#editProfileMod").style.display = 'flex';
});

$(document).on('click', '#slidingImgBtn', function() {
    fetch(contextPath + '/mypage/imgSlider?mypageNo=' + mpNo)
    .then(response => {
        if (!response.ok) throw new Error('에러 발생');
        return response.text();
    })
    .then(html => {
        document.querySelector(".container").innerHTML = html;
    })
    .catch(error => {
        document.querySelector(".main-body").innerHTML = '<p>콘텐츠를 불러오지 못했습니다.</p>';
    });
});

$(document).on('click', '#newImgUpload', function() {
    clickCnt = $(this).data('click-cnt');
    imgSize = $(this).data('img-size');

    if (imgSize + clickCnt <= 30) {
        const html = 
        `<tr>
            <th><label for="image">업로드 이미지${clickCnt}</label></th>
            <td>
                <div class="input-wrapper">
                    <input type="file" name="upfile" class="form-control inputImage" 
                        accept="images/*" id="img${imgSize + clickCnt}">
                    <button type="button" class="delete-image" data-img-id="${imgSize + clickCnt}">&times;</button>
                </div>
                <br>
            </td>
        </tr>`;
        $('#newUploads').append(html);
        $(this).data('click-cnt', $(this).data('click-cnt') + 1);
    }
});

$(document).on('click', '.delete-image', function() {
    document.querySelector("#img"+$(this).data('img-id')).value = "";
});

$(document).on('click', '.changeImgBtn', function() {
    if(confirm("기존 사진은 영구적으로 삭제됩니다. 정말 변경하시겠습니까?")) {
        document.querySelector("#imgPrev"+$(this).data('img-id')).style.display = 'none';
        document.querySelector("#img"+$(this).data('img-id')).style.display = 'flex';
        fetch(contextPath + '/mypage/deleteSlidingImg?imgNo=' + $(this).data('img-no'))
        .then(response => {
            if (!response.ok) throw new Error('에러 발생');
            return response.json();
        })
        .then(res => {

        })
        .catch(error => {
            
        });
    }
});

$(document).on('click', '.deleteImgBtn', function() {
    document.querySelector("#imgPrev"+$(this).data('img-id')).removeAttribute("src");
    if(confirm("정말 삭제하시겠습니까?")) {
        fetch(contextPath + '/mypage/deleteSlidingImg?imgNo=' + $(this).data('img-no'))
        .then(response => {
            if (!response.ok) throw new Error('에러 발생');
            return response.json();
        })
        .then(res => {
            alert(res.response);
        })
        .catch(error => {
            
        });
    }
});

$(document).on('change', '.inputImage', function() {
    const id = $(this).attr("id");
    const index = id.replace(/\D/g, "");
    const imgTag = document.querySelector("#imgPrev"+index);
    if (imgTag != null) {
        imgTag.style.display = 'none';
    }
});

//////////////////

// 모달 열기
$("#open-modal-btn").on("click", function () {
    $("#create-modal-bg").addClass("active");
    $("#classroom-name").focus();
});


// 모달 닫기
$("#cancel-modal-btn, .modal-bg").on("click", function (e) {
    // 배경 클릭 시만 닫히도록
    if (e.target === this)
        $("#create-modal-bg").removeClass("active");
});


// 폼 제출 처리
$("#create-btn").on("click", function (e) {
    e.preventDefault();
    const className = $("#classroom-name").val().trim();
    const classCode = $("#classroom-code").val().trim();
    let url = window.location.pathname; // "/new-learn/mypage/113"
    let userNo = url.split('/').filter(Boolean).pop(); // "113"
    console.log(userNo); // 결과: "113"
    console.log(className);
    console.log(classCode);


    if (!className || !classCode) {
        alert("모든 값을 입력하세요!");
        return;
    }
    // 여기서 AJAX 등 서버에 전송 가능
    alert("클래스룸 이름: " + className + "\n입장 코드: " + classCode);


    $("#create-modal-bg").removeClass("active");
    // $(this)[0].reset();


    $.ajax({
        url: contextPath + "/mypage/createClass",
        type: "POST",
        data: {
            className,
            classCode,
            userNo
        },
        // beforeSend: function(xhr) {
        //     xhr.setRequestHeader(window.csrf.header, window.csrf.token);
        // },
        success: function(res) {
            console.log(res);
            if (res > 0) {
                alert("클래스 생성 성공.");
            } else {
                alert("클래스 생성 실패.");
            }
            location.reload();
        },
        error: function(error) {
            console.log(error);
            alert("클래스 생성 실패.");
        }
    });
});
