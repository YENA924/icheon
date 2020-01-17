<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<div id="icContent_wrap">
  <section id="icContent_admin" class="l_ct l_notice" v-if="groupcode == 'ADMIN'" v-cloak>
    <div class="l_content">
      <!-- 컨텐츠 영역. s. -->
      <h2>시설물 건의사항</h2>
  
      <div class="l_search_btns">
        <button type="submit" class="s_blue" @click="initSuggestList()">건의사항 작성</button>
      </div>
        <!-- 목록 테이블 형식. s. -->
        <div class="l_list_box">
          <div class="l_list_tablewrap">
            <table>
              <caption>시설물 건의사항 목록</caption>
              <thead>
                <tr>
                  <th></th>
                  <th>작성일</th>
                  <th>동/관</th>
                  <th>시설</th>
                  <th>작성자</th>
                  <th>처리현황</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(list, key) in suggestInfo" :key="key" @click="getSuggestList(list)">
                  <td>{{ list.num }}</td>
                  <td>{{ list.regdate }}</td>
                  <td>{{ list.quarter }}</td>
                  <td>{{ list.number }}</td>
                  <td>{{ list.username }}</td>
                  <td v-bind:class="{s_orange_txt: list.state == '700'}">
                    {{ list.state == '700' ? '처리대기' : list.state == '701' ? '처리완료' : '처리보류' }}
                  </td>
                </tr>
                <tr v-if="suggestInfo.length == 0">
                  <td colspan="6">
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
          
          <div v-if="suggestInfo.length>0" class="l_paging_area">
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
    <!-- 시설물 건의사항 처리완료/반려 -->
  <transition name="fade">
    <div id="l_popup__suggest_update" class="m_popup m_suggest__popup m_admin" v-if="showUpdatePopup">
      <h1>시설물 건의사항</h1>
      <div class="m_popup__contents">
        <div class="l_search_field">
          <div class="l_field">
            <label for="quarter_update">동/관</label>
            <input type="text" name="quarter_update" id="quarter_update" class="s_gray_txt" placeholder="소속" v-model="quarter" v-if="state !== '701'" disabled />
            <input type="text" name="quarter_update" id="quarter_update" class="s_blue_txt" placeholder="소속" v-model="quarter" v-else readonly />
          </div>
          <div class="l_field">
            <label for="facility_update">시설</label>
            <input type="text" name="facility_update" id="facility_update" class="s_gray_txt" placeholder="소속" v-model="facility" v-if="state !== '701'"  disabled />
            <input type="text" name="facility_update" id="facility_update" class="s_blue_txt" placeholder="소속" v-model="facility" v-else readonly />
          </div>
          <div class="l_field">
            <label for="writer_update">작성자</label>
            <input type="text" name="writer_update" id="writer_update" class="s_gray_txt" placeholder="소속" v-model="writer" v-if="state !== '701'" disabled />
            <input type="text" name="writer_update" id="writer_update" class="s_blue_txt" placeholder="소속" v-model="writer" v-else readonly />
          </div>
        </div>
        <div class="l_search_field" style="margin-top:20px;">
          <div class="l_field">
            <label for="content_update">건의내용</label>
            <textarea type="text" name="content_update" id="content_update" class="s_gray_txt m_large_txt" v-if="state !== '701'" disabled>{{ contents }}</textarea>
            <textarea type="text" name="content_update" id="content_update" class="s_gray_txt m_large_txt" v-else readonly>{{ contents }}</textarea>
          </div>
        </div>
        <div class="l_search_field" v-show="isApproval">
          <div class="l_field">
            <label for="approval_update">보류사유</label>
            <textarea type="text" name="approval_update" id="approval_update" class="s_gray_txt m_large_txt" placeholder="보류 사유 입력" v-model="approval" v-if="state !== '701'"></textarea>
            <textarea type="text" name="approval_update" id="approval_update" class="s_gray_txt m_large_txt" placeholder="보류 사유 입력" v-model="approval" v-else disabled></textarea>
          </div>
        </div>
        <div class="l_search_btns m_inline">
          <button type="submit" class="s_gray" @click="approvalSuggest()" v-if="!isUpdate && state !== '701'">보류</button>
          <button type="submit" class="s_gray" @click="approvalSuggest()" v-if="isUpdate && state !== '701'">보류사유 수정</button>
          <button type="submit" class="s_blue" @click="updateSuggest('Y')" v-show="!isClick && state !== '701'">처리완료</button>
            <div>
              <button type="submit" class="s_white" @click="closePopup(l_popup__suggest_update)">닫기</button>
            </div>
          </div>
      </div>
    </div>
  </transition>

  <!-- 시설물 건의사항 등록 -->
  <transition name="fade">
    <div id="l_popup__suggest_add" class="m_popup m_suggest__popup" v-if="showAddPopup">
      <h1>시설물 건의사항 작성</h1>
      <div class="m_popup__contents">
        <div class="l_search_field">
          <div class="l_field">
            <label for="quarter_add">동/관</label>
            <select name="quarter_add" id="quarter_add" v-model="quarter" @change="changeFacilitySelectBoxList()">
              <option value="0">==선택==</option>
              <option v-for="(select, key) in quarter_arr" :key="key" :value="select.seq">{{ select.title }}</option>
            </select>
          </div>
          <div class="l_field">
            <label for="facility_add">시설</label>
            <select name="facility_add" id="facility_add" v-model="facility">
              <option value="0">==선택==</option>
              <option v-for="(select, key) in facility_arr" :key="key" :value="select.seq">{{ select.number }}</option>
            </select>
          </div>
          <div class="l_field">
            <label for="writer_add">작성자</label>
            <input type="text" name="writer_add" id="writer_add" class="s_blue_txt" placeholder="소속" v-model="writer" readonly/>
          </div>
        </div>
        <div class="l_search_field" style="margin-top:20px;">
          <div class="l_field">
            <label for="content_add">건의내용</label>
            <textarea type="text" name="content_add" id="content_add" class="m_large_txt" placeholder="입력" v-model="contents"></textarea>
          </div>
        </div>
        <div class="l_search_btns m_center">
            <button type="submit" class="s_blue" @click="addSuggest()">등록</button>
            <button type="submit" class="s_gray" @click="closePopup(l_popup__suggest_add)">취소</button>
          </div>
        </div>
    </div>
  </transition>
  </section>

  <section id="icContent_leader" class="l_ct l_notice" v-if="groupcode == 'ASSOCIATION'" v-cloak>
    <!-- 종목별 시설물 건의사항 s. -->
    <div class="l_content">
      <!-- 컨텐츠 영역. s. -->
      <h2>시설물 건의사항</h2>
  
      <div class="l_search_btns">
        <button type="submit" class="s_blue" @click="initSuggestList()">건의사항 작성</button>
      </div>
      <!-- 목록 테이블 형식. s. -->
      <div class="l_list_box">
        <div class="l_list_tablewrap">
          <table>
            <caption>시설물 건의사항 목록</caption>
            <thead>
              <tr>
                <th></th>
                <th>작성일</th>
                <th>동/관</th>
                <th>시설</th>
                <th>작성자</th>
                <th>처리현황</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(list, key) in suggestInfo" :key="key" @click="getSuggestList(list)">
                <td>{{ list.num }}</td>
                <td>{{ list.regdate }}</td>
                <td>{{ list.quarter }}</td>
                <td>{{ list.number }}</td>
                <td>{{ list.username }}</td>
                <td v-bind:class="{s_blue_txt: list.state == '700'}">
                  {{ list.state == '700' ? '처리대기' : list.state == '701' ? '처리완료' : '처리보류' }}
                </td>
              </tr>
              <tr v-if="suggestInfo.length == 0">
                <td colspan="6">
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
        
        <div v-if="suggestInfo.length>0" class="l_paging_area">
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
    
    <!-- 공지사항 수정 -->
    <transition name="fade">
      <div id="l_popup__suggest" class="m_popup m_suggest__popup" v-if="showPopup">
        <h1 v-if="!isComplete">시설물 건의사항 작성</h1>
        <h1 v-else>시설물 건의사항</h1>
        <div class="m_popup__contents">
          <div class="l_search_field">
            <div class="l_field">
              <label for="quarter">동/관</label>
              <select name="quarter" id="quarter" v-model="quarter" v-show="!isComplete" @change="changeFacilitySelectBoxList()">
                <option value="0">==선택==</option>
                <option v-for="(select, key) in quarter_arr" :key="key" :value="select.seq">{{ select.title }}</option>
              </select>
              <input type="text" name="writer" class="s_blue_txt" placeholder="소속" v-model="quarter" v-show="isComplete" readonly/>
            </div>
            <div class="l_field">
              <label for="facility">시설</label>
              <select name="facility" id="facility" v-model="facility" v-show="!isComplete">
                <option value="0">==선택==</option>
                <option v-for="(select, key) in facility_arr" :key="key" :value="select.seq">{{ select.number }}</option>
              </select>
              <input type="text" name="writer" class="s_blue_txt" placeholder="소속" v-model="facility" v-show="isComplete" readonly/>
            </div>
            <div class="l_field">
              <label for="writer">작성자</label>
              <input type="text" name="writer" id="writer" class="s_blue_txt" placeholder="소속" v-model="writer" readonly/>
            </div>
          </div>
          <div class="l_search_field" style="margin-top:20px;">
            <div class="l_field">
              <label for="content">건의내용</label>
              <textarea type="text" name="content" id="content" class="m_large_txt" placeholder="입력" v-model="contents" v-if="!isUpdate"></textarea>
              <textarea type="text" name="content" id="content" class="m_large_txt" placeholder="입력" v-model="contents" v-else readonly></textarea>
            </div>
          </div>
          <div class="l_search_field" v-show="isApproval">
            <div class="l_field">
              <label for="approval">보류사유</label>
              <textarea type="text" name="approval" id="approval" class="s_gray_txt m_large_txt" placeholder="보류 사유 입력" v-model="cancel_comment" disabled>{{ cancel_comment }}</textarea>
            </div>
          </div>
          <div class="l_search_btns m_center">
              <button type="submit" class="s_blue" @click="closePopup(l_popup__suggest)" v-show="isComplete">확인</button>
              <button type="submit" class="s_blue" @click="addSuggest()" v-show="!isComplete">등록</button>
              <button type="submit" class="s_gray" @click="closePopup(l_popup__suggest)" v-show="!isComplete">취소</button>
            </div>
          </div>
      </div>
    </transition>
    <!-- 종목별 시설물 건의사항 e. -->
  </section>
