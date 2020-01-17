ADMIN.animate = {
    init: null,
    slideMenu: null,
    tabMenu: null,
};

ADMIN.animate.init = function () {
    this.slideMenu();
    this.slideBoard();
    this.tabMenu();
};

// 메뉴 슬라이드
ADMIN.animate.slideMenu = function () {
    var menu = $('.s_navMenu');
    var subMenu = '';

    menu.on('click', function() {
        subMenu = $(this).nextAll();

        if (subMenu && subMenu !== null) {
            if (subMenu.hasClass('s_navMenu__sub_wrap')){
                subMenu.slideToggle('slow');
            }
        }
    });
};

// 게시판 슬라이드
ADMIN.animate.slideBoard = function () {
    var slideTr = $('.s_tr__slide');
    var slideTrCon = $('.s_tr__slide_content');

    slideTr.on('click', function() {
        var $this = $(this);
        var $slideTrCon = $this.next();
        var dataSlide = $this.data('board-slide');

        slideTrCon.removeClass('active');
        if ($this.data('board-slide') == dataSlide){
            $slideTrCon.addClass('active').delay(300).slideToggle('slow');
        }
    });
};

// 탭메뉴
ADMIN.animate.tabMenu = function () {
    var tab = $('.s_tab_board_tab');

    tab.on('click', function() {
        var $this = $(this);
        var $wrap = $this.closest('.s_tab_board__con');
        var dataTab = $this.data('tab');

        $wrap.find('.s_tab_board_tab').removeClass('active');
        $this.addClass('active');

        $wrap.find('.s_tab_board__content').removeClass('active');
        $('#'+ dataTab).addClass('active');
    });
};