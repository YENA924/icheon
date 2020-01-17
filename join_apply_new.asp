<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct join_apply new_apply" v-cloak>
	<div class="l_content">
		<!-- 컨텐츠 영역. s. -->
		<h2>입촌신청</h2>
  
    <div class="l_search_box">
      <div class="l_search_field">
        <div class="l_field">
          <label for="teamname">소속단체명</label>
          <input type="text" id="teamname" :value="association_name" class="l_readonly" readonly>
        </div>
        <div class="l_field">
          <label for="sports">종목</label>
          <input type="text" id="sports" :value="sports_title" class="l_readonly" readonly>
        </div>
        <!-- 협회 seq : 1     협회 이름  : 대한장애인농구협회     종목 코드 : SP0023     종목 이름 : 농구 -->
        <div class="l_field">
          <label for="impairmenttype">장애유형</label>
          <select id="impairmenttype" v-model="disabled_type_code">
            <option value="">선택</option>
            <option v-for="(option,key) in selectinfo.disabled_type" :key="key" :value="option.seq">{{option.title}}</option>
          </select>
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field">
          <label for="gender">성별</label>
          <select id="gender" v-model="gender_code">
            <option value="">선택</option>
            <option v-for="(option,key) in selectinfo.gender2" :key="key" :value="option.seq">{{option.title}}</option>
          </select>
        </div>
        <div class="l_field">
          <label for="trainingtype">훈련구분</label>
          <select id="trainingtype" v-model="train_type_code">
            <option value="">선택</option>
            <option v-for="(option,key) in selectinfo.train_purpose" :key="key" :value="option.seq">{{option.title}}</option>
          </select>
        </div>
        <div class="l_field">
          <label for="applyname">신청자명</label>
          <input type="text" id="applyname" placeholder="신청자명을 입력하세요" v-model="applicant">
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field">
          <label for="telnumber">연락처</label>
          <input type="text" id="telnumber" placeholder="연락처를 입력하세요" maxlength="13" v-model="phone" v-on:input="phone=nav.addDash($event.target.value)">
        </div>
        <div class="l_field">
          <label for="emailaddr">이메일</label>
          <input type="text" id="emailaddr" placeholder="이메일을 입력하세요" v-model="email">
        </div>
        <div class="l_field">
          <label for="grouppledge">단체서약서</label>
          <div class="filewrap">
            <input type="file" id="grouppledge" @change="uploadFile($event.target, 2)">
            <p class="l_filename">{{grouppledgefilename}}</p>
            <p class="l_btnstyle">첨부</p>
          </div>
        </div>
      </div>
      
      <div class="l_search_field l_search_long">
        <div class="l_field_long">
          <div class="l_field">
            <label for="acquistiondate_start">입촌기간</label>
            <input id="acquistiondate_start" class="flatpickr" placeholder="시작일을 선택하세요" title="시작일 선택" v-model="sDate"></input>
            <div class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></div>
          </div>
          <div class="l_fieldtime">
            <select title="입촌기간 시작일의 시" v-model="sHour">
              <option value="">시</option>
              <option v-for="(option,key) in 23" :value="option<10?'0'+option:option">{{option<10?'0'+option:option}}</option>
            </select>
          </div>
          <span class="l_col">:</span>
          <div class="l_fieldtime">
            <select title="입촌기간 시작일의 분" v-model="sMin">
              <option value="">분</option>
              <option v-if="key%10==0" v-for="(option,key) in 60" :value="key==0?'00':key">{{key==0?"00":key}}</option>
            </select>
          </div>
          <span class="l_wave">~</span>
          <div class="l_field">
            <input id="acquistiondate_end" class="flatpickr" placeholder="종료일을 선택하세요" title="종료일 선택" v-model="eDate"></input>
            <div class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></div>
          </div>
          <div class="l_fieldtime">
            <select title="입촌기간 종료일의 시" v-model="eHour">
              <option value="">시</option>
              <option v-for="(option,key) in 23" :value="option<10?'0'+option:option">{{option<10?'0'+option:option}}</option>
            </select>
          </div>
          <span class="l_col">:</span>
          <div class="l_fieldtime">
            <select title="입촌기간 종료일의 분" v-model="eMin">
              <option value="">분</option>
              <option v-if="key%10==0" v-for="(option,key) in 60" :value="key==0?'00':key">{{key==0?"00":key}}</option>
            </select>
          </div>
        </div>
        <p class="l_searchfield_cmt">* 입촌기간은 생활관 이용기간을 포함해서 입력해주세요.</p>
      </div>
      <div class="l_search_btns">
        <button class="l_btn s_blue" v-bind:class="{gray:!info_update}" @click="saveData('0')">{{!choicedata? "등 록" : "수 정"}}</button>
        <button class="l_btn s_orange" v-if="choicedata && enter_state!=3" @click="deletepop=true">삭 제</button>
        <a href="/join_apply.asp" class="l_btn s_white" v-if="choicedata && enter_state!=3" @click="pagemove=true">취 소</a>
        <button class="l_btn s_white" v-if="!choicedata" @click="deleteData">취 소</button>
      </div>
    </div>

    <div class="l_list_box l_addtitle">
      <h2>입촌선수</h2>
      <p class="l_outplayer_cmt">※퇴촌 선수는 회색으로 표시됩니다. 퇴촌처리된 선수 관련 문의는 이천훈련원에 별도 문의하거나 재입촌신청 해주시기바랍니다.</p>
      <div class="l_search_btns">
        <button class="l_btn s_gray" @click="managePlayerPop">입촌선수명단 관리</button>
        <button class="l_btn s_whitegline" @click="saveData('1')">선수등록 바로가기</button>
      </div>
      <div class="l_list_tablewrap">
        <table>
          <caption>입촌 선수 목록</caption>
          <colgroup>
            <col style="width:6%;">
            <col style="width:6%;">
            <col style="width:3%;">
            <col style="width:7%;">
            <col style="width:4%;">
            <col style="width:6%;">
            <col style="width:6%;">
            <col style="width:5%;">
            <col style="width:7%;">
            <col style="width:13%;">
            <col style="width:13%;">
            <col style="width:12%;">
            <col style="width:12%;">
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
            <tr v-if="playerlist.length==0">
              <!-- <td colspan="13">{{errorcode}}</td> -->
              <td colspan="13"><p class="m_no_list"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
            </tr>
            <tr v-bind:class="{s_graybg:list.state_title=='퇴촌'}" v-if="playerlist.length>0" v-for="(list,key) in playerlist" :key="key">
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
                <div class="l_addfilewrap" v-if="list.medical_file==''">
                  <input type="file" title="파일첨부하기" @change="uploadFile($event.target, 3, list.enter_player_seq)">
                  <p class="l_addfilestyle">첨부하기</p>
                </div>
                <div v-else>
                  <button class="l_download" @click="nav.downloadFile(list.medical_file_path)">{{list.medical_file}}</button>
                  <div class="l_addfilewrap l_update">
                    <input type="file" title="파일수정하기" @change="uploadFile($event.target, 3, list.enter_player_seq)">
                    <p class="l_btnstyle">수정</p>
                  </div>
                </div>
              </td>
              <td>
                <div class="l_addfilewrap" v-if="list.agree_file==''">
                  <input type="file" title="파일첨부하기" @change="uploadFile($event.target, 1, list.enter_player_seq)">
                  <p class="l_addfilestyle">첨부하기</p>
                </div>
                <div v-else>
                  <button class="l_download" @click="nav.downloadFile(list.agree_file_path)">{{list.agree_file}}</button>
                  <div class="l_addfilewrap l_update">
                    <input type="file" title="파일수정하기" @change="uploadFile($event.target, 1, list.enter_player_seq)">
                    <p class="l_btnstyle">수정</p>
                  </div>
                </div>
              </td>
              <td>
                <div class="l_field">
                  <input class="flatpickr" placeholder="시작일을 선택" title="시작일 선택" :value="list.sDate" @change="updatePlayerInfo(33, list.enter_player_seq, $event.target.value)"></input>
                  <div class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></div>
                </div>
              </td>
              <td>
                <div class="l_field">
                  <input class="flatpickr" placeholder="종료일을 선택" title="종료일 선택" :value="list.eDate" @change="updatePlayerInfo(44, list.enter_player_seq, $event.target.value)"></input>
                  <div class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 팝업 -->
    <transition name="fade">
      <div class="l_popup_bg" v-if="deletepop">
        <div class="l_popup_area">
          <p class="l_popup_title">입촌신청 내용을 삭제하시겠습니까?</p>
          <p class="l_popup_cmt">확인을 누르시면 편집했던 데이터는 삭제됩니다.</p>
          <div class="l_search_btns">
            <button type="submit" class="l_btn s_blue" @click="deleteData">확 인</button>
            <button type="reset" class="l_btn s_white" @click="deletepop=false">취 소</button>
          </div>
        </div>
      </div>
    </transition>
    
    <transition name="fade">
      <div class="l_popup_bg" v-if="playerlistpop">
        <div class="l_popup_area l_playerlist">
          <div class="l_popup_topinfo">
            <p class="l_popup_title">입촌선수 명단</p>
            <p class="l_infotxt">선택된 인원</p>
            <p class="l_infodata">{{playerCheck.length}}</p>
            <p class="l_infotxt">총인원</p>
            <p class="l_infodata">{{mngplayerlist.total}}</p>
          </div>
          <div class="l_list_tablewrap">
            <table>
              <caption>입촌선수 선택 목록</caption>
              <thead>
                <tr>
                  <th scope="col">
                    <div class="l_checkbox">
                      <input type="checkbox" name="playerCheckAll" id="playerCheckAll" v-model="playerCheckAll">
                      <label for="playerCheckAll">선수 전체 선택</label>
                    </div>
                  </th>
                  <th scope="col">선수번호</th>
                  <th scope="col">성명</th>
                  <th scope="col">성명(영문)</th>
                  <th scope="col">성별</th>
                  <th scope="col">생년월일</th>
                  <th scope="col">직위</th>
                  <th scope="col">소속</th>
                  <th scope="col">장애여부</th>
                  <th scope="col">장애유형</th>
                  <th scope="col">경기등급</th>
                </tr>
              </thead>
              <tbody>
                <tr v-bind:class="{s_graybg:list.state==='5'}" v-for="(list,key) in mngplayerlist.player" :key="key">
                  <td>
                    <div class="l_checkbox">
                      <input type="checkbox" :id="'playerCheck'+key" :value="list.player_seq" v-model="playerCheck">
                      <label :for="'playerCheck'+key">선수번호 {{list.player_code}} {{list.name}}선택</label>
                    </div>
                  </td>
                  <td><label :for="'playerCheck'+key">{{list.player_code}}</label></td>
                  <td><label :for="'playerCheck'+key">{{list.name}}</label></td>
                  <td><label :for="'playerCheck'+key">{{list.en_name}}</label></td>
                  <td><label :for="'playerCheck'+key">{{list.gender}}</label></td>
                  <td><label :for="'playerCheck'+key">{{nav.addBirthDot(list.birthday)}}</label></td>
                  <td><label :for="'playerCheck'+key">{{list.player_position}}</label></td>
                  <td><label :for="'playerCheck'+key">{{list.player_area}}</label></td>
                  <td><label :for="'playerCheck'+key">{{list.disabled_state}}</label></td>
                  <td><label :for="'playerCheck'+key">{{list.disabled_type}}</label></td>
                  <td><label :for="'playerCheck'+key">{{list.disabled_grade}}</label></td>
                </tr>
              </tbody>
            </table>
          </div>

          <div class="l_search_btns">
            <button type="submit" class="l_btn s_blue" @click="checkPlayer('check')">확 인</button>
            <button class="l_btn s_white" @click="checkPlayer('reset')">취 소</button>
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
      upload_api:"http://ic.sportsdiary.co.kr/api/file_upload/upload.asp",// 업로드.  file_type = 1:개인 서약서, 2:단체 서약서, 3:건강진단서, 4:공지사항 첨부파일
      upload_change_api:"http://ic.sportsdiary.co.kr/api/enter_center_manager/enter_attach_file.asp",// 단체서약서 업로드 후 업로드 된 파일 정보가 수정된 전체 값 api

      select_api:"http://ic.sportsdiary.co.kr/api/menu_control/selected_item.asp",// 옵션 정보 목록 url
      selectinfo:[],// 옵션 정보 목록. select option

      enter_api:"http://ic.sportsdiary.co.kr/api/enter_center_manager/enter_select.asp",// (수정하기). 입촌신청 - 입촌신청내역 조회의 목록에서 선택한 신청서의 enter_seq 값을 받기
      enterlist_api:"http://ic.sportsdiary.co.kr/api/enter_player_manager/player_list.asp",// 입촌선수 목록 api
      playerlist:[],// 입촌선수 목록

      update_api:"http://ic.sportsdiary.co.kr/api/enter_player_manager/player_modify.asp",// modify_type = 1: 건강진단서, 2: 서약서, 3: 입촌 시작일, 4: 입촌 종료일

      manager_playerlist_api:"http://ic.sportsdiary.co.kr/api/enter_player_manager/manage_player_list.asp",// 입촌선수명단 관리 api
      addplayerlist_api:"http://ic.sportsdiary.co.kr/api/enter_player_manager/player_add.asp",// 선수명단에서 추가/삭제한 상태 업데이트 api(최소 1명 이상 남아 있을 때)
      removeplayerlist_api:"http://ic.sportsdiary.co.kr/api/enter_player_manager/player_del_all.asp",// 선수명단에서 전부 체크 풀어서 아무도 선택이 안되었을 때 api
      mngplayerlist:[],// 입촌선수관리 목록

      update_modify_api:"http://ic.sportsdiary.co.kr/api/enter_center_manager/enter_modify.asp",// 등록/수정

      delete_api:"http://ic.sportsdiary.co.kr/api/enter_center_manager/enter_del.asp",// 삭제

      newemptydata_api:"http://ic.sportsdiary.co.kr/api/enter_center_manager/enter_add.asp",// 신규등록 빈 데이터
      

      // selected
      enter_seq:null,// 기준값
      temp_modify:0,// 임시 저장 파일 유무
      association_seq:"",// 협회명seq,  1(대한장애인농구협회)
      association_name:"",// 협회명,  1(대한장애인농구협회)
      sports_code:"",// 운동종목, 농구(SP0023)
      sports_title:"",// 운동종목, 농구(SP0023)
      disabled_type_code:"",// 장애유형
      gender_code:"",// 성별
      train_type_code:"",// 훈련구분,   대관/훈련 목적
      applicant:"",// 신청자
      phone:"",// 연락처
      email:"",// 이메일
      filedata:"",// 
      sDate:"",// 시작일
      sHour:"",// 시작일 시
      sMin:"",// 시작일 분
      eDate:"",// 종료일
      eHour:"",// 종료일 시
      eMin:"",// 종료일 분
      enter_state:"",// 1:확인요청,  3:확인
      pagemove:false,// 저장/수정 하지 않고 페이지 이동하면 삭제시키려고. 신규등록 버튼 누르면 일단 빈 테이블이 db에 생겨서.

      fileseq:"",// 파일 업로드 후 fileseq 받음(입촌신청 등록에서)
      fileseq2:"",// 파일 업로드 후 fileseq 받음(입촌선수 목록에서)

      // 비교용
      c_disabled_type_code:"",//
      c_gender_code:"",//
      c_train_type_code:"",//
      c_applicant:"",//
      c_phone:"",//
      c_email:"",//
      c_filedata:"",//
      c_sDate:"",//
      c_sHour:"",//
      c_sMin:"",//
      c_eDate:"",//
      c_eHour:"",//
      c_eMin:"",//

      temp_save:false,// 입촌신청 내용 넣고, 선수등록 바로가기 버튼 누르면 true

      grouppledgefilename:"단체서약서를 첨부하세요",// 단체서약서 파일명

      errorcode:"",// 에러코드 ERR-130 : 리스트없음

      // 확인이 아닌거 보다가 내용 바뀌면.  등록 -> 수정, 삭제, 취소
      choicedata:false,

      // 팝업 보이기 여부
      deletepop:false,
      playerlistpop:false,

      // 팝업 선수 체크
      playerCheckAll:false,
      playerCheck:[],
      
      info_update:false,// 수정했나?
		},
    watch:{
      // 입촌선수 명단 팝업에서 전체 체크/해제
      playerCheckAll:function(){
        if(this.playerCheckAll){
          this.playerCheck=[];
          for(var i=0;i<this.mngplayerlist.player.length;i++){
            this.playerCheck.push(this.mngplayerlist.player[i].player_seq);
          }
        }else{
          if(this.playerCheck.length==this.mngplayerlist.player.length){
            this.playerCheck=[];
          }
        }
      },
      // 입촌선수 명단 팝업에서 체크
      playerCheck:function(){
        // if(this.mngplayerlist>0){
        if(this.mngplayerlist!=undefined){
          if(this.playerCheck.length==this.mngplayerlist.player.length){
            this.playerCheckAll=true;
          }else{
            this.playerCheckAll=false;
          }
        }
      },

      // 비교용
      disabled_type_code:function(newval,oldval){
        this.disabled_type_code=newval;
        this.c_disabled_type_code!=this.disabled_type_code ? this.info_update=true : this.info_update=false;
      },
      gender_code:function(newval,oldval){
        this.gender_code=newval;
        this.c_gender_code!=this.gender_code ? this.info_update=true : this.info_update=false;
      },
      train_type_code:function(newval,oldval){
        this.train_type_code=newval;
        this.c_train_type_code!=this.train_type_code ? this.info_update=true : this.info_update=false;
      },
      applicant:function(newval,oldval){
        this.applicant=newval;
        this.c_applicant!=this.applicant ? this.info_update=true : this.info_update=false;
      },
      phone:function(newval,oldval){
        this.phone=newval;
        this.c_phone!=this.phone ? this.info_update=true : this.info_update=false;
      },
      email:function(newval,oldval){
        this.email=newval;
        this.c_email!=this.email ? this.info_update=true : this.info_update=false;
      },
      filedata:function(newval,oldval){
        this.filedata=newval;
        this.c_filedata!=this.filedata? this.info_update=true: this.info_update=false;
      },
      sDate:function(newval,oldval){
        this.sDate=newval;
        this.c_sDate!=this.sDate ? this.info_update=true : this.info_update=false;
      },
      sHour:function(newval,oldval){
        this.sHour=newval;
        this.c_sHour!=this.sHour ? this.info_update=true : this.info_update=false;
      },
      sMin:function(newval,oldval){
        this.sMin=newval;
        this.c_sMin!=this.sMin ? this.info_update=true : this.info_update=false;
      },
      eDate:function(newval,oldval){
        this.eDate=newval;
        this.c_eDate!=this.eDate ? this.info_update=true : this.info_update=false;
      },
      eHour:function(newval,oldval){
        this.eHour=newval;
        this.c_eHour!=this.eHour ? this.info_update=true : this.info_update=false;
      },
      eMin:function(newval,oldval){
        this.eMin=newval;
        this.c_eMin!=this.eMin ? this.info_update=true :  this.info_update=false;
      },
    },
		methods:{
      // 파일 업로드
			uploadFile:function(file,state,enterplayerseq){
        // file : 업로드파일
        // state : 1-개인서약서, 2-단체서약서, 3-건강진단서
        // enterplayerseq : 첨부파일 수정하는 선수 값
        var _this=this;
        
        _this.filedata=file.files[0];
        var config={
          headers:{
            "Content-Type":"multipart/form-data"
          }
        }

        // 파일 올리고
        var fd=new FormData();
        fd.append("file_type", state);
        fd.append("file_data", _this.filedata);
        fd.append("user_id", nav.userid);
        axios.post(_this.upload_api, fd, config).then(function(response){
          if(response.data.state==="true"){
            // 2-단체서약서
            if(state===2){
              // 반환 받은 값에서 fileseq를 받아, 그 값으로 파일명 찾아오기
              _this.fileseq=response.data.fileSeq;
              _this.updateFileInfo();
            }
            // 1-개인 서약서, 3-건강진단서
            else{
              _this.fileseq2=response.data.fileSeq
              _this.updatePlayerInfo(state,enterplayerseq);
            }
          }
        });
      },
      // 업로드한 파일 정보(2-단체서약서)
      updateFileInfo:function(){
        var _this=this;
        axios.post(_this.upload_change_api,{
          enter_seq:_this.enter_seq,
          file_seq:_this.fileseq
        }).then(function(response){
          if(response.data.state==="true"){
            _this.grouppledgefilename=response.data.enter[0].agree_file;
          }
        })
      },
      // 업로드한 파일 정보(1-개인 서약서, 3-건강진단서)
      updatePlayerInfo:function(state,enterplayerseq,udate){
        // state : 33=입촌시작일, 44=입촌종료일의 값
        var _this=this;

        var mtype=state==3? 1 : state==2||state==1? 2 : state==33? 3 : state==44? 4 : null;

        // modify_type = 1: 건강진단서, 2: 서약서, 3: 입촌 시작일, 4: 입촌 종료일
        var data;
        if(mtype===1 || mtype===2){
          data={
            enter_player_seq:enterplayerseq,
            modify_type:mtype,
            modify_data:_this.fileseq2
          }
        }
        if(mtype===3 || mtype===4){
          data={
            enter_player_seq:enterplayerseq,
            modify_type:mtype,
            modify_data:udate
          }
        }
        axios.post(_this.update_api, data).then(function(response){
          if(response.data.state==="true"){
            // console.log(response.data);
            // 바뀐 데이터를 원래 목록데이터에 넣기
            _this.playerlist.filter(function(val,idx){
              if(val.enter_player_seq==response.data.player[0].enter_player_seq){
                if(mtype==1){// 건강진단서
                  val.medical_file=response.data.player[0].medical_file;
                  val.medical_file_path=response.data.player[0].medical_file_path;
                  val.medical_file_seq=response.data.player[0].medical_file_seq;
                  return;
                }
                if(mtype==2){// 서약서
                  val.agree_file=response.data.player[0].agree_file;
                  val.agree_file_path=response.data.player[0].agree_file_path;
                  val.agree_file_seq=response.data.player[0].agree_file_seq;
                  return;
                }
                if(mtype==3){// 입촌 시작일
                  val.sDate=response.data.player[0].sDate;
                  _this.info_update=true;
                  return;
                }
                if(mtype==4){// 입촌 종료일
                  val.eDate=response.data.player[0].eDate;
                  _this.info_update=true;
                }
              }
            });
          }
        });
      },

      // 등록/수정, 임시저장
      saveData:function(no){
        var _this=this;
        var moveurl="";
        
        // 등록/수정
        if(no==="0"){
          if(_this.disabled_type_code=="" || _this.gender_code=="" || _this.train_type_code=="" || _this.applicant=="" || _this.phone=="" || _this.email=="" || _this.fileseq=="" || _this.sDate=="" || _this.sHour=="" || _this.sMin=="" || _this.eDate=="" || _this.eHour=="" || _this.eMin==""){
            alert("모든 항목을 입력하십시오.");
            return;
          }

          // 수정된게 없으면 취소
          if(_this.choicedata && !_this.info_update){
            return;
          }

          // 입촌 선수가 한명도 없으면 안됨
          if(_this.playerlist.length==0){
            alert("입촌 선수가 있어야 합니다");
            return;
          }

          moveurl="/join_apply.asp";
        }
        // 임시저장
        else if(no==="1"){
          // 내용이 하나라도 있으면
          moveurl="/player_admit.asp";
          if(_this.info_update){
            _this.temp_save=true;
            var txt=confirm("작성내용을 임시저장 하시겠습니까?");
            if(txt){
              //
            }else{
              this.temp_save=false;
              axios.post(_this.delete_api,{
                enter_seq:_this.enter_seq
              }).then(function(response){
                if(response.data.state==="true"){
                  location.href=moveurl;
                }
              });
              return;
            }
          }
          // 없으면 data삭제 후 이동
          else{
            axios.post(_this.delete_api,{
              enter_seq:_this.enter_seq
            }).then(function(response){
              if(response.data.state==="true"){
                location.href=moveurl;
              }
            });
            return;
          }
        }

        axios.post(_this.update_modify_api,{
          enter_seq:_this.enter_seq,
          temp_modify:no,
          association_seq:_this.association_seq,
          association_name:nav.association_name,
          sports_code:_this.sports_code,
          disabled_type_code:_this.disabled_type_code,
          gender_code:_this.gender_code,
          train_type_code:_this.train_type_code,
          applicant:_this.applicant,
          phone:nav.addDash(_this.phone),
          email:_this.email,
          agree_file_seq:_this.fileseq,
          sDate:_this.sDate,
          sHour:_this.sHour,
          sMin:_this.sMin,
          eDate:_this.eDate,
          eHour:_this.eHour,
          eMin:_this.sMin
        }).then(function(response){
          if(response.data.state==="true"){
            _this.pagemove=true;
            location.href=moveurl;
          }
        });
      },

      // 삭제.  deletepop=true로 띄우고 확인 버튼
      deleteData:function(){
        var _this=this;
        _this.pagemove=true;
        axios.post(_this.delete_api,{
          enter_seq:_this.enter_seq
        }).then(function(response){
          if(response.data.state==="true"){
            location.href="/join_apply.asp";
          }
        });
      },

      // 입촌선수명단 관리 목록 팝업
      managePlayerPop:function(){
        var _this=this;
        
        // 기간 선택해야 함
        if(_this.sDate=="" || _this.eDate==""){
          alert("기간을 선택해주세요");
          return;
        }

        this.playerlistpop=true;
        axios.post(_this.manager_playerlist_api,{
          enter_seq:_this.enter_seq,
          sports_code:_this.sports_code
        }).then(function(response){
          if(response.data.state==="true"){
            _this.mngplayerlist=response.data;

            // 미리 선택된 사람은 표시하기
            _this.mngplayerlist.player.filter(function(val,idx){
              if(val.has_own==1){
                _this.playerCheck[idx]=val.player_seq;
              }
            });
            if(_this.playerCheck.length==_this.mngplayerlist.total){
              _this.playerCheckAll=true;
            }
          }else{
            if(response.data.errorcode==="ERR-130"){
              _this.errorcode="현재 목록이 없습니다.";
            }
          }
        });
      },
      // 입촌선수명단 관리 팝업에서 선택한 선수 목록
      checkPlayer:function(txt){
        var _this=this;
        this.playerlistpop=false;

        // 확인
        if(txt=="check"){
          // 선수가 최소 한 명 이상 있으면 몇명을 선택하든 선택한 수 만큼 입촌선수 목록에 나오게
          if(_this.playerCheck.length>0){
            axios.post(_this.addplayerlist_api,{
              enter_seq:_this.enter_seq,
              player_seqs:_this.playerCheck,
              sDate:_this.sDate,
              eDate:_this.eDate
            }).then(function(response){
              if(response.data.state==="true"){
                _this.playerlist=response.data.player;
                _this.playerCheck=[];// 초기화
                _this.info_update=true;// 비교용
              }
            });
          }
          // 선수를 전부 선택하지 않으면 입촌선수 목록에 있던 선수들 삭제
          else{
            axios.post(_this.removeplayerlist_api,{
              enter_seq:_this.enter_seq,
            }).then(function(response){
              if(response.data.state==="true"){
                _this.playerlist=[];
                _this.info_update=true;// 비교용
              }
            });
          }
        }
        
        // 취소
        if(txt=="reset"){
          setTimeout(function(){
            _this.playerCheck=[];// 초기화
          }, 200);
        }
      },

      // 신규등록 빈 데이터
      newEmptyData:function(){
        var _this=this;
        axios.post(_this.newemptydata_api,{}).then(function(response){
          if(response.data.state==="true"){
            _this.enter_seq=response.data.enter_seq;
            _this.delNewEmptyData();
          }
        });
      },

      // 목록 불러오기
      loadData:function(){
        var _this=this;

        // 기구 옵션 목록 불러오기
        var selectInfo=axios.post(_this.select_api,{
          step1:4,step2:2
        });

        // 입촌신청 - 입촌신청내역 조회의 목록에서 선택한 데이터 불러오기
        var selectData=axios.post(_this.enter_api,{
          enter_seq:_this.enter_seq
        });

        // 입촌선수 목록
        var playerData=axios.post(_this.enterlist_api,{
          enter_seq:_this.enter_seq
        });

        // 한 번에 불러오기
        axios.all([
          selectInfo,
          selectData,
          playerData
        ]).then(axios.spread(function(responseselect, resdata, resplayer){
          // 기구 옵션 목록 data
          if(responseselect.data.state==="true"){
            _this.selectinfo=responseselect.data;
          }

          // 입촌신청 - 입촌신청내역 조회의 목록에서 선택한 data
          if(resdata.data.state==="true"){
            // console.log(resdata.data.enter[0]);
            _this.disabled_type_code=resdata.data.enter[0].disabled_type_code;
            _this.gender_code=resdata.data.enter[0].gender_code;
            _this.train_type_code=resdata.data.enter[0].training_type_code;
            _this.applicant=resdata.data.enter[0].applicant_name;
            _this.phone=resdata.data.enter[0].phone;
            _this.email=resdata.data.enter[0].email;
            _this.grouppledgefilename=resdata.data.enter[0].agree_file==""? "단체서약서를 첨부하세요" : resdata.data.enter[0].agree_file;
            _this.fileseq=resdata.data.enter[0].agree_file_seq;
            _this.sDate=resdata.data.enter[0].sDate;
            _this.sHour=resdata.data.enter[0].sHour;
            _this.sMin=resdata.data.enter[0].sMinute;
            _this.eDate=resdata.data.enter[0].eDate;
            _this.eHour=resdata.data.enter[0].eHour;
            _this.eMin=resdata.data.enter[0].eMinute;
            _this.enter_state=resdata.data.enter[0].enter_state;
            // _this.sports_code=resdata.data.enter[0].sports_code;

            // 비교용
            _this.c_disabled_type_code=_this.disabled_type_code;//
            _this.c_gender_code=_this.gender_code;//
            _this.c_train_type_code=_this.train_type_code;//
            _this.c_applicant=_this.applicant;//
            _this.c_phone=_this.phone;//
            _this.c_email=_this.email;//
            _this.c_filedata=_this.filedata;//
            _this.c_sDate=_this.sDate;//
            _this.c_sHour=_this.sHour;//
            _this.c_sMin=_this.sMin;//
            _this.c_eDate=_this.eDate;//
            _this.c_eHour=_this.eHour;//
            _this.c_eMin=_this.eMin;//
            
            // 달력
            var calendars=document.querySelectorAll(".flatpickr");
            flatpickr(calendars,{
              locale:"ko",
            });
          }

          // 입촌선수 목록 data
          if(resplayer.data.state==="true"){
            _this.playerlist=resplayer.data.player;
            
            // 달력
            setTimeout(function(){
              var calendars=document.querySelectorAll(".l_list_tablewrap .flatpickr");
              flatpickr(calendars,{
                locale:"ko",
              });

              if(_this.disabled_type_code!="" && _this.gender_code!="" && _this.train_type_code!="" && _this.applicant!="" && _this.phone!="" && _this.email!="" && _this.fileseq!="" && _this.sDate!="" && _this.sHour!="" && _this.sMin!="" && _this.eDate!="" && _this.eHour!="" && _this.eMin!="" && _this.playerlist.length>0 && _this.enter_state==0){
                _this.info_update=true;
              }
            }, 100);
          }else{
            if(resplayer.data.errorcode==="ERR-130"){
              _this.errorcode="현재 목록이 없습니다.";
            }
          }
        })).catch(function(error){
          console.log("error : ");
          console.log(error);
        }).finally(function(){
          _this.association_seq=nav.association_seq;
          _this.association_name=nav.association_name;
          _this.sports_code=nav.sports_code;
          _this.sports_title=nav.sports_title;

          // 달력
          if(_this.sDate=="" && _this.eDate==""){
            setTimeout(function(){
              var calendars=document.querySelectorAll(".flatpickr");
              flatpickr(calendars,{
                locale:"ko",
              });
            }, 100);
          }
          
          _this.delNewEmptyData();
        });
      },

      // 화면 나갈 때 신규로 만들어진 db 삭제.... ..
      delNewEmptyData:function(){
        var _this=this;
        // firefox에서 확인창이 안뜨게 하면 beforeunload는 적용 안됨
        // window.addEventListener("beforeunload", function(e){
        //   if(!_this.pagemove && !_this.temp_save){
        //     axios.post(_this.delete_api,{enter_seq:_this.enter_seq});
        //     delete e["returnValue"];// 확인창 안뜸
        //   }
        // });
        // ie때문에
        document.onkeydown=function(e){
          if(e.keyCode===116){
            if(!_this.pagemove && !_this.temp_save){
              axios.post(_this.delete_api,{
                enter_seq:_this.enter_seq
              }).then(function(response){
                if(response.data.state==="true"){
                  location.reload();
                }
              });
              return false;
            }
          }
        };
        // firefox에서 확인창이 안뜨게 하면 beforeunload는 적용 안되서.. 페이지 이동 시
        setTimeout(function(){
          $("a").off().on({
            click:function(e){
              if(!_this.pagemove && !_this.temp_save){
                e.preventDefault();
                var thisda=$(this);
                axios.post(_this.delete_api,{
                  enter_seq:_this.enter_seq
                }).then(function(response){
                  if(response.data.state==="true"){
                    location.href=thisda.attr("href");
                  }
                });
              }
            }
          });
        },100);
      },

		},
		mounted:function(){
      this.loadData();
    },
		created:function(){
			// 현재 메뉴(위치) 확인
			eventBus.$emit("menuinfo");
      eventBus.$emit("menudrop", [4,2]);
      
      var _this=this;
      // 신규등록인지 수정인지 확인
      if(location.href.indexOf("enter_seq=")==-1){
        // 신규
        _this.pagemove=false;
        _this.newEmptyData();
        return;
      }else{
        // 수정
        _this.enter_seq=location.href.substr(location.href.indexOf("enter_seq=")+10);
        _this.choicedata=true;
        _this.pagemove=true;
      }
		}
	});
</script>
</body>
</html>