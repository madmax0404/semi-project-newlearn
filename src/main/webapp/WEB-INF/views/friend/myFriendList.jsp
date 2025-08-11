<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>친구관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/friend.css">
<meta id="_csrf" name="_csrf" content="${_csrf.token}"/>
<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
	
    
  
    <sec:csrfMetaTags />
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />



<div class="search-container">
    <div class="search-box">
        <div class="search-icon" onclick="searchAllUsers()" onkeypress="search">🔍</div>
        <input   type="text" id="searcMember"   placeholder="이름을 입력하세요" />
        <div class="clear-btn" onclick="clearInput()">지우기</div>
        
    </div>
    <div class="sort-box">
        <select id="sortSelect" onchange="sortFriends()">
            <option value="name" selected>이름순</option>
            <option value="new">최신순</option>
            <option value="old">오래된순</option>
        </select>
    </div>
</div>

<div class="container">
    <div class="sidebar">
        <button class="btn btn-outline-primary" >전체 친구 목록</button>
        <button class="btn btn-outline-primary">즐겨찾기</button>
        <button class="btn btn-outline-primary">숨긴 친구 목록</button>
        <button class="btn btn-outline-primary" id="requestListBtn">요청 목록</button>
    </div>

    <div class="main">
        <div class="friend-grid">
            <c:forEach var="friend" items="${friendList}">
                <div class="friend-card" data-userno="${friend.userNo }">
                <!-- 디버깅용 출력 -->
                    <div class="friend-info">
                        <div class="avatar"></div>
                        <div class="friend-name">${friend.userName}</div>
                         
                        <button  class="message-btn" class="btn btn-primary">메시지</button>
                        
                    </div>
                    <div class="options">
                        ⋯
                        <div class="options-menu">
                           <div class="delete-btn" data-userno="${friend.userNo}">삭제</div>
                            <div class="profile-btn" 
                            	data-name="${friend.userName}"
                            	data-email="${friend.email }">프로필 보기</div>
                             <div class="fav-btn" data-userno="${friend.userNo}">즐겨찾기</div>
                           <div class="hide-btn" data-userno="${friend.userNo}">숨기기</div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="friend-request-container"  >
        <div class="friend-card">
          <div class="friend-info">
            <div class="avatar"></div>
            <div class="friend-name">${friendUserName }</div>
            <div class="friend-email">${email }</div>
          </div>
          <div class="request-buttons">
            <button class="accept-btn" onclick="accept(${friend.userNo})">수락</button>
            <button class="reject-btn">거절</button>
          </div>
        </div>
        </div>
      </div>
    </div>


<div id="profilePopup">
    <div class="profile-card" >
        <div class="profile-avatar" ></div>
        <div class="profile-name">${friend.userName}</div>
        <div class="profile-status">소개</div>
        <div class="profile-email">${friend.email}</div>
        <div class="profile-buttons">
            <a href="${pageContext.request.contextPath}/chat/main" class="btn btn-primary">💬 메시지 보내기</a>
            <button class="fav-btn  btn-primary" data-userno="${friend.userNo}" onclick="favFriendFromPopup(this)">⭐ 즐겨찾기</button>
            <button class="hide-btn btn-primary" data-userno="${friend.userNo}" onclick="hideFriendFromPopup(this)">🕵️ 숨기기</button>
        </div>
        
    </div>
</div>


 <div class="friend-popup" id="friendRequestPopup">
    <div class="popup-header">
      친구초대 요청이 도착했습니다
      <button class="close-btn" onclick="closePopup()">✕</button>
    </div>
    <div class="popup-body">
      <div class="popup-img"></div>
      <div class="popup-info">
        <div class="popup-name">${friend.userName}</div>
        <div class="popup-email">${friend.email}</div>
      </div>
      <div class="popup-actions">
        <button class="accept-btn" onclick="acceptFromPopup(this)">수락</button>
  <button class="reject-btn" onclick="rejectFromPopup(this)">거절</button>
      </div>
    </div>
  </div> 
  
  <div class="afriend-popup" id="friendAcceptPopup">
    <div class="apopup-header">
      친구초대 요청을 수락 했습니다
      <button class="close-btn" onclick="closePopup()">✕</button>
    </div>
    <div class="apopup-body">
      <div class="apopup-img"></div>
      <div class="apopup-info">
        <div class="apopup-name">${friend.userName}</div>
        <div class="apopup-email">${friend.email}</div>
      </div>
      
    </div>
  </div> 
  
  
  
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>





