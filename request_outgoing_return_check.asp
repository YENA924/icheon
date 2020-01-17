<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->
<section id="icContent" class="l_ct l_request_outgoing_check" v-cloak>
  <div class="l_content">
    <h2>외출/외박 복귀 조회</h2>

    <div class="l_search_box">
      <div class="l_search_field">
        <div class="l_field">
          <label for="date">날짜선택</label>
          <input type="text" name="date" id="date" class="date" placeholder="날짜선택" v-model="date">
          <button class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></button>
        </div>
        <div class="l_field">
          <label for="sports">종목선택</label>
          <select name="sports" id="sports" v-model="sport">
            <option value="">전체</option>
            <option v-for="(select,key) in sportsInfo" :key="key" :value="select.seq">{{select.title}}</option>
          </select>
        </div>
        <div class="l_field">
          <label for="name">성명</label>
          <input type="text" name="name" id="name" class="name" placeholder="이름을 입력하세요." v-model="searchstr">
        </div>
        <div class="l_search_btns m_inline">
          <button type="submit" class="s_white" @click="loadInoutCheckList()">조회</button>
        </div>
      </div>
    </div>

    <div class="l_search_box" style="background: #fff;margin-top:30px;" v-show="isChoiceList">
      <div class="l_search_field l_readonly">
        <div class="l_field">
          <label for="reason">신청구분</label>
          <input id="reason" name="reason" type="text" value="" v-model="reason" disabled/>
        </div>
        <div class="l_field">
          <label for="applicant">신청자</label>
          <input id="applicant" name="applicant" type="text" v-model="applicant" disabled/>
        </div>
        <div class="l_field">
          <label for="leader">지도자</label>
          <input id="leader" name="leader" type="text" value="" v-model="leader" disabled/>
        </div>
        <div class="l_field">
          <label for="dormitory">사용호실</label>
          <input id="dormitory" name="dormitory" type="text" value="" v-model="dormitory" disabled/>
        </div>
      </div>
      <div class="l_search_field l_readonly">
        <div class="l_field">
          <label for="apply_reason">신청사유</label>
          <input id="apply_reason" name="apply_reason" type="text" value="" v-model="apply_reason" disabled/>
        </div>
        <div class="l_field">
          <label for="destination">목적지</label>
          <input id="destination" name="destination" type="text" value="" v-model="destination" disabled/>
        </div>
        <div class="l_field">
          <label for="sDate">출발예정일시</label>
          <input id="sDate" name="sDate" type="text" value="" v-model="sdate" disabled/>
        </div>
        <div class="l_field">
          <label for="eDate">복귀예정일시</label>
          <input id="eDate" name="eDate" type="text" value="" v-model="edate" disabled/>
        </div>
      </div>
      <div class="l_search_btns">
        <button type="submit" v-if="state !== '402'" class="s_blue" @click="updateInoutCheck()">확인</button>
        <button type="submit" v-else class="gray s_blue" @click="updateInoutCheck()">확인완료</button>
      </div>
    </div>

      <!-- 목록 테이블 형식. s. -->
      <div class="l_list_box">
        <div class="l_list_tablewrap" style="overflow-y: auto;">
          <table>
            <caption>외출/외박 신청 확인</caption>
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
                <th>복귀확인일시</th>
                <th>복귀예정일시</th>
                <th>승인</th>
                <th>승인자</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(list,key) in inoutInfo" :key="key" @click="listInfoChoice(list)">
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
                <td>{{ list.echkdate == '' ? '-' : list.echkdate }}</td>
                <td>{{ list.edate }}</td>
                <td v-bind:class="{s_orange_txt: list.state == '400' || list.state == '401'}">
                  {{ list.state == '400' ? '확인요청' : list.state == '401' ? '재확인요청' : '확인완료'}}
                </td>
                <td>{{ list.check_name }}</td>
              </tr>
              <tr v-if="inoutInfo.length == 0">
                <td colspan="14">
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
  </div>
</section>

