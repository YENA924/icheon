<!DOCTYPE HTML>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
  <meta name="apple-mobile-web-app-title" content="스포츠다이어리" />
  <meta name="format-detection" content="telephone=no" />
  <meta http-equiv="Cache-Control" content="No-Cache" />
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="pragma" content="no-store" />
  <meta http-equiv="Expires" content="-1" />

  <link rel="stylesheet" type="text/css" href="./front/css/admin/initialize.css">
  <link rel="stylesheet" type="text/css" href="./front/css/admin/admin-login.css">

  <script src="front/js/library/jquery/jquery-3.4.1.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/vue/vue.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/vue/axios.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-polyfill/6.26.0/polyfill.min.js"></script>
  <style>
    table{margin-bottom:30px;width:730px;border-collapse:collapse;border-spacing:0;}
    th,td{padding:10px 4px;vertical-align:middle;text-align:center;}
    th{background-color:rgba(255,255,255,0.5);}
    td,label{color:#fff;background-color:rgba(64,64,64,0.4);border:1px solid rgba(0,0,0,0.5);}
    .libtn{float:left;font-family: 'NanumSquare-b', sans-serif;font-size:1.125em;border-radius: 10px 10px 0px 0px;overflow:hidden;}
    .libtn button{padding:13px 42px 7px;background-color:rgba(0,0,0,0.3);border:none;color:#fff;font-size:14px;}
    .libtn.active button{background-color:rgba(255,255,255,0.7);color:#000;}
    .s_pagination__list button{padding:4px 8px;background-color:transparent;border:none;color:inherit;}
    .s_red{color:#e67676;}
    [v-cloak]{display:none;} /*가상 돔 데이터 display: none 처리*/
    /* .m_tab_board__tbody tr {display: block; width: 100%;}
    .m_tab_board__tbody td {display: block; float:left; width: 172px;} */
    .m_tr__slide {cursor: pointer;}
    .m_tr__slide_content {display: none;}
    .m_tr__slide_content.active {display: table-row;}
  </style>
</head>

<body>
  <div id="app" v-cloak>
    <div class="admin_login_box">
      <div id="l_login_board" class="logo s_tab_board__con">
          <button class="m_popup__btn s_popup__btn" @click="showpopup=true">팝업 임시 버튼</button><!-- 단순 팝업을 띄울 때와 닫을 때 변수(아래 showpopup 추가)로만 제어해도 상관없음 -->
        <ul>
          <li class="libtn" v-bind:class="{active: show_tab==1}">
            <button @click="show_tab=1;">공지사항</button>
          </li>
          <li class="libtn" v-bind:class="{active: show_tab==2}">
            <button @click="show_tab=2;">대관현황</button>
          </li>
        </ul>

        <div v-if="show_tab==1">
          <table>
            <colgroup>
              <col style="width:7%">
              <col style="width:13%">
              <col style="width:35%">
              <col style="width:35%">
              <col style="width:10%">
            </colgroup>
            <thead>
              <tr>
                <th>번호</th>
                <th>게시일</th>
                <th>제목</th>
                <th>게시자</th>
              </tr>
            </thead>
            <tbody v-for="(list,key) in notice_list.notice" :key="key">
              <!-- <tr class="m_tr__slide" @click="attachClickSlideEvt(key, $event)"> -->
              <!-- 
                클릭할 때 함수로 빼지 않고 변수 s_tr__slide_id 값이랑 key값이 같으면 -1, 다르면 s_tr__slide_id에 해당 key값이 들어가게 설정하고
                -->
              <tr class="m_tr__slide" @click="s_tr__slide_id==key? s_tr__slide_id=-1 : s_tr__slide_id=key">
                <td>{{list.num}}</td>
                <td>{{list.date}}</td>
                <td>{{list.title}}</td>
                <td>{{list.username}}</td>
              </tr>
              <!-- s_tr__slide_id랑 key 값이 같으면 active 클래스 추가 -->
              <tr class="m_tr__slide_content" v-bind:class="{active: key==s_tr__slide_id}">
                <td colspan="4">{{list.contents}}</td>
              </tr>
            </tbody>
          </table>
          
          <div class="m_pagination__list s_pagination__list">
            <ul>
              <template v-for="(list,key) in notice_totalpage" :key="key">
                <li class="page" v-bind:class="{active: key==(notice_list.page-1)}">
                  <button @click="paging(key+1)">{{key+1}}</button>
                </li>
              </template>
            </ul>
          </div>
        </div>

        <div v-if="show_tab==2">
          <input type="date" v-model="reservation_day">
          <input id="showAppResChkBox" type="checkbox" v-model="reservation_check">
          <label for="showAppResChkBox">대관가능 신청만 보기</label>
          <table>
            <colgroup>
              <col style="width:22%">
              <col style="width:14%">
              <col style="width:44%">
              <col style="width:20%">
            </colgroup>
            <thead>
              <tr>
                <th>시설명</th>
                <th>상태</th>
                <th>사용기간</th>
                <th>1일 비용</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(list,key) in reservation_list.reservation" :key="key" v-if="!reservation_check">
                <td>{{list.facility}}</td>
                <td v-bind:class="{s_red: list.facilitystate=='2'}">{{list.facilitystate=="1" ? "대관중" : list.facilitystate=="2" ? "대관가능" : "신청대기"}}</td>
                <td>{{list.usedate}}</td>
                <td>{{addcomma(list.cost)}} 원</td>
              </tr>
              <tr v-for="(list,key) in reservation_list.reservation" :key="key" v-if="reservation_check && list.facilitystate==2">
                <td>{{list.facility}}</td>
                <td class="s_red">대관가능</td>
                <td>{{list.usedate}}</td>
                <td>{{addcomma(list.cost)}} 원</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
  
      <div class="login_con">
        <div class="in_list">
          <div id="l_login__wrap">
            <h1 id="m_login__title">로그인</h1>
            <ul class="m_login">
              <li>
                <label for="adminId">아이디</label>
                <input type="text" v-model="adminId" name="loginInput" class="" placeholder="아이디" value=""
                  maxlength="18" v-on:keyup="attachIdKeyupEvt"/>
              </li>
              <li>
                <label for="adminPw">비밀번호</label>
                <input type="password" id="adminPw" name="loginInput" class="" placeholder="비밀번호" v-on:keyup="attachPwKeyupEvt"/>
              </li>
            </ul>
            <div class="m_login__checkGrp">
              <input type="checkbox" v-model="rememberId" name="rememberChk" @change="attachRememberIdEvt()"/>
              <label for="rememberId">아이디 저장</label>
            </div>
            <div class="m_login__btnGrp">
              <button href="" id="btnLogin" class="login_btn" @click="idPwCheck()">로그인</button>
              <div>
                <a href="" id="btnManual" name="loginSiteLink" class="btn_manual">연맹사용자용 매뉴얼</a>
                <a href="" id="btnDaegwanApply" name="loginSiteLink" class="btn_daegwan_apply">대관신청
                  바로가기</a>
              </div>
            </div>
          </div>
          <div id="l_login__footer">
            <p>스마트폰에서 http://이천훈련원.kr/download/로</p>
            <p>접속하시면 외출/외박 신청을 스마트폰으로 간편하게</p>
            <p>할 수 있는 앱을 다운로드 받을 수 있습니다.</p>
          </div>
        </div>
      </div>
      <div id="l_login__notice">
        <p class="copy_text">온라인 입퇴촌 신청 사용문의/장애처리</p>
        <p class="copy_text">전화 : 041)589-0940</p>
        <p class="copy_text">내선 : 102</p>
      </div>
    </div>

    <div v-if="showpopup" class="m_popup m_login__popup" v-bind:class="{active: showpopup}">
      <!--
        showpop의 상태(true/false)에 따라 팝업이 보여짐. 
        v-if는 tag 자체를 없앴다가 붙였다가 하는거라 display:none, display:block을 위해 클래스를 추가할 필요는 없음... 여기선 active클래스로 display:block을 제어해서 추가시켜놓음
        (v-show는 display:block, display:none 토글)
      -->

      <div class="m_popup__header">
        <p class="m_popup__title">대관 신청 내역 확인</p>
      </div>
      <div class="m_popup__content">
        <p class="m_popup__text">대관 신청 시 등록한 이메일 주소를 입력해 주세요.</p>
        <div class="m_popup__input_grp">
          <label for="popupEmailAdd" class="m_popup__label">이메일 주소</label>
          <input id="popupEmailAdd" class="m_popup__input_text" type="text"/>
        </div>
      </div>
      <div class="m_popup__footer">
        <div class="m_center m_popup__btn_grp">
          <button class="m_popup__btn_ok">확인</button>
          <button class="m_popup__btn_close s_popup__btn_close" @click="showpopup=false">취소</button><!-- 단순 팝업을 띄울 때와 닫을 때 변수(아래 showpopup 추가)로만 제어해도 상관없음  -->
        </div>
      </div>
    </div>
  </div>

<script>
var api_notice='http://ic.sportsdiary.co.kr/api/main/notice.asp';
var api_reservation='http://ic.sportsdiary.co.kr/api/main/reservation.asp';
var api_login='http://ic.sportsdiary.co.kr/api/loginout/login.asp';
var api_loginChk = 'http://ic.sportsdiary.co.kr/api/loginout/loginChk.asp';

var app=new Vue({
  el:'#app',// vue를 사용하겠다는 선언. 맨 위 div에 id값으로
  data:{// 사용한 변수들
    show_tab:1,// 현재 보여지는 탭.  1 = 공지사항,   2 = 대관현황
    notice_list:[],// 공지사항 목록
    notice_page:1,//
    notice_totalpage:null,

    reservation_list:[],// 대관현황 목록
    reservation_check:false,// 대관가능 목록 선택
    reservation_day:"",

    adminId: '',
    adminPw: '',
    rememberId: '',
    loginCheck: '',

    showpopup:false,// 팝업 보이기

    s_tr__slide_id: '-1',
  },
  watch:{// watch안에 있는 data값 (여기서는 reservation_day)은 항상 주시. 무언가가 바뀌면 바로 실행
    // 날짜 바뀌어도 목록은 같아서 아무 변화가 없어 보이지만 json에서 page값은 바뀌어짐..
    reservation_day:function(){
      this.loadReservation(api_reservation);
    },
  },
  methods:{// 함수 모음
    // json 불러오기
    loadNotice:function(url){
      var _this=this;// ie 
      axios.post(url,{
        page:this.notice_page
      }).then(function(response){
        if(response.data.state=="true"){
          _this.notice_list=response.data;
          _this.notice_totalpage=Number(response.data.totalpage);
        }
      }).catch(function(error){
        console.log("loadNotice error : ");
        console.log(error);
      }).finally(function(){
        console.log("loadNotice. finally");
      });
    },
    loadReservation:function(url){
      var _this=this;// ie 
      axios.post(url,{
        selectdate:this.reservation_day
      }).then(function(response){
        if(response.data.state=="true"){
          _this.reservation_list=response.data;
        }
      }).catch(function(error){
        console.log("loadNotice error : ");
        console.log(error);
      }).finally(function(){
        console.log("loadNotice. finally");
      });
    },

    idPwCheck:function() {
      var _this=this;// ie
      axios.post(api_login,{
        userid:this.adminId,
        userpw:this.adminPw
      }).then(function(response){
          if(response.data.state=="true"){
              console.log('로그인 성공');
              this.loginCheck = '0';
          } else {
              alert('아이디, 비밀번호가 다릅니다');
              document.getElementById('adminPw').value = '';
          }
      }).catch(function(error){
          console.log("idPwCheck failed : "+error);
      });
    },

    loginSessionChk:function() {
      var _this=this;
      axios.post(api_loginChk,{
        loginChk: this.login_check
      }).then(function(response){
          if(response.data.State=="true"){
            // 관리자 정보 세션에 저장
            var sessionInfo = response.data.session;
            var session = {};
            for (var i = 0; i < sessionInfo.length; i++) {
                session = sessionInfo[i];
                sessionStorage.setItem('groupcode', session.groupcode);
            }

            // 관리자 메인 페이지로 넘어가기
            location.href = "/default.asp"; // 서버용
            // location.href = "/default.html";
          }
      }).catch(function(error){
          console.log("loginSessionChk failed : "+error);
      });
    },

    paging:function(pageno){
      // 페이지 번호 클릭해도 목록은 같아서 아무 변화가 없어 보이지만 json에서 page값은 바뀌어짐..
      this.notice_page=pageno;
      this.loadNotice(api_notice, "notice_list");
    },

    addcomma:function(won){
      return won.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
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
    attachRememberIdEvt:function() {
      console.log(this, this.rememberId);
      if (this.rememberId) {
        localStorage.setItem('rememberChk', 'true');
      } else {
        localStorage.setItem('rememberChk', '');
      }
    },

    // // 팝업 오픈
    // attachOpenPopupEvt:function(wrapId) {
    //   wrapId.classList.add('active');
    // },

    // // 팝업 닫기
    // attachClosePopupEvt:function(wrapId) {
    //   wrapId.classList.remove('active');
    // },

    // // 게시판 목록 슬라이드
    // attachClickSlideEvt:function(key, event) {
    //   var tr = $('.m_tr__slide');
    //   var clickTr = $(event.target).parent();

    //   tr.removeClass('click');
    //   clickTr.addClass('click');
    //   if (this.s_tr__slide_id == key) this.s_tr__slide_id = '-1';
    //   else this.s_tr__slide_id = key;
    // },

    // 게시판 목록
  },
  mounted:function(){// 가상dom이 만들어지면 실행되는 영역
    this.loadNotice(api_notice);
    this.loadReservation(api_reservation);

    var date=new Date();
    this.reservation_day=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()

    // 로그인 아이디 저장 체크
    var rememberChkStr = localStorage.getItem('rememberChk');
    var rememberIdStr = localStorage.getItem('rememberId');

    if (rememberChkStr && rememberChkStr !== '') {
        this.adminId = rememberIdStr;
        this.rememberId = true;
    }
  },
  created:function(){// 시작하자마자 실행되는 영역
  }
});
</script>
</body>
</html>