//정렬
let fullFriendList = [];
let myFriendList = [];

function sortFriends() {
	
	  const selected = document.getElementById("sortSelect").value;
	  let sortedList = [...fullFriendList];

	  if (selected === "name") {
	    sortedList.sort((a, b) => a.userName.localeCompare(b.userName));
	  } else if (selected === "new") {
	    sortedList.sort((a, b) => b.RESPONSEDATE - a.RESPONSEDATE);
	  } else if (selected === "old") {
	    sortedList.sort((a, b) => a.RESPONSEDATE - b.RESPONSEDATE);
	  }
	  sortedList.forEach(friend => {
		    console.log(friend.userName, friend.RESPONSEDATE);
		  });

	  renderFriendList(sortedList);
	}



	// 즐겨찾기
	function FavoriteButtons(friendUserNo) {
const header = document.querySelector('meta[name=_csrf_header]').content;
const token = document.querySelector('meta[name=_csrf]').content;
const favListBtn = document.querySelector('.sidebar button:nth-child(2)');

console.log("즐겨찾기 클릭됨:", friendUserNo);

fetch(`favoritBtn?friendUserNo=\${friendUserNo}`, {
 method: 'POST',
 headers: {
   'header': header,
   'X-CSRF-Token': token,
   "Content-Type": "application/json"
 },
 body: JSON.stringify({ friendUserNo })
})
 .then(response => response.text())
 .then(result => {
   

   

   if (result === 'Y') {
     
     alert("즐겨찾기 되었습니다.");
   } else if (result === 'N') {
     
     alert("즐겨찾기 해제 되었습니다.");
     if (favListBtn) favListBtn.click(); // 즐겨찾기 목록 새로고침
   } else {
     alert("즐겨찾기 처리 실패");
   }
 })
 .catch(error => {
   console.error("즐겨찾기 오류:", error);
   alert("오류가 발생했습니다.");
 });
}
	
	// 프로필에서 즐겨찾기
	function favFriendFromPopup(button) {
	  const friendUserNo = button.getAttribute('data-userno');
	  console.log("숨기기 클릭됨:", friendUserNo);
	  const allFriendsBtn = document.querySelector('.sidebar button:nth-child(1)');

	  FavoriteButtons(friendUserNo);  // 기존 숨기기 함수 재사용
	  const popup = document.getElementById('profilePopup');
	  if (popup) popup.style.display = 'none';
	  if (allFriendsBtn) allFriendsBtn.click(); // 전체 친구 목록 새로고침
	}
	
	
	
	

	<!-- 친구 삭제 -->
	function deleteFriend(friendUserNo) {
		  if (!confirm("정말 삭제하시겠습니까?")) return;
		  const header = document.querySelector('meta[name=_csrf_header]').content;
		  const token = document.querySelector('meta[name=_csrf]').content;
		  const allFriendsBtn = document.querySelector('.sidebar button:nth-child(1)');
		  console.log("삭제 클릭됨:", friendUserNo);
		  fetch(`deleteBtn?friendUserNo=\${friendUserNo}`, {
			  method: 'POST',
	  	    headers: {
	  			  'header': header,
	  			  'X-CSRF-Token': token,
	  	        "Content-Type": "application/json",          
	  	    },
	  	    body:JSON.stringify({ friendUserNo: friendUserNo })
	  	})
		    .then(res => res.text())
		    .then(result => {
		      if (result === "success") {
		        alert("친구가 삭제되었습니다.");
		        // 전체 친구 목록 버튼 클릭으로 자동 새로고침
		        if (allFriendsBtn) allFriendsBtn.click();
		      } else {
		        alert("삭제에 실패했습니다.");
		      }
		    })
		    .catch(err => {
		      console.error("삭제 요청 실패:", err);
		      alert("삭제 중 오류가 발생했습니다.");
		    });
		}

	<!-- 숨기기 기능 -->
	function hideFriend(friendUserNo) {
		  const allFriendsBtn = document.querySelector('.sidebar button:nth-child(1)');
		  const hideBtn = document.querySelector('.sidebar button:nth-child(3)');
		  const header = document.querySelector('meta[name=_csrf_header]').content;
		  const token = document.querySelector('meta[name=_csrf]').content;

		  console.log("숨기기 클릭됨:", friendUserNo);

		  fetch(`hide?friendUserNo=\${friendUserNo}`, {
		    method: 'POST',
		    headers: {
		      'header': header,
		      'X-CSRF-Token': token,
		      "Content-Type": "application/json"
		    },
		    body: JSON.stringify({ friendUserNo: friendUserNo })
		  })
		    .then(response => response.text())
		    .then(result => {

		        // ✅ alert 및 목록 새로고침
		        if (result === 'Y') {
		          alert("숨김 처리되었습니다.");
		          if (allFriendsBtn) allFriendsBtn.click();
		        } else if (result === 'N') {
		          alert("숨김이 해제되었습니다.");
		          if (hideBtn) hideBtn.click();
		        } else {
		          alert("처리 중 오류가 발생했습니다.");
		        }
		      })
		      .catch(err => {
		        console.error("숨기기 오류:", err);
		        alert("숨기기 처리 중 오류 발생");
		      });
		  }
	
		// 프로필에서 숨기기
		function hideFriendFromPopup(button) {
		  const friendUserNo = button.getAttribute('data-userno');
		  console.log("숨기기 클릭됨:", friendUserNo);
		  const allFriendsBtn = document.querySelector('.sidebar button:nth-child(1)');

		  hideFriend(friendUserNo);  // 기존 숨기기 함수 재사용
		  const popup = document.getElementById('profilePopup');
		  if (popup) popup.style.display = 'none';
		  if (allFriendsBtn) allFriendsBtn.click(); // 전체 친구 목록 새로고침
		}
		
		
	 

