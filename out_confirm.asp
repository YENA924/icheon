<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct out_confirm" v-cloak>
	<div class="l_content">
		<!-- 컨텐츠 영역. s. -->
    <h2>퇴촌처리</h2>
    <div class="l_list_searchbox m_ibarea">
      <p class="l_labeltxt">기간선택</p>
      <div class="l_field">
        <input class="flatpickr" placeholder="시작일을 선택하세요" title="시작일 선택" v-model="sDate"></input>
        <div class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></div>
      </div>
      <span class="l_wave">~</span>
      <div class="l_field">
        <input class="flatpickr" placeholder="종료일을 선택하세요" title="종료일 선택" v-model="eDate"></input>
        <div class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></div>
      </div>
      <label for="choicesports" class="l_labeltxt">종목선택</label>
      <div class="l_selectwrap">
        <select id="choicesports" v-model="sports">
          <option value="">종목 전체</option>
          <option v-for="(option,key) in nav.sportslist" :key="key" :value="option.seq">{{option.title}}</option>
        </select>
      </div>
      <div class="l_search_btns">
        <button class="l_btn s_white" @click="searchData">조 회</button>
      </div>
    </div>

    <div class="l_list_tablewrap m_tbodyscroll l_outlist">
      <table>
        <caption>퇴촌할 대상 목록</caption>
        <thead>
          <tr>
            <th scope="col">번호</th>
            <th scope="col">소속단체명</th>
            <th scope="col">종목</th>
            <th scope="col">성별</th>
            <th scope="col">훈련구분</th>
            <th scope="col">장애유형</th>
            <th scope="col">입촌기간</th>
            <th scope="col">대표자명</th>
            <th scope="col">연락처</th>
            <th scope="col">이메일</th>
            <th scope="col">입촌인원</th>
          </tr>
        </thead>
        <tbody>
          <tr style="width:100%;display:table;" v-if="searchlist.length==0">
            <td colspan="11"><p class="m_no_list" style="height:15rem;line-height:15rem;"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
          </tr>
          <tr class="m_cursor" v-bind:class="{l_choice:choice==key}" v-if="searchlist.length>=0" v-for="(list,key) in searchlist" :key="key" @click="outList(list.enter_seq, key)">
            <td>{{list.Idx}}</td>
            <td>{{list.association}}</td>
            <td>{{list.sports}}</td>
            <td>{{list.gender}}</td>
            <td>{{list.training_type}}</td>
            <td>{{list.disabled_type}}</td>
            <td>{{list.enter_period}}</td>
            <td>{{list.applicant_name}}</td>
            <td>{{list.phone}}</td>
            <td>{{list.email}}</td>
            <td>{{list.player_cnt}}</td>
          </tr>
        </tbody>
      </table>
    </div>
    
    <div class="l_searchresult_topinfo">
      <div class="l_search_btns">
        <button class="l_btn s_blue" @click="outpop=true">퇴 촌</button>
      </div>
      <div class="l_searchresult_staffinfo">
        <p class="l_infotxt">감독</p>
        <p class="l_infodata">{{outplayer.cnt_leader==undefined? 0 : outplayer.cnt_leader}}</p>
        <p class="l_infotxt">코치</p>
        <p class="l_infodata">{{outplayer.cnt_coach==undefined? 0 : outplayer.cnt_coach}}</p>
        <p class="l_infotxt">트레이너</p>
        <p class="l_infodata">{{outplayer.cnt_trainer==undefined? 0 : outplayer.cnt_trainer}}</p>
        <p class="l_infotxt">선수</p>
        <p class="l_infodata">{{outplayer.cnt_player==undefined? 0 : outplayer.cnt_player}}</p>
        <p class="l_infotxt">총인원</p>
        <p class="l_infodata">{{outplayer.cnt_player==undefined? 0 : Number(outplayer.cnt_leader)+Number(outplayer.cnt_coach)+Number(outplayer.cnt_trainer)+Number(outplayer.cnt_player)}}</p>
      </div>
    </div>
    <div class="l_list_tablewrap m_tbodyscroll l_outsearch">
      <table>
        <caption>검색 된 퇴촌 목록</caption>
        <thead>
          <tr>
            <th scope="col">
              <div class="l_checkbox">
                <input type="checkbox" id="outPlayerCheckAll" v-model="outPlayerCheckAll">
                <label for="outPlayerCheckAll">전체 선택</label>
              </div>
            </th>
            <th scope="col">번호</th>
            <th scope="col">침대</th>
            <th scope="col">종목</th>
            <th scope="col">선수번호</th>
            <th scope="col">성명</th>
            <th scope="col">성명(영문)</th>
            <th scope="col">성별</th>
            <th scope="col">생년월일</th>
            <th scope="col">직위</th>
            <th scope="col">선수구분</th>
            <th scope="col">장애유형</th>
            <th scope="col">경기등급</th>
            <th scope="col">소속</th>
            <th scope="col">입촌시작</th>
            <th scope="col">입촌종료</th>
          </tr>
        </thead>
        <tbody>
          <tr style="width:100%;display:table;" v-if="outplayer.length==0">
            <td colspan="16"><p class="m_no_list" style="height:15rem;line-height:15rem;"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
          </tr>
          <tr v-for="(list,key) in outplayer.player" :key="key">
            <td>
              <div class="l_checkbox">
                <input type="checkbox" :id="'outPlayerCheck'+key" :value="list.enter_player_seq" v-model="outPlayerCheck">
                <label :for="'outPlayerCheck'+key">선수번호 {{list.player_code}} {{list.name}} 선택</label>
              </div>
            </td>
            <td><label :for="'outPlayerCheck'+key">{{list.room_no}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.bed_type}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.sports}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.player_code}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.name}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.name_en}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.gender}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.birthday}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.player_position}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.player_type}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.disabled_type}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.disabled_grade}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.player_area}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.sDate}}</label></td>
            <td><label :for="'outPlayerCheck'+key">{{list.eDate}}</label></td>
          </tr>
        </tbody>
      </table>
    </div>
    
    
    <!-- 팝업 -->
    <transition name="fade">
      <div class="l_popup_bg" v-if="outpop">
        <div class="l_popup_area">
          <p class="l_popup_title">퇴촌 시키겠습니까?</p>
          <p class="l_popup_cmt">확인을 누르시면 퇴촌 처리됩니다.</p>
          <div class="l_search_btns">
            <button class="l_btn s_blue" @click="outData">확 인</button>
            <button class="l_btn s_white" @click="outpop=false">취 소</button>
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
      out_api:"http://ic.sportsdiary.co.kr/api/enter_center_manager/out_center_list.asp",// 퇴촌 목록 api
      outcheck_api:"http://ic.sportsdiary.co.kr/api/enter_player_manager/player_list_out.asp",// 퇴촌 목록에서 선택하여 퇴촌대상이 나오는 api
      removecheck_api:"http://ic.sportsdiary.co.kr/api/enter_player_manager/set_player_out.asp",// 선택한 대상 퇴촌
      
      searchlist:[],// 검색 목록
      outplayer:[],// 퇴촌 선수 목록

      enter_seq:"",// 기준값

      // selected
      sDate:"",// 시작일
      eDate:"",// 종료일
      sports:"",// 종목

      choice:-1,// 선택 표시

      // 퇴촌 선수 체크
      outPlayerCheckAll:false,
      outPlayerCheck:[],

      outpop:false,// 팝업
		},
    watch:{
      // 퇴촌선수 명단에서 전체 체크/해제
      outPlayerCheckAll:function(){
        if(this.outPlayerCheckAll){
          this.outPlayerCheck=[];
          for(var i=0;i<this.outplayer.player.length;i++){
            this.outPlayerCheck.push(this.outplayer.player[i].enter_player_seq);
          }
        }else{
          if(this.outplayer.player!=undefined){
            if(this.outPlayerCheck.length==this.outplayer.player.length){
              this.outPlayerCheck=[];
            }
          }
        }
      },
      // 퇴촌선수 명단에서 체크
      outPlayerCheck:function(){
        if(this.outplayer.player!=undefined){
          if(this.outPlayerCheck.length==this.outplayer.player.length){
            this.outPlayerCheckAll=true;
          }else{
            this.outPlayerCheckAll=false;
          }
        }
      },
    },
		methods:{
      // 목록 조회
      searchData:function(){
        var _this=this;
        axios.post(_this.out_api,{
          sports_code:_this.sports,
          sDate:_this.sDate,
          eDate:_this.eDate
        }).then(function(response){
          if(response.data.state==="true"){
            _this.searchlist=response.data.enter_list;
          }else if(response.data.state==="false"){
            _this.searchlist=[];
            _this.outplayer=[];
          }
        });
      },

      // 조회에서 나온 목록 선택 시 퇴촌 목록 생성
      outList:function(enterseq,key){
        var _this=this;
        _this.outPlayerCheckAll=false;
        _this.enter_seq=enterseq;
        axios.post(_this.outcheck_api,{
          enter_seq:_this.enter_seq
        }).then(function(response){
          if(response.data.state==="true"){
            _this.outplayer=response.data;
            _this.choice=key;
          }else if(response.data.state==="false"){
            _this.outplayer=[];
            _this.choice=-1;
          }
        });
      },

      // 선택한 목록 퇴촌
      outData:function(){
        var _this=this;

        if(_this.outPlayerCheck.length==0){
          alert("퇴촌할 선수를 선택하세요");
          _this.outpop=false;
          return;
        }

        axios.post(_this.removecheck_api,{
          enter_seq:_this.enter_seq,
          enter_player_seqs:_this.outPlayerCheck
        }).then(function(response){
          if(response.data.state==="true"){
            _this.outplayer=[];
            _this.outPlayerCheck=[];
            _this.outPlayerCheckAll=false;
            _this.outplayer=response.data;
            _this.searchData();
            _this.outpop=false;
          }else if(response.data.state==="false"){
            _this.outplayer=[];
            _this.searchData();
            _this.outpop=false;
          }
        });
      },

		},
		mounted:function(){
      var calendars=document.querySelectorAll(".flatpickr");
      flatpickr(calendars,{
        locale:"ko",
      });

      this.searchData();
    },
		created:function(){
			// 현재 메뉴(위치) 확인
			eventBus.$emit("menuinfo");
			eventBus.$emit("menudrop", [4,5]);
		}
	});
</script>
</body>
</html>