ADMIN.date = {
    init: null,
    getToday: null,
    
    today: '',
};

// initialize
ADMIN.date.init = function() {
    if (this.today == '') this.today = this.getToday();
};

// 오늘 날짜 가져오기
ADMIN.date.getToday = function() {
    var dt = new Date();

    var recentYear = dt.getFullYear();
    var recentMonth = dt.getMonth() + 1;
    var recentDay = dt.getDate();

    if(recentMonth < 10) recentMonth = "0" + recentMonth;
    if(recentDay < 10) recentDay = "0" + recentDay;

    //if (this.today == '') this.today = recentYear + "-" + recentMonth + "-" + recentDay;
    return recentYear + "-" + recentMonth + "-" + recentDay;
};

// 이번달 가져오기
ADMIN.date.getMonth = function() {
    var dt = new Date();
    var recentMonth = dt.getMonth() + 1;

    if(recentMonth < 10) recentMonth = "0" + recentMonth;

    return recentMonth;
};

// 오늘 날짜 가져오기
ADMIN.date.getDay = function() {
    var dt = new Date();
    var recentDay = dt.getDate();

    if(recentDay < 10) recentDay = "0" + recentDay;

    return recentDay;
};