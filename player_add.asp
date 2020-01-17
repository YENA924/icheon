<!doctype html>
<html>

<head>
  <title>이천훈련원 관리자 로그인</title>
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
  <link rel="stylesheet" type="text/css" href="./front/css/admin/main.css">
  <link rel="stylesheet" type="text/css" href="./front/css/admin/page.css">
  <link rel="stylesheet" type="text/css" href="./front/css/library/fullcalendar/fullcalendar.css">
  <link rel="stylesheet" type="text/css" href="./front/css/library/fullcalendar/daygrid.css">
  <!-- <link rel="stylesheet" type="text/css" href="./front/css/library/jquery/jquery-ui.css"> -->

  <script src="front/js/library/jquery/jquery-3.4.1.min.js"></script>
  <script src="front/js/library/jquery/jquery-ui.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/vue/vue.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/vue/axios.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-polyfill/6.26.0/polyfill.min.js"></script>
  <script src="front/js/library/fullcalendar/fullcalendar.js"></script>
  <script src="front/js/library/fullcalendar/daygrid.js"></script>
  <script src="front/js/library/fullcalendar/ko.js"></script>
  <!--[if lt IE 9]>
	<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js"></script>
	<![endif]-->
  <!--[if lt IE 9]>
	<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
  <script>
    // $(document).ready(function () {
    //   // 시작
    //   var page = ['main'];
    //   ADMIN.init.start(page);
    // });
  </script>
  <style>
    .m_search__title:after {
      content: "";
      display: block;
      border-bottom: #525765 1px solid;
      width: calc(100% - 35px);
      margin: 15px 1%;
    }

    .m_add__item_wrap {
      display: inline-block;
    }

    .m_add__item {
      display: inline-block;
    }

    .m_tr {
      text-align: center;
      background: #fff;
      cursor: pointer;
    }

    .m_tr.active {
      border: 1px solid #FF8000;
      border-width: 1px 1px 1px 25px;
    }

    .ui-datepicker-year {
      display: none;
    }


    .fc-scroller {
      overflow-y: hidden !important;
    }
    .fc-day-grid-container {
      height: 200px;
    }

    .fc-dayGrid-view .fc-body .fc-row {
      min-height: 2.0em;
    }
  </style>
</head>

