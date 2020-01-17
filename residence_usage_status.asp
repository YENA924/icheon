<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct l_residence_usage_status" v-cloak>
  <div class="l_content">
    <!-- 컨텐츠 영역. s. -->
    <h2>숙소이용현황</h2>
  
    <div class="l_search_box">
      <div class="l_search_field">
        <div class="l_field">
          <label for="date">날짜선택</label>
          <input type="text" name="date" id="date" class="date" placeholder="날짜선택" v-model="date">
          <button class="l_btn_calendar"><img src="/front/img/icon_calendar2.png" alt="달력선택"></button>
        </div>
        <div class="l_field">
          <label for="sports">종목선택</label>
          <select name="sports" id="sports" v-model="sports">
            <option value="">전체</option>
            <option v-for="(select,key) in sportsInfo" :key="key" :value="select.seq">{{select.title}}</option>
          </select>
        </div>
        <div class="l_search_btns m_inline">
          <button type="submit" class="s_blue" @click="loadResidenceList()">조회</button>
        </div>
      </div>
    </div>

      <div class="l_list_btn">
        <ul>
          <li class="l_list" @click="changeListFloor(1)" v-bind:class="{active: floor == 1}">1층</li>
          <li class="l_list" @click="changeListFloor(2)" v-bind:class="{active: floor == 2}">2층</li>
          <li class="l_list" @click="changeListFloor(3)" v-bind:class="{active: floor == 3}">3층</li>
          <li class="l_list" @click="changeListFloor(4)" v-bind:class="{active: floor == 4}">4층</li>
        </ul>
      </div>
      <!-- 목록 테이블 형식. s. -->
      <div class="l_list_box">
        <div class="l_list_tablewrap l_list_roomwrap" v-if="floor == 1">
          <!-- 숙소 -->
          <template v-for="(list, key) in residenceInfo1" :key="key">
            <div v-if="list.fixed_info.length == 0" class="m_room__wrap empty">
              <div class="m_room__number">
                <p class="m_number">{{ list.number }} 호</p>
              </div>
              <div class="m_room">
                <template v-for="n in Number(list.fixed)" :key="key">
                  <div class="m_room__people">
                    <img src="/front/img/num_stayed_peopole.png" alt="사람 이미지"/>
                    <span class="m_name">-</span>
                  </div>
                </template>
              </div>
            </div>
            <div v-else class="m_room__wrap" @click="getResidence(list, $event.target)" style="cursor: pointer;">
              <div class="m_room__number">
                <p class="m_number">{{ list.number }} 호</p>
              </div>
              <div class="m_room">
                <template v-for="(player,key) in list.fixed_info" :key="key">
                  <div class="m_room__people">
                    <img src="/front/img/num_stayed_peopole.png" alt="사람 이미지"/>
                    <span class="m_name">{{ player.name }}</span>
                  </div>
                </template>
              </div>
            </div>
          </template>
        </div>
        <div class="l_list_tablewrap l_list_roomwrap" v-if="floor == 2">
          <!-- 숙소 -->
          <template v-for="(list, key) in residenceInfo2" :key="key">
            <div v-if="list.fixed_info.length == 0" class="m_room__wrap empty">
              <div class="m_room__number">
                <p class="m_number">{{ list.number }} 호</p>
              </div>
              <div class="m_room">
                <template v-for="n in Number(list.fixed)" :key="key">
                  <div class="m_room__people">
                    <img src="/front/img/num_stayed_peopole.png" alt="사람 이미지"/>
                    <span class="m_name">-</span>
                  </div>
                </template>
              </div>
            </div>
            <div v-else class="m_room__wrap" @click="getResidence(list, $event.target)" style="cursor: pointer;">
              <div class="m_room__number">
                <p class="m_number">{{ list.number }} 호</p>
              </div>
              <div class="m_room">
                <template v-for="(player,key) in list.fixed_info" :key="key">
                  <div class="m_room__people">
                    <img src="/front/img/num_stayed_peopole.png" alt="사람 이미지"/>
                    <span class="m_name">{{ player.name }}</span>
                  </div>
                </template>
              </div>
            </div>
          </template>
        </div>
        <div class="l_list_tablewrap l_list_roomwrap" v-if="floor == 3">
          <template v-for="(list, key) in residenceInfo3" :key="key">
            <div v-if="list.fixed_info.length == 0" class="m_room__wrap empty">
              <div class="m_room__number">
                <p class="m_number">{{ list.number }} 호</p>
              </div>
              <div class="m_room">
                <template v-for="n in Number(list.fixed)" :key="key">
                  <div class="m_room__people">
                    <img src="/front/img/num_stayed_peopole.png" alt="사람 이미지"/>
                    <span class="m_name">-</span>
                  </div>
                </template>
              </div>
            </div>
            <div v-else class="m_room__wrap" @click="getResidence(list, $event.target)" style="cursor: pointer;">
              <div class="m_room__number">
                <p class="m_number">{{ list.number }} 호</p>
              </div>
              <div class="m_room">
                <template v-for="(player,key) in list.fixed_info" :key="key">
                  <div class="m_room__people">
                    <img src="/front/img/num_stayed_peopole.png" alt="사람 이미지"/>
                    <span class="m_name">{{ player.name }}</span>
                  </div>
                </template>
              </div>
            </div>
          </template>
        </div>
        <div class="l_list_tablewrap l_list_roomwrap" v-if="floor == 4">
          <template v-for="(list, key) in residenceInfo4" :key="key">
            <div v-if="list.fixed_info.length == 0" class="m_room__wrap empty">
              <div class="m_room__number">
                <p class="m_number">{{ list.number }} 호</p>
              </div>
              <div class="m_room">
                <template v-for="n in Number(list.fixed)" :key="key">
                  <div class="m_room__people">
                    <img src="/front/img/num_stayed_peopole.png" alt="사람 이미지"/>
                    <span class="m_name">-</span>
                  </div>
                </template>
              </div>
            </div>
            <div v-else class="m_room__wrap" @click="getResidence(list, $event.target)" style="cursor: pointer;">
              <div class="m_room__number">
                <p class="m_number">{{ list.number }} 호</p>
              </div>
              <div class="m_room">
                <template v-for="(player,key) in list.fixed_info" :key="key">
                  <div class="m_room__people">
                    <img src="/front/img/num_stayed_peopole.png" alt="사람 이미지"/>
                    <span class="m_name">{{ player.name }}</span>
                  </div>
                </template>
              </div>
            </div>
          </template>
        </div>
      </div>
    <!-- 컨텐츠 영역. e. -->
  </div>
  <!-- 선수 신청자 팝업 -->
  <transition name="fade">
    <div id="l_popup__residence" class="m_popup m_residence__popup" v-if="showPopup">
      <div>
        <h1>숙소이용현황 - {{ today }}</h1>
      </div>
      <div class="m_popup__table">
        <h1>{{ residence_number }}호 ({{ residence_floor }}층)</h1>
        <table>
          <caption>숙소이용현황 상세 팝업 테이블</caption>
          <thead>
            <tr>
              <th>침대</th>
              <th>이름</th>
              <th>종목</th>
              <th>직위</th>
              <th>장애여부</th>
              <th>입촌시작일</th>
              <th>입촌종료일</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(player,key) in residence" :key="key">
              <td>{{ player.bed_name }}</td>
              <td>{{ player.name }}</td>
              <td>{{ player.sports }}</td>
              <td>{{ player.position }}</td>
              <td>{{ player.disabledstate }}</td>
              <td>{{ player.sdate }}</td>
              <td>{{ player.edate }}</td>
            </tr>
          </tbody>
        </table>
        <div class="l_search_btns">
          <button class="s_blue" @click="closePopup(l_popup__residence)">확인</button>
        </div>
      </div>
    </div>
  </transition>
