ADMIN.axios = {
    init: null,
    getNotice: null,
    getReservation: null,
    getMenuList: null,
    startModule: null,

    page: '1',
    selectdate: '',
    groupcode: '',
}

ADMIN.axios.init = function(flag) {
    switch(flag) {
        case 'login' : 
            this.getNotice(true);
            this.getReservation(true);
            break;
        case 'main' :
            this.getMenuList(true);
            break;
    }
};

// 로그인 공지사항 불러오기
ADMIN.axios.getNotice = function(isFirst) {
    axios.post(ADMIN.api.notice,{
        page: this.page
        }).then(function(response){
            if(response.data.state == "true"){
                console.log('공지사항 게시판 불러오기');
                ADMIN.board.createBoard(response.data.notice, 'notice');
                if (isFirst) ADMIN.pagination.init(response.data);
            } else {
                alert('data state false!');
            }
        }).catch(function(error){
            console.log("failed!! :::: "+ error);
        }).finally(function() {
            ADMIN.axios.startModule();
        });
};

// 로그인 대관신청 불러오기
ADMIN.axios.getReservation = function(isFirst) {
    axios.post(ADMIN.api.reservation,{
        selectdate: this.selectdate
        }).then(function(response){
            if(response.data.state == "true"){
                console.log('대관현황 게시판 불러오기');
                ADMIN.board.createBoard(response.data.reservation, 'reservation');
            } else {
                alert('data state false!');
            }
        }).catch(function(error){
            console.log("failed!! :::: "+ error);
        });
};

// 메인 메뉴리스트 가져오기
ADMIN.axios.getMenuList = function (isFirst) {
    axios.post(ADMIN.api.menu,{
        groupcode: this.groupcode
        }).then(function(response){
            if(response.data.state == "true"){
                console.log('메뉴리스트 가져오기');
                ADMIN.board.createMenuList(response.data.menu);
            } else {
                alert('data state false!');
            }
        }).catch(function(error){
            console.log("failed!! :::: "+ error);
        }).finally(function() {
            ADMIN.axios.startModule();
        });
};

// 로그인 공지사항 페이지 set
ADMIN.axios.setPage = function(page) {
    this.page = page;
};

// 메인 그룹코드 set
ADMIN.axios.setGroupcode = function(groupcode) {
    this.groupcode = groupcode;
};

// 로그인 공지사항 불러오기
ADMIN.axios.regetNotice = function() {
    this.getNotice(false);
};

// 모듈 시작
ADMIN.axios.startModule = function() {
    ADMIN.module.start();
};