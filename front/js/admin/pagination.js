ADMIN.pagination = {
    init: null,
    pagination: null,
    attachClickList: null,
    attachClickPrev: null,
    attachClickNext: null,
};

// 페이지네이션 만들기
ADMIN.pagination.init = function (data){
    var content = $('.s_pagination');

    content.each(function() {
        var $this = $(this);
        var pageNum = $this.data('page-num');
        var pageRow = $this.data('page-row');

        var wrap = content.closest('.s_pagination__wrap');
        var paginationLi = wrap.find('.s_pagination__list');

        paginationLi.each(function() {
            var totalPage = parseInt(data.totalpage, 10);
            var ul = $(this).find('ul');

            if (totalPage == 0 || totalPage == undefined) {
                return false;
            }

            ul.append('<li class="prev"></li>');
            for(var i = 0; i < totalPage; i++){
                if ((i + 1) == pageNum) ul.append('<li class="page active" data-num="'+ (i + 1) +'">'+ (i + 1) +'</li>');
                else ul.append('<li class="page" data-num="'+ (i + 1) +'">'+ (i + 1) +'</li>');
            }
            ul.append('<li class="next"></li>');
        });
    });

    this.attachClickList();
    this.attachClickPrev();
    this.attachClickNext();
};

// 페이지 클릭시
ADMIN.pagination.attachClickList = function() {
    var page = $('.page');
    
    page.on('click', function() {
        var $this = $(this);
        var num = $this.data('num');

        if ($this.hasClass('active')) return false;
        
        page.removeClass('active');
        $this.addClass('active');
        
        ADMIN.axios.setPage(num);
        ADMIN.axios.regetNotice();
    });
};

// 이전 버튼 클릭시
ADMIN.pagination.attachClickPrev = function() {
    var prev = $('.prev');

    prev.on('click', function() {
        var $this = $(this);
        var wrap = $this.closest('.s_pagination__list');
        var activeEl = wrap.find('.page.active');
        var prevEl = activeEl.prev();

        if (prevEl == undefined || prevEl == '' || prevEl.hasClass('prev')) return false;
        activeEl.removeClass('active');
        prevEl.addClass('active');
    });
};

// 다음 버튼 클릭시
ADMIN.pagination.attachClickNext = function() {
    var next = $('.next');

    next.on('click', function() {
        var $this = $(this);
        var wrap = $this.closest('.s_pagination__list');
        var activeEl = wrap.find('.page.active');
        var nextEl = activeEl.next();

        if (nextEl == undefined || nextEl == '' || nextEl.hasClass('next')) return false;
        activeEl.removeClass('active');
        nextEl.addClass('active');
    });
};