<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->
<section id="icContent" class="l_ct l_request_outgoing" v-cloak>
  <div class="l_content">
    <h2>외출/외박 신청</h2>

    <div class="l_search_box">
      <div class="l_search_field">
        <div class="l_field">
          <label for="outing">신청구분</label>
          <div class="m_field__radio_grp">
            <input id="outing" name="applyDiv" type="radio" class="m_field__radio_button_input" value="1" v-model="outing" @change="checkRadioBtn('applyDiv', 0)"/>
            <i class="m_field__radio_button" @click="checkRadioBtn('applyDiv', 0)"></i>
            <label for="outing">외출</label>
          </div>
          <div class="m_field__radio_grp">
            <input id="overnight" name="applyDiv" type="radio" class="m_field__radio_button_input" value="2" v-model="overnight" @change="checkRadioBtn('applyDiv', 1)"/>
            <i class="m_field__radio_button" @click="checkRadioBtn('applyDiv', 1)"></i>
            <label for="overnight">외박</label>
          </div>
        </div>
        <div class="l_field">
          <label for="applicant">신청자</label>
          <input type="text" name="applicant" id="applicant" value="" v-model="applicant" placeholder="입력" readonly/>
          <button class="m_btn_player" @click="openPopup()">선수선택</button>
        </div>
        <div class="l_field">
          <label for="leader">지도자</label>
          <input type="text" class="m_readonly" name="leader" id="leader" value="" v-model="leader" disabled />
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field">
          <label for="dormitory">사용호실</label>
          <input type="text" class="m_readonly" id="dormitory" name="dormitory" value="" v-model="dormitory" id="productname" disabled />
        </div>
        <div class="l_field" style="margin-left:294px;">
          <label for="apply_reason">신청사유</label>
          <select name="apply_reason" id="apply_reason" v-model="apply_reason">
            <option v-for="(select,key) in applyReasonInfo" :key="key" :value="select.seq">{{select.title}}</option>
          </select>
        </div>
        <div class="l_field" style="margin-left:165px;">
          <label for="destination">목적지</label>
          <input type="text" name="destination" id="destination" value="" v-model="destination" placeholder="입력" />
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field l_field__date">
          <div class="m_field__date">
            <label for="sDate">출발예정일시</label>
            <input type="text" name="sDate" id="sDate" class="sDate" placeholder="날짜선택" v-model="sDate">
            <button class="l_btn_calendar s_sDate"><img src="/front/img/icon_calendar.svg" alt="달력선택"></button>
          </div>
          <div class="m_field__time m_start">
            <select name="start_date_hour" id="start_date_hour" title="출발 예정 시" v-model="start_date_hour">
              <option v-for="hour in date_hours" :value="hour">{{ hour }}</option>
            </select>
          </div>
          <span class="m_field__time_division">&#58;</span>
          <div class="m_field__time">
            <select name="start_date_minute" id="start_date_minute" title="출반 예정 분" v-model="start_date_minute">
              <option v-for="minute in date_minutes" :value="minute">{{ minute }}</option>
            </select>
          </div>
        </div>
        <div class="l_field l_field__date">
          <div class="m_field__date">
            <label for="eDate">복귀예정일시</label>
            <input type="text" name="eDate" id="eDate" class="eDate" placeholder="날짜선택" v-model="eDate">
            <button class="l_btn_calendar eDate"><img src="/front/img/icon_calendar.svg" alt="달력선택"></button>
          </div>
          <div class="m_field__time m_start">
            <select name="end_date_hour" id="end_date_hour"  title="복귀 예정 시" v-model="end_date_hour">
              <option v-for="hour in date_hours" :value="hour">{{ hour }}</option>
            </select>
          </div>
          <span class="m_field__time_division">&#58;</span>
          <div class="m_field__time">
            <select name="end_date_minute" id="end_date_minute" title="복귀 예정 분" v-model="end_date_minute">
              <option v-for="minute in date_minutes" :value="minute">{{ minute }}</option>
            </select>
          </div>
        </div>
      </div>
      <div class="l_search_btns">
        <button type="submit" class="s_blue" v-if="!choicedata" @click="addInout()">등록</button>
        <template v-else>
          <button type="submit" v-bind:class="{s_blue: isChange, s_grayblue: !isChange}" @click="modifyInout()">수정</button>
          <button type="submit" class="s_orange" @click="deleteInout()">삭제</button>
          <button type="submit" class="s_white" @click="resetData()">신규</button>
        </template>
      </div>
    </div>

      <!-- 목록 테이블 형식. s. -->
      <div class="l_list_box">
        <div class="l_list_tablewrap">
          <table>
            <caption>외출/외박 신청 목록</caption>
            <thead>
              <tr>
                <th>No</th>
                <th>구분</th>
                <th>신청자</th>
                <th>직위</th>
                <th>지도자</th>
                <th>종목</th>
                <th>생활관</th>
                <th>신청사유</th>
                <th>목적지</th>
                <th>출발예정일시</th>
                <th>복귀예정일시</th>
                <th>승인</th>
                <th>승인자</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(list, key) in inoutInfo" :key="key" @click="listInfoChoice(list)">
                <td>{{ list.no }}</td>
                <td>{{ list.reason == '1' ? '외출' : '외박' }}</td>
                <td>{{ list.player_name }}</td>
                <td>{{ list.position }}</td>
                <td>{{ list.applicant_name }}</td>
                <td>{{ list.sports }}</td>
                <td>{{ list.number }}</td>
                <td>{{ list.inout }}</td>
                <td>{{ list.destination }}</td>
                <td>{{ list.sdate }}</td>
                <td>{{ list.edate }}</td>
                <td v-bind:class="{s_blue_txt: list.state == '400' || list.state == '401'}">
                  {{ list.state == '400' ? '확인대기' : list.state == '401' ? '재확인대기' : '확인완료'}}
                </td>
                <td>{{ list.check_name }}</td>
              </tr>
              <tr v-if="inoutInfo.length == 0">
                <td colspan="13">
                  <p class="m_no_list">
                    <span class="no_list_icon">
                      <img src="/front/img/search_icon.png" alt=""/>
                    </span>
                    조회된 결과가 없습니다.
                  </p>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    <!-- 컨텐츠 영역. e. -->

    <!-- 선수 신청자 팝업 -->
    <transition name="fade">
      <div id="l_popup__applicant" class="m_popup m_request_outgoing__popup" v-if="showPopup">
        <div>
          <h1>외출/외박 신청 선수 명단</h1>
          <div class="m_popup__panel">
            <div>
              <span>감독</span>
              <span class="m_panel__number s_blue_txt">{{ supervisor }}</span>
            </div>
            <div>
              <span>코치</span>
              <span class="m_panel__number s_blue_txt">{{ coach }}</span>
            </div>
            <div>
              <span>트레이너</span>
              <span class="m_panel__number s_blue_txt">{{ trainer }}</span>
            </div>
            <div>
              <span>선수</span>
              <span class="m_panel__number s_blue_txt">{{ player }}</span>
            </div>
            <div>
              <span>총인원</span>
              <span class="m_panel__number s_orange_txt">{{ playerTot }}</span>
            </div>
          </div>
        </div>
        <div class="m_popup__table">
          <table>
            <caption>외출/외박 신청 선수 명단</caption>
            <thead>
              <tr>
                <th></th>
                <th>선수번호</th>
                <th>성명</th>
                <th>성명(영문)</th>
                <th>성별</th>
                <th>생년월일</th>
                <th>직위</th>
                <th>소속</th>
                <th>장애여부</th>
                <th>장애유형</th>
                <th>경기등급</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(list, key) in inoutPlayerInfo" :key="key">
                <td class="m_field__radio_grp">
                  <input name="assign_player_seq" type="radio" class="m_field__radio_button_input" :value="list.assign_player_seq" @change="checkRadioBtn('assign_player_seq', key)"/>
                  <i class="m_field__radio_button" @click="checkRadioBtn('assign_player_seq', key)"></i>
                </td>
                <td>{{ list.player_seq }}</td>
                <td>{{ list.player_name }}</td>
                <td>{{ list.player_en_name }}</td>
                <td>{{ list.gender }}</td>
                <td>{{ list.birthday }}</td>
                <td>{{ list.position }}</td>
                <td>{{ list.area }}</td>
                <td>{{ list.disabledstate == '장애인' ? 'O' : 'X'}}</td>
                <td>{{ list.disabledtype }}</td>
                <td>{{ list.disabledgrade }}</td>
              </tr>
              <tr v-if="inoutPlayerInfo.length == 0">
                <td colspan="13">
                  <p class="m_no_list">
                    숙소배정 후, 외출/외박 신청을 할 수 있습니다.
                  </p>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="l_search_btns l_popup_btns">
          <button class="s_blue" @click="choicePlayer()">확인</button>
          <button class="s_white" @click="closePopup(l_popup__applicant)">취소</button>
        </div>
      </div>
    </transition>
  </div>