//유저 검색기능

	function loadMyFriendList() {
fetch('reFriendList')
 .then(response => response.json())
 .then(data => {
   myFriendList = data.map(friend => friend.userNo);
   console.log("내 친구 목록 (응답 후):", myFriendList); // ✅ 이게 정확한 위치
 })
 .catch(error => {
   console.error("친구 목록 로딩 실패:", error);
 });
}



function searchAllUsers() {
	 const keyword = document.getElementById("searcMember").value.trim();
	  if (keyword === "") return;  // 빈 입력일 경우 아무 작업도 하지 않음

	  fetch(`searchMember?keyword=\${encodeURIComponent(keyword)}`)
	    .then(response => response.json())
	     .then(data => {
       console.log('검색 응답 데이터:', data);
	      const grid = document.querySelector(".friend-grid");
	      grid.innerHTML = "";

	      if (data.length === 0) {
	        grid.innerHTML = "<p>검색 결과가 없습니다.</p>";
	        return;
	      }

	      data.forEach(user => {
	    	  const isFriend = myFriendList.includes(Number(user.userNo));

	          let card = "";

	          if (isFriend) {
	            // 이미 친구인 경우: 기존 카드 디자인
	            card = `
	              <div class="friend-card" data-userno="\${user.userNo}">
	                <div class="friend-info">
	                  <div class="avatar"></div>
	                  <div class="friend-name">\${user.userName}</div>
	                  <button class="message-btn">메시지</button>
	                </div>
	                <div class="options">
	                  ⋯
	                  <div class="options-menu">
	                    <div class="delete-btn" onclick="deleteFriend(\${user.userNo})">삭제</div>
	                    <div class="profile-btn" 
	                         data-name="\${user.userName}"
	                         data-email="\${user.email}">프로필 보기</div>
	                    <div class="fav-btn" data-userno="\${user.userNo}">즐겨찾기</div>
	                    <div class="hide-btn" data-userno="\${user.userNo}">숨기기</div>
	                  </div>
	                </div>
	              </div>
	            `;
	          } else {
	            // 친구 아닌 경우: 친구 요청 카드
	            card = `
	              <div class="friend-card" data-userno="\${user.userNo}">
	                <div class="friend-info">
	                  <div class="avatar"></div>
	                  <div class="friend-name">\${user.userName}</div>
	                </div>
	                <div class="friend-actions">
	                  <button class="accept-btn" onclick="send(\${user.userNo})">친구 요청</button>
	                </div>
	              </div>
	            `;
	          }

	          grid.innerHTML += card;
	        });
	      });
	  }
	    	  
	    	  
	    	 
	
	// 친구요청보내기
	function send(friendUserNo) {
		var header = document.querySelector('meta[name=_csrf_header]').content;
	  	var token = document.querySelector('meta[name=_csrf]').content;
	  	const allFriendsBtn = document.querySelector('.sidebar button:nth-child(1)');
	  	console.log("보낼 유저 번호:", friendUserNo); // ← 디버깅
	  	console.log(token, header)
fetch(`send?friendUserNo=\${friendUserNo}`, {
 method: 'POST',
 headers: {
		  'header': header,
		  'X-CSRF-Token': token,
     "Content-Type": "application/json",          
 },
 body:JSON.stringify({ friendUserNo: friendUserNo })
})
.then(response => response.text())
.then(result => {
	  if (result === 'success') {
	      alert('요청을 보냈습니다');
	      if (allFriendsBtn) {
	    	  allFriendsBtn.click();
	    } else {
	      alert('요청 보내기 실패');
	    }
	    }
	  });
	}

