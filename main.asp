<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct l_main" v-cloak>
	<div class="l_content">
		<!-- 컨텐츠 영역. s. -->
    <h2>공지사항</h2>
    <div class="l_list_tablewrap l_noticetable">
      <div class="l_search_btns l_titlenext" v-if="nav.groupCode==='ADMIN'">
        <a href="/notice.asp" class="l_btn s_white">공지사항 더보기</a>
      </div>
      <table>
        <caption>공지사항 목록</caption>
        <colgroup>
          <col style="width:5%">
          <col style="width:8%">
          <col style="width:12%">
          <col style="width:8%">
          <col style="width:33%">
          <col style="width:10%">
          <col style="width:7%">
          <col style="width:17%">
        </colgroup>
        <thead>
          <tr>
            <th scope="col"></th>
            <th scope="col">연도</th>
            <th scope="col">작성일</th>
            <th scope="col">구분</th>
            <th scope="col">제목</th>
            <th scope="col">작성자소속</th>
            <th scope="col">작성자</th>
            <th scope="col">첨부파일</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="noticelist.length==0">
            <!-- <td colspan="8">{{errorcode}}</td> -->
            <td colspan="8"><p class="m_no_list"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
          </tr>
          <tr class="m_cursor" v-for="(list,key) in noticelist" :key="key" @click="choiceNotice(key)">
            <td>{{list.num}}</td>
            <td>{{list.year}}</td>
            <td>{{list.regdate}}</td>
            <td v-bind:class="{s_warning:list.noticetype_title.indexOf('긴급')>-1}">{{list.noticetype_title}}</td>
            <td>{{list.title}}</td>
            <td>{{list.department}}</td>
            <td>{{list.username}}</td>
            <td>{{list.filename}}</td>
          </tr>
        </tbody>
      </table>
      <div v-if="noticelist.length>0" class="l_paging_area">
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

		<h2>Today's 시설이용현황</h2>
    <div class="l_list_tablewrap l_todaystable">
      <div class="l_search_btns l_titlenext">
        <a href="/total_schedule.asp" class="l_btn s_white">통합일정조회 바로가기</a>
      </div>
      <table>
        <caption>시설이용현황 목록</caption>
        <colgroup>
          <col style="width:5%;">
          <col style="width:8%;">
          <col style="width:8%;">
          <col style="width:5%;">
          <col style="width:8%;">
          <col style="width:10%;">
          <col style="width:5%;">
          <col style="width:16%;">
          <col style="width:14%;">
          <col style="width:7%;">
          <col style="width:7%;">
          <col style="width:7%;">
        </colgroup>
        <thead>
          <tr>
            <th></th>
            <th>이용일자</th>
            <th>동관</th>
            <th>층</th>
            <th>시설명</th>
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
          <tr v-if="todayslist.length==0 || todayslist.length==gongsillen">
            <!-- <td colspan="12">{{errorcode}}</td> -->
            <td colspan="12"><p class="m_no_list"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
          </tr>
          <tr v-if="todayslist.length>0 && list.use_type!='공실'" v-for="(list,key) in todayslist" :key="key">
            <td>{{list.no}}</td>
            <td>{{list.searchdate}}</td>
            <td>{{list.number}}</td>
            <td>{{list.floor}}</td>
            <td>{{list.quarter}}</td>
            <td>{{list.times}}</td>
            <td>{{list.gubun}}</td>
            <td>{{list.association}}</td>
            <td>{{list.use_date}}</td>
            <td>{{list.type_title}}</td>
            <td>{{list.name}}</td>
            <td>{{list.use_count}}</td>
          </tr>
        </tbody>
      </table>
    </div>

    
    <!-- 팝업 -->
    <transition name="fade">
      <div class="l_popup_bg" v-if="showpop">
        <div class="l_popup_area">
          <p class="l_popup_title">공지사항</p>
          <div class="lpop_detail_area">
            <div class="lpop_line m_ibarea">
              <p class="lpop_title">게시구분</p>
              <p class="lpop_txt" v-bind:class="{s_warning:noticetype_title.indexOf('긴급')>-1}">{{noticetype_title}}</p>
              <p class="lpop_title">게시일자</p>
              <p class="lpop_txt">{{regdate}}</p>
            </div>
            <div class="lpop_line m_ibarea">
              <p class="lpop_title">작성자 소속</p>
              <p class="lpop_txt">{{department}}</p>
              <p class="lpop_title">작성자</p>
              <p class="lpop_txt">{{username}}</p>
            </div>
            <div class="lpop_line m_ibarea">
              <p class="lpop_title">첨부파일</p>
              <button class="lpop_txt l_down" v-if="filename!=''" @click="nav.downloadFile(fileuri)">{{filename}}</button>
              <p class="lpop_txt" v-if="filename==''">없음</p>
            </div>
            <div class="lpop_line m_ibarea">
              <p class="lpop_title">제목</p>
              <p class="lpop_txt l_long">{{title}}</p>
            </div>
            <div class="lpop_line m_ibarea">
              <p class="lpop_title">내용</p>
              <div class="lpop_txt l_box">
                <textarea class="l_boxtxt" readonly>{{contents}}</textarea>
              </div>
            </div>
          </div>
          <div class="l_search_btns">
            <button class="l_btn s_blue" @click="init">확 인</button>
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
      noticelist_api:"http://ic.sportsdiary.co.kr/api/notice_manager/notice_list.asp",// 공지사항 api
      todayslist_api:"http://ic.sportsdiary.co.kr/api/facility_manager/facility_use_list.asp",// 시설이용현황 api

      noticelist:[],// 공지사항 목록
      todayslist:[],// today's 시설이용현황 목록
      gongsillen:0,// today's 시설이용현황의 목록 수와 해당 시설의 '공실'수가 같으면 검색 결과 없게

      pageMax:null,// 최대 페이지 수
      pageCount:0,// 몇번째 5단위 page인가 확인용
      pageNo:0,// 현재 페이지수

      errorcode:"",//s
      curdate:"",// 오늘날짜
      noticetype_title:"",// 게시구분
      regdate:"",// 게시일자
      department:"",// 작성자 소속
      username:"",// 작성자
      filename:"",// 첨부파일명
      fileuri:"",// 첨부파일 경로
      title:"",// 제목
      contents:"",// 내용

      // 팝업 보이기 여부
      showpop:false,
    },
    methods:{
      // 공지사항 목록
      noticeList:function(){
        var _this=this;
        axios.post(_this.noticelist_api,{
          page:_this.pageNo+1,
          pagesize:5
        }).then(function(response){
          if(response.data.state==="true"){
            _this.pageMax=Number(Math.ceil(response.data.total/5));// 5개 기준
            _this.noticelist=response.data.notice;
          }else{
            if(response.data.errorcode==="ERR-130"){
              _this.errorcode="현재 목록이 없습니다.";
            }
          }
        });
      },

      // 선택한 공지사항 보기
      choiceNotice:function(idx){
        this.showpop=true;
        this.noticetype_title=this.noticelist[idx].noticetype_title;// 게시구분
        this.regdate=this.noticelist[idx].regdate;// 게시일자
        this.department=this.noticelist[idx].department;// 작성자 소속
        this.username=this.noticelist[idx].username;// 작성자
        this.filename=this.noticelist[idx].filename;// 첨부파일명
        this.fileuri=this.noticelist[idx].fileuri;// 첨부파일 경로
        this.title=this.noticelist[idx].title;// 제목
        this.contents=this.noticelist[idx].contents.replace(/(<br>|<br\/>|<br \/>)/g, '\r\n');// 내용
      },
      //
      init:function(){
        this.showpop=false;
        this.noticetype_title="";
        this.regdate="";
        this.department="";
        this.username="";
        this.filename="";
        this.fileuri="";
        this.title="";
        this.contents="";
      },

      // today's 시설이용현황 목록
      todaysList:function(){
        var _this=this;
        axios.post(_this.todayslist_api,{
          usedate:_this.curdate
        }).then(function(response){
          if(response.data.state==="true"){
            _this.pageMax2=Number(Math.ceil(response.data.total/5));// 5개 기준
            _this.todayslist=response.data.facility;
            _this.todayslist.filter(function(val,idx){
              if(val.use_type=="공실"){
                _this.gongsillen+=1;
              }
            });
          }else{
            if(response.data.errorcode==="ERR-130"){
              _this.errorcode="현재 목록이 없습니다.";
            }
          }
        });
      },

      // 공지사항 페이징
      pageMove:function(idx){
        var _this=this;
        _this.pageNo=idx;
        _this.noticeList();
      },
      pageJump:function(cnt){
        var _this=this;
        _this.pageNo=cnt*5;
        if(cnt<=-1){
          _this.pageNo=0;
          _this.noticeList();
          return;
        }
        if(_this.pageNo>_this.pageMax-1){
          _this.pageNo=_this.pageMax-1;
          _this.noticeList();
          return;
        }
        _this.pageCount=cnt;
        _this.noticeList();
      },
    },
		mounted:function(){
      this.noticeList();
      this.todaysList();
    },
		created:function(){
			// 현재 메뉴(위치) 확인
			eventBus.$emit("menuinfo");
      eventBus.$emit("menudrop", [1,0]);
      
      this.curdate=new Date().getFullYear()+"-"+(new Date().getMonth()+1)+"-"+new Date().getDate();
		}
	});
</script>
</body>
</html>