</div>

</body>
<script>
var cont_admin = new Vue({
  el:"#icContent_admin",
  data:{
    // api
    api_select_box: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_item_custom.asp',
    api_select_box_facility: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_facility.asp',
    api_suggestion_list: 'http://ic.sportsdiary.co.kr/api/facility_qa_manager/facility_qa_list.asp',
    api_suggestion_add: 'http://ic.sportsdiary.co.kr/api/facility_qa_manager/facility_qa_add.asp',
    api_suggestion_update: 'http://ic.sportsdiary.co.kr/api/facility_qa_manager/facility_qa_approval_update.asp',
    // 세션에서 가져온 사용자 정보 
    groupcode: '', // 그룹코드
    userName: '', // 사용자 이름
    // 시설물 건의사항 팝업
    seq: '', // seq
    writer: '', // 작성자
    quarter_arr: [], // 동/관 셀렉트박스 array
    facility_all_arr: [], // 시설 셀렉트박스 전체 array
    facility_arr: [], // 시설 셀렉트박스 조회결과 array
    quarter: '0', // 동/관 selected item
    facility: '0', // 시설 selected item
    contents: '', // 건의사항 내용
    approval: '', // 승인/반려 여부
    state: '',
    // 페이지네이션
    suggestInfo: [],
    pageMax:null,
    pageCount:0,
    pageNo:0,
    // flag
    isChange: false, // 동/관 셀렉트박스 선택을 변경했는가?
    isApproval: false, // 승인/반려 여부
    isClick: false, // 보류를 클릭했는가?
    isUpdate: false, // 보류를 한번 했는가?
    showAddPopup: false,
    showUpdatePopup: false,
  },
  watch:{},
  methods:{
    // 세션에서 그룹코드 가져오기
    getSessionInfo: function() {
      this.groupcode = sessionStorage.getItem('groupcode');
      this.userName = sessionStorage.getItem('username');
    },

    // 시설물 건의사항 셀렉트박스 조회
    loadSuggestSelectBox: function() {
      var _this = this;

      _this.quarter_arr = selected_item.QT;
      _this.facility_all_arr = selected_item.facility;
    },

    // 시설물 건의사항 리스트 가져오기
    loadSuggestList:function() {
      var _this=this;

      axios.post(_this.api_suggestion_list,{
        page:_this.pageNo+1,
        pagesize:10
      }).then(function(response){
        if(response.data.state=="true"){
          _this.suggestInfo = response.data.notice;
          _this.pageMax=Number(Math.ceil(response.data.total/10));
        }
      }).catch(function(error){
        console.log("시설물 건의사항 list error : ");
        console.log(error);
      }).finally(function(){
        console.log("시설물 건의사항 list success");

        _this.closePopup('#l_popup__suggest_add');
        _this.closePopup('#l_popup__suggest_update');
      });
    },

    // 페이지 클릭 시 공지사항 불러오기
    loadPaginationSuggest:function(){
      var _this=this;

      axios.post(_this.api_suggestion_list,{
        page:_this.pageNo+1,
        pagesize:10
      }).then(function(response){
        if(response.data.state=="true"){
          _this.suggestInfo = response.data.notice;
          _this.pageMax=Number(Math.ceil(response.data.total/10));
        }
      }).catch(function(error){
        console.log("시설물 건의사항 list error : ");
        console.log(error);
      });
    },

    // 시설물 건의사항 등록
    addSuggest:function() {
      var _this=this;
      var content = '';

      if (_this.quarter == '' || _this.quarter == undefined) {
        alert('시설을 선택해 주세요.');
        return false;
      }
      
      var isConfirm = confirm('한번 등록하면 수정할 수 없습니다. 등록하시겠습니까?');

      if (!isConfirm) {
        return false;
      }

      content = _this.contents.replace(/(?:\r\n|\r|\n)/g, '<br/>');

      axios.post(_this.api_suggestion_add,{
        facility_seq: _this.facility,
        comment: content,
      }).then(function(response){
        if(response.data.state=="true"){
          console.log('등록완료');
        }
      }).catch(function(error){
        console.log("시설물 건의 add error : ");
        console.log(error);
      }).finally(function() {
        _this.closePopup('#l_popup__suggest_add');
        _this.loadSuggestList();
      });
    },

    // 시설물 건의사항 확인/보류
    updateSuggest:function(app) {
      var _this=this;
      var content = '', cancel_content = '';

      content = app.replace(/(?:\r\n|\r|\n)/g, '<br/>');
      cancel_content = _this.approval.replace(/(?:\r\n|\r|\n)/g, '<br/>');

      axios.post(_this.api_suggestion_update,{
        seq: _this.seq,
        approval: content,
        cancel: cancel_content
      }).then(function(response){
        if(response.data.state=="true"){
          console.log('시설물 처리/보류 완료');
        }
      }).catch(function(error){
        console.log("시설물 처리/보류 error : ");
        console.log(error);
      }).finally(function() {
        _this.closePopup('#l_popup__suggest_update');
        _this.loadSuggestList();
      });
    },

    // 동/관 셀렉트박스 변경에 따른 시설 셀렉트박스 item 변경
    changeFacilitySelectBoxList:function() {
      var _this = this;
      var tempFacility = [];

      _this.facility = '0';
      this.facility_all_arr.forEach(function(item, idx) {
        if (_this.quarter == item.quarter_seq) {
          tempFacility.push(item);
        }
      });

      this.facility_arr = tempFacility;
    },

    // 시설물 건의사항 승인/보류 사유 체크
    approvalSuggest:function() {
      if (!this.isApproval) {
        this.isClick = true;
        this.isApproval = true;
      } else {
        if (this.approval == '' || this.approval == undefined) {
          alert('보류 사유를 작성하지 않았습니다.');
          return false;
        } else {
          this.updateSuggest('N');
        }
      }
    },

    // 건의사항 등록을 위한 최초 설정
    initSuggestList:function() {
      this.writer = this.userName;

      this.showAddPopup = true;
      this.openPopup();
    },

    // 개별 시설물 건의사항 데이터 가져오기
    getSuggestList:function(list) {
      this.state = list.state;
      this.seq = list.seq;
      this.writer = list.username;
      this.quarter = list.quarter;
      this.facility = list.number;
      this.contents = list.comment.split('<br/>').join("\r\n");
      this.approval = list.cancel_comment.split('<br/>').join("\r\n");

      if (this.approval !== '') {
        this.isApproval = true;
        this.isUpdate = true;
      }

      this.showUpdatePopup = true;
      this.openPopup();
    },

    // 시설물 건의사항 리셋
    resetSuggest:function() {
      this.isApproval = false;
      this.isClick = false;
      this.isUpdate = false;
      this.state = '';
      this.seq = '';
      this.writer = '';
      this.quarter = '0';
      this.facility = '0';
      this.contents = '';
      this.cancel_comment = '';
    },

    // 시설물 건의사항 페이징
    pageMove:function(idx){
      var _this=this;
      _this.pageNo=idx;
      _this.loadPaginationSuggest();
    },

    pageJump:function(cnt){
      var _this=this;
      _this.pageNo=cnt*10;
      if(cnt<=-1){
        _this.pageNo=0;
        _this.loadPaginationSuggest();
        return;
      }
      if(_this.pageNo>_this.pageMax-1){
        _this.pageNo=_this.pageMax-1;
        _this.loadPaginationSuggest();
        return;
      }
      _this.pageCount=cnt;
      _this.loadPaginationSuggest();
    },

    // 팝업 열기
    openPopup:function(popup) {
      $('#l_popup__dimm').addClass('active');
    },

    // 팝업 닫기
    closePopup:function(popup) {
      this.showAddPopup = false;
      this.showUpdatePopup = false;
      $('#l_popup__dimm').removeClass('active');

      this.resetSuggest();
    }
  },
  mounted:function(){
    this.getSessionInfo();
  },
  created:function(){
    eventBus.$emit("menuinfo");
    eventBus.$emit("menudrop", [8,2]);

    if (sessionStorage.getItem('groupcode') == 'ADMIN') {
      this.loadSuggestList();
      this.loadSuggestSelectBox();
    }
  }
});