//친구 요청 수락
	function accept(friendUserNo) {
	
		console.log('클릭됨', friendUserNo)
		const requestListBtn = document.querySelector('.sidebar button:nth-child(4)'); 
	  	var header = document.querySelector('meta[name=_csrf_header]').content;
	  	var token = document.querySelector('meta[name=_csrf]').content;
		console.log(token, header)
	
	  	fetch(`accept?friendUserNo=\${friendUserNo}`, {
		  method: 'POST',	    
		  headers: {
			  'header': header,
			  'X-CSRF-Token': token,
	          "Content-Type": "application/json",          
	      },
	      body: {
	    	  friendUserNo,
	      }
	    
	  })
		  .then(response => response.text())
		  .then(result => {
		    if (result === 'success') {
		      alert('친구 요청을 수락했습니다.');
		      if (requestListBtn) {
		          requestListBtn.click();
		    } else {
		      alert('수락에 실패했습니다.');
		    }
		    }
		  });
		}


	// 요청 거절
	function reject(friendUserNo) {
	const requestListBtn = document.querySelector('.sidebar button:nth-child(4)'); 
	var header = document.querySelector('meta[name=_csrf_header]').content;
	var token = document.querySelector('meta[name=_csrf]').content;
	console.log(token, header)
	fetch(`reject?friendUserNo=\${friendUserNo}`, {
	  method: 'POST',	    
	  headers: {
		  'header': header,
		  'X-CSRF-Token': token,
       "Content-Type": "application/json",          
   },
   body: {
 	  friendUserNo,
   }
 
})
.then(response => response.text())
.then(result => {
 if (result === 'success') {
   alert('친구 요청을 거절했습니다.');
   if (requestListBtn) {
       requestListBtn.click();
 } else {
   alert('거절에 실패했습니다.');
 }
 }
});
}
	
	// 팝업 수락 거절
	function acceptFromPopup(button) {
		  const friendUserNo = button.getAttribute('data-userno');
		  const allFriendsBtn = document.querySelector('.sidebar button:nth-child(1)');
		  accept(friendUserNo); // 기존 함수 재사용
		  closePopup(); // 팝업 닫기
		  allFriendsBtn.click(); // 전체 친구 목록으로 이동
		}

		function rejectFromPopup(button) {
		  const friendUserNo = button.getAttribute('data-userno');
		  const allFriendsBtn = document.querySelector('.sidebar button:nth-child(1)');
		  reject(friendUserNo); // 기존 함수 재사용
		  closePopup(); // 팝업 닫기
		  allFriendsBtn.click();// 전체 친구 목록으로 이동
		}
	
	
	// 친구랜더링
	function renderFriendList(data) {
		const friendGrid = document.querySelector('.friend-grid');
		const requestContainer = document.querySelector('.friend-request-container');
	      friendGrid.innerHTML = '';
	     
	      requestContainer.style.display = 'none';

	      data.forEach(friend => {
	        const card = document.createElement('div');
	        card.className = 'friend-card';
	        card.setAttribute('data-userno', friend.userNo);
	        card.innerHTML = `
	        	
	          <div class="friend-info">
	            <div class="avatar"></div>
	            <div class="friend-name">\${friend.userName}</div>
	            
	            <button class="message-btn">메시지</button>
	          </div>
	          <div class="options">
	            ⋯
	            <div class="options-menu">
	            <div class="delete-btn" onclick="deleteFriend(\${friend.userNo})">삭제</div>
	              <div class="profile-btn"
	                  data-name="\${friend.userName}"
	                  data-email="\${friend.email}">프로필 보기</div>
	                  <div class="fav-btn" data-userno="\${friend.userNo}" onclick="FavoriteButtons(\${friend.userNo})">즐겨찾기</div>
	                  <div class="hide-btn" data-userno="\${friend.userNo}" onclick="hideFriend(\${friend.userNo})">숨기기</div>
	            </div>
	          </div>
	        `;
	        friendGrid.appendChild(card);
	      });
	      
	      
	    }



