<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct join_comfirm" v-cloak>
	<div class="l_content">
		<!-- 컨텐츠 영역. s. -->
    <h2>입촌확인</h2>
    <div class="l_list_tablewrap">
      <table>
        <caption>입촌확인 선택 목록</caption>
        <colgroup>
          <col style="width:3%;">
          <col style="width:4%;">
          <col style="width:5%;">
          <col style="width:8%;">
          <col style="width:11%;">
          <col style="width:6%;">
          <col style="width:4%;">
          <col style="width:7%;">
          <col style="width:6%;">
          <col style="width:14%;">
          <col style="width:6%;">
          <col style="width:10%;">
          <col style="width:11%;">
          <col style="width:5%;">
        </colgroup>
        <thead>
          <tr>
            <th scope="col">
              <div class="l_checkbox">
                <input type="checkbox" id="groupCheckAll" v-model="groupCheckAll">
                <label for="groupCheckAll">단체 전체 선택</label>
              </div>
            </th>
            <th scope="col">번호</th>
            <th scope="col">신청상태</th>
            <th scope="col">신청일</th>
            <th scope="col">소속단체명</th>
            <th scope="col">종목</th>
            <th scope="col">성별</th>
            <th scope="col">장애유형</th>
            <th scope="col">훈련구분</th>
            <th scope="col">입촌기간</th>
            <th scope="col">대표자명</th>
            <th scope="col">연락처</th>
            <th scope="col">이메일</th>
            <th scope="col">입촌인원</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="enterconfirmlist.length==0">
            <!-- <td colspan="14">{{errorcode}}</td> -->
            <td colspan="14"><p class="m_no_list"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
          </tr>
          <tr class="m_cursor" v-bind:class="{l_choice:choice==key}" v-if="enterconfirmlist.length>0" v-for="(list,key) in enterconfirmlist" :key="key">
            <td>
              <div class="l_checkbox">
                <input type="checkbox" :id="'groupCheck'+key" :value="list.enter_seq" v-model="groupCheck">
                <label :for="'groupCheck'+key">{{list.association}} 선택</label>
              </div>
            </td>
            <td @click="detailPop(list.enter_seq, key)">{{list.reverseIdx}}</td>
            <td @click="detailPop(list.enter_seq, key)" v-bind:class="{s_orange_txt2:list.enter_state=='확인 요청' || list.enter_state=='확인 후 수정'}">{{list.enter_state}}</td>
            <td @click="detailPop(list.enter_seq, key)">{{list.reg_date}}</td>
            <td @click="detailPop(list.enter_seq, key)">{{list.association}}</td>
            <td @click="detailPop(list.enter_seq, key)">{{list.sports}}</td>
            <td @click="detailPop(list.enter_seq, key)">{{list.gender}}</td>
            <td @click="detailPop(list.enter_seq, key)">{{list.disabled_type}}</td>
            <td @click="detailPop(list.enter_seq, key)">{{list.training_type}}</td>
            <td @click="detailPop(list.enter_seq, key)">{{list.enter_period}}</td>
            <td @click="detailPop(list.enter_seq, key)">{{list.applicant_name}}</td>
            <td @click="detailPop(list.enter_seq, key)">{{list.phone}}</td>
            <td @click="detailPop(list.enter_seq, key)">{{list.email}}</td>
            <td @click="detailPop(list.enter_seq, key)">{{list.player_cnt}}</td>
          </tr>
        </tbody>
      </table>
      <div v-if="enterconfirmlist.length>0" class="l_paging_area">
        <button class="l_page l_prev" @click="pageJump1(pageCount1-1)"><span class="img"><img src="/front/img/icon_prevpage.svg" alt="이전 목록으로"></span></button>
        <div v-if="pageMax1<=5">
          <button v-for="(page,key) in pageMax1" :key="key" class="l_paging" v-bind:class="{s_on:key==pageNo1}" @click="pageMove1(key)">{{page}}</button>
        </div>
        <div v-else>
          <button v-for="(page,key) in 5" :key="key+(5*pageCount1)" v-if="(key+(5*pageCount1))<pageMax1" class="l_paging" v-bind:class="{s_on:key+(5*pageCount1)==pageNo1}" @click="pageMove1(key+(5*pageCount1))">{{page+(5*pageCount1)}}</button>
        </div>
        <button class="l_page l_next" @click="pageJump1(pageCount1+1)"><span class="img"><img src="/front/img/icon_nextpage.svg" alt="다음 목록으로"></span></button>
      </div>
    </div>
    
    <div class="l_search_btns l_nobtr">
      <button class="l_btn s_blue" @click="confirmInfo('확인')">확 인</button>
      <button class="l_btn s_white" @click="confirmInfo('반려')">반 려</button>
    </div>

    <div class="l_list_searchwrap">
      <div class="l_selectarea">
        <select title="연도 선택" v-model="currentyear">
          <option v-for="n in nav.year" v-if="(nav.year+1)-n>=nav.defaultYear" :value="(nav.year+1)-n">{{(nav.year+1)-n}}</option>
        </select>
      </div>
      <div class="l_selectarea">
        <select title="종목 선택" v-model="sports_code" @change="enterList">
          <option value="">종목 선택</option>
          <option v-for="(option,key) in nav.sportslist" :key="key" :value="option.seq">{{option.title}}</option>
        </select>
      </div>
    </div>
    <div class="l_list_tablewrap">
      <table>
        <caption>입촌확인 목록</caption>
        <colgroup>
          <col style="width:4%;">
          <col style="width:6%;">
          <col style="width:8%;">
          <col style="width:12%;">
          <col style="width:6%;">
          <col style="width:4%;">
          <col style="width:7%;">
          <col style="width:6%;">
          <col style="width:14%;">
          <col style="width:6%;">
          <col style="width:10%;">
          <col style="width:12%;">
          <col style="width:5%;">
        </colgroup>
        <thead>
          <tr>
            <th scope="col">번호</th>
            <th scope="col">신청상태</th>
            <th scope="col">신청일</th>
            <th scope="col">소속단체명</th>
            <th scope="col">종목</th>
            <th scope="col">성별</th>
            <th scope="col">장애유형</th>
            <th scope="col">훈련구분</th>
            <th scope="col">입촌기간</th>
            <th scope="col">대표자명</th>
            <th scope="col">연락처</th>
            <th scope="col">이메일</th>
            <th scope="col">입촌인원</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="enterlist.length==0">
            <td colspan="13"><p class="m_no_list"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
          </tr>
          <tr v-if="enterlist.length>0" v-for="(list,key) in enterlist" :key="key">
            <td>{{list.reverseIdx}}</td>
            <td>{{list.enter_state}}</td>
            <td>{{list.reg_date}}</td>
            <td>{{list.association}}</td>
            <td>{{list.sports}}</td>
            <td>{{list.gender}}</td>
            <td>{{list.disabled_type}}</td>
            <td>{{list.training_type}}</td>
            <td>{{list.enter_period}}</td>
            <td>{{list.applicant_name}}</td>
            <td>{{list.phone}}</td>
            <td>{{list.email}}</td>
            <td>{{list.player_cnt}}명</td>
          </tr>
        </tbody>

      </table>
      <div v-if="enterlist.length>0" class="l_paging_area">
        <button class="l_page l_prev" @click="pageJump2(pageCount2-1)"><span class="img"><img src="/front/img/icon_prevpage.svg" alt="이전 목록으로"></span></button>
        <div v-if="pageMax2<=5">
          <button v-for="(page,key) in pageMax2" :key="key" class="l_paging" v-bind:class="{s_on:key==pageNo2}" @click="pageMove2(key)">{{page}}</button>
        </div>
        <div v-else>
          <button v-for="(page,key) in 5" :key="key+(5*pageCount2)" v-if="(key+(5*pageCount2))<pageMax2" class="l_paging" v-bind:class="{s_on:key+(5*pageCount2)==pageNo2}" @click="pageMove2(key+(5*pageCount2))">{{page+(5*pageCount2)}}</button>
        </div>
        <button class="l_page l_next" @click="pageJump2(pageCount2+1)"><span class="img"><img src="/front/img/icon_nextpage.svg" alt="다음 목록으로"></div></button>
      </div>
	  </div>
  

    <!-- 팝업 -->
    <transition name="fade">
      <div class="l_popup_bg" v-if="detailpop">
        <div class="l_popup_area l_playerlist">
          <p class="l_popup_title">입촌신청서</p>
          <div class="l_popup_infobox">
            <div class="l_popup_infoboxline m_ibarea">
              <p class="l_title">소속단체명</p>
              <p class="l_titletxt">{{association}}</p>
              <p class="l_title">종목</p>
              <p class="l_titletxt">{{sports}}</p>
              <p class="l_title">성별</p>
              <p class="l_titletxt">{{gender}}</p>
            </div>
            <div class="l_popup_infoboxline m_ibarea">
              <p class="l_title">장애유형</p>
              <p class="l_titletxt">{{disabled_type}}</p>
              <p class="l_title">훈련구분</p>
              <p class="l_titletxt">{{training_type}}</p>
              <p class="l_title">대표자명</p>
              <p class="l_titletxt">{{applicant_name}}</p>
            </div>
            <div class="l_popup_infoboxline m_ibarea">
              <p class="l_title">연락처</p>
              <p class="l_titletxt">{{phone}}</p>
              <p class="l_title">이메일</p>
              <p class="l_titletxt">{{email}}</p>
              <p class="l_title">단체서약서</p>
              <button class="l_titletxt l_down" @click="nav.downloadFile(agree_file_path)">{{agree_file}}</button>
            </div>
            <div class="l_popup_infoboxline m_ibarea">
              <p class="l_title">입촌기간</p>
              <p class="l_titletxt l_long">{{sDate}} &nbsp; {{sHour}}:{{sMin}} &nbsp; ~ &nbsp; {{eDate}} &nbsp; {{eHour}}:{{eMin}}</p>
            </div>
          </div>

          <div class="l_popup_topinfo">
            <p class="l_popup_title">입촌선수</p>
            <p class="l_infotxt">총인원</p>
            <p class="l_infodata">{{total}}</p>
          </div>
          <div class="l_list_tablewrap">
            <table>
              <caption>입촌선수 선택 목록</caption>
              <colgroup>
                <col style="width:7%;">
                <col style="width:5%;">
                <col style="width:5%;">
                <col style="width:7%;">
                <col style="width:6%;">
                <col style="width:7%;">
                <col style="width:7%;">
                <col style="width:7%;">
                <col style="width:11%;">
                <col style="width:10%;">
                <col style="width:10%;">
                <col style="width:9%;">
                <col style="width:9%;">
              </colgroup>
              <thead>
                <tr>
                  <th scope="col">선수번호</th>
                  <th scope="col">성명</th>
                  <th scope="col">성별</th>
                  <th scope="col">생년월일</th>
                  <th scope="col">직위</th>
                  <th scope="col">장애여부</th>
                  <th scope="col">장애유형</th>
                  <th scope="col">경기등급</th>
                  <th scope="col">소속</th>
                  <th scope="col">건강진단서</th>
                  <th scope="col">서약서</th>
                  <th scope="col">입촌시작</th>
                  <th scope="col">입촌종료</th>
                </tr>
              </thead>
              <tbody>
                <tr v-bind:class="{s_graybg:list.state==='5'}" v-for="(list,key) in poplists" :key="key">
                  <td>{{list.player_code}}</td>
                  <td>{{list.name}}</td>
                  <td>{{list.gender}}</td>
                  <td>{{nav.addBirthDot(list.birthday)}}</td>
                  <td>{{list.player_position}}</td>
                  <td>{{list.disabled_state}}</td>
                  <td>{{list.disabled_type}}</td>
                  <td>{{list.disabled_grade}}</td>
                  <td>{{list.player_area}}</td>
                  <td>
                    <p v-if="list.medical_file=='no_file'">{{list.medical_file}}</p>
                    <button v-else class="l_download" @click="nav.downloadFile(list.medical_file_path)">{{list.medical_file}}</button>
                  </td>
                  <td>
                    <p v-if="list.agree_file=='no_file'">{{list.agree_file}}</p>
                    <button v-else class="l_download" @click="nav.downloadFile(list.agree_file_path)">{{list.agree_file}}</button>
                  </td>
                  <td>{{list.sDate}}</td>
                  <td>{{list.eDate}}</td>
                </tr>
              </tbody>
            </table>
          </div>


          <div class="l_search_btns">
            <button class="l_btn s_white" @click="detailPopClose">닫 기</button>
          </div>
        </div>
      </div>
    </transition>
    
    <transition name="fade">
      <div class="l_popup_bg" v-if="confirmpop">
        <div class="l_popup_area">
          <p class="l_popup_title">{{confirmtxt}} 하시겠습니까?</p>
          <p class="l_popup_cmt">확인을 누르시면 {{confirmtxt=="확인"? "신청" : "반려"}}됩니다.</p>
          <div class="l_search_btns">
            <button class="l_btn s_blue" @click="confirmInfo('ok')">확 인</button>
            <button class="l_btn s_white" @click="confirmpop=false">취 소</button>
          </div>
        </div>
      </div>
    </transition>

		<!-- 컨텐츠 영역. e. -->
	</div>
