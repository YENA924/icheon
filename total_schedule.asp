<!--#include virtual="/include/header_fullcalendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct total_schedule" v-cloak>
	<div class="l_content">
		<!-- 컨텐츠 영역. s. -->
    <h2>통합일정조회</h2>
    
    <div class="l_list_tablewrap" v-bind:class="{l_cal: showview=='cal'}">
      <div class="l_month_area m_ibarea">
        <button class="l_month_btn l_prev" @click="changeMonth('prev')"><span class="img"><img src="/front/img/icon_cal_left.svg" alt="이전 월 보기"></span></button>
        <p class="l_show_month">{{year}}.{{month}}월 <span v-if="showcal=='week'">{{curweek}}주차</span></p>
        <button class="l_month_btn l_next" @click="changeMonth('next')"><span class="img"><img src="/front/img/icon_cal_right.svg" alt="다음 월 보기"></span></button>
      </div>
      <div class="l_schedule_btns m_ibarea s_right" v-if="groupcode=='ADMIN'">
        <button class="l_schedulebtn" v-bind:class="{s_on: showview=='cal'}" @click="viewChange('cal')">캘린더 보기</button>
        <button class="l_schedulebtn" v-bind:class="{s_on: showview=='list'}" @click="viewChange('list')">리스트 보기</button>
      </div>
      <div class="l_schedule_btns m_ibarea s_left" v-if="showview=='cal'">
        <button class="l_schedulebtn" v-bind:class="{s_on: showcal=='month'}" @click="viewChange('month')">월간</button>
        <button class="l_schedulebtn" v-bind:class="{s_on: showcal=='week'}" @click="viewChange('week')">주간</button>
      </div>

      <div v-if="showview=='list'">
        <table>
          <caption>입촌현황 목록</caption>
          <colgroup>
            <col style="width:4%;">
            <col style="width:16%;">
            <col style="width:10%;">
            <col style="width:4%;">
            <col style="width:10%;">
            <col style="width:11%;">
            <col style="width:9%;">
            <col style="width:15%;">
            <col style="width:7%;">
            <col style="width:7%;">
            <col style="width:7%;">
          </colgroup>
          <thead>
            <tr>
              <th scope="col"></th>
              <th scope="col">이용기간</th>
              <th scope="col">동관</th>
              <th scope="col">층</th>
              <th scope="col">시설명</th>
              <th scope="col">이용시간</th>
              <th scope="col">구분</th>
              <th scope="col">이용단체</th>
              <th scope="col">훈련구분</th>
              <th scope="col">대표자명</th>
              <th scope="col">이용인원</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="monthlist.length==0">
              <td colspan="12"><p class="m_no_list"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
            </tr>
            <tr v-if="monthlist.length>0" v-for="(list,key) in monthlist" :key="key">
              <td>{{(total+1)-Number(list.no)}}</td>
              <td>{{list.use_date}}</td>
              <td>{{list.quarter}}</td>
              <td>{{list.floor}}</td>
              <td>{{list.number}}</td>
              <td>{{list.times}}</td>
              <td>{{list.gubun}}</td>
              <td>{{list.association}}</td>
              <td>{{list.type_title}}</td>
              <td>{{list.name}}</td>
              <td>{{list.use_count}}명</td>
            </tr>
          </tbody>
        </table>
        <div v-if="monthlist.length>0" class="l_paging_area">
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

      <!-- 월간 -->
      <div class="l_calendar" v-if="showview=='cal' && showcal=='month'">
        <div id="l_calendar"></div>
      </div>

      <!-- 주간 -->
      <div class="l_calendar_week" v-if="showview=='cal' && showcal=='week'">
        <div id="l_calendar_week"></div>
      </div>

    </div>

		<!-- 컨텐츠 영역. e. -->
	</div>
</section>