document.addEventListener('DOMContentLoaded', () => {
 const contextPath = "${pageContext.request.contextPath}";
 const friendGrid = document.querySelector('.friend-grid');
 const requestContainer = document.querySelector('.friend-request-container');
 const allFriendsBtn = document.querySelector('.sidebar button:nth-child(1)');
 const favBtn = document.querySelector('.sidebar button:nth-child(2)');
 const hideBtn = document.querySelector('.sidebar button:nth-child(3)');
 const requestListBtn = document.querySelector('.sidebar button:nth-child(4)');
 sortFriends(); 
 
 
 
  loadMyFriendList();
 
 
 let stompClient = null;
	const myUserNo = ${loginUser.userNo}; // JSTL로 현재 로그인한 사용자 번호 전달
	connectSocket(myUserNo);
	
	// WebSocket 연결
	function connectSocket(userNo) {
	  const socket = new SockJS("${pageContext.request.contextPath}/stomp"); // WebSocket 엔드포인트
	  stompClient = Stomp.over(socket);
	
	  stompClient.connect({}, function (frame) {
	    console.log("웹소켓 연결 성공:", frame);
	
	    // 친구 요청 알림 수신 구독
	    stompClient.subscribe("/topic/friendRequest/" + userNo, function (message) {
	      const data = JSON.parse(message.body);
	      console.log("📨 알림 메시지 수신:", message.body);
	      
	      showFriendRequestPopup(data); // 팝업 표시
	    });
	    stompClient.subscribe("/topic/friendAccept/" + userNo, function (message) {
	    	  const data = JSON.parse(message.body); // {type:"ACCEPT", userNo, userName, email}
	    	  showFriendAcceptPopup(data);
	    	});
	  });
	  
	}
	
	// 팝업에 사용자 정보 바인딩
	function showFriendRequestPopup(data) {
		console.log("🚨 showFriendRequestPopup 호출됨", data);
	  const popup = document.getElementById("friendRequestPopup");
	
	  popup.querySelector(".popup-name").textContent = data.userName;
	  popup.querySelector(".popup-email").textContent = data.email;
	  popup.querySelector(".accept-btn").setAttribute("data-userno", data.userNo);
	  popup.querySelector(".reject-btn").setAttribute("data-userno", data.userNo);
	
	  popup.style.display = "block";
	}
	
	function showFriendAcceptPopup(data) {
		console.log("🚨 showFriendAcceptPopup 호출됨", data);
	  const popup = document.getElementById("friendAcceptPopup");
	
	  popup.querySelector(".apopup-name").textContent = data.userName;
	  popup.querySelector(".apopup-email").textContent = data.email;
	  
	  popup.style.display = "block";
	}
	
 
 
 
 
	// 엔터로 검색
 
	document.getElementById("searcMember").addEventListener("keydown", function (e) {
 	  if (e.key === "Enter") {
 	    e.preventDefault(); // form 제출 방지
 	    searchAllUsers();   // 검색 실행 함수 호출
 	  }
 	});
 
 
 // 전체 친구 리스트
 allFriendsBtn.addEventListener('click', () => {
 	console.log('메인 버튼 클릭됨');
 	 friendGrid.style.display = 'flex'; 
 	  requestContainer.style.display = 'none'; 
 	  const sortBox = document.querySelector('.sort-box');
 	  if (sortBox) sortBox.style.display = 'flex';
   friendGrid.innerHTML = '';
   fetch('reFriendList')
     .then(res => res.json())
     .then(data => {
     	  fullFriendList = data;
     	  document.getElementById("sortSelect").value = "name"; // 이름순 선택
           sortFriends();
         console.log('메인 응답 데이터:', data);
       })
       .catch(err => console.error('메인 에러:', err));
   });

 // 즐겨찾기 친구만 보기
 favBtn.addEventListener('click', () => {
   console.log('즐겨찾기 버튼 클릭됨');
   friendGrid.style.display = 'flex'; 
   requestContainer.style.display = 'none'; 
   const sortBox = document.querySelector('.sort-box');
   if (sortBox) sortBox.style.display = 'none';
   fetch(`favList`)
     .then(res => res.json())
     .then(data => {
     	  fullFriendList = data;
       console.log('즐겨찾기 응답 데이터:', data);
       if (data.length === 0) {
           friendGrid.innerHTML = '<p>즐겨찾기된 친구가 없습니다.</p>';
         } else {
           renderFriendList(data);
         }
       })
       .catch(err => {
         console.error('숨기기 에러:', err);
         friendGrid.innerHTML = '<p>즐겨찾기 목록을 불러오지 못했습니다.</p>';
       });
   });

 // 숨긴 친구 보기
 hideBtn.addEventListener('click', () => {
 	console.log('숨기기 버튼 클릭됨');
 	friendGrid.style.display = 'flex'; 
 	requestContainer.style.display = 'none'; 
 	const sortBox = document.querySelector('.sort-box');
 	  if (sortBox) sortBox.style.display = 'none';
   friendGrid.innerHTML = '';
   fetch(`hideList`)
     .then(res => res.json())
     .then(data => {
     	  fullFriendList = data;
         console.log('숨기기 응답 데이터:', data);
         if (data.length === 0) {
             friendGrid.innerHTML = '<p>숨긴 친구가 없습니다.</p>';
           } else {
             renderFriendList(data);
           }
         })
         .catch(err => {
           console.error('숨기기 에러:', err);
           friendGrid.innerHTML = '<p>숨긴 친구 목록을 불러오지 못했습니다.</p>';
         });
     });

 // 요청 목록 보기
  requestListBtn.addEventListener('click', () => {
 	console.log('요청목록 버튼 클릭됨');
 	 friendGrid.style.display = 'none';
 	  requestContainer.style.display = 'flex';
 	  const sortBox = document.querySelector('.sort-box');
 	  if (sortBox) sortBox.style.display = 'none';
   friendGrid.innerHTML = '';
   requestContainer.innerHTML = '';
   fetch(`requestList`)
     .then(res => res.json())
     .then(data => {
         console.log('요청목록 응답 데이터:', data);
         if (data.length === 0) {
             requestContainer.innerHTML = '<p>요청이 없습니다.</p>';
           } else {
             data.forEach(friend => {
               const card = document.createElement('div');
               card.className = 'friend-card';
               card.innerHTML = `
                 <div class="friend-info">
                   <div class="avatar"></div>
                   <div class="friend-name">\${friend.userName}</div>
                   
                 </div>
                 <div class="request-buttons">
                   <button class="accept-btn" onclick="accept(\${friend.userNo})">수락</button>
                   <button class="reject-btn" onclick="reject(\${friend.userNo})">거절</button>
                 </div>
               `;
               requestContainer.appendChild(card);
             });
           }
         })
         .catch(err => console.error('요청목록 에러:', err));
     });

 // 프로필 보기
 document.addEventListener('click', function (e) {
   if (e.target.classList.contains('profile-btn')) {
 	  const userName = e.target.dataset.name;
 	    const email = e.target.dataset.email;
 	    const userNo = e.target.closest('.friend-card')?.dataset.userno;

 	    document.querySelector('.profile-name').textContent = userName;
 	    document.querySelector('.profile-email').textContent = email;

 	    // ⭐ userNo를 동적으로 숨기기 버튼에 주입
 	    document.querySelector('#profilePopup .hide-btn').setAttribute('data-userno', userNo);

 	    // ⭐ 필요하다면 즐겨찾기 버튼도 동일하게 주입
 	    document.querySelector('#profilePopup .fav-btn')?.setAttribute('data-userno', userNo);

 	    // 팝업 열기
 	    document.getElementById('profilePopup').style.display = 'flex';
 	  }
 	});

 // 프로필 닫기
 window.addEventListener('keydown', function (e) {
   if (e.key === 'Escape') {
     document.getElementById('profilePopup').style.display = 'none';
   }
 });
 document.getElementById('profilePopup').addEventListener('click', function (e) {
   if (e.target.id === 'profilePopup') {
     e.target.style.display = 'none';
   }
 });

 if (allFriendsBtn) allFriendsBtn.click();

}); // DOMContentLoaded 끝

	// 알림 팝업 닫기
function closePopup() {
   document.getElementById("friendRequestPopup").style.display = "none";
   document.getElementById("friendAcceptPopup").style.display = "none";
 }

function clearInput() {
	  const input = document.getElementById("searcMember"); // 검색창 ID에 맞게 수정
	  if (input) {
	    input.value = '';
	    input.focus(); // 커서 다시 포커스
	  }

	  
	}

</script>
	
</body>
</html>
