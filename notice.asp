<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct l_notice" v-cloak>
  <div class="l_content">
    <!-- 컨텐츠 영역. s. -->
    <h2>공지사항</h2>

    <div class="l_search_btns">
      <button type="submit" class="s_blue" @click="openPopup('add')">등록</button>
    </div>
      <!-- 목록 테이블 형식. s. -->
      <div class="l_list_box l_notice_list">
        <div class="l_list_tablewrap">
          <table>
            <caption>공지사항 목록</caption>
            <colgroup>
              <col style="width:41px;">
              <col style="width:120px;">
              <col style="width:160px;">
              <col style="width:111px;">
              <col style="width:433px;">
              <col style="width:170px;">
              <col style="width:118px;">
              <col style="width:232px;">
            </colgroup>
            <thead>
              <tr>
                <th></th>
                <th>년도</th>
                <th>작성일</th>
                <th>구분</th>
                <th>제목</th>
                <th>작성자소속</th>
                <th>작성자</th>
                <th>첨부파일</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(list, key) in noticeInfo" :key="key" @click="openPopup('update', key)">
                <td>{{ list.num }}</td>
                <td>{{ list.year }}</td>
                <td>{{ list.regdate }}</td>
                <td v-bind:class="{s_orange_txt: list.noticetype_title == '긴급공지'}">{{ list.noticetype_title }}</td>
                <td>{{ list.title }}</td>
                <td>{{ list.department }}</td>
                <td>{{ list.username }}</td>
                <td>
                  <a @click="downloadFile(list.fileuri)" @click.stop="openPopup('update', key)" href="" target="_blank">{{ list.filename }}</a>
                </td>
              </tr>
              <tr v-if="noticeInfo.length == 0">
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
        <div v-if="noticeInfo.length>0" class="l_paging_area">
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
  <!-- 공지사항 등록 -->
<transition name="fade">
  <div id="l_popup__notice_add" class="m_popup m_notice__popup" v-if="showAddPopup">
    <h1>공지사항 등록</h1>
    <div class="m_popup__contents">
      <div class="l_search_field">
        <div class="l_field">
          <label for="a_notice_type">게시구분</label>
          <select name="a_notice_type" id="a_notice_type" v-model="a_notice.noticeTypeSeq">
            <option v-for="(select,key) in notice_type" :key="key" :value="select.seq">{{select.title}}</option>
          </select>
        </div>
        <div class="l_field">
          <label for="a_reg_date">게시일자</label>
          <input type="text" name="a_reg_date" id="a_reg_date" class="s_gray_txt" :value="regDate" disabled>
        </div>
      </div>
      <div class="l_search_field" style="margin-left:-21px;">
        <div class="l_field">
          <label for="a_department">작성자 소속</label>
          <input type="text" name="a_department" id="a_department" class="s_gray_txt" placeholder="소속" v-model="a_notice.department">
        </div>
        <div class="l_field">
          <label for="a_username">작성자</label>
          <input type="text" name="a_username" id="a_username" class="s_gray_txt" :value="userName" disabled>
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field">
          <label for="a_attach_file">첨부파일</label>
          <input type="text" id="a_attach_file_name" value="" readonly />
          <input type="file" name="a_attach_file" id="a_attach_file" class="s_gray_txt" @change="uploadFile($event.target, 1)">
          <label for="a_attach_file" class="m_label__attach_btn">첨부하기</label>
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field">
          <label for="a_title">제목</label>
          <input type="text" name="a_title" id="a_title" class="s_gray_txt m_large_txt" placeholder="입력" v-model="a_notice.title"/>
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field">
          <label for="a_content">내용</label>
          <textarea name="a_content" id="a_content" class="s_gray_txt m_large_txt" placeholder="입력" v-model="a_notice.contents"></textarea>
        </div>
      </div>
    <div class="l_search_btns">
      <button type="submit" class="s_blue" @click="addNotice()">등록</button>
      <button type="submit" class="s_white" @click="closePopup(l_popup__notice_add)">취소</button>
    </div>
  </div>
  </div>
</transition>
  