<script>
	var cont=new Vue({
		el:"#icContent",
		data:{
      monthschedule_api:"http://ic.sportsdiary.co.kr/api/schedule_manager/schedule_month_list.asp",// 월별 일정 목록
      weekschedule_api:"http://ic.sportsdiary.co.kr/api/schedule_manager/schedule_week_list.asp",// 주별 일정 목록

      monthlist:[],// 월 목록
      weeklist:[],// 주 목록

      pageMax:null,// 최대 페이지 수
      pageCount:0,// 몇번째 5단위 page인가 확인용
      pageNo:0,//
      total:0,// 전체
      
      // selected
      seq:"",// 기준점
      groupcode:"",//
      dayinfo:"",// 해당 주의 일요일 날짜. new Date(dayinfo).getWeek()로 주 구하려고. 53주도 있음
      year:"",// 현재 연도
      month:"",// 현재 월
      oriyear:"",// 현재 연도ori
      orimonth:"",// 현재 월ori
      weeksunday:"",// 주의 처음. 일요일의 날짜
      day:"",// 현재 일
      week:"",// 현재 1년중 몇 주차
      curweek:"",// 선택한 달의 몇주차
      showview:"",// list, cal 
      showcal:"month",// month, week
      calendar:"",// 월간calendar
      calendarweek:"",// 주간calendar
      calendarlist:[],//
      caldatajsonok:false,// 다 불러왔나
		},
    watch:{
    },
		methods:{
      // 월간 리스트 조회
      searchData:function(){
        var _this=this;

        axios.post(_this.monthschedule_api,{
          month_date:_this.year+"-"+(Number(_this.month)<10?"0"+Number(_this.month):_this.month),
          page:_this.pageNo+1,
          pagesize:15
        }).then(function(response){
          if(response.data.state==="true"){
            _this.pageMax=Number(Math.ceil(response.data.total/15));// 15개 기준
            _this.monthlist=response.data.schedule;
            _this.total=Number(response.data.total);
          }else if(response.data.state==="false"){
            _this.pageMax=null;
            _this.pageCount=0;
            _this.pageNo=0;
            _this.monthlist=[];
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

      // 캘린더보기 or 리스트보기
      viewChange:function(txt){
        var _this=this;
        _this.dayinfo="";
        _this.weeksunday="";

        if(txt=="list"){
          _this.showview="list";
          _this.showcal="month";
          _this.pageNo=0;
          _this.searchData();
        }else if(txt=="cal"){
          _this.year=_this.oriyear;
          _this.month=_this.orimonth;
          // if(_this.calendar!="" && _this.calendar.getEventSourceById("caldata")!=null){
          if(_this.calendar!=""){
            // _this.calendar.getEventSourceById("caldata").remove();
            _this.calendar="";
          }
          _this.showview="cal";
          if(_this.showcal=="week" && _this.showview=="cal"){
            _this.year=_this.oriyear;
            _this.month=_this.orimonth;
            _this.week=new Date().getWeek();
          }
          _this.calData();
          _this.calDatajson();
        }else if(txt=="month"){
          _this.year=_this.oriyear;
          _this.month=_this.orimonth;
          _this.week=new Date().getWeek();
          
            // if(_this.calendar!="" && _this.calendar.getEventSourceById("caldata")!=null){
            if(_this.calendar!=""){
              // _this.calendar.getEventSourceById("caldata").remove();
              _this.calendar="";
            }
            _this.curweek="";
            _this.showview="cal";
            _this.showcal="month";
            _this.pageNo=0;
            _this.calData();
            _this.calDatajson();
        }else if(txt=="week"){
          var date=_this.oriyear+"-"+_this.orimonth+"-"+_this.day;
          _this.year=_this.oriyear;
          _this.month=_this.orimonth;
          _this.week=new Date().getWeek();
          
          // if(_this.calendarweek!="" && _this.calendarweek.getEventSourceById("caldata")!=null){
          if(_this.calendarweek!=""){
            // _this.calendarweek.getEventSourceById("caldata").remove();
            _this.calendarweek="";
          }
          _this.showcal="week";
          _this.calDataWeek();
          _this.calDatajson();
        }
      },

      // 캘린더용 json데이터
      calDatajson:function(){
        var _this=this;
        var schedulelist_api="";
        var postdata="";
        
        // 캘린더(월간) 보기 일 때
        if(_this.showview==="cal" && _this.showcal==="month"){
          schedulelist_api=_this.monthschedule_api;
          postdata={
            month_date:_this.year+"-"+(Number(_this.month)<10?"0"+Number(_this.month):_this.month),
            page:0
          }
          if(_this.calendar!="" && _this.caldatajsonok){
            if(_this.calendar.getEventSourceById("caldata")!=null){
              _this.calendar.getEventSourceById("caldata").remove();// 이벤트 소스 삭제할 땐 id로
            }
            _this.caldatajsonok=false;
          }
        }
        // 캘린더(주간) 보기 일 때
        else if(_this.showview==="cal" && _this.showcal==="week"){
          schedulelist_api=_this.weekschedule_api;
          postdata={
            year_date:_this.year,
            week_date:_this.week,
            page:0
          }
          if(_this.calendarweek!="" && _this.caldatajsonok){
            if(_this.calendarweek.getEventSourceById("caldata")!=null){
              _this.calendarweek.getEventSourceById("caldata").remove();// 이벤트 소스 삭제할 땐 id로
            }
            _this.caldatajsonok=false;
          }
        }

        axios.post(schedulelist_api, postdata).then(function(response){
          var list=_this.calendarlist;
          if(response.data.state==="true"){
            _this.monthlist=response.data.schedule;
            _this.calendarlist=[];
            _this.calendarlist.id="caldata";
            _this.monthlist.filter(function(val,idx){
              _this.calendarlist.push(
                {
                  title:val.gubun+"("+val.name+"-"+val.number+")",
                  start:"20"+(val.use_date.substr(0,8).replace(/[.]/gi,"-")),
                  end:"20"+(val.use_date.substr(11,8).replace(/[.]/gi,"-"))+"T23:59:00",
                }
              );
            });
          }else if(response.data.state==="false"){
            _this.monthlist=[];
            _this.calendarlist=[];
          }

          _this.caldatajsonok=true;
          if(_this.calendar!="" && _this.caldatajsonok){
            // 캘린더(월간) 보기 일 때
            if(_this.showview==="cal" && _this.showcal==="month"){
              _this.calendar.addEventSource(_this.calendarlist);
            }
          }
          if(_this.calendarweek!="" && _this.caldatajsonok){
            // 캘린더(주간) 보기 일 때
            if(_this.showview==="cal" && _this.showcal==="week"){
              _this.calendarweek.addEventSource(_this.calendarlist);
            }
          }
          
          // _this.calData();
        });
      },

      // 캘린더(주간)의 more 클릭 시. 색상 변환, '월/일'만 나오게
      changeCode:function(){
        var _this=this;
        // 훈련일 때 class 추가
        var odiv=document.querySelectorAll(".fc-title");
        for(var i=0;i<odiv.length;i++){
          if(odiv[i].innerHTML.indexOf("훈련(")>=0){
            odiv[i].parentNode.parentNode.classList.add("green");
          }
        }
        
        // 캘린더(월간) 보기 일 때
        if(_this.showview==="cal" && _this.showcal==="month"){
          // +more 클릭시
          var more=$(".fc-more");
          more.on({
            click:function(){
              // 훈련일 때 class 추가
              var odiv=document.querySelectorAll(".fc-title");
              for(var i=0;i<odiv.length;i++){
                if(odiv[i].innerHTML.indexOf("훈련(")>=0){
                  odiv[i].parentNode.parentNode.classList.add("green");
                }
              }

              // '일'만 나오게
              // document.querySelector(".fc-widget-header .fc-title").innerHTML=document.querySelector(".fc-widget-header .fc-title").innerHTML.substr(document.querySelector(".fc-widget-header .fc-title").innerHTML.indexOf("/")+1,2).replace(/[/]/,"");// 12/29/2019,   1/1/2020..인데 '일'만 나오게
              // '월/일'만 나오게
              if(document.querySelector(".fc-widget-header .fc-title").innerHTML.length>7){
                document.querySelector(".fc-widget-header .fc-title").innerHTML=document.querySelector(".fc-widget-header .fc-title").innerHTML.substr(0, document.querySelector(".fc-widget-header .fc-title").innerHTML.lastIndexOf("/"));// 12/29/2019,   1/1/2020..인데 '월/일'만 나오게
              }
            }
          });
        }
      },

      // 캘린더 목록(월간)
      calData:function(){
        var _this=this;
        setTimeout(function(){
          var calendardiv=document.getElementById("l_calendar");
          calendardiv.innerHTML="";
          _this.calendar=new FullCalendar.Calendar(calendardiv,{
            plugins:["dayGrid"],
            defaultView:"dayGridMonth",// default : dayGridMonth
            // dayNamesShort:["일","월","화","수","목","금","토"],// 아래로 바뀜
            columnHeaderText:function(date){
              if(date.getDay()===0){return "일";}
              else if(date.getDay()===1){return "월";}
              else if(date.getDay()===2){return "화";}
              else if(date.getDay()===3){return "수";}
              else if(date.getDay()===4){return "목";}
              else if(date.getDay()===5){return "금";}
              else if(date.getDay()===6){return "토";}
            },
            dayPopoverFormat:{
              year:"numeric", month:"numeric", day:"numeric", 
            },
            contentHeight:700,
            defaultDate:_this.year+"-"+(_this.month<10? '0'+_this.month: _this.month)+"-01",//"2019-11-15",
            eventLimit:true,
            eventLimitText:"건 더보기",
            eventSourceSuccess:function(cont,xhr){
              setTimeout(function(){
                _this.changeCode();
              },200);
            }
          });
          _this.calendar.render();
          _this.calendar.addEventSource(_this.calendarlist);
        },50);
      },

      // 캘린더 목록(주간)
      calDataWeek:function(){
        var _this=this;
        setTimeout(function(){
          var calendardivweek=document.getElementById("l_calendar_week");
          calendardivweek.innerHTML="";
          _this.calendarweek=new FullCalendar.Calendar(calendardivweek,{
            plugins:["dayGrid"],
            defaultView:"dayGridWeek",
            columnHeaderText:function(date){
              if(date.getDay()===0){return "일";}
              else if(date.getDay()===1){return "월";}
              else if(date.getDay()===2){return "화";}
              else if(date.getDay()===3){return "수";}
              else if(date.getDay()===4){return "목";}
              else if(date.getDay()===5){return "금";}
              else if(date.getDay()===6){return "토";}
            },
            contentHeight:700,
            defaultDate:_this.year+"-"+(_this.month<10? '0'+_this.month: _this.month)+"-"+(_this.day<10? '0'+_this.day: _this.day),//"2019-11-15",
            eventSourceSuccess:function(cont,xhr){
              setTimeout(function(){
                _this.dayinfo=$(".fc-day-header.fc-widget-header").eq(0).data("date");
                _this.weeksunday=new Date(_this.dayinfo);// 50ms 안기다리고 바로 다음 주 날짜 구하려고
                var dayinfos=_this.weekNumberByMonth(_this.dayinfo);
                if(_this.year!=dayinfos.year){
                  _this.year=dayinfos.year;
                }
                _this.month=dayinfos.month
                _this.curweek=dayinfos.weekNo;
              },50);
              setTimeout(function(){
                _this.changeCode();
                $(".fc-day-header.fc-widget-header").each(function(no,obj){
                  $(obj).append("<p class='l_weekday'>"+$(obj).data("date").substr(8)+"</p>");
                });
              },200);
            },
          });
          _this.calendarweek.render();
          _this.calendarweek.addEventSource(_this.calendarlist);
        },50);
      },

      // 캘린더 이동
      changeMonth:function(dir){
        var _this=this;
        var maxweek="";

        if(dir==="prev"){
          if(_this.showcal=="month"){
            _this.month=Number(_this.month)-1;
            if(_this.month<1){
              _this.year-=1;
              _this.month=12;
            }
            if(_this.month<10){
              _this.month="0"+_this.month;
            }
          }else if(_this.showcal=="week"){
            _this.calendarweek.prev();
            _this.weeksunday.setDate(_this.weeksunday.getDate()-7);
            maxweek=new Date(_this.weeksunday.getFullYear()+"-"+(_this.weeksunday.getMonth()+1)+"-"+_this.weeksunday.getDate()).getWeek()==53? 53 : 52;
            _this.week=Number(_this.week)-1;
            if(_this.week<=0){
              _this.week=maxweek;
              _this.month=12;
              _this.year-=1;
            }
            _this.calDatajson();
          }
        }
        if(dir==="next"){
          if(_this.showcal=="month"){
            _this.month=Number(_this.month)+1;
            if(_this.month>12){
              _this.year+=1;
              _this.month=1;
            }
            if(_this.month<10){
              _this.month="0"+_this.month;
            }
          }else if(_this.showcal=="week"){
            _this.calendarweek.next();
            _this.weeksunday.setDate(_this.weeksunday.getDate()+7);
            maxweek=new Date(_this.weeksunday.getFullYear()+"-"+(_this.weeksunday.getMonth()+1)+"-"+_this.weeksunday.getDate()).getWeek()==53? 53 : 52;
            _this.week=Number(_this.week)+1;
            if(_this.week>maxweek){
              _this.week=1;
              _this.month=1;
              _this.year+=1;
            }
            _this.calDatajson();
          }
        }

        // 리스트
        if(_this.showview==="list"){
          _this.pageNo=0;
          _this.searchData();
        }

        // 리스트, 달력(월간)
        if(_this.showview==="cal" && _this.showcal=="month"){
          if(dir==="prev"){
            _this.calendar.prev();
          }
          if(dir==="next"){
            _this.calendar.next();
          }
          _this.calDatajson();
        }
      },

      // 특정 날짜가 1년중 몇주차인지
      weekNumberByMonth:function(dateFormat){
        var inputDate=new Date(dateFormat);
      
        // 인풋의 년, 월
        var year=inputDate.getFullYear();
        var month=inputDate.getMonth()+1;
      
        var weekNumberByThurFnc=function(paramDate){
          var year=paramDate.getFullYear();
          var month2=paramDate.getMonth();
          var date=paramDate.getDate();
      
          // 인풋한 달의 첫 날과 마지막 날의 요일
          var firstDate=new Date(year, month2, 1);
          var lastDate=new Date(year, month2+1, 0);
          var firstDayOfWeek=firstDate.getDay();
          var lastDayOfweek=lastDate.getDay();

          // 인풋한 달의 마지막 일
          var lastDay=lastDate.getDate();
      
          // 첫 날의 요일이 목, 금, 토요일 이라면 true
          var firstWeekCheck=firstDayOfWeek===5 || firstDayOfWeek===6 || firstDayOfWeek===4;
          // 마지막 날의 요일이 일, 월, 화라면 true
          var lastWeekCheck=lastDayOfweek===1 || lastDayOfweek===2 || lastDayOfweek===0;
      
          // 해당 달이 총 몇주까지 있는지
          var lastWeekNo=Math.ceil((firstDayOfWeek+lastDay)/7);
      
          // 날짜 기준으로 몇주차 인지
          var weekNo1=Math.ceil((firstDayOfWeek+date)/7);

          // 인풋한 날짜가 첫 주에 있고 첫 날이 일, 월, 화로 시작한다면 'prev'(전달 마지막 주)
          if(weekNo1===1 && firstWeekCheck) weekNo1="prev";
          // 인풋한 날짜가 마지막 주에 있고 마지막 날이 일, 월, 화로 끝난다면 'next'(다음달 첫 주)
          else if(weekNo1===lastWeekNo && lastWeekCheck) weekNo1="next";
          // 인풋한 날짜의 첫 주는 아니지만 첫날이 목, 금, 토로 시작하면 -1;
          else if(firstWeekCheck) weekNo1=weekNo1-1;
      
          return weekNo1;
        };
      
        // 수요일 기준의 주차
        var weekNo=weekNumberByThurFnc(inputDate);
      
        // 이전달의 마지막 주차일 떄
        if(weekNo==="prev"){
          // 이전 달의 마지막날
          var afterDate=new Date(year, month-1, 0);
          year=month===1? year-1 : year;
          month=month===1? 12 : month-1;
          weekNo=weekNumberByThurFnc(afterDate);
        }
        // 다음달의 첫 주차일 때
        if(weekNo==="next"){
          year=month===12? year+1 : year;
          month=month===12? 1 : month+1;
          weekNo=1;
        }

        var ar={
          year:year, month:month, weekNo:weekNo
        }

        return ar;
      },

		},
		mounted:function(){
      this.searchData();
    },
		created:function(){
      // 오늘이 몇주차인지
      Date.prototype.getWeek=function(dowOffset){
        dowOffset=typeof(dowOffset) == "number" ? dowOffset : 0;
        var newYear=new Date(this.getFullYear(),0,1);
        var day=newYear.getDay()-dowOffset;
        day=(day>=0 ? day : day+7);
        var daynum=Math.floor((this.getTime()-newYear.getTime()-(this.getTimezoneOffset()-newYear.getTimezoneOffset())*60000)/86400000)+1;
        var weeknum;
        if(day<4){
          weeknum=Math.floor((daynum+day-1)/7)+1;
          if(weeknum>52){
            var nYear=new Date(this.getFullYear()+1,0,1);
            var nday=nYear.getDay()-dowOffset;
            nday=nday>=0 ? nday : nday+7;
            weeknum=nday<4 ? 1 : 53;
          }
        }else{
          weeknum=Math.floor((daynum+day-1)/7);
        }
        return weeknum;
      };
      
			// 현재 메뉴(위치) 확인
			eventBus.$emit("menuinfo");
			eventBus.$emit("menudrop", [3,1]);
      
      var day=new Date();
      this.oriyear=this.year=day.getFullYear();
      this.orimonth=this.month=day.getMonth()+1;
      this.day=day.getDate();
      this.week=new Date().getWeek();

      this.groupcode=sessionStorage.groupcode;
      this.groupcode=="ADMIN"? this.showview="list" : this.showview="cal";
      this.viewChange(this.showview);
		}
	});
</script>
</body>
</html>