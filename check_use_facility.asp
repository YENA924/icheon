<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->


<section id="icContent" class="l_ct l_check_use_facility" v-cloak>
  <div class="l_content">
    <!-- 컨텐츠 영역. s. -->
    <h2>시설별 이용현황</h2>
  
    <div class="l_select_box_field">
        <div class="l_field">
          <label for="date">이용일자</label>
          <input type="text" name="date" id="date" class="date" placeholder="날짜선택" v-model="date">
          <button class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></button>
        </div>
        <div class="l_field">
          <label for="quarter">동/관</label>
          <select name="quarter" id="quarter" v-model="quarter">
            <option value="0">전체</option>
            <option v-for="(select, key) in quarter_arr" :key="key" :value="select.seq">{{ select.title }}</option>
          </select>
        </div>
        <div class="l_field">
          <label for="facility_type">시설현황</label>
          <select name="facility_type" id="facility_type" v-model="facility_type">
            <option value="0">전체</option>
            <option v-for="(select, key) in facility_type_arr" :key="key" :value="select">{{ select }}</option>
          </select>
        </div>
      <div class="l_search_btns">
        <button type="submit" class="s_white" @click="loadUseFacilityList()">조회</button>
      </div>
    </div>

    <!-- 목록 테이블 형식. s. -->
    <div class="l_list_box">
      <div class="l_list_tablewrap">
        <table>
          <caption>시설이용현황 조회 테이블</caption>
          <thead>
            <tr>
              <th></th>
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
          <tbody>
            <tr v-for="(list, key) in facilityInfo" :key="key">
              <td>{{ list.no }}</td>
              <td>{{ list.searchdate }}</td>
              <td>{{ list.quarter }}</td>
              <td>{{ list.floor }}</td>
              <td>{{ list.number }}</td>
              <td>{{ list.use_type }}</td>
              <td>{{ list.times }}</td>
              <td>{{ list.gubun }}</td>
              <td>{{ list.association }}</td>
              <td>{{ list.use_date }}</td>
              <td>{{ list.type_title }}</td>
              <td>{{ list.name }}</td>
              <td>{{ list.use_count }}</td>
            </tr>
            <tr v-if="facilityLen == 0" class="m_tr__empty">
              <td colspan="100%">
                <p class="m_no_list">
                  <span class="no_list_icon">
                    <img src="/front/img/search_icon.png" alt=""/>
                  </span>
                  검색된 결과가 없습니다.
                </p>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
</section>

<script>
var cont=new Vue({
  el:"#icContent",
  data:{
    // api
    api_select_box: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_item_custom.asp',
    api_select_box_facility: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_facility.asp',
    api_facility_list: 'http://ic.sportsdiary.co.kr/api/facility_manager/facility_use_list.asp',
    // 메인 셀렉트 박스
    date: '', // 이용일자
    quarter: '0', // 동/관 selected item
    facility_type: '0', // 시설현황 selected item
    quarter_arr: [], // 동/관 셀렉트박스 array
    facility_type_arr: ['이용중', '공실'], // 시설현황 셀렉트 박스 array
    // 시설이용현황 리스트
    facilityTot: '', // 시설이용현황 total
    facilityAllInfo: [], // 시설이용현황 모든 리스트
    facilityInfo: [], // 시설이용현황 조회 리스트
    facilityLen: 1, // 시설이용현황 조회 리스트 length
  },
  watch:{},
  methods:{
    // 날짜 설정
    setDate: function() {
      var date=new Date();

      var year = date.getFullYear();
      var month = date.getMonth() + 1;
      var day = date.getDate();

      if (String(month).split('').length < 2) month = '0' + month;
      if (String(day).split('').length < 2) day = '0' + day;

      this.date = year + '-' + month + '-' + day;
    },

    // 달력 가져오기
    loadCalendar:function() {
      var calendar = document.querySelector(".date");
      flatpickr(calendar,{
        locale:"ko",
      });
    },

    // 공지타입 셀렉트박스 조회
    loadUseFacilitySelectBox: function() {
      var _this = this;

      _this.quarter_arr = selected_item.QT;
    },

    // 시설별 이용현황 리스트 가져오기
    loadUseFacilityList:function() {
      var _this=this;

      axios.post(_this.api_facility_list,{
        usedate: _this.date
      }).then(function(response){
        if(response.data.state=="true"){
          _this.facilityTot = response.data.total;
          _this.facilityAllInfo = response.data.facility;
        } else {
          if (response.data.errorcode == 'ERR-130') {
            _this.facilityAllInfo = [];
          }
        }
      }).catch(function(error){
        console.log("시설별 이용현황 list error : ");
        console.log(error);
      }).finally(function(){
        console.log("시설별 이용현황 list success");
        _this.searchUseFacilityList();
      });
    },

    // 시설별 이용현황 검색
    searchUseFacilityList:function() {
      var _this = this;
      var qt = this.quarter;
      var ft = this.facility_type;

      if (_this.facilityAllInfo.length == 0) return false;
      
      this.facilityInfo = [];
      
      if (qt == '0' && ft == '0') {
        this.facilityInfo = this.facilityAllInfo;
        
      } else if (qt == '0' && ft !== '0'){
          this.facilityAllInfo.forEach(function(info, idx) {
          if (info.use_type == ft) {
            _this.facilityInfo.push(info);
          }
        });  
      }else if (ft == '0' && qt !== '0') {
        this.facilityAllInfo.forEach(function(info, idx) {

          if (info.quarter_seq == qt) {
            _this.facilityInfo.push(info);
          }
        });
      } else if (qt !== '0' && ft !== '0') {
        this.facilityAllInfo.forEach(function(info, idx) {

          if (info.quarter_seq == qt && info.use_type == ft) {
            _this.facilityInfo.push(info);
          }
        });
      }

      this.facilityLen = this.facilityInfo.length;
    },
  },
  mounted:function(){
    this.loadCalendar();
  },
  created:function(){
    eventBus.$emit("menuinfo");
    eventBus.$emit("menudrop", [10,2]);

    this.setDate();
    this.loadUseFacilityList();
    this.loadUseFacilitySelectBox();
  }
});
</script>
</body>
</html>