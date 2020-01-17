ADMIN.checkbox = {
    init: null,
    showHideToggle: null,
};

ADMIN.checkbox.init = function () {
    this.showHideToggle();
};

// 체크박스로 특정 필터만 보기
ADMIN.checkbox.showHideToggle = function (){
    var toggleChkBox = $('.s_toggleChkBox');
    var container, el;

    toggleChkBox.on('change', function() {
        var $this = $(this);
        var dataCon = $this.data('container');
        var dataState = $this.data('state');
        var isCheck = $this.prop('checked');

        container = $(document).find('[data-filter-container="'+ dataCon +'"');
        el = container.find('.s_filter');

        el.each(function() {
            if ($(this).data('state') !== dataState){
                if (isCheck) $(this).addClass('hide');
                else $(this).removeClass('hide');
            }
        });
    });
};