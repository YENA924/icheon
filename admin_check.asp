<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct l_admin_check" v-cloak>
  <div class="l_content">
    <!-- 컨텐츠 영역. s. -->
    <div class="l_content_top">
      <h2>회원가입 신청 / 관리</h2>
      <!-- 목록 테이블 형식. s. -->
      <div class="l_list_box">
        <div class="l_list_tablewrap">
          <table>
            <caption>회원가입 신청/관리 목록</caption>
            <thead>
              <tr>
                <th>번호</th>
                <th>신청상태</th>
                <th>신청일</th>
                <th>소속단체명</th>
                <th>대표자명</th>
                <th>휴대폰 번호</th>
                <th>이메일</th>
                <th>ID</th>
                <th>권한설정</th>
                <th>가입승인</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(list, key) in newPermissionInfo" :key="key">
                <td>{{ list.num }}</td>
                <td v-if="list.state == '800'" class="s_orange_txt">대기</td>
                <td v-else-if="list.state == '801'">승인</td>
                <td v-else-if="list.state == '802'">반려</td>
                <td v-else-if="list.state == '803'">승인취소</td>
                <td v-else-if="list.state == '804'">탈퇴</td>
                <td v-else-if="list.state == '808'" class="s_orange_txt">잠금</td>
                <td v-else>삭제</td>
                <td>{{ list.regdate }}</td>
                <td>{{ list.association }}</td>
                <td>{{ list.name }}</td>
                <td>{{ list.cellphone }}</td>
                <td>{{ list.email }}</td>
                <td>{{ list.id }}</td>
                <td>
                  <select name="new_permission" class="new_permission" :title="list.name+' 권한설정'" v-model="list.permission">
                    <option v-for="(select, key) in permission_arr" :key="key" :value="select.seq" >{{ select.title }}</option>
                  </select>
                </td>
                <td>
                  <button class="s_blue" @click="openPopup(list, 'y')" v-if="(list.state == '800' || list.state == '803') && (list.state !== '802' && list.state !== '808')">승인</button>
                  <button class="s_gray_txt" @click="openPopup(list, 'n')" v-if="(list.state == '800' || list.state == '801') && (list.state !== '803'&& list.state !== '808')">반려</button>
                  <button class="s_gray" @click="openPopup(list, 'd')" v-if="list.state == '802'">삭제</button>
                  <button class="s_orange_bg" @click="openPopup(list, 'l')" v-if="list.state == '808'">잠금해제</button>
                </td>
              </tr>
            </tbody>
          </table>
          
          <div v-if="newPermissionInfo.length>0" class="l_paging_area">
            <button class="l_page l_prev" @click="newPageJump(new_permi_pageCount-1)"><span class="img"><img src="/front/img/previous_page_group.png" alt="이전 목록으로"></span></button>
            <div v-if="new_permi_pageMax<=5">
              <button v-for="(page,key) in new_permi_pageMax" :key="key" class="l_paging" v-bind:class="{s_on:key==new_permi_pageNo}" @click="newPageMove(key)">{{page}}</button>
            </div>
            <div v-else>
              <button v-for="(page,key) in 5" :key="key+(5*new_permi_pageCount)" v-if="(key+(5*new_permi_pageCount))<new_permi_pageMax" class="l_paging" v-bind:class="{s_on:key+(5*new_permi_pageCount)==new_permi_pageNo}" @click="newPageMove(key+(5*new_permi_pageCount))">{{page+(5*new_permi_pageCount)}}</button>
            </div>
            <button class="l_page l_next" @click="newPageJump(new_permi_pageCount+1)"><span class="img"><img src="/front/img/next_page_group.png" alt="다음 목록으로"></span></button>
          </div>
        </div>
      </div>
    </div>
    <div class="l_content_bottom">
      <h2>회원가입 계정 조회 / 권한수정</h2>
      <div class="l_search_box">
        <div class="l_search_field">
          <div class="l_field">
            <select name="section" id="section" title="분류 선택" v-model="section" @change="loadPermissionSelectBox()">
              <option value="0">이천훈련원</option>
              <option value="1">협회/연맹/단체</option>
            </select>
          </div>
          <div class="l_field">
            <select name="association" id="association" title="소속 선택" v-model="association">
              <option value="0">전체</option>
              <option v-for="(select, key) in association_arr" :key="key" :value="select.seq">{{ select.title }}</option>
            </select>
          </div>
          <div class="l_field">
            <input type="text" name="date" class="sdate" title="검색어 입력" placeholder="검색어 입력" value="" v-model="searchText"/>
          </div>
          <div class="l_search_btns">
            <button type="submit" class="s_white" @click="loadPaginationPermi(true)">조회</button>
          </div>
          <div class="l_search_btns m_right">
            <button class="s_blue" @click="openPopup('', 'a')" v-if="groupcode == 'ADMIN'">관리자 계정 추가</button>
          </div>
        </div>
      </div>
      <!-- 목록 테이블 형식. s. -->
      <div class="l_list_box">
        <div class="l_list_tablewrap">
          <table>
            <caption>회원가입 계정 조회/권한 설정 테이블</caption>
            <thead>
              <tr>
                <th>번호</th>
                <th>신청일</th>
                <th>소속단체명</th>
                <th>대표자명</th>
                <th>휴대폰 번호</th>
                <th>이메일</th>
                <th>ID</th>
                <th>권한설정</th>
                <th>취소</th>
                <th>회원탈퇴</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(list, key) in permissionInfo" :key="key">
                <td>{{ list.num }}</td>
                <td>{{ list.regdate }}</td>
                <td>{{ list.association }}</td>
                <td>{{ list.name }}</td>
                <td>{{ list.cellphone }}</td>
                <td>{{ list.email }}</td>
                <td>{{ list.id }}</td>
                <td>
                  <select name="new_permission" class="new_permission" v-model="list.permission" @change="changePermission(list)" :title="list.name+' 권한설정'">
                    <option v-for="(select, key) in permission_arr" :key="key" :value="select.seq" >{{ select.title }}</option>
                  </select>
                </td>
                <td>
                  <button class="s_orange" @click="openPopup(list, 'c')" v-if="list.state == '800' || list.state == '801'">승인취소</button>
                </td>
                <td>
                  <button class="s_gray_txt" @click="openPopup(list, 'w')" v-if="list.state !== '804' || list.state !== '805'">탈퇴</button>
                </td>
              </tr>
              <tr v-if="permissionInfo.length == 0">
                <td colspan="10">
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

          <div v-if="permissionInfo.length>0" class="l_paging_area">
            <button class="l_page l_prev" @click="pageJump(permi_pageCount-1)"><span class="img"><img src="/front/img/previous_page_group.png" alt="이전 목록으로"></span></button>
            <div v-if="permi_pageMax<=5">
              <button v-for="(page,key) in permi_pageMax" :key="key" class="l_paging" v-bind:class="{s_on:key==permi_pageNo}" @click="pageMove(key)">{{page}}</button>
            </div>
            <div v-else>
              <button v-for="(page,key) in 5" :key="key+(5*permi_pageCount)" v-if="(key+(5*permi_pageCount))<permi_pageMax" class="l_paging" v-bind:class="{s_on:key+(5*permi_pageCount)==permi_pageNo}" @click="pageMove(key+(5*permi_pageCount))">{{page+(5*permi_pageCount)}}</button>
            </div>
            <button class="l_page l_next" @click="pageJump(permi_pageCount+1)"><span class="img"><img src="/front/img/next_page_group.png" alt="다음 목록으로"></span></button>
          </div>
        </div>
      </div>
    </div>
    <!-- 컨텐츠 영역. e. -->
  </div>
  <!-- 호실선택 팝업 -->
  <transition name="fade">
    <div id="l_popup__admin_check" class="m_popup m_admin_check__popup" v-if="showPopup">
      <template v-if="type == 'accept'">
        <div class="m_popup__title">
          <h1>회원 권한을 수정하시겠습니까?</h1>
        </div>
        <div class="m_popup__content">
          <p>{{ name }}님의 권한이 {{ oldPermission }}에서 {{ newPermission }}로 변경됩니다.</p>
        </div>
        <div class="l_search_btns l_popup_btns">
          <button class="s_blue" @click="updatePermission('Y')">확인</button>
          <button class="s_white" @click="closePopup(l_popup__admin_check)">취소</button>
        </div>
      </template>
      <template v-else-if="type == 'reject'">
        <div class="m_popup__title">
          <h1>회원 권한 수정을 반려하시겠습니까?</h1>
        </div>
        <div class="m_popup__content">
          <p>확인을 누르시면 권한 수정이 반려됩니다.</p>
        </div>
        <div class="l_search_btns l_popup_btns">
          <button class="s_blue" @click="updatePermission('N')">확인</button>
          <button class="s_white" @click="closePopup(l_popup__admin_check)">취소</button>
        </div>
      </template>
      <template v-else-if="type == 'delete'">
        <div class="m_popup__title">
          <h1>선택된 계정을 삭제하시겠습니까?</h1>
        </div>
        <div class="m_popup__content">
          <p>확인을 누르시면 계정이 삭제됩니다.</p>
        </div>
        <div class="l_search_btns l_popup_btns">
          <button class="s_blue" @click="deletePermission()">확인</button>
          <button class="s_white" @click="closePopup(l_popup__admin_check)">취소</button>
        </div>
      </template>
      <template v-else-if="type == 'cancel'">
        <div class="m_popup__title">
          <h1>승인을 취소 하시겠습니까?</h1>
        </div>
        <div class="m_popup__content">
          <p>확인을 누르시면 승인이 취소됩니다.</p>
        </div>
        <div class="l_search_btns l_popup_btns">
          <button class="s_blue" @click="cancelPermission()">확인</button>
          <button class="s_white" @click="closePopup(l_popup__admin_check)">취소</button>
        </div>
      </template>
      <template v-else-if="type == 'withdrawal'">
        <div class="m_popup__title">
          <h1>회원 계정을 탈퇴시키겠습니까?</h1>
        </div>
        <div class="m_popup__content">
          <p>탈퇴 처리된 계정은 복구할 수 없습니다.</p>
        </div>
        <div class="l_search_btns l_popup_btns">
          <button class="s_blue" @click="withdrawalPermission()">확인</button>
          <button class="s_white" @click="closePopup(l_popup__admin_check)">취소</button>
        </div>
      </template>
      <template v-else-if="type == 'lock'">
        <div class="m_popup__title">
          <h1>선택된 계정을 잠금해제 하시겠습니까?</h1>
        </div>
        <div class="m_popup__content">
          <p>확인을 누르시면 잠금이 해제됩니다.</p>
        </div>
        <div class="l_search_btns l_popup_btns">
          <button class="s_blue" @click="lockPermission()">확인</button>
          <button class="s_white" @click="closePopup(l_popup__admin_check)">취소</button>
        </div>
      </template>
      <template v-else-if="type == 'apply' && groupcode == 'ADMIN'">
        <div class="m_popup__title apply">
          <h1>관리자 계정 추가</h1>
        </div>
        <div class="l_search_field">
          <div class="l_field">
            <label for="department">소속부서</label>
            <select name="association" id="department" v-model="department" @change="changeDepartmentInput()">
              <option value="">:::선택하세요:::</option>
              <option value="0">직접입력</option>
              <option v-for="(select, key) in department_arr" :key="key" :value="select.title">{{ select.title }}</option>
            </select>
          </div>
          <div class="l_field disabled" style="margin-top:20px;">
            <input type="text" id="department_title" name="department_title" class="department_title m_large_txt" value="" v-model="department_title" disabled/>
          </div>
        </div>
        <div class="l_search_field">
          <div class="l_field">
            <label for="admin_name">성명</label>
            <input type="text" id="admin_name" name="admin_name" class="admin_name" placeholder="고길동" value="" v-model="adminName"/>
          </div>
          <div class="l_field">
            <label for="email">이메일</label>
            <input type="text" id="email" name="email" class="email" placeholder="sample@naver.com" value="" v-model="email"/>
          </div>
          <div class="l_field">
            <label for="phone">부서 연락처</label>
            <input type="text" id="phone" name="phone" class="phone" placeholder="000-0000-0000" value="" v-model="phone" v-on:keyup="keyUpValidationEvt()"/>
          </div>
        </div>
        <div class="l_search_field">
          <div class="l_field">
            <label for="id">ID</label>
            <input type="text" for="id" name="id" class="id" placeholder="아이디를 입력해 주세요." value="" v-model="id"/>
          </div>
        </div>
        <div class="l_search_field">
          <div class="l_field">
            <label for="pw">PW</label>
            <input type="password" id="pw" name="pw" class="pw" placeholder="비밀번호 6~12자의 영문+숫자 조합" value="" v-model="pw"/>
          </div>
          <div class="l_field">
            <label for="pw_check">PW 확인</label>
            <input type="password" id="pw_check" name="pw_check" class="pw_check" placeholder="비밀번호를 재입력 하세요." value="" v-model="pwChk"/>
          </div>
        </div>
        <div class="l_search_btns l_popup_btns">
          <button class="s_blue" @click="addPermission()">확인</button>
          <button class="s_white" @click="closePopup(l_popup__admin_check)">취소</button>
        </div>
      </template>
    </div>
  </transition>
