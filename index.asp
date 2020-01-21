<!--#include virtual="/include/login_header.asp"-->

<div id="l_login" v-cloak>
    <div id="l_login__wrap">
    <div id="admin_login_box">
      <div id="in_list">
        <!-- login mark -->
        <div class="l_login__mark">
            <img src="./front/img/logo_icheon.png" alt="로고"/>
        </div>
        <!-- login -->
        <div class="l_login__box_wrap">
          <div class="m_login">
            <ul>
              <li>
                <label class="m_login__label" for="adminId">ID</label>
                <input id="adminId" type="text" v-model="adminId" class="m_login__input" placeholder="아이디" maxlength="18" v-on:keyup="attachIdKeyupEvt()" />
              </li>
              <li>
                <label class="m_login__label" for="adminPw">PASS</label>
                <input id="adminPw" type="password" class="m_login__input" placeholder="비밀번호" v-on:keyup="attachPwKeyupEvt()" />
              </li>
            </ul>
          </div>
          <div class="m_login__checkGrp">
            <label class="m_login__label" for="rememberLogin">
                <input class="m_login__checkbox_wrap" id="rememberLogin" type="checkbox" v-model="rememberId" name="rememberChk" @change="attachRememberIdEvt($event)" />
                <i class="m_login__checkbox"></i>
                로그인 유지하기
            </label>
          </div>
          <div class="m_login__sign_up">
            <a href="/join.asp">회원가입</a>
            <span>&middot;</span>
            <a href="/find_id_pw.asp">ID/PW 찾기</a>
          </div>
          <div class="m_login__btnGrp">
            <button id="btnLogin" class="m_login__btn" @click="idPwCheck()">로그인</button>
            <a href="http://ic.sportsdiary.co.kr/download/manual_download.asp" id="btnManual"  class="m_login__btn_menual" target="_blank">사용자용 매뉴얼</a>
          </div>
        </div>
      </div>

      <div id="l_login_board" class="logo s_tab_board__con">
        <ul class="l_login_board__li">
          <li class="libtn" v-bind:class="{active: show_tab==1}" @click="show_tab=1;">
            공지사항
          </li>
          <li class="libtn" v-bind:class="{active: show_tab==2}" @click="show_tab=2;">
            대관일정
          </li>
        </ul>
        <div id="l_login_board__table">
          <div class="m_tab_1" v-show="show_tab==1">
            <table class="m_login_board__table_1">
              <colgroup>
                <col style="width:40px">
                <col style="width:120px">
                <col style="width:120px">
                <col style="width:320px">
                <col style="width:160px">
              </colgroup>
              <thead class="m_login_board__thead">
                <tr>
                  <th></th>
                  <th scope="col">게시일</th>
                  <th scope="col">구분</th>
                  <th scope="col">제목</th>
                  <th scope="col">게시자</th>
                </tr>
              </thead>
              <tbody class="m_tr__slide_tbody">
                <tr class="m_tr__slide" v-for="(list,key) in notice" :key="key" @click="attachSlideDownEvt(key, $event)">
                  <td>{{list.num}}</td>
                  <td>{{list.date}}</td>
                  <td v-bind:class="{s_orange_txt: list.noticetype_title == '긴급공지'}">{{list.noticetype_title}}</td>
                  <td>{{list.title}}</td>
                  <td>{{list.username}}</td>
                </tr>
                <tr class="m_tr__slide_content" v-show="key==s_tr__slide_id" v-for="(list,key) in notice" :key="key">
                  <td colspan="5">
                    <div class="m_tr__content">
                    <textarea :title="(list.noticetype_title)+', '+(list.title)+' 내용'" disabled>{{ list.contents }}</textarea>
                    </div>
                    <div class="m_tr__list_btn__wrap">
                      <button class="m_tr__list_btn" @click="attachSlideUpEvt()">
                        <img src="./front/img/login_list_icon.png" alt="목록으로"/>
                        <span>목록으로</span>
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="m_tab_2" v-show="show_tab==2">
            <div class="m_calendar__wrap">
              <div class="m_calendar">
                <img class="m_calendar__img" src="/front/img/icon_calendar.svg" alt="달력선택">
                <input type="text" name="date" id="date" class="date m_calendar2" placeholder="날짜선택" v-model="reservation_date" readonly/>
                <div class="m_arrow_img">
                  <img src="./front/img/login_calendar_arrow.png" alt="달력 화살표"/>
                </div>
              </div>
            </div>
            <table class="m_login_board__table_2">
              <colgroup>
                <col style="width:40px">
                <col style="width:120px">
                <col style="width:200px">
                <col style="width:40px">
                <col style="width:200px">
                <col style="width:120px">
              </colgroup>
              <thead class="m_login_board__thead">
                <tr>
                  <th></th>
                  <th scope="col">이용일자</th>
                  <th scope="col">동/관</th>
                  <th scope="col">층</th>
                  <th scope="col">시설명</th>
                  <th scope="col">대관상태</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(list,key) in reservation_list" :key="key" >
                  <td>{{list.no}}</td>
                  <td>{{reservation_date}}</td>
                  <td>{{list.quarter}}</td>
                  <td>{{list.floor}}</td>
                  <td>{{list.number}}</td>
                  <td>{{list.use_type}}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <div v-if="show_tab==1">
          <div v-if="notice.length>0" class="l_paging_area">
            <button class="l_page l_prev" @click="pageJump(pageCount-1)"><span class="img"><img src="/front/img/previous_page_group.png" alt="이전 목록으로"></span></button>
            <div v-if="pageMax<=10">
              <button v-for="(page,key) in pageMax" :key="key" class="l_paging" v-bind:class="{s_on:key==pageNo}" @click="pageMove(key)">{{page}}</button>
            </div>
            <div v-else>
              <button v-for="(page,key) in 10" :key="key+(10*pageCount)" v-if="(key+(10*pageCount))<pageMax" class="l_paging" v-bind:class="{s_on:key+(10*pageCount)==pageNo}" @click="pageMove(key+(10*pageCount))">{{page+(10*pageCount)}}</button>
            </div>
            <button class="l_page l_next" @click="pageJump(pageCount+1)"><span class="img"><img src="/front/img/next_page_group.png" alt="다음 목록으로"></span></button>
          </div>
        </div>
      </div>

      <div id="l_login__notice">
        <span class="copy_text">온라인 입퇴촌 신청 사용문의/장애처리</span>
        <span class="copy_text">전화 : 041)589-0940</span>
        <span class="copy_text">내선 : 102</span>
      </div>
    </div>
  </div>
