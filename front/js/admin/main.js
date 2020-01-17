ADMIN.main = {
    init: null, // 시작
    sessionCheck: null, // 로그인 세션 확인
    getMenuList: null, // 메뉴리스트 가져오기
    logout: null, // 로그아웃

    menuList: null,
    isLogin: true,
    groupcode: '',
}

// 시작
ADMIN.main.init = function () {
    // this.isLogin = this.sessionCheck();

    // 임시 그룹코드 생성+
    sessionStorage.setItem('groupcode', 'ADMIN');
    if (this.isLogin) {
        this.groupcode = sessionStorage.getItem('groupcode');
        this.logout();
        ADMIN.axios.setGroupcode(this.groupcode);
        // this.createMenuList();
        // this.createDropDownMenu();
    }
};

// 로그인 세션 확인
ADMIN.main.sessionCheck = function () {
    var sessionCode = sessionStorage.getItem('groupcode');

    // 세션 키가 없을 때
    if (!sessionCode && sessionCode == null) {
        alert('세션이 만료되었습니다. 다시 로그인 해주세요.');
        location.href = "/index.asp"; // 서버용
        // location.href = "/index.html"; 
        return false;
    } else { // 있을 때
        return true;
    }
};

// 로그아웃
ADMIN.main.logout = function () {
    var btnLogout = document.getElementById('btnLogout');
    
    btnLogout.addEventListener('click', function () {
        axios.get(ADMIN.api.logout)
        .then(function(response){
            if(response.data.state=="true"){
                console.log('로그아웃');
                sessionStorage.clear();
    
                // 관리자 로그인 페이지로 넘어가기
                location.href = "/index.asp"; // 서버용
                // location.href = "/index.html";
            }
        }).catch(function(error){
            console.log("failed : "+error);
        });
    });
};