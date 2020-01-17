ADMIN.popup = {
    init: null, // 시작
    attachClickOpen: null, // 팝업 열기 버튼 이벤트
    attachClickClose: null, // 팝업 닫기 버튼 이벤트

    isDim: false,
};

// initialize
ADMIN.popup.init = function () {
    var popupDim = $('.s_popup__dim');

    if (popupDim !== undefined || popupDim !== '') {
        this.isDim = true;
    }

    this.attachClickOpen();
    this.attachClickClose();
};

// 팝업 버튼 클릭 시
ADMIN.popup.attachClickOpen = function() {
    var popupBtn = $('.s_popup__btn');
    var self = ADMIN.popup;
    
    popupBtn.on('click', function() {
        var $this = $(this);
        var data = $this.data('popup');
        var popupWrap = $('#'+ data);

        popupWrap.addClass('active');

        if (self.isDim) {
            self.showDim();
        }
    });
};

// 팝업 닫기 버튼 이벤트
ADMIN.popup.attachClickClose = function() {
    var popupBtnClose = $('.s_popup__btn_close');
    var self = ADMIN.popup;

    popupBtnClose.on('click', function() {
        var $this = $(this);
        var popupWrap = $this.closest('.m_popup');

        popupWrap.removeClass('active');
        
        if (self.isDim) {
            self.showDim();
        }
    });
};

// 팝업 바탕 배경 깔기
ADMIN.popup.showDim = function() {
    var popupDim = $('.s_popup__dim');
    
    popupDim.toggleClass('active');
};