</div>

<script>
var l_login = new Vue({
  el:'#l_login',
  data:{
    // api
    api_notice: 'http://ic.sportsdiary.co.kr/api/main/notice.asp',
    api_reservation: 'http://ic.sportsdiary.co.kr/api/main/reservation.asp',
    api_login: 'http://ic.sportsdiary.co.kr/api/loginout/login.asp',
    api_loginChk: 'http://ic.sportsdiary.co.kr/api/loginout/loginChk.asp',
    
    show_tab:1,// 현재 보여지는 탭.  1 = 공지사항,   2 = 대관현황
    // 공지사항
    notice: [],
    notice_list:[],// 공지사항 목록
    // 공지사항 페이징
    pageMax:null,
    pageCount:0,
    pageNo:0,
    // 대관현황
    reservation_list:[],// 대관현황 목록
    reservation_check:false,// 대관가능 목록 선택
    reservation_date:'',

    // 로그인
    adminId: '', // 아이디
    adminPw: '', // 비밀번호
    rememberId: '', // 아이디 기억
    loginCheck: '', // 로그인 체크
    // 공지사항 게시판 슬라이드 id
    s_tr__slide_id: '-1',
  },
  watch:{
    // 대관현황 날짜 선택
    reservation_date:function(){
      this.loadReservation(this.api_reservation);
    },
  },
  methods:{
    // 날짜 설정
    setDate:function() {
      var date = new Date();
      this.reservation_date = date.getFullYear() +'-' +(date.getMonth()+1) + '-' + date.getDate();
    },

    // 달력 로드
    loadCalendar:function() {
      var _this = this;
      var calendar = document.querySelector(".m_calendar");
      
      flatpickr(calendar,{
        locale:"ko",
        onChange:function(selectedDate, dateStr, instance) {
          _this.reservation_date = dateStr;
        }
      });

      calendar.removeAttribute('readonly');
    },

    // 파일 다운로드 
    downloadFile:function() {
      // window.location = 'http://ic.sportsdiary.co.kr/api/file_upload/file_download.asp?fileuri=ic.sportsdiary.co.kr/download/MANUAL.pdf';
    },

    // 공지사항 불러오기
    loadNotice:function(){
      var _this=this;// ie 
      axios.post(_this.api_notice,{
          page:_this.pageNo+1,
          pagesize:10
      }).then(function(response){
        if(response.data.state=="true"){
          _this.notice_list = response.data;
          _this.notice = response.data.notice;
          _this.pageMax=Number(Math.ceil(response.data.total/10));

          _this.replaceBreakTag(_this.notice);
        }
      }).catch(function(error){
        console.log("loadNotice error : ");
        console.log(error);
      });
    },

    // 페이지 클릭 시 공지사항 불러오기
    loadPaginationNotice:function(){
      var _this=this;// ie

      axios.post(_this.api_notice,{
          page:_this.pageNo+1,
          pagesize:10
      }).then(function(response){
        if(response.data.state=="true"){
          _this.notice_list = response.data;
          _this.notice = response.data.notice;

          _this.replaceBreakTag(_this.notice);
        }
      }).catch(function(error){
        console.log("loadNotice error : ");
        console.log(error);
      });
    },

    // 대관목록 불러오기
    loadReservation:function(url){
      var _this=this;// ie 
      axios.post(url,{
        selectdate:this.reservation_date
      }).then(function(response){
        if(response.data.state=="true"){
          _this.reservation_list = response.data.facility;
        }
      }).catch(function(error){
        console.log("loadReservation error : ");
        console.log(error);
      });
    },

    // 아이디, 패스워드 체크
    idPwCheck:function() {
      var apw = $('#adminPw');
      var _this=this;// ie

      axios.post(_this.api_login,{
        userid:_this.adminId,
        userpw:apw.val()
      }).then(function(response){
          if(response.data.state=="true"){
              console.log('로그인 성공', _this);
              _this.loginCheck = '0';
              _this.loginSessionChk();
          } else {
            if (response.data.errorcode == 'ERR-520') {
              alert('아이디, 비밀번호가 다릅니다');
              document.getElementById('adminPw').value = '';
            }

            if (response.data.errorcode == 'ERR-560') {
              alert("이 아이디로 로그인 할 수 없습니다. 관리자에게 문의해 주세요.");
            }
          }
      }).catch(function(error){
          console.log("idPwCheck failed : "+error);
      });
    },

    // 로그인 세션 확인
    loginSessionChk:function() {
      var _this=this;
      axios.post(_this.api_loginChk,{
        loginChk: _this.loginCheck
      }).then(function(response){
          if(response.data.State=="true"){
            // 관리자 정보 세션에 저장
            var sessionInfo = response.data.session;
            var session = {};
            for (var i = 0; i < sessionInfo.length; i++) {
                session = sessionInfo[i];
                // 공통 세션 정보 저장
                sessionStorage.setItem('userid', session.userid);
                sessionStorage.setItem('username', session.username);
                sessionStorage.setItem('group', session.group);
                sessionStorage.setItem('groupcode', session.groupcode);
                sessionStorage.setItem('employee_seq', session.employee_seq);
                sessionStorage.setItem('access', session.access);
                sessionStorage.setItem('association_title', session.association_title);

                // 종목별 지도자 세션 정보 저장
                if (session.groupcode == 'ASSOCIATION') {
                  sessionStorage.setItem('association_code', session.association_code);
                  sessionStorage.setItem('sports_code', session.sports_code);
                }
            }

            // 관리자 메인 페이지로 넘어가기
            location.href = "/main.asp";
          }
      }).catch(function(error){
          console.log("loginSessionChk failed : "+error);
      });
    },

    // 공지사항 페이징
    pageMove:function(idx){
      var _this=this;
      _this.pageNo=idx;
      _this.loadNotice();
    },
    pageJump:function(cnt){
      var _this=this;
      _this.pageNo=cnt*10;
      if(cnt<=-1){
        _this.pageNo=0;
        _this.loadNotice();
        return;
      }
      if(_this.pageNo>_this.pageMax-1){
        _this.pageNo=_this.pageMax-1;
        _this.loadNotice();
        return;
      }
      _this.pageCount=cnt;
      _this.loadNotice();
    },

    // 아이디 keyup 이벤트
    attachIdKeyupEvt:function(){
      var _this=this;
      var delay = (function() {
          var timer = 0;
          return function(callback, ms){
              clearTimeout (timer);
              timer = setTimeout(callback, ms);
          };
      })();

      // 로컬 스토리지에 저장
      delay(function() {
        localStorage.setItem('rememberId', _this.adminId);
      }, 150);
      // 엔터키 입력시
      if (window.event.keyCode == 13) {
        _this.idPwCheck();
      }
    },
    
    // 비밀번호 keyup 이벤트
    attachPwKeyupEvt:function() {
      var _this=this;

      if (window.event.keyCode == 13) {
        _this.idPwCheck();
      }
    },

    // 아이디 저장 체크박스
    attachRememberIdEvt:function($event) {
      var target = $($event.target);
      var checkbox = target.next();

      if (checkbox.hasClass('checked')) {
        checkbox.removeClass('checked');
      } else {
        checkbox.addClass('checked');
      }

      if (this.rememberId) {
        localStorage.setItem('rememberChk', 'true');
      } else {
        localStorage.setItem('rememberChk', '');
      }
    },

    // 팝업 오픈
    attachOpenPopupEvt:function(wrapId) {
      wrapId.classList.toggle('active');
    },

    // 팝업 닫기
    attachClosePopupEvt:function(wrapId) {
      wrapId.classList.remove('active');
    },

    // 게시판 목록 슬라이드 다운
    attachSlideDownEvt:function(key, event) {
      var trSlide = $('.m_tr__slide');
      var trContent = $('.m_tr__slide_content');
      var tbody = $('.m_tr__slide_tbody');

      var clickTr = $(event.target).closest('.m_tr__slide');
      var clickTrContent = $('.m_tr__slide_content').eq(key);

      if (tbody.hasClass('active')) {
        $('.m_tr__slide_tbody').removeClass('active');
      } else {
        $('.m_tr__slide_tbody').addClass('active');
      }
    
      trSlide.toggle();
      clickTr.toggle();
      clickTrContent.toggle();
    },

    // 게시판 목록 슬라이드 업
    attachSlideUpEvt:function() {
      var trSlide = $('.m_tr__slide');
      var trContent = $('.m_tr__slide_content');

      $('.m_tr__slide_tbody').removeClass('active');

      trSlide.show();
      trContent.hide();
    },

    // br 태그들을 replace
    replaceBreakTag:function(contents) {
      contents.forEach(function(item, idx) {
        item.contents = item.contents.split('<br/>').join("\r\n");
      });
    },
  },
  mounted:function(){
    this.loadNotice();
    this.loadReservation(this.api_reservation);
    this.loadCalendar();
  },
  created:function(){
    this.setDate();
  }
});
</script>
</body>
</html>