<transition name="fade">
  <!-- 공지사항 수정 -->
  <div id="l_popup__notice_update" class="m_popup m_notice__popup" v-if="showUpdatePopup">
    <h1>공지사항</h1>
    <div class="m_popup__contents">
      <div class="l_search_field">
        <div class="l_field">
          <label for="u_notice_type">게시구분</label>
          <select name="u_notice_type" id="u_notice_type" v-model="u_notice.noticeTypeSeq">
            <option v-for="(select,key) in notice_type" :key="key" :value="select.seq">{{select.title}}</option>
          </select>
        </div>
        <div class="l_field">
          <label for="u_reg_date">게시일자</label>
          <input type="text" name="u_reg_date" id="u_reg_date" class="s_gray_txt" :value="regDate" disabled>
        </div>
      </div>
      <div class="l_search_field" style="margin-left:-21px;">
        <div class="l_field">
          <label for="u_department">작성자 소속</label>
          <input type="text" name="u_department" id="u_department" class="s_gray_txt" placeholder="소속" v-model="u_notice.department">
        </div>
        <div class="l_field">
          <label for="u_username">작성자</label>
          <input type="text" name="u_username" id="u_username" class="s_gray_txt" :value="userName" disabled>
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field">
          <label for="u_attach_file">첨부파일</label>
          <input type="text" id="u_attach_file_name" v-model="u_notice.fileName" readonly/>
          <input type="file" name="u_attach_file" id="u_attach_file" class="s_gray_txt" @change="uploadFile($event.target, 2)"/>
          <label for="u_attach_file" class="m_label__attach_btn">첨부하기</label>
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field">
          <label for="u_title">제목</label>
          <input type="text" name="u_title" id="u_title" class="s_gray_txt m_large_txt" placeholder="입력" v-model="u_notice.title"/>
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field">
          <label for="u_content">내용</label>
          <textarea name="u_content" id="u_content" class="s_gray_txt m_large_txt" placeholder="입력" v-model="u_notice.contents"></textarea>
        </div>
      </div>
      <div class="l_search_btns m_inline">
          <button type="submit" class="s_orange" @click="deleteeNotice()">삭제</button>
          <div>
            <button type="submit" class="s_blue" @click="updateNotice()">수정</button>
            <button type="submit" class="s_white" @click="closePopup(l_popup__notice_update)">취소</button>
          </div>
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
    api_upload_file: 'http://ic.sportsdiary.co.kr/api/file_upload/upload.asp',
    api_download_file: 'http://ic.sportsdiary.co.kr/api/file_upload/file_download.asp',
    api_select_box: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_item_custom.asp',
    api_notice_list: 'http://ic.sportsdiary.co.kr/api/notice_manager/notice_list.asp',
    api_notice_add: 'http://ic.sportsdiary.co.kr/api/notice_manager/notice_add.asp',
    api_notice_update: 'http://ic.sportsdiary.co.kr/api/notice_manager/notice_modify.asp',
    api_notice_delete: 'http://ic.sportsdiary.co.kr/api/notice_manager/notice_del.asp',
    // 세션에서 가져온 사용자 정보
    userName: '', // 사용자이름
    userId: '', // 사용자 id
    // 메인 셀렉트 박스
    regDate: '', // 등록날짜
    use_facility_type: '', // 게시구분
    association: '', // 작성자 소속
    notice_type: [], // 공지사항 리스트
    noticeTot: '', // 공지사항 total
    // 공지사항 등록
    a_notice: {
      title: '', // 제목
      noticeTypeSeq: 'NT0001', // 게시구분
      openDate: '', // 게시일자
      department: '', // 작성자 소속
      regname: '', // 작성자
      fileSeq: '', // 첨부파일
      contents: '', // 내용
    },
    //공지사항 수정
    u_notice: {
      title: '', // 제목
      noticeTypeSeq: '', // 게시구분
      openDate: '', // 게시일자
      department: '', // 작성자 소속
      regname: '', // 작성자
      fileSeq: '', // 첨부파일
      fileName: '', // 첨부파일 이름
      contents: '', // 내용
      seq: '', // seq
    },
    // 페이지네이션
    noticeInfo: [],
    pageMax:null,
    pageCount:0,
    pageNo:0,
    changeList: false,
    // flag
    showAddPopup: false,
    showUpdatePopup: false,
  },
  watch:{},
  methods:{
    // 세션에서 정보 가져오기
    getSessionInfo: function() {
      this.a_notice.department = sessionStorage.getItem('association_title');
      this.association = sessionStorage.getItem('association_title');
      this.userName = sessionStorage.getItem('username');
      this.userId = sessionStorage.getItem('userid');
    },

    // 파일 업로드
    uploadFile:function(file, state){
      // file : 업로드파일
      var _this = this;
      var filedata = file.files[0];
      var config={
        headers:{
          "Content-Type":"multipart/form-data"
        }
      }
      var fileInput = '';

      if (state == '1') {
        fileInput = $('#a_attach_file_name');
        fileInput.val(filedata.name);
      } else {
        this.u_notice.fileName = filedata.name;
      }

      // 파일 올리고
      var fd = new FormData();
      fd.append("file_type", 4);
      fd.append("file_data", filedata);
      fd.append("user_id", _this.userId);

      axios.post(_this.api_upload_file, fd, config).then(function(response){
        if(response.data.state == "true"){
          if (state == '1') _this.a_notice.fileSeq = response.data.fileSeq;
          else _this.u_notice.fileSeq = response.data.fileSeq;
        } else {
          alert('파일 업로드에 실패하였습니다.');
        }
      }).catch(function(error){
        console.log("파일 업로드 error : ");
        console.log(error);
      }).finally(function(){
        console.log("파일 업로드 success");
      });
    },

    // 파일 다운로드
    downloadFile:function(url) {
      url = 'http://ic.sportsdiary.co.kr/api/file_upload/file_download.asp?fileuri=' + url;
      window.location = url;
    },

    // 등록날짜 설정
    setRegDate: function() {
      var date=new Date();

      var year = date.getFullYear();
      var month = date.getMonth() + 1;
      var day = date.getDate();

      if (String(month).split('').length < 2) month = '0' + month;
      if (String(day).split('').length < 2) day = '0' + day;

      this.regDate = year + '-' + month + '-' + day;
    },

    // 공지타입 셀렉트박스 조회
    loadNoticeSelectBox: function() {
      var _this=this;

      _this.notice_type = selected_item.NT;
    },

    // 공지사항 리스트 가져오기
    loadNoticeList:function() {
      var _this=this;

      axios.post(_this.api_notice_list,{
          page:_this.pageNo+1,
          pagesize:10
      }).then(function(response){
        if(response.data.state=="true"){
          _this.noticeTot = response.data.total;
          _this.noticeInfo = response.data.notice;
          _this.pageMax=Number(Math.ceil(response.data.total/10));
        }
      }).catch(function(error){
        console.log("공지사항 list error : ");
        console.log(error);
      }).finally(function(){
        console.log("공지사항 list success");
      });
    },

    // 페이지 클릭 시 공지사항 불러오기
    loadPaginationNotice:function(){
      var _this=this;

      axios.post(_this.api_notice_list,{
          page:_this.pageNo+1,
          pagesize:10
      }).then(function(response){
        if(response.data.state=="true"){
          _this.noticeInfo = response.data.notice;
          _this.pageMax=Number(Math.ceil(response.data.total/10));
        }
      }).catch(function(error){
        console.log("공지사항 list error : ");
        console.log(error);
      });
    },

    // 공지사항 등록
    addNotice:function() {
      var _this=this;
      var content = '';

      _this.a_notice.openDate = _this.regDate;
      _this.a_notice.regname = _this.userName;
      content = _this.a_notice.contents.replace(/(?:\r\n|\r|\n)/g, '<br/>');

      axios.post(_this.api_notice_add,{
        title: _this.a_notice.title,
        noticetype_seq: _this.a_notice.noticeTypeSeq,
        opendate: _this.a_notice.openDate,
        department: _this.a_notice.department,
        regname: _this.a_notice.regname,
        fileSeq: _this.a_notice.fileSeq,
        contents: content
      }).then(function(response){
        if(response.data.state=="true"){
          console.log('등록완료');
        }
      }).catch(function(error){
        console.log("공지사항 add error : ");
        console.log(error);
      }).finally(function() {
          _this.a_notice.title = '';
          _this.a_notice.openDate = '';
          _this.a_notice.department = _this.association;
          _this.a_notice.regname = '';
          _this.a_notice.fileSeq = '';
          _this.a_notice.contents = '';

          _this.loadNoticeList();
          _this.closePopup('#l_popup__notice_add');
      });
    },

    // 공지사항 수정
    updateNotice:function() {
      var _this=this;
      var content = '';

      _this.u_notice.openDate = _this.regDate;
      content = _this.u_notice.contents.replace(/(?:\r\n|\r|\n)/g, '<br/>');

      axios.post(_this.api_notice_update,{
        title: _this.u_notice.title,
        noticetype_seq: _this.u_notice.noticeTypeSeq,
        opendate: _this.u_notice.openDate,
        department: _this.u_notice.department,
        regname: _this.u_notice.regname,
        fileSeq: _this.u_notice.fileSeq,
        contents: content,
        seq: _this.u_notice.seq,
      }).then(function(response){
        if(response.data.state=="true"){
          console.log('수정완료');
        }
        _this.closePopup('#l_popup__notice_update');
      }).catch(function(error){
        console.log("공지사항 update error : ");
        console.log(error);
      }).finally(function() {
          _this.loadNoticeList();
          _this.closePopup('#l_popup__notice_update');
      });
    },

    // 공지사항 삭제 
    deleteeNotice:function() {
      var _this=this;

      axios.post(_this.api_notice_delete,{
        seq: _this.u_notice.seq,
      }).then(function(response){
        if(response.data.state=="true"){
          console.log('삭제완료');
        }
      }).catch(function(error){
        console.log("공지사항 delete error : ");
        console.log(error);
      }).finally(function() {
        _this.loadNoticeList();
        _this.closePopup('#l_popup__notice_update');
      });
    },

    // 개별 공지사항 리스트 데이터 가져오기
    readNoticeList:function(num) {
      var notice = this.noticeInfo[num];

      this.u_notice.title = notice.title;
      this.u_notice.noticeTypeSeq = notice.noticetype_seq;
      this.u_notice.openDate = notice.opendate;
      this.u_notice.department = notice.department;
      this.u_notice.regname = notice.username;
      this.u_notice.fileName = notice.filename;
      this.u_notice.contents = notice.contents.split('<br/>').join("\r\n");
      this.u_notice.seq = notice.seq;
    },

    // 공지사항 리셋
    resetNoticeData:function() {
      this.a_notice = {
        title : '',
        noticeTypeSeq: 'NT0001',
        openDate: '',
        department: '',
        regname: '',
        fileSeq: '',
        contents: '',
      };
      this.u_notice = {
        title: '',
        noticeTypeSeq: '',
        openDate: '',
        department: '',
        regname: '',
        fileSeq: '',
        fileName: '',
        contents: '',
        seq: '',
      };
    },

    // 공지사항 페이징
    pageMove:function(idx){
      var _this=this;
      _this.pageNo=idx;
      _this.loadPaginationNotice();
    },
    pageJump:function(cnt){
      var _this=this;
      _this.pageNo=cnt*10;
      if(cnt<=-1){
        _this.pageNo=0;
        _this.loadPaginationNotice();
        return;
      }
      if(_this.pageNo>_this.pageMax-1){
        _this.pageNo=_this.pageMax-1;
        _this.loadPaginationNotice();
        return;
      }
      _this.pageCount=cnt;
      _this.loadPaginationNotice();
    },

    // 팝업 열기
    openPopup:function(popup, num) {
      if (popup == undefined) return false;
      
      if (popup == 'add') {
        this.showAddPopup = true;
      } else {
        this.showUpdatePopup = true;
      }

      $('#l_popup__dimm').addClass('active');

      if (num !== undefined && num !== null) {
        this.readNoticeList(num);
      } else {
        this.a_notice.noticeTypeSeq = 'NT001';
      }
    },

    // 팝업 닫기
    closePopup:function(popup) {
      this.showAddPopup = false;
      this.showUpdatePopup = false;
      $('#l_popup__dimm').removeClass('active');

      this.resetNoticeData();
    }
  },
  mounted:function(){
    this.getSessionInfo();
    this.loadNoticeList();
    this.loadNoticeSelectBox();
    this.setRegDate();
  },
  created:function(){
    eventBus.$emit("menuinfo");
    eventBus.$emit("menudrop", [8,1]);
  }
});
</script>
</body>
</html>