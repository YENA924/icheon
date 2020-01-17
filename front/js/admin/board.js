ADMIN.board = {
    init: null,
    createBoard: null,
    createTabBoard: null,
    createMenuList: null,
    createDropDownMenu: null,
};

ADMIN.board.init = function() {
    
};

// 데이터에 맞게 탭메뉴 그려주기
ADMIN.board.createBoard = function(dataSet, dataSetName) {
    var data;
    var tabBoardInner = '';

    for (var i = 0; i < dataSet.length; i++){
        data = dataSet[i];

        if (dataSetName == 'notice') {
            tabBoardInner += '<tr class="m_tr m_tr__slide s_tr__slide" data-board-slide='+ i +'>';
            tabBoardInner += '<td>'+ data.num +'</td>';
            tabBoardInner += '<td>'+ data.date +'</td>';
            switch (data.type){
                case '1': tabBoardInner += '<td>일반공지</td>'; break;
                case '2': tabBoardInner += '<td>특수공지</td>'; break;
                default: tabBoardInner += '<td></td>'; break;
            }
            tabBoardInner += '<td>'+ data.title +'</td>';
            tabBoardInner += '<td>'+ data.username +'</td>';
            tabBoardInner += '</tr>';
            tabBoardInner += '<tr class="m_tr__slide_content s_tr__slide_content" data-board-slide='+ i +'>';
            tabBoardInner += '<td>'+ data.contents +'</td>';
            tabBoardInner += '</tr>';
        } else {
            tabBoardInner += '<tr class="m_tr s_filter" data-num='+ data.seq +' data-state='+ data.facilitystate +'>';
            tabBoardInner += '<td>'+ data.facility +'</td>';
            switch (data.facilitystate){
                case '1': tabBoardInner += '<td>대관중</td>'; break;
                case '2': tabBoardInner += '<td>대관가능</td>'; break;
                case '3': tabBoardInner += '<td>신청대기</td>'; break;
                default: tabBoardInner += '<td></td>'; break;
            }
            tabBoardInner += '<td>'+ data.usedate +'</td>';
            tabBoardInner += '<td>'+ data.cost +'</td>';
            switch (data.facilitystate){
                case '1': tabBoardInner += '<td>신청내역</td>'; break;
                case '2': tabBoardInner += '<td>대관신청</td>'; break;
                default: tabBoardInner += '<td></td>'; break;
            }
        }
    }

    ADMIN.board.createTabBoard(dataSetName, tabBoardInner);
};

// 탭메뉴 데이터 붙이기
ADMIN.board.createTabBoard = function(dataSetName, html) {
    var tabBoardCon = document.getElementsByClassName('s_tab_board__content');
    var tabBoardData = '', tabBoardtBody = '';

    for (var i = 0; i < tabBoardCon.length; i++){
        tabBoardData = tabBoardCon[i].getAttribute('data-board');
        if (tabBoardData == dataSetName){
            tabBoardtBody = tabBoardCon[i].getElementsByClassName('s_tab_board__tbody');
            tabBoardtBody[0].innerHTML = '';
            for(var j = 0; j < tabBoardtBody.length; j++){
                tabBoardtBody[j].innerHTML += html;
            }
        }
    }
};

// 메뉴리스트 만들기
ADMIN.board.createMenuList = function (menuList) {
    // console.log('메뉴리스트 ::: ', menuList);
    // console.log('length ::: ', menuList.length);

    var navBar = document.getElementById('navBar');
    var menu = "", submenu = "";
    var navMenuInner = "";

    for (var i = 0; i < menuList.length; i++) {
        menu = menuList[i];

        navMenuInner += '<div class="m_navMenu__wrap">'; // temp :: javascript 이벤트 막기
        navMenuInner += '<a href="'+ menu.uri +'" class="m_navMenu s_navMenu" data-popup="'+ menu.popup +'" onclick="event.preventDefault();">'+ menu.title +'</a>';
        
        if (menu.submenu && menu.submenu !== null) {
            navMenuInner += '<div class="m_navMenu__sub_wrap s_navMenu__sub_wrap">';

            for(var j = 0; j < menu.submenu.length; j++) {
                submenu = menu.submenu[j]; // temp :: javascript 이벤트 막기
                navMenuInner += '<a href="'+ submenu.uri +'" class="m_navMenu__sub" data-popup="'+ submenu.popup +'" onclick="event.preventDefault();">'+submenu.title+'</a>';
            }
            navMenuInner += '</div>';
        }
        navMenuInner += '</div>';
    }

    navBar.innerHTML += navMenuInner;

    this.createDropDownMenu();
};

// 드롭다운 메뉴 만들기
ADMIN.board.createDropDownMenu = function () {
    var m_navMenu = document.getElementsByClassName('m_navMenu');
    var navMenu = "", subMenu = "";

    for(var i = 0;i < m_navMenu.length;i++) {
        navMenu = m_navMenu[i];

        navMenu.addEventListener('click', function (){
            this.classList.toggle('active');
            subMenu = this.nextElementSibling;

            if (subMenu && subMenu !== null) {
                if (subMenu.classList.contains('m_navMenu__sub_wrap')) {
                    subMenu.classList.toggle('active');
                }
            }
        });
    }
};