</section>

<script>
var cont = new Vue({
  el:"#icContent",
    data:{
      // api
      api_select_section_box: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_association.asp',
      api_select_department_box: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_department.asp',
      api_new_permission_list: 'http://ic.sportsdiary.co.kr/api/permission_manager/new_permission_list.asp',
      api_permission_list: 'http://ic.sportsdiary.co.kr/api/permission_manager/permission_list.asp',
      api_permission_add: 'http://ic.sportsdiary.co.kr/api/employee_manager/administrator_employee_add.asp',
      api_permission_update: 'http://ic.sportsdiary.co.kr/api/permission_manager/permission_approval_update.asp',
      api_permission_delete: 'http://ic.sportsdiary.co.kr/api/permission_manager/employee_del.asp',
      api_permission_cancel: 'http://ic.sportsdiary.co.kr/api/permission_manager/employee_cancel.asp',
      api_permission_withdrawal: 'http://ic.sportsdiary.co.kr/api/permission_manager/employee_withdrawal.asp',
      api_employee_permission_update: 'http://ic.sportsdiary.co.kr/api/permission_manager/employee_permission_update.asp',
      // init
      groupcode: '', // 그룹코드
      userName: '', // 사용자 이름
      // 셀렉트 박스
      section: '1', // 소속부서, 협회
      association: '0', // 소속부서(협회)에 따른 
      association_arr: [], // 협회 셀렉트 박스 array
      // 검색조건
      searchText: '',
      // 팝업
      employee_seq: '', // 회원 고유 seq
      state: '', // 상태
      type: '', // 계정 타입 
          // case 'a': '관리자 계정 추가';
          // case 'y': '승인';
          // case 'n': '반려';
          // case 'd': '삭제';
          // case 'c': '승인취소';
          // case 'w': '탈퇴';
      name: '', // 이름
      newPermission: '', // 새롭게 부여된 권한
      permission: '', // 권한 selected item
      permission_seq: '', // 권한 seq
      permission_arr: [ // 권한 셀렉트박스 array
        {seq: 'PM0001', title: '권한대기'},
        {seq: 'PM0002', title: '종목별 지도자'},
        {seq: 'PM0003', title: '훈련원 관리자'},
        {seq: 'PM0004', title: '단체 대표자'},
      ],
      oldPermission: '', // 이전 권한
      // 팝업 : 관리자 계정 등록
      department: '', // 소속부서 selected item
      department_title: '', // 소속부서 이름
      department_arr: [], // 소속부서 셀렉트박스 array
      adminName: '', // 성명
      email: '', // 이메일
      phone: '', // 부서연락처
      id: '', // 아이디
      pw: '', // 패스워드
      pwChk: '', // 패스워드 확인
      // 페이지네이션
      newPermissionInfo: [],
      permissionInfo: [0], // 0: '조회된 결과가 없습니다' 방지
      // 회원가입 신청/관리 페이징
      permi_pageMax:null,
      permi_pageCount:0,
      permi_pageNo:0,
      // 회원가입 계정 조회/권한수정 페이징
      new_permi_pageMax:null,
      new_permi_pageCount:0,
      new_permi_pageNo:0,
      // flag
      showPopup: false, // 팝업 show/hide
    },
    watch:{},
    methods:{
      // 세션에서 그룹코드 가져오기
      getSessionInfo: function() {
        this.groupcode = sessionStorage.getItem('groupcode');
        this.userName = sessionStorage.getItem('username');
      },

      // 가입 시, 유효성 검사
      signUpValidationEvt:function() {
        var _this = this;

        if (_this.department_title == ""){
          alert("소속단체명을 입력하세요.");
          return false;
        }
        if (_this.adminName == ""){
          alert("이름을 입력하세요.");
          return false;
        }
        if (_this.email ==""){
          alert("이메일을 입력하세요.");
          return false;
        }
        if (_this.chkEmail(_this.email) == false){
          alert("이메일 형식이 맞지 않습니다. 다시 확인해주세요");
          return false;
        }
        if (_this.phone == ""){
          alert("유선전화번호를 입력하세요.");
          return false;
        }
        if (_this.id == ""){
          alert("아이디를 입력하세요.");
          return false;
        }
        if (_this.CheckId(_this.id) == false){
          alert('아이디는 영문+숫자조합 입니다. 다시 입력해주세요.');
          return false;
        }
        if (_this.id.length < 6){
          alert('아이디가 너무 짧습니다.');
          return false;
        }
        if (_this.id.length > 21){
          alert('아이디가 너무 깁니다.');
          return false;
        }
        if (_this.pw == ""){
          alert("패스워드를 입력하세요.");
          return false;
        }
        if (_this.CheckPass(_this.pw) == false){
          alert('비밀번호 6~12자리 영문+숫자조합 입니다. 다시 입력해주세요.');
          return false;
        }
        if (_this.pw !== _this.pwChk){
          alert("확인된 패스워드가 다릅니다. 다시 입력하세요.");
          return false;
        }

        return true;
      },

      // 휴대폰 번호 입력시 변환
      keyUpValidationEvt:function() {
        this.phone = this.phone.replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})/,"$1-$2-$3").replace("--", "-");
      },

      // 이메일 유효성 검사
      chkEmail:function(str){
        var regExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
        if (regExp.test(str)) return true;
        else return false;
      },

      // 패스워드 유효성 검사
      CheckPass:function(str){
        var reg1 = /^[a-z0-9]{6,12}$/;
        var reg2 = /[a-z]/g;
        var reg3 = /[0-9]/g;
        return(reg1.test(str) &&  reg2.test(str) && reg3.test(str));
      },

      // 아이디 유효성 검사
      CheckId:function(str){
        var reg1 = /^[a-z]/g;
        var reg2 = /[0-9]/g;
        return(reg1.test(str) && reg2.test(str));
      },

      // 관리자 계정 추가 셀렉트박스 조회
      loadAddDepartmentSelectBox:function(){
        var _this = this;
        
        _this.department_arr = selected_item.department;
      },

      // 권한설정 셀렉트박스 조회
      loadPermissionSelectBox:function(){
        var _this = this;
        
        if (_this.section == '0')  {
          _this.association_arr = selected_item.department;
        } else {
          _this.association_arr = selected_item.association;
        }
      },

      // 회원가입신청, 회원계정 목록 조회
      loadPermissionList:function() {
        var _this = this;

        // 회원가입 신청
        var newPermission = axios.post(_this.api_new_permission_list,{
          page:_this.new_permi_pageNo+1,
          pagesize:5
        });

        // 회원계정
        var permission = axios.post(_this.api_permission_list,{
          page:_this.permi_pageNo+1,
          pagesize: 5,
          searchgubun: _this.section,
          searchseq: '0',
          searchText: '',
        });

        // 한 번에 불러오기
        axios.all([
          newPermission,
          permission,
        ]).then(axios.spread(function(responseNewPermission, responsePermission){
          if(responseNewPermission.data.state == "true"){
            _this.newPermissionInfo = responseNewPermission.data.new_employee;
            _this.new_permi_pageMax=Number(Math.ceil(responseNewPermission.data.total/5));

            _this.getPermissionList();
          }

          if(responsePermission.data.state == "true"){
            _this.permissionInfo = responsePermission.data.new_employee;
            _this.permi_pageMax=Number(Math.ceil(responsePermission.data.total/5));
          }
        })).catch(function(errorNewPermission, errorPermission){
          console.log("errorNewPermission : ");
          console.log(errorNewPermission);
          console.log("errorPermission : ");
          console.log(errorPermission);
        });
      },

      // 페이지 클릭 시 회원가입 관리 리스트 가져오기
      loadPaginationNewPermi:function(){
        var _this=this;

        axios.post(_this.api_new_permission_list,{
          page:_this.new_permi_pageNo+1,
          pagesize:5
        }).then(function(response){
          if(response.data.state=="true"){
            _this.newPermissionInfo = response.data.new_employee;
            _this.new_permi_pageMax=Number(Math.ceil(response.data.total/5));
            _this.getPermissionList();
          }
        }).catch(function(error){
          console.log("시설물 건의사항 list error : ");
          console.log(error);
        });
      },

      // 페이지 클릭 시 권한수정 리스트 가져오기
      loadPaginationPermi:function(flag){
        var _this=this;
        
        if (flag && flag !== undefined) {
          _this.permi_pageNo = 0;
        }

        axios.post(_this.api_permission_list,{
          page:_this.permi_pageNo+1,
          pagesize:5,
          searchgubun: _this.section,
          searchseq: _this.association,
          searchText: _this.searchText,
        }).then(function(response){
          if(response.data.state=="true"){
            _this.permissionInfo = response.data.new_employee;
            _this.permi_pageMax=Number(Math.ceil(response.data.total/5));
          } else {
            if (response.data.errorcode == 'ERR-130') {
              _this.permissionInfo = [];
            }
          }
        }).catch(function(error){
          console.log("권한수정 list error : ");
          console.log(error);
        });
      },

      // 관리자 계정 추가
      addPermission:function() {
        var _this = this;
        var validation = _this.signUpValidationEvt();

        if (!validation) return false;

        axios.post(_this.api_permission_add,{
          department_title: _this.department_title,
          name: _this.adminName,
          email: _this.email,
          phone: _this.phone,
          id: _this.id,
          pw: _this.pw
        }).then(function(response){
          if(response.data.state=="true"){
            console.log('관리자 계정등록 완료');
            _this.closePopup('#l_popup__admin_check');
            _this.loadPaginationNewPermi();
            _this.loadPaginationPermi();
            _this.loadAddDepartmentSelectBox();
          } else {
            if (response.data.errorcode == 'ERR-350') {
              alert('이미 있는 아이디 입니다. 아이디를 다시 입력해 주세요.');
            }
          }
        }).catch(function(error){
          console.log("관리자 계정등록 완료 error : ");
          console.log(error);
        });
      },

      // 회원가입신청 승인/반려
      updatePermission:function(apply) {
        var _this = this;

        axios.post(_this.api_permission_update,{
          employee_seq: _this.employee_seq,
          permission_seq: _this.permission_seq,
          apply: apply,
        }).then(function(response){
          if(response.data.state=="true"){
            console.log('회원가입신청 승인/반려 완료');
          }
        }).catch(function(error){
          console.log("회원가입신청 승인/반려 완료 error : ");
          console.log(error);
        }).finally(function() {
          _this.closePopup('#l_popup__admin_check');
          _this.loadPaginationNewPermi();
          _this.loadPaginationPermi();
        });
      },

      // 회원가입신청 삭제
      deletePermission:function() {
        var _this = this;

        axios.post(_this.api_permission_delete,{
          employee_seq: _this.employee_seq,
        }).then(function(response){
          if(response.data.state=="true"){
            console.log('회원가입신청 삭제 완료');
          }
        }).catch(function(error){
          console.log("회원가입신청 삭제 완료 error : ");
          console.log(error);
        }).finally(function() {
          _this.closePopup('#l_popup__admin_check');
          _this.loadPaginationNewPermi();
          _this.loadPaginationPermi();
        });
      },
      
      // 회원가입계정 권한설정 change
      changePermission:function(list) {
        var _this = this;

        axios.post(_this.api_employee_permission_update,{
          employee_seq: list.employee_seq,
          permission_seq: list.permission,
        }).then(function(response){
          if(response.data.state=="true"){
            console.log('회원가입계정 권한설정 change 완료');
          }
        }).catch(function(error){
          console.log("회원가입계정 권한설정 change error : ");
          console.log(error);
        }).finally(function() {
          _this.loadPaginationPermi();
        });
      },

      // 회원가입계정 승인취소
      cancelPermission:function() {
        var _this = this;

        axios.post(_this.api_permission_cancel,{
          employee_seq: _this.employee_seq,
        }).then(function(response){
          if(response.data.state=="true"){
            console.log('회원가입계정 승인취소 완료');
          }
        }).catch(function(error){
          console.log("회원가입계정 승인취소 완료 error : ");
          console.log(error);
        }).finally(function() {
          _this.closePopup('#l_popup__admin_check');
          _this.loadPaginationNewPermi();
          _this.loadPaginationPermi();
        });
      },

      // 회원가입계정 탈퇴
      withdrawalPermission:function() {
        var _this = this;

        axios.post(_this.api_permission_withdrawal,{
          employee_seq: _this.employee_seq,
        }).then(function(response){
          if(response.data.state=="true"){
            console.log('회원가입계정 탈퇴 완료');
          }
        }).catch(function(error){
          console.log("회원가입계정 탈퇴 완료 error : ");
          console.log(error);
        }).finally(function() {
          _this.closePopup('#l_popup__admin_check');
          _this.loadPaginationNewPermi();
          _this.loadPaginationPermi();
        });
      },

      // 계정 잠금
      lockPermission:function() {
        var _this = this;

        axios.post(_this.api_permission_update,{
          employee_seq: _this.employee_seq,
          permission_seq: '',
          apply: 'L'
        }).then(function(response){
          if(response.data.state=="true"){
            console.log('회원가입계정 잠금 완료');
          }
        }).catch(function(error){
          console.log("회원가입계정 잠금 완료 error : ");
          console.log(error);
        }).finally(function() {
          _this.closePopup('#l_popup__admin_check');
          _this.loadPaginationNewPermi();
          _this.loadPaginationPermi();
        });
      },

      // 이전 권한 설정
      getPermissionList:function() {
        var _this = this;

        _this.newPermissionInfo.forEach(function(info, idx) {
          info.old_permission = info.permission;
        });
      },

      // 관리자 계정 추가, 회원가입 신청 정보 reset
      resetAdminCheck:function() {
        $('#department_title').attr('disabled', true);
        this.employee_seq = '';
        this.state = '';
        this.name = '';
        this.newPermission = '';
        this.permission = '';
        this.permission_seq = '';
        this.oldPermission = '';

        this.department = '';
        this.department_title = '';
        this.adminName = '';
        this.email = '';
        this.phone = '';
        this.id = '';
        this.pw = '';
        this.pwChk = '';
      },

      // 소속부서 셀렉트 박스 변경에 따른 input 박스 상태 변경
      changeDepartmentInput:function() {
        this.department_title = '';
        
        if (this.department == '0') {
          $('#department_title').attr('disabled', false);
        } else {
          if (this.department !== '') {
            this.department_title = this.department;
          }
          $('#department_title').attr('disabled', true);
        }
      },

      // 권한 이름 바꾸기
      replacePermissionName:function(permission) {
        var permiName = '';

        switch(permission) {
          case 'PM0001': permiName = '권한대기';break;
          case 'PM0002': permiName = '종목별 지도자';break;
          case 'PM0003': permiName = '훈련원 관리자';break;
          case 'PM0004': permiName = '단체 대표자';break;
          case 'PM0005': permiName = '권한 대기';break;
          default: permiName = '';break;
        }

        return permiName;
      },

      // 팝업 열기
      openPopup:function(list, type) {
        var _this = this;

        switch(type){
          case 'a': _this.type = 'apply';break;
          case 'y': _this.type = 'accept';break;
          case 'n': _this.type = 'reject';break;
          case 'd': _this.type = 'delete';break;
          case 'c': _this.type = 'cancel';break;
          case 'w': _this.type = 'withdrawal';break;
          case 'l': _this.type = 'lock';break;
        }

        if (list !== '' || list !== undefined) {
          this.setPopupInfo(list);
        }

        this.showPopup = true;
        $('#l_popup__dimm').addClass('active');
      },

      // 팝업 정보 설정
      setPopupInfo:function(list) {
        this.state = list.state;
        this.employee_seq = list.employee_seq;
        this.permission_seq = list.permission;
        if (this.type == 'accept' || this.type == 'reject') {
          this.name = list.name;
          this.oldPermission = this.replacePermissionName(list.old_permission);
          this.newPermission = this.replacePermissionName(list.permission);
        }
      },

      // 팝업 닫기
      closePopup:function(popup) {
        // $(popup).removeClass('active');
        this.showPopup = false;
        $('#l_popup__dimm').removeClass('active');

        this.resetAdminCheck();
      },

      // 회원가입 계정 추가 페이징
      newPageMove:function(idx){
        var _this=this;
        _this.new_permi_pageNo=idx;
        _this.loadPaginationNewPermi();
      },
      newPageJump:function(cnt){
        var _this=this;
        _this.new_permi_pageNo=cnt*5;
        if(cnt<=-1){
          _this.new_permi_pageNo=0;
          _this.loadPaginationNewPermi();
          return;
        }
        if(_this.new_permi_pageNo>_this.new_permi_pageMax-1){
          _this.new_permi_pageNo=_this.new_permi_pageMax-1;
          _this.loadPaginationNewPermi();
          return;
        }
        _this.new_permi_pageCount=cnt;
        _this.loadPaginationNewPermi();
      },

      // 권한설정 페이징
      pageMove:function(idx){
        var _this=this;
        _this.permi_pageNo=idx;
        _this.loadPaginationPermi();
      },
      pageJump:function(cnt){
        var _this=this;
        _this.permi_pageNo=cnt*5;
        if(cnt<=-1){
          _this.permi_pageNo=0;
          _this.loadPaginationPermi();
          return;
        }
        if(_this.permi_pageNo>_this.permi_pageMax-1){
          _this.permi_pageNo=_this.permi_pageMax-1;
          _this.loadPaginationPermi();
          return;
        }
        _this.permi_pageCount=cnt;
        _this.loadPaginationPermi();
      },

    },
    mounted:function(){
      this.getSessionInfo();
    },
    created:function(){
      eventBus.$emit("menuinfo");
      eventBus.$emit("menudrop", [11,1]);

      this.loadPermissionList();
      this.loadAddDepartmentSelectBox();
      this.loadPermissionSelectBox();
  }
});
</script>
</body>
</html>