</section>
<script>

var cont=new Vue({
    el:"#icContent",
    data:{
      // api
      api_select_box: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_item_custom.asp',
      api_inout_list: 'http://ic.sportsdiary.co.kr/api/inout_manager/inout_list.asp',
      api_inout_player_list: 'http://ic.sportsdiary.co.kr/api/inout_manager/inout_player_list.asp',
      api_inout_add: 'http://ic.sportsdiary.co.kr/api/inout_manager/inout_add.asp',
      api_inout_modify: 'http://ic.sportsdiary.co.kr/api/inout_manager/inout_modify.asp',
      api_inout_delete: 'http://ic.sportsdiary.co.kr/api/inout_manager/inout_del.asp',
      
      inoutInfo: [], // 외출/외박 리스트
      // 외출/외박 선택시 나오는 정보
      outing: '1', // 외출
      overnight: '', // 외박
      applicant: '', // 신청자
      leader: '', // 지도자
      dormitory: '', // 숙소
      apply_reason: 'IO0006', // 외출/외박 신청 이유 selected item
      applyReasonInfo: [], // 외출/외박 셀렉트박스 array
      destination: '', // 도착지
      sDate: '', // 시작일
      eDate: '', // 종료일
      start_date_hour: '01', // 시작일 :시간 selected item
      start_date_minute: '00', // 시작일 : 분 selected item
      end_date_hour: '01', // 종료일 : 시간 selected item
      end_date_minute: '00', // 종료일 : 분 selected item
      date_hours: [], // 시간 셀렉트박스 array
      date_minutes: [], // 분 셀렉트 박스 array 
      previous_list : [], // 수정이 됐는지 안됐는지 확인하기 비교하기 위한 list
      // 외출/외박, 신청자 선수 명단 팝업
      inoutPlayerInfo: [], // 외출/외박 선수 리스트
      supervisor: 0, // 감독
      coach: 0, // 코치
      trainer: 0, // 트레이너
      player: 0, // 선수
      playerTot: 0, // 총인원
      player_no: '', // 선수 number
      // 외출,외박 리스트 클릭 시, 해당 외출/외박 정보
      IO: {
        reason: '1',
        assign_player_seq: '',
        player_seq: '',
        inout_seq: '',
        destination: '',
        sdate: '',
        edate: '',
        seq: '',
      },
      // flag
      choicedata: false, // 외출/외박 리스트를 클릭했느냐, 하지 않았느냐
      isChange: false, // 수정됐느냐, 되지 않았느냐 (수정버튼 활성화 조건)
      showPopup: false,
    },
    watch:{
      // 수정 버튼 활성화 조건
      applicant:function() {
        if (this.previous_list.player_name !== this.applicant){
          this.isChange = true;
        }
      },
      leader:function() {
        if (this.previous_list.applicant_name !== this.leader){
          this.isChange = true;
        }
      },
      apply_reason:function() {
        if (this.previous_list.inout_seq !== this.apply_reason){
          this.isChange = true;
        }
      },
      destination:function() {
        if (this.previous_list.destination !== this.destination){
          this.isChange = true;
        }
      },
      sDate:function() {
        if (this.previous_list.sdate !== this.sDate){
          this.isChange = true;
        }
      },
      eDate:function() {
        if (this.previous_list.edate !== this.eDate){
          this.isChange = true;
        }
      },
      start_date_hour:function() {
        if (this.previous_list.sH !== this.start_date_hour){
          this.isChange = true;
        }
      },
      start_date_minute:function() {
        if (this.previous_list.sM !== this.start_date_minute){
          this.isChange = true;
        }
      },
      end_date_hour:function() {
        if (this.previous_list.eH !== this.end_date_hour){
          this.isChange = true;
        }
      },
      end_date_minute:function() {
        if (this.previous_list.eM !== this.end_date_minute){
          this.isChange = true;
        }
      },
    },
    methods:{
      // 날짜 설정
      setDate: function() {
        var date = new Date();
        var hour = '', minute = '';
        var _this = this;

        this.sDate = this.calcDate(date);
        this.eDate = this.calcDate(date);

        for(var i = 0; i < 24; i++) {
          if (String(i).split('').length == 1) hour = '0' + i;
          else hour = String(i);

          _this.date_hours.push(hour);
        }

        for(var j = 0; j < 6; j++) {
          minute = j + '0';
          _this.date_minutes.push(minute);
        }
      },

      // 날짜 계산 (년도,월,일)
      calcDate: function(date) {
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var day = date.getDate();

        if (String(month).split('').length < 2) month = '0' + month;
        if (String(day).split('').length < 2) day = '0' + day;

        return year + '-' + month + '-' + day;
      },

      // 달력 불러오기
      loadCalendar:function() {
        var calendar = document.querySelector(".sDate");
        flatpickr(calendar,{
          locale:"ko",
        });

        var calendar2 = document.querySelector(".eDate");
        flatpickr(calendar2,{
          locale:"ko",
        });
      },

      // 외출/외박 셀렉트 박스 가져오기
      loadInoutSelectBoxList:function() {
        var _this=this;

        _this.applyReasonInfo = selected_item.IO;
      },

      // 외출/외박 리스트 가져오기
      loadInoutList:function() {
        var _this=this;

        axios.post(_this.api_inout_list,{
        }).then(function(response){
          if(response.data.state=="true"){
            _this.inoutInfo = response.data.inout_player;
          } else {
            if (response.data.errorcode == 'ERR-130') {
              _this.inoutInfo = [];
            }
          }
        }).catch(function(error){
          console.log("외출/외박 list error : ");
          console.log(error);
        }).finally(function(){
          console.log("외출/외박 list success");
          _this.loadCalendar();
        });
      },

      // 외출/외박 선수 리스트 가져오기
      loadInoutPlayerList:function() {
        var _this=this;

        axios.post(_this.api_inout_player_list,{
        }).then(function(response){
          if(response.data.state=="true"){
            _this.playerTot = response.data.total;
            _this.inoutPlayerInfo = response.data.inout_player;
            _this.calcPlayerNum(response.data.inout_player);
          }
        }).catch(function(error){
          console.log("외출/외박 선수 list error : ");
          console.log(error);
        }).finally(function(){
          console.log("외출/외박 선수 list success");
        });
      },

      // 선수 인원 계산
      calcPlayerNum: function(data) {
        var su = 0, co = 0, tr = 0, pl = 0;

        data.forEach(function(player, i){
          switch (player.position) {
            case '감독' : su++; break;
            case '코치' : co++; break;
            case '트레이너' : tr++; break;
            case '선수' : pl++; break;
            default: '';
          }
        });

        this.supervisor = su;
        this.coach = co;
        this.trainer = tr;
        this.player = pl;
      },

      // 신청자 선수 선택 시, 데이터 설정
      choicePlayer:function() {
        var c_player = this.inoutPlayerInfo[this.player_no];

        this.applicant = c_player.player_name;
        this.leader = c_player.applicant_name;
        this.dormitory = c_player.number;

        this.IO.player_seq = c_player.player_seq;
        this.closePopup('#l_popup__applicant');
      },

      // 신청자 선수 선택 시, 라디오버튼 이벤트
      checkRadioBtn:function(name, key) {
        var radioBtn = $('.m_field__radio_button');
        var radioInput = '';
        var _this = this;

        this.isChange = true;

        radioBtn.each(function(idx) {
          if (idx == key) {
            radioInput = $('.m_field__radio_button_input[name='+ name +']').eq(key);
            radioInput.prop('checked', true);

            if (name == 'applyDiv') {
              _this.IO.reason = radioInput.val();
            } else {
              _this.IO.assign_player_seq = radioInput.val();
              _this.player_no = key;
            }
          }
        });
      },

      // 외출/외박 신청, 수정시 데이터 설정
      setData:function() {
        this.IO.sdate = this.sDate + ' ' + this.start_date_hour + ':' + this.start_date_minute;
        this.IO.edate = this.eDate + ' ' + this.end_date_hour + ':' + this.end_date_minute;
        this.IO.destination = this.destination;
        this.IO.inout_seq = this.apply_reason;
      },

      // 외출/외박 신청
      addInout:function() {
        var _this=this;

        _this.setData();

        if(this.IO.player_seq == '' || this.IO.player_seq == undefined){
            alert('선수를 선택하세요.');
            return false;
        }

        if(_this.IO.destination == '' || _this.IO.destination == undefined){
            alert('목적지를 입력하세요.');
            return false;
        }

        axios.post(_this.api_inout_add,{
          player_seq: this.IO.player_seq,
          assign_player_seq: this.IO.assign_player_seq,
          reason: this.IO.reason,
          inout_seq: this.IO.inout_seq,
          destination: this.IO.destination,
          sdate: this.IO.sdate,
          edate: this.IO.edate
        }).then(function(response){
          if(response.data.state=="true"){
            console.log('등록완료');
            
            _this.loadInoutList();
            _this.resetData();
          } else {
            if (response.data.errorcode == 'ERR-730') {
              alert('선수 입촌기간에 해당하는 기간이 아닙니다. 날짜를 다시 선택해 주세요.');
            }
          }
        }).catch(function(error){
          console.log("외출/외박 선수 add error : ");
          console.log(error);
        });
      },

      // 외출/외박 수정
      modifyInout:function() {
        var _this=this;

        if (this.isChange == false) {
          return false;
        }

        _this.setData();

        axios.post(_this.api_inout_modify,{
          player_seq: this.IO.player_seq,
          assign_player_seq: this.IO.assign_player_seq,
          reason: this.IO.reason,
          inout_seq: this.IO.inout_seq,
          destination: this.IO.destination,
          sdate: this.IO.sdate,
          edate: this.IO.edate,
          seq: this.IO.seq
        }).then(function(response){
          if(response.data.state=="true"){
            console.log('수정완료');

            _this.loadInoutList();
            _this.resetData();
          } else {
            if (response.data.errorcode == 'ERR-730') {
              alert('선수 입촌기간에 해당하는 기간이 아닙니다. 날짜를 다시 선택해 주세요.');
            }
          }
        }).catch(function(error){
          console.log("외출/외박 선수 수정 error : ");
          console.log(error);
        });
      },

      // 외출/외박 삭제
      deleteInout:function() {
        var _this=this;

        axios.post(_this.api_inout_delete,{
          seq: _this.IO.seq
        }).then(function(response){
          if(response.data.state=="true"){
            console.log('삭제완료');
          }
        }).catch(function(error){
          console.log("외출/외박 선수 delete error : ");
          console.log(error);
        }).finally(function(){
          _this.loadInoutList();
          _this.resetData();
        });
      },
      // 선택한 테이블
      listInfoChoice:function(list){
        this.choicedata = true;
        this.isChange = false;

        this.previous_list = list;
        this.applicant = list.player_name;
        this.leader = list.applicant_name;
        this.apply_reason = list.inout_seq;
        this.destination = list.destination;
        this.dormitory = list.number;
        if (list.reason == '1') {
          this.outing = '1';
          this.overnight = '';
        } else {
          this.outing = '';
          this.overnight = '2';
        }
        this.sDate = list.sdate;
        this.eDate = list.edate;
        this.start_date_hour = list.sH;
        this.start_date_minute = list.sM;
        this.end_date_hour = list.eH;
        this.end_date_minute = list.eM;

        this.IO.reason = list.reason;
        this.IO.player_seq = list.player_seq;
        this.IO.seq = list.seq;
        this.IO.assign_player_seq = list.assign_player_seq;

        this.highlight(list.no);
      },

      // 리셋 (신규 버튼 클릭시, 등록,수정,삭제 후)
      resetData:function() {
        this.choicedata = false;
        this.isChange = false;
        this.previous_list = [];

        this.setDate();

        this.applicant = '';
        this.leader = '';
        this.apply_reason = 'IO0006';
        this.destination = '';
        this.dormitory = '';
        this.outing = '1';
        this.overnight = '';
        this.start_date_hour = '01';
        this.start_date_minute = '00';
        this.end_date_hour = '01';
        this.end_date_minute = '00';
      },

      // 팝업 열기
      openPopup:function(popup) {
        this.showPopup = true;
        $('#l_popup__dimm').addClass('active');
      },

      // 팝업 닫기
      closePopup:function(popup) {
        this.showPopup = false;
        $('#l_popup__dimm').removeClass('active');
      },
      
      // 테이블 선택 시 hightlight
      highlight:function(no) {
        $('.l_list_tablewrap tr').removeClass('highlight');
        $('.l_list_tablewrap tr').eq(no).addClass('highlight');
      },
    },
    mounted:function(){
      // init
      this.setDate();
      this.loadInoutSelectBoxList();
      this.loadInoutList();
      this.loadInoutPlayerList();
    },
    created:function(){
      eventBus.$emit("menuinfo");
      eventBus.$emit("menudrop", [9,3]);
    }
});
  </script>
</body>
</html>