</section>


<script>
	var cont=new Vue({
		el:"#icContent",
		data:{
      enterlist_api:"http://ic.sportsdiary.co.kr/api/enter_center_manager/enter_list_allow.asp",// 입촌 확인/반려 목록 api
      enterconfirmlist_api:"http://ic.sportsdiary.co.kr/api/enter_center_manager/enter_list_allow_req.asp",// 확인요청 목록 api
      enterejec_api:"http://ic.sportsdiary.co.kr/api/enter_center_manager/enter_allow.asp",// 확인/반려 api

      // 팝업용
      enter_api:"http://ic.sportsdiary.co.kr/api/enter_center_manager/enter_select.asp",// 입촌신청내역 조회의 목록에서 선택한 신청서의 enter_seq 값으로 팝업 값 찾기
      enterplayer_api:"http://ic.sportsdiary.co.kr/api/enter_player_manager/player_list.asp",// 입촌선수 목록에서 선택한 선수의 enter_seq 값으로 팝업 값 찾기

      enterlist:[],// 입촌 확인/반려 목록
      enterconfirmlist:[],// 확인요청 목록

      currentyear:"",// 현재연도
      sports_code:"",// 종목코드
      
      pageMax1:null,// 최대 페이지 수
      pageCount1:0,// 몇번째 5단위 page인가 확인용
      pageNo1:0,// 현재 페이지수
      pageMax2:null,// 
      pageCount2:0,// 
      pageNo2:0,//

      enter_seq:"",// 기준점

      // 팝업 보이기 여부
      detailpop:false,
      association:"",// 소속 단체명
      sports:"",// 종목
      poplists:[],// 팝업 상단정보 목록
      disabled_type:"",// 장애유형
      gender:"",// 성별
      training_type:"",// 훈련구분
      applicant_name:"",// 대표자명
      phone:"",
      email:"",
      agree_file:"",// 단체서약서 파일명
      agree_file_path:"",// 경로
      sDate:"",
      sHour:"",
      sMin:"",
      eDate:"",
      eHour:"",
      eMin:"",

      leader:0,
      coach:0,
      trainer:0,
      player:0,
      total:0,

      errorcode:"",
      choice:-1,// 선택 표시

      // 입촌확인 체크
      groupCheckAll:false,
      groupCheck:[],

      confirmpop:false,// 확인/반려 확인 팝업
      confirmtxt:"",// 확인/반려 문구
		},
    watch:{
      // 입촌선수 명단 팝업에서 전체 체크/해제
      groupCheckAll:function(){
        if(this.groupCheckAll){
          this.groupCheck=[];
          for(var i=0;i<this.enterconfirmlist.length;i++){
            this.groupCheck.push(this.enterconfirmlist[i].enter_seq);
          }
        }else{
          if(this.groupCheck.length==this.enterconfirmlist.length){
            this.groupCheck=[];
          }
        }
      },
      // 입촌선수 명단 팝업에서 체크
      groupCheck:function(){
        if(this.groupCheck.length==this.enterconfirmlist.length){
          this.groupCheckAll=true;
        }else{
          this.groupCheckAll=false;
        }
      },
    },
		methods:{
      // 확인요청 목록에서 선택한거 확인 / 반려
      confirmInfo:function(conf){
        // conf : 확인, 반려 문구
        // conf==ok : 확인, 반려 실행
        var _this=this;
        if(conf=="확인" || conf=="반려"){
          _this.confirmtxt=conf;
        }
        if(_this.groupCheck.length==0){
          alert("체크박스로 "+_this.confirmtxt+"하려는 신청건을 선택해주세요");
          return;
        }
        _this.confirmpop=true;

        if(_this.confirmtxt=="확인" && conf=="ok"){
          // enter_allow : 3 === 확인
          axios.post(_this.enterejec_api,{
            enter_seqs:_this.groupCheck,
            enter_allow:3
          }).then(function(response){
            if(response.data.state==="true"){
              _this.pageNo1=0;
              _this.pageNo2=0;
              _this.enterList();
              _this.enterConfirmList();
              _this.confirmpop=false;
              _this.confirmtxt="";
              _this.choice=-1;
            }
          });
        }else if(_this.confirmtxt=="반려" && conf=="ok"){
          // enter_allow : 4 === 반려
          axios.post(_this.enterejec_api,{
            enter_seqs:_this.groupCheck,
            enter_allow:4
          }).then(function(response){
            if(response.data.state==="true"){
              _this.pageNo1=0;
              _this.pageNo2=0;
              _this.enterList();
              _this.enterConfirmList();
              _this.confirmpop=false;
              _this.confirmtxt="";
              _this.choice=-1;
            }
          });
        }
      },

      // 확인요청 목록에서 선택한 내용 상세팝업보기
      detailPop:function(enterseq,key){
        var _this=this;
        this.detailpop=true;
        _this.enter_seq=enterseq;
        _this.choice=key;

        // 선택한 입촌 확인에 맞는 데이터를 입촌신청내역 목록에서 찾아오기
        var selectData=axios.post(_this.enter_api,{
          enter_seq:_this.enter_seq
        });
        // 선택한 입촌 확인에 맞는 데이터를 입촌선수 목록에서 찾아오기
        var playerData=axios.post(_this.enterplayer_api,{
          enter_seq:_this.enter_seq
        });

        axios.all([
          selectData,
          playerData
        ]).then(axios.spread(function(selres, playeres){
          // 팝업 정보
          if(selres.data.state==="true"){
            _this.association=selres.data.enter[0].association;
            _this.sports=selres.data.enter[0].sports;
            _this.disabled_type=selres.data.enter[0].disabled_type;
            _this.gender=selres.data.enter[0].gender;
            _this.training_type=selres.data.enter[0].training_type;
            _this.applicant_name=selres.data.enter[0].applicant_name;
            _this.phone=selres.data.enter[0].phone;
            _this.email=selres.data.enter[0].email;
            _this.agree_file=selres.data.enter[0].agree_file;
            _this.agree_file_path=selres.data.enter[0].agree_file_path;
            _this.sDate=selres.data.enter[0].sDate;
            _this.sHour=selres.data.enter[0].sHour;
            _this.sMin=selres.data.enter[0].sMinute;
            _this.eDate=selres.data.enter[0].eDate;
            _this.eHour=selres.data.enter[0].eHour;
            _this.eMin=selres.data.enter[0].eMinute;

            _this.sports_code=selres.data.enter[0].sports_code;
          }

          // 팝업 목록
          if(playeres.data.state==="true"){
            _this.poplists=[];
            _this.leader=_this.coach=_this.trainer=_this.player=_this.total=0;

            _this.poplists=playeres.data.player;
            _this.total=playeres.data.total;
            _this.poplists.filter(function(val,idx){
              if(val.player_position=="감독"){
                _this.leader+=1;
              }else if(val.player_position=="코치"){
                _this.coach+=1;
              }else if(val.player_position=="트레이너"){
                _this.trainer+=1;
              }else if(val.player_position=="선수"){
                _this.player+=1;
              }
            });
          }else if(playeres.data.state==="false"){
            _this.poplists=[];
            _this.leader=_this.coach=_this.trainer=_this.player=0;
          }
        }));
      },
      // 팝업 내용 초기화
      detailPopClose:function(){
        this.detailpop=false
        this.association="";
        this.sports="";
        this.disabled_type="";
        this.gender="";
        this.training_type="";
        this.applicant_name="";
        this.phone="";
        this.email="";
        this.agree_file="";
        this.agree_file_path="";
        this.sDate="";
        this.sHour="";
        this.sMin="";
        this.eDate="";
        this.eHour="";
        this.eMin="";
        this.sports_code="";
        this.poplists=[];
        this.leader=this.coach=this.trainer=this.player=0;
      },

      // 확인 요청 목록
      enterConfirmList:function(){
        var _this=this;
        axios.post(_this.enterconfirmlist_api,{
          reg_year:_this.currentyear,
          sports_code:_this.sports_code,
          page_num:_this.pageNo1+1,
          page_per_cnt:5
        }).then(function(response){
          if(response.data.state==="true"){
            _this.pageMax1=Number(response.data.max_page);
            _this.enterconfirmlist=response.data.allow_enter;
          }else if(response.data.state==="false"){
            _this.pageMax1=null;
            _this.pageCount1=0;
            _this.pageNo1=0;
            _this.enterconfirmlist=[];
            if(response.data.errorcode==="ERR-130"){
              _this.errorcode="현재 목록이 없습니다.";
            }
          }
        });
      },

      // 확인/반려된 목록
      enterList:function(){
        var _this=this;
        axios.post(_this.enterlist_api,{
          reg_year:_this.currentyear,
          sports_code:_this.sports_code,
          page_num:_this.pageNo2+1,
          page_per_cnt:5
        }).then(function(response){
          if(response.data.state==="true"){
            _this.pageMax2=Number(response.data.max_page);
            _this.enterlist=response.data.allow_enter;
          }else if(response.data.state==="false"){
            _this.pageMax2=null;
            _this.pageCount2=0;
            _this.pageNo2=0;
            _this.enterlist=[];
            if(response.data.errorcode==="ERR-130"){
              _this.errorcode="현재 목록이 없습니다.";
            }
          }
        });
      },

      // 확인 요청 목록 페이징
      pageMove1:function(idx){
        var _this=this;
        _this.pageNo1=idx;
        _this.enterConfirmList();
      },
      pageJump1:function(cnt){
        var _this=this;
        _this.pageNo1=cnt*5;
        if(cnt<=-1){
          _this.pageNo1=0;
          _this.enterConfirmList();
          return;
        }
        if(_this.pageNo1>_this.pageMax1-1){
          _this.pageNo1=_this.pageMax1-1;
          _this.enterConfirmList();
          return;
        }
        _this.pageCount1=cnt;
        _this.enterConfirmList();
      },

      // 확인/반려된 목록 페이징
      pageMove2:function(idx){
        var _this=this;
        _this.pageNo2=idx;
        _this.enterList();
      },
      pageJump2:function(cnt){
        var _this=this;
        _this.pageNo2=cnt*5;
        if(cnt<=-1){
          _this.pageNo2=0;
          _this.enterList();
          return;
        }
        if(_this.pageNo2>_this.pageMax2-1){
          _this.pageNo2=_this.pageMax2-1;
          _this.enterList();
          return;
        }
        _this.pageCount2=cnt;
        _this.enterList();
      },

		},
		mounted:function(){
      this.enterList();
      this.enterConfirmList();
    },
		created:function(){
      this.currentyear=nav.year;
			// 현재 메뉴(위치) 확인
			eventBus.$emit("menuinfo");
			eventBus.$emit("menudrop", [4,3]);
		}
	});
</script>
</body>
</html>