<body>
  <div id="l_header">
    <div class="m_logo">
      <img src="./front/img/admin-log.png" width="30.52" />
      <span>이천훈련원</span>
    </div>
    <div class="m_logout"
      style="background-color: #fff;vertical-align: middle;display: inline-block;float: right;margin-top: 15px;">
      <button id="btnLogout" class="btn_logout" style="color:#000;border:none;">로그아웃 (임시)</button>
    </div>
  </div>
  <aside id="l_left_nav">
    <div id="navBar" class="l_navbar">
      <!-- <div class="m_navMenu__wrap">
				<a href="#" class="m_navMenu s_navMenu">훈련원 시설 관리</a>
				<div class="m_navMenu__sub_wrap s_navMenu__sub_wrap">
					<a href="#" class="m_navMenu__sub">시설 현황 등록</a>
					<a href="#" class="m_navMenu__sub">기구 현황 등록</a>
					<a href="#" class="m_navMenu__sub">훈련원 시설 관리 현황</a>
				</div>
			</div>-->
    </div>
  </aside>
  <div id="l_content">
    <div id="l_content__title">
      <p style="display: inline-block;"><img src="./front/img/home_icon.png"></p>
      <p style="display: inline-block;">Home</p>
      <p style="display: inline-block;"> > </p>
      <p style="display: inline-block;">입/퇴촌 관리</p>
      <p style="display: inline-block;"> > </p>
      <p style="display: inline-block;">선수 등록</p>
    </div>
    <div id="l_content__wrap" style="position:relative; background: #F2F2F2;width: 100%; height: 100%;">
      <div id="l_content__page" style="position:relative; padding-top: 30px;padding-left:50px;">
        <div id="l_content__search"
          style="position:relative; max-width: 1620px;background: #E0E5F2;padding-top: 15px;padding-left: 20px;padding-right: 15px;box-sizing: border-box;">
          <div class="m_search__title">
            <p style="font-family:'NanumSquare-exb', sans-serif; font-size:1.5em;display: inline-block;">선수 등록/조회</p>
          </div>
          <div class="m_add__panel" style="position:relative; max-width: 1145px;">
            <div class="m_add__item_wrap">
              <div class="m_add__picture_wrap" style="display: inline-block;">
                <div>
                  <!-- <img src="./front/img/a1-CVKff_400x400.jpg"> -->
                  <form id="m_add__picture_form" runat="server">
                    <img class="m_add__picture" src="">
                    <label for="uploadPicture" class="m_add__picture_btn">사진선택</label>
                    <input type="file" id="uploadPicture" required style="display: none;" @change="attachFileUploadEvt($event)">
                  </form>
                </div>
                <p>120 X 135</p>
                <p>(jpg, bmp)</p>
              </div>
            </div>
            <div class="m_add__item_wrap">
              <div class="m_add__item_text">
                <div class="m_add__item">
                  <label>성명</label>
                  <input type="text"/>
                </div>
                <div class="m_add__item">
                    <label>성명(영문)</label>
                    <input type="text"/>
                </div>
              </div>
              <div class="m_add__item_text">
                <div class="m_add__item">
                  <span>직위</span>
                  <select name="" class="m_add__item_select_box">
                    <option value="">a</option>
                    <option value="">b</option>
                    <option value="">c</option>
                  </select>
                </div>
                <div class="m_add__item">
                  <label>장애여부</label>
                  <input type="text"/>
                </div>
              </div>
              <div class="m_add__item_text">
                <div class="m_add__item">
                  <span>소속</span>
                  <select name="" class="m_add__item_select_box">
                    <option value="">a</option>
                    <option value="">b</option>
                    <option value="">c</option>
                  </select>
                </div>
                <div class="m_add__item">
                  <label>선수구분</label>
                  <input type="text"/>
                </div>
              </div>
              <div class="m_add__item_textarea">
                <label>대회참가현황</label>
                <textarea></textarea>
              </div>
            </div>

            <div class="m_add__item_wrap">
              <div class="m_add__item_text">
                <div class="m_add__item">
                  <span>성별</span>
                  <select name="" class="m_add__item_select_box">
                    <option value="">a</option>
                    <option value="">b</option>
                    <option value="">c</option>
                  </select>
                </div>
                <div class="m_add__item">
                  <label>생년월일</label>
                  <input type="text"/>
                </div>
              </div>
              <div class="m_add__item_text">
                <div class="m_add__item">
                  <span>장애유형</span>
                  <select name="" class="m_add__item_select_box">
                    <option value="">a</option>
                    <option value="">b</option>
                    <option value="">c</option>
                  </select>
                </div>
                <div class="m_add__item">
                  <span>경기등급</span>
                  <select name="" class="m_add__item_select_box">
                    <option value="">a</option>
                    <option value="">b</option>
                    <option value="">c</option>
                  </select>
                </div>
              </div>
              <div class="m_add__item_text">
                <div class="m_add__item">
                  <span>종목</span>
                  <select name="" class="m_add__item_select_box">
                    <option value="">a</option>
                    <option value="">b</option>
                    <option value="">c</option>
                  </select>
                </div>
                <div class="m_add__item">
                  <label>종목상세</label>
                  <input type="text"/>
                </div>
              </div>
              <div class="m_add__item_textarea">
                <label>훈포상현황</label>
                <textarea></textarea>
              </div>
            </div>
          </div>
        </div>
        <div class="m_content__btn_wrap">
          <a href="#">등록</a>
          <a href="#">수정</a>
          <a href="#">삭제</a>
        </div>
        </div>
        <div id="l_content__table" style="position:relative;min-width: 1620px;margin-top: 30px;">
          <div class="m_content__excel">
            <a href="#">액셀 다운</a>
          </div>
          <table style="width:1620px;">
            <thead style="background: #6E727C;color: #fff;">
              <tr style="text-align: center;">
                <th style="padding:7px 0;">No.</th>
                <th>이용일자</th>
                <th>동/관</th>
                <th>층</th>
                <th>시설명</th>
                <th>현황</th>
                <th>이용시간</th>
                <th>구분</th>
                <th>이용단체</th>
                <th>이용기간</th>
                <th>훈련구분</th>
                <th>대표자명</th>
                <th>이용인원</th>
              </tr>
            </thead>
            <tbody class="m_tbody">
              <tr class="m_tr" v-for="(list,key) in facilityList" :key="key" @click="attachClickTableEvt(key, $event)">
                <td style="padding: 19px 0;">{{ list.seq }}</td>
                <td>{{ list.code }}</td>
                <td>{{ list.quarter }}</td>
                <td>{{ list.floor }}</td>
                <td>{{ list.number }}</td>
                <td>{{ list.use }}</td>
                <td>{{ list.use_seq }}</td>
                <td>{{ list.price }}</td>
                <td>{{ list.department }}</td>
                <td>{{ list.extension }}</td>
                <td>{{ list.relative }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="m_pagination__list s_pagination__list">
          <ul>

          </ul>
        </div>
      </div>
    </div>
  </div>
</body>

<script>
  var api_facility_list='http://ic.sportsdiary.co.kr/api/facility_manager/facility_list.asp';
  var api_facility_add='http://ic.sportsdiary.co.kr/api/main/reservation.asp';
  var api_facility_modify='http://ic.sportsdiary.co.kr/api/loginout/login.asp';
  var api_selected_item='http://ic.sportsdiary.co.kr/api/facility_manager/facility_selected_item.asp';
  
  var page=new Vue({
    el:'#l_content__wrap',
    data:{
      facilitySelectedItemList : [],
      facilityList : [],
    },
    watch:{

    },
    methods:{
      // axios 불러오기
      // 로그인 세션 확인
      sessionCheck:function() {
        this.groupCode = sessionStorage.getItem('groupcode');

        // 세션 키가 없을 때
        if (!this.groupCode && this.groupCode == null) {
            alert('세션이 만료되었습니다. 다시 로그인 해주세요.');
            location.href = '/index.html';
            // location.href = "/index.html"; // 서버용
            return false;
        } else { // 있을 때
            return true;
        }
      },

      // select item 가져오기
      loadSelectItemList: function(url) {
        var _this=this;
        axios.post(url,{
        }).then(function(response){
          if(response.data.state == 'true'){
            console.log('시설현황 select item 로드 완료');
            _this.facilitySelectedItemList = response.data;
          }
        }).catch(function(error){
          console.log('loadSelectItemList error : ');
          console.log(error);
        });
      },

      // 시설현황관리 가져오기
      loadFacilityList: function(url) {
        var _this=this;

        axios.post(url,{
        }).then(function(response){
          if(response.data.state == 'true'){
            console.log('시설현황 로드 완료');
            _this.facilityList = response.data.facility;
            // _this.createList();
            // _this.notice_totalpage=Number(response.data.totalpage);
          }
        }).catch(function(error){
          console.log('loadFacilityList error : ');
          console.log(error);
        });
      },

      // 내비게이션 메뉴 만들기
      // createList: function() {
      //   var listWraps = document.getElementsByClassName('m_tbody');
      //   var listWrap = '', listEl;
      //   var listInner = '';
      //   var list = this.facilityList;

      //   for (var i = 0; i < listWraps.length; i++){
      //     listWrap = listWraps[i];

      //     for (var j = 0; j < list.length; j++) {
      //       listEl = list[j];

      //       listInner += '<tr class="m_tr" style="text-align: center;background: #fff;">';
      //       listInner += '<td class="m_td" style="padding: 19px 0;">'+ listEl.seq +'</td>';
      //       listInner += '<td class="m_td">'+ listEl.code +'</td>';
      //       listInner += '<td class="m_td">'+ listEl.quarter +'</td>';
      //       listInner += '<td class="m_td">'+ listEl.floor +'</td>';
      //       listInner += '<td class="m_td">'+ listEl.number +'</td>';
      //       listInner += '<td class="m_td">'+ listEl.use +'</td>';
      //       listInner += '<td class="m_td">'+ listEl.use_seq +'</td>';
      //       listInner += '<td class="m_td">'+ listEl.price +'</td>';
      //       listInner += '<td class="m_td">'+ listEl.department +'</td>';
      //       listInner += '<td class="m_td">'+ listEl.extension +'</td>';
      //       listInner += '<td class="m_td">'+ listEl.relative +'</td>';
      //       listInner += '</tr>';
      //     }

      //     listWrap.innerHTML += listInner;
      //   }
      // },

      // 테이블 클릭 이벤트
      attachClickTableEvt: function(key, event) {
        var tr = $('.m_tr');
        var clickTr = $(event.target).closest('.m_tr');
        
        tr.removeClass('active');
        clickTr.addClass('active');
      },

      // 파일 업로드
      attachFileUploadEvt: function(event) {
        var imgWrap = $('.m_search__picture');
        var fileReader = new FileReader();

        console.log(this.$emit);
        var file = event.target;
        var filePath = event.target.value;

        fileReader.onload = function(e) {
          imgWrap.attr('src', filePath);
        }
        
        fileReader.readAsDataURL(file.files[0]);
      },
    },
    mounted:function(){
      var isLogin = this.sessionCheck();
      if (isLogin) {
        // this.loadSelectItemList(api_selected_item);
        this.loadFacilityList(api_facility_list);
      }
    },
    created:function(){
    }
  });
  </script>
</html>