</section>

<script>
  var cont=new Vue({
    el:"#icContent",
    data:{
      // api
      api_select_box: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_item_custom.asp',
      api_assign_situation_list: 'http://ic.sportsdiary.co.kr/api/assign_manager/assign_situation_list.asp',
      floor: '1', // 층
      // 셀렉트박스
      date: '', // 날짜
      sports: '', // 종목 selected item
      sportsInfo: [], // 종목 셀렉트박스 array
      // 숙소이용현황 list
      residenceTot: '', // 숙소이용현황 total
      residenceInfo1: [], // 1층 
      residenceInfo2: [], // 2층
      residenceInfo3: [], // 3층
      residenceInfo4: [], // 4층
      // 팝업
      today: '', // 오늘 날짜
      residence_number: '', // 해당 호실
      residence_floor: '', // 해당 층
      residence: [], // 해당 숙소를 사용하고 있는 선수 목록
      calendar: '',
      // flag
      showPopup: false, // 팝업 show/hide
    },
    watch:{},
    methods:{
      // 등록날짜 설정
      setDate: function() {
        var date=new Date();

        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var day = date.getDate();

        if (String(month).split('').length < 2) month = '0' + month;
        if (String(day).split('').length < 2) day = '0' + day;

        this.date = year + '-' + month + '-' + day;
        this.today = year + '년 ' + month + '월 ' + day + '일';
      },

      // 달력 가져오기
      loadCalendar:function() {
        var calendar=document.querySelector(".date");
        var _this = this;

        flatpickr(calendar,{
          locale:"ko",
          onChange:function(selectedDates, dateStr) {
            var year = dateStr.split('-')[0];
            var month = dateStr.split('-')[1];
            var day = dateStr.split('-')[2];

            _this.today = year + '년 ' + month + '월 ' + day + '일';
          }
        });
      },

      // 숙소이용현황 셀렉트박스 조회
      loadResidenceSelectBox: function() {
        var _this=this;

        _this.sportsInfo = selected_item.SP;
      },

      // 숙소이용현황 조회
      loadResidenceList:function() {
        var _this=this;

        axios.post(_this.api_assign_situation_list,{
          date: _this.date,
          sports_seq: _this.sports,
        }).then(function(response){
          if(response.data.state=="true"){
            _this.residenceInfo1 = response.data.room1;
            _this.residenceInfo2 = response.data.room2;
            _this.residenceInfo3 = response.data.room3;
            _this.residenceInfo4 = response.data.room4;
          }
        }).catch(function(error){
          console.log("숙소이용현황 error : ");
          console.log(error);
        }).finally(function(){
          console.log("숙소이용현황 success");
        });
      },

      // 층 리스트 클릭시
      changeListFloor:function(data) {
        this.floor = data;
      },

      // 숙소 상세 팝업
      getResidence:function(list, target){
        $(target).closest('.m_room__wrap').addClass('active');

        this.residence_floor = list.floor;
        this.residence_number = list.number;
        this.residence = list.fixed_info;

        this.openPopup('#l_popup__residence');
      },

      // 팝업 열기
      openPopup:function(popup) {
        this.showPopup = true;
        // $(popup).addClass('active');
        $('#l_popup__dimm').addClass('active');
      },

      // 팝업 닫기
      closePopup:function(popup) {
        // $(popup).removeClass('active');
        
        var room = $('.m_room__wrap');

        room.removeClass('active');
        this.showPopup = false;
        $('#l_popup__dimm').removeClass('active');
      },
    },
    mounted:function(){
      this.setDate();
      this.loadCalendar();
      this.loadResidenceSelectBox();
      this.loadResidenceList();
    },
    created:function(){
      // 현재 메뉴(위치) 확인
      eventBus.$emit("menuinfo");
      eventBus.$emit("menudrop", [9,1]);
    }
  });
</script>
</body>
</html>