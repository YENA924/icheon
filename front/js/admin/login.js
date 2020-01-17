ADMIN.login = {
    init: null, // 시작
    idPwChk: null, // 로그인 아이디, 비밀번호 확인
    loginSessionChk: null, // 로그인 세션 확인
    rememberMe: null, // 로그인 아이디 저장
    getNotice: null, // 공지사항 불러오기
    createTabBoard: null, // 탭메뉴 게시판 만들기

    adminId: '',
    adminPw: '',
    loginCheck: '',
    rememberChk: '',
}

// initialize
ADMIN.login.init = function (){
    var self = ADMIN.login;
    var btnLogin = document.getElementById('btnLogin');
    var rememberId = document.getElementById('rememberId');
    var adminId = document.getElementById('adminId');
    var adminPw = document.getElementById('adminPw');
    var delay = (function() {
        var timer = 0;
        return function(callback, ms){
            clearTimeout (timer);
            timer = setTimeout(callback, ms);
        };
    })();

    // 로그인 버튼
    btnLogin.addEventListener('click', function() {
        self.adminId = document.getElementById('adminId').value;
        self.adminPw = document.getElementById('adminPw').value;
        self.idPwChk(self.adminId, self.adminPw);
    });

    // 아이디 input에 입력시
    adminId.addEventListener('keyup', function (e) {
        // 로컬 스토리지에 저장
        delay(function() {
            localStorage.setItem('rememberId', e.target.value);
        }, 150);
    });

    adminPw.addEventListener('keyup', function() {
        // 엔터키 입력시
        if (window.event.keyCode == 13) {
            self.adminId = document.getElementById('adminId').value;
            self.adminPw = document.getElementById('adminPw').value;
            self.idPwChk(self.adminId, self.adminPw);
        }
    });
    
    // 아이디 저장 체크박스
    rememberId.addEventListener('change', function(e) {
        if (e.target.checked) {
            localStorage.setItem('rememberChk', 'true');
        } else {
            localStorage.setItem('rememberChk', '');
        }
    });

    self.rememberMe(adminId, rememberId);
    self.setTodayTitle();
};

// 로그인 아이디, 비밀번호 확인
ADMIN.login.idPwChk = function (adminId, adminPw) {
    axios.post(ADMIN.api.login,{
    userid:adminId,
    userpw:adminPw
    }).then(function(response){
    // console.log(response.data);
        if(response.data.state=="true"){
            //this.logincheck();
            console.log('로그인 성공');
            ADMIN.login.loginCheck = "0";
            ADMIN.login.loginSessionChk();
        } else {
            alert('아이디, 비밀번호가 다릅니다');
            document.getElementById('adminPw').value = '';
        }
    }).catch(function(error){
        console.log("로그인 실패");
        console.log("failed : "+error);
    });
};

// 로그인 체크 세션
ADMIN.login.loginSessionChk = function () {
    axios.post(ADMIN.api.loginChk,{
    loginChk: this.loginCheck
    }).then(function(response){
        if(response.data.State=="true"){
            // 관리자 정보 세션 스토리지에 저장
            console.log('로그인 세션 저장', response);
            var sessionInfo = response.data.session;
            var session = {};
            for (var i = 0; i < sessionInfo.length; i++) {
                session = sessionInfo[i];
                sessionStorage.setItem('groupcode', session.groupcode);
            }

            // 관리자 메인 페이지로 넘어가기
            location.href = "/default.asp"; // 서버용
            // location.href = "/default.html";
        }
    }).catch(function(error){
        console.log("failed : "+error);
    });
};

// 로그인 아이디 저장
ADMIN.login.rememberMe = function (adminId, rememberChkbox) {
    this.rememberChk = localStorage.getItem('rememberChk');
    this.rememberId = localStorage.getItem('rememberId');

    // 로그인 아이디를 저장하고 있었을 경우
    if (this.rememberChk && this.rememberChk !== '') {
        // 아이디 input에 값 뿌려주기
        adminId.value = this.rememberId;
        rememberChkbox.checked = true;
    }
};

ADMIN.login.setTodayTitle = function() {
    var thTitle = document.getElementById('s_today');

    thTitle.textContent = ADMIN.date.getMonth() + '월 ' + ADMIN.date.getDay() + '일';
};