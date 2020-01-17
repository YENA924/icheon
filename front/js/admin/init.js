var ADMIN = ADMIN || {};

ADMIN.init = {
    start: null,
};

// init start
ADMIN.init.start = function (pageArr) {
    if (pageArr == null || pageArr == '') return false;

    for(var i = 0; i < pageArr.length; i++){
        var page = pageArr[i];

        switch(page) {
            case 'login': ADMIN.login.init(); break;
            case 'main': ADMIN.main.init(); break;
        }
        ADMIN.axios.init(page);
    }
};