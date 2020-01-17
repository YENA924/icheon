<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct join_comfirm join_ing" v-cloak>
	<div class="l_content">
		<!-- 컨텐츠 영역. s. -->
    <h2>선수단 입촌현황</h2>
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
        <button class="l_btn s_white" @click="pageNo=0;searchData();">조 회</button>
      </div>
    </div>
    
    <div class="l_list_tablewrap">
      <table>
        <caption>입촌현황 목록</caption>
        <colgroup>
          <col style="width:3%;">
          <col style="width:8%;">
          <col style="width:6%;">
          <col style="width:5%;">
          <col style="width:9%;">
          <col style="width:4%;">
          <col style="width:7%;">
          <col style="width:6%;">
          <col style="width:7%;">
          <col style="width:7%;">
          <col style="width:7%;">
          <col style="width:6%;">
          <col style="width:11%;">
          <col style="width:7%;">
          <col style="width:7%;">
        </colgroup>
        <thead>
          <tr>
            <th scope="col">번호</th>
            <th scope="col">종목</th>
            <th scope="col">선수번호</th>
            <th scope="col">성명</th>
            <th scope="col">성명(영문)</th>
            <th scope="col">성별</th>
            <th scope="col">생년월일</th>
            <th scope="col">직위</th>
            <th scope="col">선수구분</th>
            <th scope="col">장애여부</th>
            <th scope="col">장애유형</th>
            <th scope="col">경기등급</th>
            <th scope="col">소속</th>
            <th scope="col">입촌시작</th>
            <th scope="col">입촌종료</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="searchlist.length==0">
            <!-- <td colspan="15">{{errorcode}}</td> -->
            <td colspan="15"><p class="m_no_list"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
          </tr>
          <tr v-if="searchlist.length>0" v-for="(list,key) in searchlist" :key="key">
            <td>{{list.reverse_Idx}}</td>
            <td>{{list.sports_title}}</td>
            <td>{{list.code}}</td>
            <td>{{list.name}}</td>
            <td>{{list.en_name}}</td>
            <td>{{list.gender}}</td>
            <td>{{nav.addBirthDot(list.birthDay)}}</td>
            <td>{{list.position}}</td>
            <td>{{list.player_type}}</td>
            <td>{{list.disabled_state}}</td>
            <td>{{list.disabled_type}}</td>
            <td>{{list.game_grade}}</td>
            <td>{{list.area}}</td>
            <td>{{list.sDate}}</td>
            <td>{{list.eDate}}</td>
          </tr>
        </tbody>
      </table>
      <div v-if="searchlist.length>0" class="l_paging_area">
        <button class="l_page l_prev" @click="pageJump(pageCount-1)"><span class="img"><img src="/front/img/icon_prevpage.svg" alt="이전 목록으로"></span></button>
        <div v-if="pageMax<=5">
          <button v-for="(page,key) in pageMax" :key="key" class="l_paging" v-bind:class="{s_on:key==pageNo}" @click="pageMove(key)">{{page}}</button>
        </div>
        <div v-else>
          <button v-for="(page,key) in 5" :key="key+(5*pageCount)" v-if="(key+(5*pageCount))<pageMax" class="l_paging" v-bind:class="{s_on:key+(5*pageCount)==pageNo}" @click="pageMove(key+(5*pageCount))">{{page+(5*pageCount)}}</button>
        </div>
        <button class="l_page l_next" @click="pageJump(pageCount+1)"><span class="img"><img src="/front/img/icon_nextpage.svg" alt="다음 목록으로"></span></button>
      </div>
	  </div>
  
		<!-- 컨텐츠 영역. e. -->
	</div>
</section>


<script>
	var cont=new Vue({
		el:"#icContent",
		data:{
      joining_api:"http://ic.sportsdiary.co.kr/api/enter_center_manager/enter_list_current.asp",// 목록 조회

      searchlist:[],// 검색 목록

      pageMax:null,// 최대 페이지 수
      pageCount:0,// 몇번째 5단위 page인가 확인용
      pageNo:0,//
      
      // selected
      sDate:"",// 시작일
      eDate:"",// 종료일
      sports:"",// 종목

      errorcode:"현재 목록이 없습니다.",
		},
		methods:{
      // 목록 조회
      searchData:function(){
        var _this=this;

        axios.post(_this.joining_api,{
          sports_code:_this.sports,
          page_num:_this.pageNo+1,
          page_per_cnt:20,
          sDate:_this.sDate,
          eDate:_this.eDate
        }).then(function(response){
          if(response.data.state==="true"){
            _this.pageMax=Number(response.data.max_page);
            _this.searchlist=response.data.player;
          }else if(response.data.state==="false"){
            _this.pageMax=null;
            _this.pageCount=0;
            _this.pageNo=0;
            _this.searchlist=[];
            if(response.data.errorcode==="ERR-130"){
              _this.errorcode="현재 목록이 없습니다.";
            }
          }
        });
      },

      // 페이징
      pageMove:function(idx){
        var _this=this;
        _this.pageNo=idx;
        _this.searchData();
      },
      pageJump:function(cnt){
        var _this=this;
        _this.pageNo=cnt*5;
        if(cnt<=-1){
          _this.pageNo=0;
          _this.searchData();
          return;
        }
        if(_this.pageNo>_this.pageMax-1){
          _this.pageNo=_this.pageMax-1;
          _this.searchData();
          return;
        }
        _this.pageCount=cnt;
        _this.searchData();
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
			eventBus.$emit("menudrop", [4,4]);
		}
	});
</script>
</body>
</html>