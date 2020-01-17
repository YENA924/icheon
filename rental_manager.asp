<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct rental_manager" v-cloak>
	<div class="l_content">
		<!-- 컨텐츠 영역. s. -->
    <h2>대관신청 및 내역관리</h2>
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
      <label for="rentaltype" class="l_labeltxt">구분선택</label>
      <div class="l_selectwrap">
        <select id="rentaltype" v-model="rentaltypelist_seq" @change="searchData">
          <option value="">전체</option>
          <option v-for="(option,key) in selectinfo" :key="key" :value="option.seq">{{option.title}}</option>
        </select>
      </div>
      <div class="l_search_btns" v-if="nav.groupCode!=='ADMIN'">
        <button class="l_btn s_blue" @click="rentalPop(true)">대관 신청하기</button>
      </div>
    </div>

    <div class="l_list_tablewrap">
      <table>
        <caption>입촌현황 목록</caption>
        <colgroup>
          <col style="width:4%;">
          <col style="width:8%;">
          <col style="width:10%;">
          <col style="width:8%;">
          <col style="width:14%;">
          <col style="width:8%;">
          <col style="width:11%;">
          <col style="width:13%;">
          <col style="width:14%;">
          <col style="width:4%;">
          <col style="width:6%;">
        </colgroup>
        <thead>
          <tr>
            <th scope="col">번호</th>
            <th scope="col">신청상태</th>
            <th scope="col">신청일</th>
            <th scope="col">대관구분</th>
            <th scope="col">대관단체명</th>
            <th scope="col">대표자명</th>
            <th scope="col">연락처</th>
            <th scope="col">대관기간</th>
            <th scope="col">대관시설(프로그램명)</th>
            <th scope="col">총인원</th>
            <th scope="col">휠체어<br>이용인원</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="searchlist.length==0">
            <td colspan="11"><p class="m_no_list"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
          </tr>
          <tr class="m_cursor" v-for="(list,key) in searchlist" :key="key" @click="updateData(list.seq)">
            <td>{{Number(totallist+1)-Number(list.no)}}</td>
            <td v-bind:class="{s_orange_txt2:list.state=='600' && nav.groupCode=='ADMIN' || list.state=='603' && nav.groupCode=='ASSOCIATION' || list.state=='604' && nav.groupCode=='ASSOCIATION' || list.state=='605' && nav.groupCode=='ADMIN', s_blue_txt2:list.state=='600' && nav.groupCode=='ASSOCIATION'}">{{list.state=="600"?nav.groupCode=="ADMIN"?"승인요청":"승인대기":list.state=="601"?"신청취소":list.state=="602"?nav.groupCode=="ADMIN"?"승인완료":"승인":list.state=="603"?"반려":list.state=="604"?"승인취소":list.state=="605"?"신청취소":""}}</td>
            <td>{{list.applydate}}</td>
            <td>{{list.rentaltype}}</td>
            <td>{{list.association}}</td>
            <td>{{list.name}}</td>
            <td>{{list.phone}}</td>
            <td>{{list.rentaldate}}</td>
            <td>{{list.number}}</td>
            <td>{{list.user_count}}</td>
            <td>{{list.machine_count}}</td>
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


    <transition name="fade">
      <div class="l_popup_bg" v-if="rentalpop">
        <div class="l_popup_area l_rental m_ibarea">
          <div class="l_rentalpop_linfo">
            <p class="l_popup_title">대관 신청하기</p>
            <p class="l_pop_cmt" v-if="rentaltype_seq=='RT0001'">*샤워시설 2,000원, 음향기기 50,000원, 숙소 2인실 40,000원(1일 기준)</p>
            <div class="l_rentalpop_infoarea m_ibarea">
              <div class="l_rentalpop_linfo_l">
                <div class="l_field">
                  <label for="rentaltype_pop">대관구분</label>
                  <select id="rentaltype_pop" v-model="rentaltype_seq" @change="init();calinit();">
                    <option v-for="(option,key) in selectinfo" :key="key" :value="option.seq">{{option.title}}</option>
                  </select>
                </div>
                <div class="l_field">
                  <label for="association">대관단체명</label>
                  <input type="text" id="association" placeholder="단체명을 입력하세요" v-model="association">
                </div>
                <div class="l_field">
                  <label for="phone">연락처</label>
                  <input type="text" id="phone" maxlength="13" placeholder="000-0000-0000" v-model="phone" v-on:input="phone=nav.addDash($event.target.value)">
                </div>
                <div class="l_field" v-if="rentaltype_seq=='RT0002'">
                  <label for="program_seq">프로그램 선택</label>
                  <select id="program_seq" v-model="program_seq">
                    <option value="">프로그램을 선택하세요</option>
                    <option v-for="(option,key) in programlist" :key="key" :value="option.seq">{{option.title}}</option>
                  </select>
                </div>
                <div class="l_field" v-if="rentaltype_seq!='RT0002'">
                  <label for="number">시설 선택</label>
                  <select id="number" v-model="number">
                    <option value="">대관시설을 선택하세요</option>
                    <option v-for="(option,key) in rentalfacility" :key="key" :value="option.seq">{{option.number}} - {{nav.addComma(option.price)}}원</option>
                  </select>
                </div>
                <div class="l_field" v-if="rentaltype_seq!='RT0002'">
                  <p>숙소</p>
                  <div class="l_radio">
                    <input type="radio" class="l_radio" id="lodging1" name="lodging" value="1" v-model="lodging">
                    <label for="lodging1">사용</label>
                  </div>
                  <div class="l_radio">
                    <input type="radio" class="l_radio" id="lodging2" name="lodging" value="0" v-model="lodging">
                    <label for="lodging2">사용안함</label>
                  </div>
                </div>
                <div class="l_field" v-if="rentaltype_seq!='RT0002'">
                  <p>샤워시설</p>
                  <div class="l_radio">
                    <input type="radio" class="l_radio" id="shower1" name="shower" value="1" v-model="shower">
                    <label for="shower1">사용</label>
                  </div>
                  <div class="l_radio">
                    <input type="radio" class="l_radio" id="shower2" name="shower" value="0" v-model="shower">
                    <label for="shower2">사용안함</label>
                  </div>
                </div>
                <div class="l_field" v-if="rentaltype_seq!='RT0002'">
                  <p>음향기기</p>
                  <div class="l_radio">
                    <input type="radio" class="l_radio" id="sound1" name="sound" value="1" v-model="sound">
                    <label for="sound1">사용</label>
                  </div>
                  <div class="l_radio">
                    <input type="radio" class="l_radio" id="sound2" name="sound" value="0" v-model="sound">
                    <label for="sound2">사용안함</label>
                  </div>
                </div>
                <div class="l_field l_short" v-if="rentaltype_seq!='RT0002'">
                  <label for="total_price">총납부금액</label>
                  <input type="text" id="total_price" class="l_bluetxt m_nochange l_orangetxt" placeholder="0" v-model="total_price">
                  <span>원</span>
                </div>
                <div class="l_field l_short" v-if="rentaltype_seq=='RT0002'">
                  <label for="machine_count">휠체어이용인원</label>
                  <input type="text" id="machine_count" class="l_bluetxt" placeholder="인원수를 넣어주세요" v-model="machine_count">
                  <span>명</span>
                </div>
              </div>
              <div class="l_rentalpop_linfo_r">
                <div class="l_field">
                  <label for="join_state">신청상태</label>
                  <input type="text" id="join_state" class="m_nochange" readonly value="신규">
                </div>
                <div class="l_field">
                  <label for="name">대표자명</label>
                  <input type="text" id="name" class="m_nochange" readonly v-model="name">
                </div>
                <div class="l_field" v-if="rentaltype_seq!='RT0002'">
                  <p class="l_labeltxt">이용기간</p>
                  <div class="l_field_cal">
                    <input class="flatpickr" placeholder="시작일을 선택" title="시작일 선택" v-model="sDatepop"></input>
                    <div class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></div>
                  </div>
                  <span class="l_wave">~</span>
                  <div class="l_field_cal">
                    <input class="flatpickr" placeholder="종료일을 선택" title="종료일 선택" v-model="eDatepop"></input>
                    <div class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></div>
                  </div>
                </div>
                <div class="l_field" v-if="rentaltype_seq=='RT0002'">
                  <p class="l_labeltxt">일시</p>
                  <div class="l_field_cal">
                    <input class="flatpickr" placeholder="방문일을 선택" title="방문일 선택" v-model="inDate"></input>
                    <div class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></div>
                  </div>
                  <div class="l_field_time">
                    <select title="방문일의 시" v-model="sHour">
                      <option value="">시</option>
                      <option v-for="(option,key) in 24" :value="key<10?'0'+key:key">{{key<10?'0'+key:key}}</option>
                    </select>
                  </div>
                  <div class="l_field_time">
                    <select title="방문일의 분" v-model="sMin">
                      <option value="">분</option>
                      <option v-if="key%10==0" v-for="(option,key) in 60" :value="key==0?'00':key">{{key==0?"00":key}}</option>
                    </select>
                  </div>
                </div>
                <div class="l_field l_short">
                  <label for="user_count">인원</label>
                  <input type="text" id="user_count" class="l_bluetxt" placeholder="인원수를 넣어주세요" v-model="user_count" maxlength="4">
                  <span>명</span>
                </div>
                <div class="l_field l_short" v-if="rentaltype_seq!='RT0002'">
                  <label for="machine_count">휠체어이용인원</label>
                  <input type="text" id="machine_count" class="l_bluetxt" placeholder="인원수를 넣어주세요" v-model="machine_count" maxlength="4">
                  <span>명</span>
                </div>
                <div class="l_field m_ibarea" v-if="rentaltype_seq!='RT0002'">
                  <p>식사신청</p>
                  <div class="l_radio_wrap">
                    <div class="l_radio line">
                      <input type="radio" class="l_radio" id="food1" name="food" value="0" v-model="food">
                      <label for="food1">안함</label>
                    </div>
                    <div class="l_radio line">
                      <input type="radio" class="l_radio" id="food2" name="food" value="1" v-model="food">
                      <label for="food2">대관식(6,000원)</label>
                    </div>
                    <div class="l_radio line">
                      <input type="radio" class="l_radio" id="food3" name="food" value="2" v-model="food">
                      <label for="food3">선수식(13,000원)</label>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="l_search_btns" v-bind:class="{l_checkpop: checkpop}">
              <div v-if="!checkpop">
                <button type="submit" class="l_btn s_blue" @click="rentalOrder">신 청</button>
                <button class="l_btn s_white" @click="rentalPop(false)">취 소</button>
              </div>
              <div v-else>
                <button class="l_btn s_whitegline" @click="rentalCancle">{{rentaltype_seq=="RT0001"? "대관 취소하기" : "신청 취소"}}</button>
                <button class="l_btn s_blue" @click="rentalPop(false)">확 인</button>
              </div>
            </div>
          </div>
          <div class="l_rentalpop_rinfo" v-if="food!=0">
            <p class="l_pop_rtitle">
              <span class="l_title">사용일자별 식사여부 -</span>
              <span class="l_day">{{food_chk.length==undefined? "0" : food_chk.length}}</span>
              <span class="l_txt">일 / 총</span>
              <span class="l_day">{{user_count==""? "0" : user_count}}</span>
              <span class="l_txt">명 /</span>
              <span class="l_day">{{total_eat}}</span>
              <span class="l_txt">식</span>
            </p>
            <div class="l_list_tablewrap m_tbodyscroll">
              <table>
                <caption>사용일자별 식사여부 체크 표</caption>
                <thead>
                  <tr>
                    <th scope="col">사용일자</th>
                    <th scope="col">조식</th>
                    <th scope="col">중식</th>
                    <th scope="col">석식</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-if="food_chk!=undefined" v-for="(chk,key) in food_chk" :key="key">
                    <td>{{chk.date}}</td>
                    <td>
                      <div class="l_checkbox">
                        <input type="checkbox" :id="'foodcheck'+key+'1'" :value="chk.morning" v-model="food_chk[key].morning=='1'? 1 : 0" @change="foodChkChange(key, 'morning', 1)">
                        <label :for="'foodcheck'+key+'1'">{{chk.date}} 조식</label>
                      </div>
                    </td>
                    <td>
                      <div class="l_checkbox">
                        <input type="checkbox" :id="'foodcheck'+key+'2'" :value="chk.lunch" v-model="food_chk[key].lunch=='1'? 1 : 0" @change="foodChkChange(key, 'lunch', 1)">
                        <label :for="'foodcheck'+key+'2'">{{chk.date}} 중식</label>
                      </div>
                    </td>
                    <td>
                      <div class="l_checkbox">
                        <input type="checkbox" :id="'foodcheck'+key+'3'" :value="chk.dinner" v-model="food_chk[key].dinner=='1'? 1 : 0" @change="foodChkChange(key, 'dinner', 1)">
                        <label :for="'foodcheck'+key+'3'">{{chk.date}} 석식</label>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div class="l_foodcheck_area m_ibarea">
              <p class="l_food_info">{{nav.addComma(foodprice)}}</p>
              <p class="l_food_txt"> 원</p>
              <p class="l_food_info">x {{total_eat}}</p>
              <p class="l_food_txt"> 식</p>
              <p class="l_food_info">x {{user_count=="" ? "0" : user_count}}</p>
              <p class="l_food_txt"> 명</p>
              <p class="l_food_rtxt">급식비</p>
              <p class="l_food_info">{{nav.addComma(foodprice * total_eat * user_count)}}</p>
              <p class="l_food_txt"> 원</p>
            </div>
          </div>

        </div>
      </div>
    </transition>

    <transition name="fade">
      <div class="l_popup_bg" v-if="afterpop">
        <div class="l_popup_area l_rentalafter">
          <p class="l_popup_title">대관신청내역</p>
          <div class="l_rentalinfo_wrap m_ibarea">
            <div class="l_rentalinfo_line">
              <p class="l_rentalinfo_title">대관구분</p>
              <p class="l_rentalinfo_txt">{{rentaltype}}</p>
              <p class="l_rentalinfo_title">신청상태</p>
              <p class="l_rentalinfo_txt" v-bind:class="{s_brown: state=='605' || state=='604' || state=='603' || state=='601'}">{{state=="600"?"승인대기":state=="601"?"신청취소":state=="602"?"승인완료":state=="603"?"반려":state=="604"?"승인 후 취소":state=="605"?"대관 후 취소":""}}</p>
            </div>
            <div class="l_rentalinfo_line">
              <p class="l_rentalinfo_title">대관단체명</p>
              <p class="l_rentalinfo_txt">{{association}}</p>
              <p class="l_rentalinfo_title">대표자명</p>
              <p class="l_rentalinfo_txt">{{name}}</p>
            </div>
            <div class="l_rentalinfo_line">
              <p class="l_rentalinfo_title">연락처</p>
              <p class="l_rentalinfo_txt">{{phone}}</p>
              <p class="l_rentalinfo_title">이용기간</p>
              <p class="l_rentalinfo_txt" v-if="rentaltype=='시설대관'">{{sDatepop.substr(0,10)}} ~ {{eDatepop.substr(0,10)}}</p>
              <p class="l_rentalinfo_txt" v-else>{{sDatepop}}</p>
            </div>
            <div class="l_rentalinfo_line">
              <p class="l_rentalinfo_title">시설 선택</p>
              <p class="l_rentalinfo_txt">{{facility}}</p>
              <p class="l_rentalinfo_title">인원</p>
              <p class="l_rentalinfo_txt"><span>{{user_count}}</span> 명</p>
            </div>
            <div class="l_rentalinfo_line">
              <p class="l_rentalinfo_title">숙소</p>
              <p class="l_rentalinfo_txt">{{lodging==0? "사용안함" : "사용"}}</p>
              <p class="l_rentalinfo_title">휠체어이용인원</p>
              <p class="l_rentalinfo_txt"><span>{{machine_count}}</span> 명</p>
            </div>
            <div class="l_rentalinfo_line">
              <p class="l_rentalinfo_title">샤워시설</p>
              <p class="l_rentalinfo_txt">{{shower==0? "사용안함" : "사용"}}</p>
              <p class="l_rentalinfo_title">식사신청</p>
              <p class="l_rentalinfo_txt">{{food==0? "안함" : food==1? "대관식" : food==2? "선수식" :""}}{{food!=0? "("+foodprice+")원*"+total_eat+"식*총인원" : ""}}</p>
            </div>
            <div class="l_rentalinfo_line">
              <p class="l_rentalinfo_title">음향기기</p>
              <p class="l_rentalinfo_txt">{{sound==0? "사용안함" : "사용"}}</p>
              <p class="l_rentalinfo_title">총납부금액</p>
              <p class="l_rentalinfo_txt">{{total_price}} 원</p>
            </div>
          </div>
          <div class="l_confirmcancel_wrap" v-if="addcomment || state=='605' || state=='604'">
            <p class="l_popup_title">{{state=="605" || state=="602" && groupcode!="ADMIN"? "신청취소사유" : "승인취소사유"}}</p>
            <p class="l_popup_cmt2" v-if="state=='602'">* {{groupcode=="ADMIN"? "승인" : "신청"}}취소가 완료된 후에는 복구가 불가능합니다. {{groupcode=="ADMIN"? "승인" : "신청"}}을 취소하시겠습니까?</p>
            <div class="l_confirmcancel_box m_ibarea" v-bind:class="{l_boxtxt: state=='605' || state=='604'}">
              <div v-if="state=='602'">
                <label for="txtcmt">취소사유</label>
                <input type="text" id="txtcmt" placeholder="취소사유를 입력해주세요." v-model="cancelcmt" v-on:input="cancelcmt=$event.target.value">
              </div>
              <p class="l_boxcmt" v-if="state=='605' || state=='604'">{{cancel_comment}}</p>
            </div>
          </div>
          <div class="l_search_btns">
            <div v-if="state=='600'">
              <button class="l_btn s_whitegline" @click="rentalConfirm('N')">반 려</button>
              <button class="l_btn s_blue" @click="rentalConfirm('Y')">승 인</button>
              <button class="l_btn s_white" @click="afterpop=false;checkpop=false;">취 소</button>
            </div>
            <div v-if="state=='602' && !addcomment || state=='605' || state=='604' || state=='603' || state=='601'">
              <button class="l_btn s_whitegline" v-if="state=='602' && !addcomment" @click="rentalConfirmCancel('addcomment', true)">{{groupcode=="ADMIN"? "승인 취소" : "신청 취소"}}</button>
              <button class="l_btn s_blue" @click="afterpop=false;checkpop=false;">확 인</button>
            </div>
            <div v-if="state=='602' && addcomment">
              <button class="l_btn s_blue" @click="rentalConfirmCancel('ccy')">확 인</button>
              <button class="l_btn s_white" @click="rentalConfirmCancel('addcomment', false)">취 소</button>
            </div>
            </div>
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
      select_api:"http://ic.sportsdiary.co.kr/api/menu_control/selected_item_custom.asp",// 종목선택 api. "code": "SP"
      rentallist_api:"http://ic.sportsdiary.co.kr/api/rental_manager/rental_list.asp",// 목록 조회

      rentalfacility_api:"http://ic.sportsdiary.co.kr/api/menu_control/selected_facility_rental.asp",// 대관시설 목록
      programlist_api:"http://ic.sportsdiary.co.kr/api/menu_control/selected_program.asp",// 프로그램 목록
      checkinfo_api:"http://ic.sportsdiary.co.kr/api/rental_manager/rental_list_view.asp",// 선택한 정보

      rentalsave_api:"http://ic.sportsdiary.co.kr/api/rental_manager/rental_add.asp",// 대관신청
      newfoodchk_api:"http://ic.sportsdiary.co.kr/api/rental_manager/rantal_food_chk.asp",// 신규 신청할 때 식사여부목록
      rentalcancel_api:"http://ic.sportsdiary.co.kr/api/rental_manager/rental_user_cancel.asp",// 승인 전 대관 취소
      rentalupdatereject_api:"http://ic.sportsdiary.co.kr/api/rental_manager/rental_approval_update.asp",// 승인/반려
      confirmcancel_api:"http://ic.sportsdiary.co.kr/api/rental_manager/rental_non-approval_update.asp",// 승인 후 취소
      userconfirmcancel_api:"http://ic.sportsdiary.co.kr/api/rental_manager/rental_user_approval_cancel.asp",// 승인 후 취소(사용자)


      selectinfo:[],// 종목 목록
      searchlist:[],// 검색 목록
      rentalfacility:[],// 대관시설 목록
      programlist:[],// 프로그램 목록
      checkinfos:[],// 선택한 목록의 정보

      totallist:0,// 최대목록
      pageMax:null,// 최대 페이지 수
      pageCount:0,// 몇번째 5단위 page인가 확인용
      pageNo:0,//

      // selected
      rentaltype:"",// 대관구분
      rentaltypelist_seq:"",// 목록용 seq
      rentaltype_seq:"",// 대관구분 seq
      association:"",// 대관단체명
      phone:"",// 연락처
      number:"",// 대관시설 선택 set
      numberprice:0,// 대관시설 가격
      facility:"",// 대관시설
      program_seq:"",// 프로그램 선택 seq
      lodging:"0",// 숙소
      lodgingprice:0,// 숙소가격
      shower:"0",// 샤워시설
      showerprice:0,// 샤워시설 가격
      sound:"0",// 음향기기
      soundprice:0,// 음향기기 가격
      total_price:"",// 총납부금액
      //join_state:"",// 신청상태
      name:"",// 대표자명
      sDate:"",// 시작일
      eDate:"",// 종료일
      sDatepop:"",// 시작일(팝업)
      eDatepop:"",// 종료일(팝업)
      // daterange:[],// 시작일(팝업)-종료일(팝업) 사이의 날짜들
      inDate:"",// 방문일
      sHour:"",// 방문 시
      sMin:"",// 방문 분
      user_count:"",// 인원
      machine_count:"",// 휠체어이용인원
      machineprice:0,// 휠체어이용인원 가격
      food:0,// 식사신청
      foodprice:0,// food=1이면 6000,  food=2면 13000
      food_chk:[],// 날짜별 밥 선택
      total_eat:0,// 총 몇식?
      state:"",// 상태. 600 - 승인대기, 601 - 신청취소, 602 - 승인, 603 - 반려, 604 - 승인 후 취소, 605 - 대관 후 취소
      seq:"",// 기준점
      groupcode:"",//

      cancelcmt:"",// 승인취소사유(입력값)
      cancel_comment:"",// 승인취소사유(받는값)

      // 팝업 관련
      rentalpop:false,//
      checkpop:false,// 목록 선택해서 팝업 띄울 때
      afterpop:false,// 관리자, 사용자 분리 팝업
      addcomment:false,// 승인취소사유 보이기 여부
		},
    watch:{
      // 달력 바뀌면 다시 로드
      sDate:function(newval,oldval){
        if(!this.checkpop){
          this.searchData();
        }
      },
      eDate:function(newval,oldval){
        if(!this.checkpop){
          this.searchData();
        }
      },
      // 식사값
      food:function(newval,oldval){
        if(!this.checkpop){
          if(newval==0){
            this.foodprice=0;
          }else if(newval==1){
            this.foodprice=6000;
          }else if(newval==2){
            this.foodprice=13000;
          }
          this.totalPrice();
        }
      },
      // 이용기간
      sDatepop:function(newval,oldval){
        if(!this.checkpop){
          if(this.eDatepop!="" && !this.checkpop){
            this.newFoodChk();
          }
        }
      },
      eDatepop:function(newval,oldval){
        if(!this.checkpop){
          if(this.sDatepop!="" && !this.checkpop){
            this.newFoodChk();
          }
        }
      },

      // 시설 사용 시 총 납부금액 계산
      number:function(newval,oldval){
        if(!this.checkpop){
          var _this=this;
          this.rentalfacility.filter(function(val,idx){
            if(val.seq==newval){
              _this.numberprice=Number(val.price);
              _this.totalPrice();
              return;
            }
            if(newval==""){
              _this.numberprice=0;
              _this.totalPrice();
              return;
            }
          });
        }
      },
      // 숙소 사용 시 총 납부금액 계산
      lodging:function(newval,oldval){
        if(!this.checkpop){
          if(newval==="1"){
            this.lodgingprice=40000;// 1일 기준 2인실. 4만원
          }else{
            this.lodgingprice=0;
          }
          this.totalPrice();
        }
      },
      // 샤워시설 사용 시 총 납부금액 계산
      shower:function(newval,oldval){
        if(!this.checkpop){
          if(newval==="1"){
            this.showerprice=2000;
          }else{
            this.showerprice=0;
          }
          this.totalPrice();
        }
      },
      // 음향기기 사용 시 총 납부금액 계산
      sound:function(newval,oldval){
        if(!this.checkpop){
          if(newval==="1"){
            this.soundprice=50000;
          }else{
            this.soundprice=0;
          }
          this.totalPrice();
        }
      },
      // 휠체어이용인원 총 납부금액 계산
      machine_count:function(newval,oldval){
        if(!this.checkpop){
          if(newval!==""){
            this.machineprice=100000*Number(this.machine_count);
          }else{
            this.machineprice=0;
          }
          this.totalPrice();
        }
      },
      // 인원 변경 시 총 납부금액 계산
      user_count:function(){
        if(!this.checkpop){
          this.totalPrice();
        }
      }
    },
		methods:{
      // 총 납부금액 계산
      totalPrice:function(){
        this.total_price=nav.addComma(
          (this.numberprice*Number(this.food_chk.length))+
          ((this.lodgingprice*Math.ceil(Number(this.user_count)/2))*(Number(this.food_chk.length)-1<0?0:Number(this.food_chk.length)-1))+
          (this.showerprice*Number(this.user_count)*Number(this.food_chk.length))+
          (this.soundprice*Number(this.food_chk.length))+
          (this.machineprice*Number(this.food_chk.length))+
          (this.total_eat*this.foodprice*Number(this.user_count))
        );
      },

      // 조회
      searchData:function(){
        var _this=this;

        axios.post(_this.rentallist_api,{
          sdate:_this.sDate,
          edate:_this.eDate,
          rentaltype_seq:_this.rentaltypelist_seq,
          page:_this.pageNo+1,
          pagesize:15
        }).then(function(response){
          if(response.data.state==="true"){
            _this.totallist=Number(response.data.total);
            _this.pageMax=Number(Math.ceil(response.data.total/15));// 15개 기준
            _this.searchlist=response.data.rental;
          }else if(response.data.state==="false"){
            _this.pageMax=null;
            _this.totallist=0;
            _this.pageCount=0;
            _this.pageNo=0;
            _this.searchlist=[];
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

      // 목록 data불러오기
      loadData:function(){
        var _this=this;
        if(selected_item.RT.length<0){
          axios.post(_this.select_api,{
            code:"RT"
          }).then(function(response){
            if(response.data.state==="true"){
              _this.selectinfo=response.data.rental;
            }
          });
        }
        else{
          _this.selectinfo=selected_item.RT;
        }

        // 대관시설 목록
        if(_this.rentalfacility.length==0){
          if(selected_item.facility_rental.length<0){
            axios.post(_this.rentalfacility_api,{}).then(function(response){
              if(response.data.state==="true"){
                _this.rentalfacility=response.data.facility;
              }
            });
          }
          else{
            _this.rentalfacility=selected_item.facility_rental;
          }
        }
        // 프로그램 목록
        if(_this.programlist.length==0){
          if(selected_item.program.length<0){
            axios.post(_this.programlist_api,{}).then(function(response){
              if(response.data.state==="true"){
                _this.programlist=response.data.program;
              }
            });
          }
          else{
            _this.programlist=selected_item.program;
          }
        }
      },

      // n달 후
      addMonth:function(date,month){
        // n달 후의 1일
        var addMonthFirstDate=new Date(date.getFullYear(), date.getMonth()+month, 1);
        // n달 후의 말일
        var addMonthLastDate=new Date(addMonthFirstDate.getFullYear(), addMonthFirstDate.getMonth()+1, 0);
        var result=addMonthFirstDate;
        if(date.getDate()>addMonthLastDate.getDate()){
          result.setDate(addMonthLastDate.getDate());
        }else{
          result.setDate(date.getDate());
        }

        var resultMonth=(result.getMonth()+1);
        var resultdate=result.getFullYear()+"-"+(resultMonth<10? resultMonth="0"+resultMonth : resultMonth=resultMonth)+"-"+(result.getDate()<10? "0"+result.getDate():result.getDate());
        return resultdate;
      },

      // 대관신청하기 팝업
      rentalPop:function(bo,renseq){
        var _this=this;
        _this.rentalpop=bo;
        if(bo){
          // 열기
          if(_this.rentaltype_seq!=""){
            _this.rentaltype_seq="";
            _this.searchData();
          }

          if(renseq==undefined){// 신규
            _this.init();
            _this.calinit();
            _this.rentaltype_seq="RT0001";// 시설대관 기본
            _this.name=nav.username;
            _this.food_chk=[];
          }else{
            _this.rentaltype_seq=renseq;
          }
        }else{
          // 닫기
          _this.rentaltype_seq="";
          _this.checkpop=false;
          _this.init();
        }
      },

      //
      init:function(){
        this.total_eat=0;
        this.food=0;
        this.foodprice="";
        this.food_chk=[];
        this.program_seq="";
        this.association="";
        this.phone="";
        // this.name="";
        this.machine_count="";
        this.machineprice=0;
        this.user_count="";
        this.total_price=0;
        this.inDate="";
        this.sHour="";
        this.sMin="";
        this.number="";
        this.numberprice=0;
        this.lodging="0";
        this.lodgingprice=0;
        this.shower="0";
        this.showerprice=0;
        this.sound="0";
        this.soundprice=0;
        this.sDatepop="";
        this.eDatepop="";
        // this.daterange=[];
      },

      // 팝업 안에 있는 달력 초기화
      calinit:function(){
        setTimeout(function(){
          var calendars=document.querySelectorAll(".l_popup_area .flatpickr");
          flatpickr(calendars,{
            locale:"ko",
          });
        },100);
      },

      // 식사 체크 
      foodChkChange:function(idx,txt,val){
        var _this=this;
        if(_this.food_chk[idx][txt]==val){
          _this.food_chk[idx][txt]=0;
        }else{
          _this.food_chk[idx][txt]=1;
        }
        _this.$set(_this.food_chk, idx, _this.food_chk[idx]);
        _this.total_eat=0;
        _this.food_chk.filter(function(val,idx){
          if(val.dinner=="1"){
            _this.total_eat+=1;
          }
          if(val.lunch=="1"){
            _this.total_eat+=1;
          }
          if(val.morning=="1"){
            _this.total_eat+=1;
          }
        });
        _this.totalPrice();
      },

      // 신규 신청할 때 식사여부목록
      newFoodChk:function(){
        var _this=this;
        _this.total_eat=0;
        axios.post(_this.newfoodchk_api,{
          sdate:_this.sDatepop,
          edate:_this.eDatepop
        }).then(function(response){
          if(response.data.state==="true"){
            _this.food_chk=response.data.food_chk;
          }else if(response.data.state==="false"){
            _this.food_chk=[];
          }
        }).finally(function(){
          _this.totalPrice();
        });
      },

      // 선택한 정보
      updateData:function(seq){
        var _this=this;
        _this.checkpop=true;
        _this.seq=seq;

        axios.post(_this.checkinfo_api,{
          seq:_this.seq
        }).then(function(response){
          if(response.data.state==="true"){
            _this.checkinfos=[];
            _this.checkinfos=response.data.rental_view[0];

            //
            if(_this.checkinfos.rentaltype_seq==="RT0001"){
              _this.rentaltype="시설대관";
              _this.number=_this.checkinfos.facility_seq;
              _this.rentalfacility.filter(function(val,idx){
                if(val.seq==_this.number){
                  _this.numberprice=Number(val.price);
                  _this.facility=val.number;
                  return;
                }
              });
              _this.lodging=_this.checkinfos.lodging;
              _this.shower=_this.checkinfos.shower;
              _this.sound=_this.checkinfos.sound;
              _this.sDatepop=_this.checkinfos.sdate.substr(0,10);
              _this.eDatepop=_this.checkinfos.edate.substr(0,10);
              _this.food=_this.checkinfos.food;
              if(_this.food==0){
                _this.foodprice=0;
              }else if(_this.food==1){
                _this.foodprice=6000;
              }else if(_this.food==2){
                _this.foodprice=13000;
              }
              _this.food_chk=[];
              _this.food_chk=_this.checkinfos.food_chk;
              _this.food_chk.filter(function(val,idx){
                if(val.dinner==="1"){
                  _this.total_eat+=1;
                }
                if(val.lunch==="1"){
                  _this.total_eat+=1;
                }
                if(val.morning==="1"){
                  _this.total_eat+=1;
                }
              });
              // 식사목록?
              _this.inDate="";
              _this.sHour="";
              _this.sMin="";
            }
            if(_this.checkinfos.rentaltype_seq==="RT0002"){
              _this.rentaltype="견학";
              _this.number="";
              _this.lodging="0";
              _this.shower="0";
              _this.sound="0";
              _this.sDatepop=_this.checkinfos.sdate;
              _this.eDatepop="";
              _this.numberprice=0;
              _this.food=0;
              _this.foodprice=0;
              _this.food_chk=[];
              _this.inDate=_this.checkinfos.sdate.substr(0,10);
              _this.sHour=_this.checkinfos.sdate.substr(11,2);
              _this.sMin=_this.checkinfos.sdate.substr(14,2);
            }
            _this.cancel_comment=_this.checkinfos.cancel_comment;
            _this.state=_this.checkinfos.state;
            _this.program_seq=_this.checkinfos.program_seq;
            _this.association=_this.checkinfos.association;
            _this.phone=_this.checkinfos.phone;
            _this.name=_this.checkinfos.name;
            _this.machine_count=_this.checkinfos.machine_count;
            _this.user_count=_this.checkinfos.user_count;
            _this.total_price=nav.addComma(_this.checkinfos.total_price);

            // 팝업 구분
            if(_this.groupcode=="ADMIN"){
              _this.afterpop=true;
            }else if(_this.groupcode!="ADMIN" && _this.state==="601" || _this.groupcode!="ADMIN" && _this.state==="602"  || _this.groupcode!="ADMIN" && _this.state==="603" || _this.groupcode!="ADMIN" && _this.state==="604" || _this.groupcode!="ADMIN" && _this.state==="605"){
              _this.afterpop=true;
            }else{
              // _this.rentalpop=true;
              _this.rentalPop(true, _this.checkinfos.rentaltype_seq);
            }
          }else{
            _this.checkinfos=[];
          }
        });
      },

      // 대관 신청하기
      rentalOrder:function(){
        var _this=this;
        var sdate="", edate="";

        if(_this.rentaltype_seq==="RT0001"){
          if(_this.association==="" || _this.phone==="" || _this.number==="" || _this.sDatepop==="" || _this.eDatepop==="" || _this.user_count===""){
            alert("모든 항목을 선택하세요.1");
            return;
          }
        }

        if(_this.rentaltype_seq==="RT0002"){
          if(_this.association==="" || _this.phone==="" || _this.program_seq==="" || _this.inDate==="" || _this.sHour==="" || _this.sMin==="" || _this.user_count===""){
            alert("모든 항목을 선택하세요.2");
            return;
          }
        }

        if(_this.rentaltype_seq==="RT0001"){
          sdate=_this.sDatepop+" 00:00";
          edate=_this.eDatepop+" 00:00";
        }
        if(_this.rentaltype_seq==="RT0002"){
          sdate=_this.inDate+" "+_this.sHour+":"+_this.sMin;
          edate=_this.inDate+" "+_this.sHour+":"+_this.sMin;
        }
        axios.post(_this.rentalsave_api,{
          rentaltype_seq:_this.rentaltype_seq,
          association:_this.association,
          name:_this.name,
          phone:nav.addDash(_this.phone),
          sdate:sdate,
          edate:edate,
          facility_seq:_this.number,
          program_seq:_this.program_seq,
          user_count:_this.user_count,
          machine_count:_this.machine_count,
          lodging:_this.lodging,
          shower:_this.shower,
          food:_this.food,
          sound:_this.sound,
          total_price:_this.total_price.replace(/,/g,""),
          food_chk:_this.food_chk
        }).then(function(response){
          if(response.data.state==="true"){
            _this.rentalPop(false);
            _this.searchData();
          }
        });
      },
      // 대관 취소하기
      rentalCancle:function(){
        var _this=this;
        axios.post(_this.rentalcancel_api,{
          seq:_this.seq
        }).then(function(response){
          if(response.data.state==="true"){
            _this.rentalPop(false);
            _this.searchData();
          }
        });
      },

      // 대관신청내역 승인/반려
      rentalConfirm:function(or){
        // or : Y=승인, N반려
        var _this=this;
        axios.post(_this.rentalupdatereject_api,{
          seq:_this.seq,
          approval:or
        }).then(function(response){
          if(response.data.state==="true"){
            _this.afterpop=false;
            _this.init();
            _this.searchData();
          }
        });
      },
      // 승인완료 후 승인 취소
      rentalConfirmCancel:function(ifcon,bo){
        var _this=this;

        if(ifcon==="ccy"){// 승인취소사유 입력 후 확인. ccy=confirmcancely
          if(_this.cancelcmt===""){
            alert("사유를 입력해주세요");
            return;
          }

          var cancelapi="";

          if(_this.groupcode=="ADMIN"){
            cancelapi=_this.confirmcancel_api;// 관리자
          }else{
            cancelapi=_this.userconfirmcancel_api;// 사용자
          }
          axios.post(cancelapi,{
            seq:_this.seq,
            cancel:_this.cancelcmt
          }).then(function(response){
            if(response.data.state==="true"){
              _this.rentalConfirmCancel("addcomment", false);
              _this.searchData();
            }
          });
        }

        //
        _this[ifcon]=bo;
        if(bo){

        }else{
          _this.afterpop=bo;//false;
          _this.cancelcmt="";
          _this.init();
        }

      },
		},
		mounted:function(){
      var _this=this;
      _this.name=nav.username;

      this.loadData();

      setTimeout(function(){
        _this.searchData();
        var calendars=document.querySelectorAll(".flatpickr");
        flatpickr(calendars,{
          locale:"ko",
        });
      },300);
    },
		created:function(){
			// 현재 메뉴(위치) 확인
			eventBus.$emit("menuinfo");
			eventBus.$emit("menudrop", [6,0]);

      var day=new Date();
      var month=day.getMonth()+1<10? "0"+(day.getMonth()+1) : day.getMonth()+1;
      var date=day.getDate()<10? "0"+day.getDate() : day.getDate();
      this.sDate=day.getFullYear()+"-"+month+"-"+date;
      this.eDate=this.addMonth(new Date(), 1);

      this.groupcode=sessionStorage.groupcode;
		}
	});
</script>
</body>
</html>