<script>
var cont=new Vue({
  el:"#icContent",
  data:{
    // api
    api_select_box: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_item_custom.asp',
    api_inout_incheck_list: 'http://ic.sportsdiary.co.kr/api/inout_manager/inout_incheck_list.asp',
    api_inout_update: 'http://ic.sportsdiary.co.kr/api/inout_manager/inout_incheck_update.asp',
    // 셀렉트 박스
    date: '',  // 날짜
    sport: '', // 종목 selected item
    sportsInfo: [], // 종목 셀렉트 박스 array
    searchstr: '', // 이름 검색
    // 외출/외박 상세정보
    seq: '', // seq
    reason: '', // 외출/외박
    applicant: '', // 신청자
    position: '', // 직위
    leader: '', // 지도자
    dormitory: '', // 숙소
    apply_reason: '', // 외출/외박 신청 이유
    destination: '', // 목적지
    sdate: '', // 외출/외박 시작일
    edate: '', // 외출/외박 복귀일
    state: '', // 상태
    // 외출/외박 리스트
    inoutInfo: [],
    // flag
    isChoiceList: false, // 개별 리스트를 선택했는가, 하지 않았는가
  },
  watch:{},
  methods:{
    // 날짜 설정
    setDate: function() {
      var date = new Date();

      var year = date.getFullYear();
      var month = date.getMonth() + 1;
      var day = date.getDate();

      if (String(month).split('').length < 2) month = '0' + month;
      if (String(day).split('').length < 2) day = '0' + day;

      this.date = year + '-' + month + '-' + day;
    },

    // 달력설정, 불러오기
    loadCalendar:function() {
      // 달력 관련
      var calendar = document.querySelector(".date");
      flatpickr(calendar,{
        locale:"ko",
      });
    },

    // 외출/외박 셀렉트 박스 가져오기
    loadInoutSelectBoxList:function() {
      var _this=this;

      _this.sportsInfo = selected_item.SP;
    },

    // 외출/외박 리스트 가져오기
    loadInoutList:function() {
      var _this=this;

      axios.post(_this.api_inout_incheck_list,{
        sdate: _this.date,
        sports_seq: _this.sport,
        searchstr: _this.searchstr
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
      });
    },

    // 외출/외박 리스트에서 선수 조회
    loadInoutCheckList:function() {
      var _this=this;

      axios.post(_this.api_inout_incheck_list,{
        edate: _this.date,
        sports_seq: _this.sport,
        searchstr: _this.searchstr
      }).then(function(response){
        if(response.data.state=="true"){
          _this.inoutInfo = response.data.inout_player;
        } else {
          if (response.data.errorcode == 'ERR-130') {
            _this.inoutInfo = [];
          }
        }
      }).catch(function(error){
        console.log("외출/외박 선수 조회 error : ");
        console.log(error);
      }).finally(function(){
        console.log("외출/외박 선수 조회 success");
      });
    },

    // 외출/외박 확인
    updateInoutCheck:function() {
      var _this=this;

      if (this.state == '402') {
        alert('이미 확인한 외출/외박 내용입니다.');
        return false;
      }
      
      axios.post(_this.api_inout_update,{
        seq: this.seq
      }).then(function(response){
        if(response.data.state=="true"){
          console.log('승인완료');
        }
      }).catch(function(error){
        console.log("외출/외박 선수 승인 error : ");
        console.log(error);
      }).finally(function(){
        _this.loadInoutCheckList();
        _this.resetData();
      });
    },

    // 외출/외박 개별 리스트 클릭 시
    listInfoChoice:function(list){
      this.isChoiceList = true;
      this.applicant = list.player_name;
      this.leader = list.applicant_name;
      this.apply_reason = list.inout;
      this.destination = list.destination;
      this.dormitory = list.number;
      if (list.reason == '1') {
        this.reason = '외출';
      } else {
        this.reason = '외박';
      }
      this.sdate = list.sdate;
      this.edate = list.edate;
      this.seq = list.seq;
      this.state = list.state;
      this.highlight(list.no);
    },

    // 외출/외박 복귀 확인시 리셋 데이터
    resetData:function() {
      this.isChoiceList = false;
      this.applicant = '';
      this.leader = '';
      this.apply_reason = '';
      this.destination = '';
      this.dormitory = '';
      this.reason = '';
      this.sdate = '';
      this.edate = '';
      this.state = '';
    },

    // 팝업 열기
    openPopup:function(popup) {
      $('#l_popup__dimm').addClass('active');
      $(popup).addClass('active');
    },

    // 팝업 닫기
    closePopup:function(popup) {
      $('#l_popup__dimm').removeClass('active');
      $(popup).removeClass('active');
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
    this.loadCalendar();
    this.loadInoutSelectBoxList();
    this.loadInoutList();
  },
  created:function(){
    eventBus.$emit("menuinfo");
    eventBus.$emit("menudrop", [9,5]);
  }
});
</script>
</body>
</html>