var cont_ledaer = new Vue({
  el:"#icContent_leader",
      data:{
        // api
        api_select_box: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_item_custom.asp',
        api_select_box_facility: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_facility.asp',
        api_suggestion_list: 'http://ic.sportsdiary.co.kr/api/facility_qa_manager/facility_qa_list.asp',
        api_suggestion_add: 'http://ic.sportsdiary.co.kr/api/facility_qa_manager/facility_qa_add.asp',
        // 세션에서 가져온 사용자 정보
        groupcode: '', // 그룹코드
        userName: '', // 사용자 이름
        // 시설물 건의사항 팝업
        seq: '', // seq
        writer: '', // 작성자
        quarter: '0', // 동/관 selected item
        facility: '0', // 시설 selected item
        quarter_arr: [], // 동/관 셀렉트박스 array
        facility_all_arr: [], // 시설 셀렉트박스 전체 array
        facility_arr: [], // 시설 셀렉트박스 조회 array
        cancel_comment: '', // 보류 사유
        contents: '', // 
        state: '',
        // 페이지네이션
        suggestInfo: [],
        pageMax:null,
        pageCount:0,
        pageNo:0,
        // flag
        isComplete: false,
        isChange: false, // 동/관 셀렉트박스 선택을 변경했는가?
        isApproval: false, // 승인/반려 여부
        isClick: false, // 보류를 클릭했는가?
        isUpdate: false, // 보류를 한번 했는가?
        showPopup: false,
      },
      watch:{},
      methods:{
        // 세션에서 그룹코드 가져오기
        getSessionInfo: function() {
          this.groupcode = sessionStorage.getItem('groupcode');
          this.userName = sessionStorage.getItem('username');
        },

        // 시설물 건의사항 셀렉트박스 조회
        loadSuggestSelectBox: function() {
          var _this = this;

          _this.quarter_arr = selected_item.QT;
          _this.facility_all_arr = selected_item.facility;
        },

        // 시설물 건의사항 리스트 가져오기
        loadSuggestList:function() {
          var _this=this;

          axios.post(_this.api_suggestion_list,{
            page:_this.pageNo+1,
            pagesize:10
          }).then(function(response){
            if(response.data.state=="true"){
              _this.suggestInfo = response.data.notice;
              _this.pageMax=Number(Math.ceil(response.data.total/10));
            }
          }).catch(function(error){
            console.log("시설물 건의사항 list error : ");
            console.log(error);
          }).finally(function(){
            console.log("시설물 건의사항 list success");
          });
        },

        // 페이지 클릭 시 공지사항 불러오기
        loadPaginationSuggest:function(){
          var _this=this;

          axios.post(_this.api_suggestion_list,{
            page:_this.pageNo+1,
            pagesize:10
          }).then(function(response){
            if(response.data.state=="true"){
              _this.suggestInfo = response.data.notice;
              _this.pageMax=Number(Math.ceil(response.data.total/10));
            }
          }).catch(function(error){
            console.log("시설물 건의사항 list error : ");
            console.log(error);
          });
        },

        // 공지사항 등록
        addSuggest:function() {
          var _this=this;
          var content = '';

          if (_this.quarter == '' || _this.quarter == undefined) {
            alert('시설을 선택해 주세요.');
            return false;
          }
          
          var isConfirm = confirm('한번 등록하면 수정할 수 없습니다. 등록하시겠습니까?');

          if (!isConfirm) {
            return false;
          }
      
          content = _this.contents.replace(/(?:\r\n|\r|\n)/g, '<br/>');

          axios.post(_this.api_suggestion_add,{
            facility_seq: _this.facility,
            comment: content,
          }).then(function(response){
            if(response.data.state=="true"){
              console.log('등록완료');
            }
          }).catch(function(error){
            console.log("시설물 건의 add error : ");
            console.log(error);
          }).finally(function() {
            _this.closePopup('#l_popup__suggest');
            _this.loadSuggestList();
          });
        },

        // 동/관 셀렉트박스 변경에 따른 시설 셀렉트박스 item 변경
        changeFacilitySelectBoxList:function() {
          var _this = this;
          var tempFacility = [];

          this.facility = '0';
          this.facility_all_arr.forEach(function(item, idx) {
            if (_this.quarter == item.quarter_seq) {
              tempFacility.push(item);
            }
          });

          this.facility_arr = tempFacility;
        },

        // 건의사항 등록을 위한 최초 설정
        initSuggestList:function() {
          this.isComplete = false;
          this.writer = this.userName;

          this.openPopup('#l_popup__suggest');
        },

        // 개별 시설물 건의사항 데이터 가져오기
        getSuggestList:function(list) {
          this.isComplete = true;
          this.isUpdate = true;
          this.state = list.state;
          this.seq = list.seq;
          this.writer = list.username;
          this.quarter = list.quarter;
          this.facility = list.number;
          this.contents = list.comment.split('<br/>').join("\r\n");
          this.cancel_comment = list.cancel_comment.split('<br/>').join("\r\n");

          if (this.state == '702' || this.cancel_comment !== '') {
            this.isApproval = true;
          }

          this.openPopup('#l_popup__suggest');
        },

        // 시설물 건의사항 리셋
        resetSuggest:function() {
          this.isComplete = false;
          this.isApproval = false;
          this.isUpdate = false;
          this.state = '';
          this.seq = '';
          this.writer = '';
          this.quarter = '0';
          this.facility = '0';
          this.contents = '';
          this.cancel_comment = '';
        },

        // 시설물 건의사항 페이징
        pageMove:function(idx){
          var _this=this;
          _this.pageNo=idx;
          _this.loadPaginationSuggest();
        },
        pageJump:function(cnt){
          var _this=this;
          _this.pageNo=cnt*10;
          if(cnt<=-1){
            _this.pageNo=0;
            _this.loadPaginationSuggest();
            return;
          }
          if(_this.pageNo>_this.pageMax-1){
            _this.pageNo=_this.pageMax-1;
            _this.loadPaginationSuggest();
            return;
          }
          _this.pageCount=cnt;
          _this.loadPaginationSuggest();
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

          this.resetSuggest();
        }
      },
      mounted:function(){
        this.getSessionInfo();
      },
      created:function(){
        eventBus.$emit("menuinfo");
        eventBus.$emit("menudrop", [8,2]);

        if (sessionStorage.getItem('groupcode') == 'ASSOCIATION') {
          this.loadSuggestList();
          this.loadSuggestSelectBox();
        }
      }
});
</script>
</body>
</html>