<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<div id="icContent_wrap">
  <section id="icContent_admin" class="l_ct l_trainig_plan_write l_admin" v-if="groupcode == 'ADMIN'"  v-cloak>
    <!-- 관리자 훈련계획서 s. -->
    <div class="l_content">
      <!-- 컨텐츠 영역. s. -->
      <h2>훈련계획서 조회 및 승인</h2>
    
      <div class="l_select_box_field">
          <div class="l_field">
            <label for="sdate">기간선택</label>
            <input type="text" name="sdate" id="sdate" class="sdate" placeholder="날짜선택" v-model="sdate">
            <button class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></button>
          </div>
          <div class="l_field__wave">
            <span class="m_field__wave">&#126;</span>
          </div>
          <div class="l_field">
            <input type="text" name="edate" id="edate" class="edate" title="조회 종료 날짜 선택" placeholder="날짜선택" v-model="edate">
            <button class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></button>
          </div>
          <div class="l_field">
            <label for="sports">종목선택</label>
            <select name="sports" id="sports" class="sports" v-model="sports">
              <option value="">전체</option>
              <option v-for="(list, key) in sports_arr" :value="list.seq">{{ list.title }}</option>
            </select>
          </div>
          <div class="l_field">
            <label for="train_purpose">훈련구분</label>
            <select name="train_purpose" id="train_purpose" class="train_purpose" v-model="train_purpose">
              <option value="">전체</option>
              <option v-for="(list, key) in train_purpose_arr" :value="list.seq">{{ list.title }}</option>
            </select>
          </div>
        <div class="l_search_btns">
          <button type="submit" class="s_white" @click="loadTrainingListBtn()">조회</button>
        </div>
      </div>
  
        <!-- 목록 테이블 형식. s. -->
        <div class="l_list_box" style="margin-top:-19px;">
          <div class="l_list_btns">
            <button class="l_btn_download" @click="nav.excelDown('exceldown', '훈련계획서')">엑셀다운<span class="img"><img src="/front/img/icon_arrow_down.svg" alt=""></span></button>
          </div>
          <div class="l_list_tablewrap">
            <table id="exceldown">
              <caption>훈련계획서</caption>
              <thead>
                <tr>
                  <th>
                    <input class="s_list__checkBox_all" type="checkbox" name="list" value="" />
                    <i class="m_list__checkBox_all" @click="clickCheckBoxAll()"></i>
                  </th>
                  <th></th>
                  <th>종목</th>
                  <th>주차</th>
                  <th>훈련일자</th>
                  <th>종목상세</th>
                  <th>훈련구분</th>
                  <th>성별</th>
                  <th>장애유형</th>
                  <th>새벽훈련</th>
                  <th>오전훈련</th>
                  <th>오후훈련</th>
                  <th>야간훈련</th>
                  <th>승인</th>
                </tr>
              </thead>
              <tbody>
                <tr class="l_list__table_tr" v-for="(list, key) in training" :key="key" @click="toggleTrainingList(list)">
                  <td>
                    <input class="s_list__checkBox" type="checkbox" name="train_seq" :value="list.training_seq" />
                    <i class="m_list__checkBox" @click="clickCheckBox(list)" @click.prevent="toggleTrainingList(list)"></i>
                  </td>
                  <td>{{ list.no }}</td>
                  <td>{{ list.sports }}</td>
                  <td>{{ list.week }}</td>
                  <td>{{ list.date }}</td>
                  <td>-</td>
                  <td>{{ list.trainpurpose }}</td>
                  <td>{{ list.man == '0' ? '여' : list.woman == '0' ? '남' : '통합' }}</td>
                  <td>{{ list.desabledstate }}</td>
                  <td>{{ list.Schedule[0].stime }} ~ {{ list.Schedule[0].etime }}</td>
                  <td>{{ list.Schedule[1].stime }} ~ {{ list.Schedule[1].etime }}</td>
                  <td>{{ list.Schedule[2].stime }} ~ {{ list.Schedule[2].etime }}</td>
                  <td>{{ list.Schedule[3].stime }} ~ {{ list.Schedule[3].etime }}</td>
                  <td v-bind:class="{s_orange_txt: list.state == '500' || list.state == '503'}">
                    {{ list.state == '500' ? '승인요청' : list.state == '501' ? '승인완료' : list.state == '502' ? '반려' : list.state == '503' ? '재승인요청' : list.state == '504' ? '삭제' : list.state == '505' ? '승인요청' : list.state == '506' ? '승인완료' : '반려'}}
                  </td>
                </tr>
                <tr v-if="training.length == 0">
                  <td colspan="14">
                    <p class="m_no_list">
                      <span class="no_list_icon">
                        <img src="/front/img/search_icon.png" alt=""/>
                      </span>
                      검색된 결과가 없습니다.
                    </p>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="l_search_btns">
            <button type="submit" class="s_blue" @click="updateTrainingApproval('Y')">승인</button>
            <button type="submit" class="s_gray" @click="updateTrainingApproval('N')">반려</button>
          </div>
        </div>
  
        <!-- 클릭 시 리스트 -->
        <div class="l_list_box l_trainig_plan hide">
            <div class="l_search_box">
              <div class="l_search_field">
                <div class="l_field">
                  <label for="writer">작성자</label>
                  <input id="writer" class="m_text" value="" v-model="writer" disabled />
                </div>
                <div class="l_field">
                  <label for="training_date">훈련일자</label>
                  <input id="training_date" class="m_text" value="" v-model="training_date" disabled/>
                </div>
                <div class="l_field">
                  <label for="competition">종목</label>
                  <input id="competition" class="m_text" value="" v-model="competition" disabled/>
                </div>
                <div class="l_field">
                  <label for="division">훈련구분</label>
                  <input id="division" class="m_text" value="" v-model="division" disabled/>
                </div>
                <div class="l_field">
                  <label for="obstacle">장애유형</label>
                  <input id="obstacle" class="m_text" value="" v-model="obstacle" disabled/>
                </div>
              </div>
              <div class="l_search_field">
                <div class="l_field" style="margin-left:0;">
                  <label for="leader">지도자</label>
                  <input id="leader" class="m_text m_right" value="" v-model="leader" disabled/>
                  <span>명</span>
                </div>
                <div class="l_field">
                  <label for="player_male">선수(남)</label>
                  <input id="player_male" class="m_text m_right" value="" v-model="player_male" disabled/>
                  <span>명</span>
                </div>
                <div class="l_field">
                  <label for="player_female">선수(여)</label>
                  <input id="player_female" class="m_text m_right" value="" v-model="player_female" disabled/>
                  <span>명</span>
                </div>
                <div class="l_field">
                  <label for="etc">기타</label>
                  <input id="etc" class="m_text m_right" value="" v-model="etc" disabled/>
                  <span>명</span>
                </div>
              </div>
            </div>
        
            <div class="m_popup__content_wrap">
              <template v-for="(plan, key) in schedule" :key="key">
                <div class="m_content__box">
                  <div class="m_content_title">
                    <h4>{{ plan.title }}</h4>
                  </div>
                  <div class="m_content">
                    <div class="l_field m_select_box">
                      <label :for="'quarter'+key">동/관</label>
                      <input :id="'quarter'+key" class="m_text" value="" v-model="plan.quarter" disabled/>
                    </div>
                    <div class="l_field m_select_box">
                      <label :for="'facility'+key">호실</label>
                      <input :id="'facility'+key" class="m_text" value="" v-model="plan.number" disabled/>
                    </div>
                  </div>
                  <div class="m_content">
                    <div class="l_field m_select_box">
                      <label :for="'use_time'+key">이용시간</label>
                      <input :id="'use_time'+key" class="m_text" value="" v-model="plan.time" disabled/>
                    </div>
                  </div>
                  <div class="m_content m_content__text">
                    <div class="l_field">
                      <label :for="'content'+key">내용</label>
                      <textarea :id="'content'+key" class="m_text" disabled>{{ plan.comment }}</textarea>
                    </div>
                  </div>
                </div>
              </template>
            </div>
        </div>
      <!-- 컨텐츠 영역. e. -->
    </div>
    <!-- 관리자 훈련계획서 s. -->
  </section>

  <section id="icContent_leader" class="l_ct l_trainig_plan_write" v-if="groupcode == 'ASSOCIATION'" v-cloak>
    <!-- 종목별 지도자 훈련계획서 s. -->
    <div class="l_content">
      <!-- 컨텐츠 영역. s. -->
      <h2>훈련계획서</h2>
    
      <div class="l_select_box_field">
          <div class="l_field">
            <select name="year" title="연도 선택" id="year" v-model="year">
              <option v-for="year in s_year">{{ year }}</option>
            </select>
          </div>
          <div class="l_field" style="margin-left:30px;">
            <select name="month" title="월 선택" id="month" v-model="month">
              <option v-for="month in s_month" :value="month">{{ month }}월</option>
            </select>
          </div>
        <div class="l_search_btns">
          <button type="submit" class="s_white" @click="loadTrainingAssocList()">조회</button>
          <button type="submit" class="s_blue" @click="initTrainingAssoc()">훈련계획서 작성</button>
        </div>
      </div>

        <!-- 목록 테이블 형식. s. -->
        <div class="l_list_box">
          <div class="l_list_tablewrap">
            <table>
              <caption>훈련계획서 목록</caption>
              <thead>
                <tr>
                  <th></th>
                  <th scope="col">훈련일자</th>
                  <th scope="col">종목</th>
                  <th scope="col">종목상세</th>
                  <th scope="col">훈련구분</th>
                  <th scope="col">성별</th>
                  <th scope="col">장애유형</th>
                  <th scope="col">새벽훈련</th>
                  <th scope="col">오전훈련</th>
                  <th scope="col">오후훈련</th>
                  <th scope="col">야간훈련</th>
                  <th scope="col">승인</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(list, key) in trainigInfo" :key="key" @click="getTrainingAssoc(list)">
                  <td>{{ list.no }}</td>
                  <td>{{ list.date }}</td>
                  <td>{{ list.sports }}</td>
                  <td>-</td>
                  <td>{{ list.trainpurpose }}</td>
                  <td>{{ list.man == '0' ? '여' : list.woman == '0' ? '남' : '통합' }}</td>
                  <td>{{ list.desabledstate }}</td>
                  <td>{{ list.Schedule[0].stime }} ~ {{ list.Schedule[0].etime }}</td>
                  <td>{{ list.Schedule[1].stime }} ~ {{ list.Schedule[1].etime }}</td>
                  <td>{{ list.Schedule[2].stime }} ~ {{ list.Schedule[2].etime }}</td>
                  <td>{{ list.Schedule[3].stime }} ~ {{ list.Schedule[3].etime }}</td>
                  <td v-bind:class="{s_blue_txt: list.state == '500' || list.state == '503', s_orange_txt: list.state == '502'}">
                    {{ list.state == '500' ? '승인대기' : list.state == '501' ? '승인' : list.state == '502' ? '반려' : list.state == '503' ? '재승인대기' : '삭제'}}
                  </td>
                </tr>
                <tr v-if="trainigInfo.length == 0">
                  <td colspan="12">
                    <p class="m_no_list">
                      <span class="no_list_icon">
                        <img src="/front/img/search_icon.png" alt=""/>
                      </span>
                      검색된 결과가 없습니다.
                    </p>
                  </td>
                </tr>
              </tbody>
            </table>

            <div v-if="trainigInfo.length>0" class="l_paging_area">
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
      <!-- 컨텐츠 영역. e. -->
    </div>

    <!-- 훈련계획서 등록 팝업 -->
    <transition name="fade">
      <div id="l_popup__trainig_plan_add" class="m_popup m_trainig_plan__popup active" v-if="showAddPopup">
        <div>
          <h1>훈련계획서 등록</h1>
        </div>
        <div class="l_search_box">
          <div class="l_search_field">
            <div class="l_field">
              <label for="writer2">작성자</label>
              <input id="writer2" type="text" name="writer" class="m_readonly" value="" v-model="writer" readonly />
            </div>
            <div class="l_field">
              <label for="training_date_add">훈련일자</label>
              <input type="text" id="training_date_add" name="training_date" value="" placeholder="입력" v-model="training_date"/>
              <button class="l_btn_calendar s_departureDate"><img src="/front/img/icon_calendar.svg" alt="달력선택"></button>
            </div>
            <div class="l_field">
              <label for="competition2">종목</label>
              <input id="competition2" type="text" class="m_readonly" :value="sportsReadOnly" readonly />
            </div>
            <div class="l_field">
              <label for="division2">훈련구분</label>
              <select id="division2" name="division" v-model="division">
                <option v-for="tp in train_purpose" :value="tp.seq">{{ tp.title }}</option>
              </select>
            </div>
            <div class="l_field">
              <div class="m_field__date">
                <label for="obstacle2">장애유형</label>
                <select id="obstacle2" name="obstacle" v-model="obstacle">
                  <option v-for="dt in disabled_type" :value="dt.seq">{{ dt.title }}</option>
                </select>
              </div>
            </div>
          </div>
          <div class="l_search_field">
            <div class="l_field">
              <label for="leader2">지도자</label>
              <span class="l_btn_calendar m_inner__s_character">&#42;</span>
              <input id="leader2" type="text" name="leader" value="" v-model="leader"/>
              <span class="l_btn_calendar m_inner__text">명</span>
            </div>
            <div class="l_field">
              <label for="player_male2">선수(남)</label>
              <span class="l_btn_calendar m_inner__s_character" style="left:74px;">&#42;</span>
              <input id="player_male2" type="text" name="player_male" value="" v-model="player_male"/>
              <span class="l_btn_calendar m_inner__text">명</span>
            </div>
            <div class="l_field">
              <label for="player_female2">선수(여)</label>
              <span class="l_btn_calendar m_inner__s_character" style="left:74px;">&#42;</span>
              <input id="player_female2" type="text" name="player_female" value="" v-model="player_female"/>
              <span class="l_btn_calendar m_inner__text">명</span>
            </div>
            <div class="l_field">
              <label for="etc2">기타</label>
              <span class="l_btn_calendar m_inner__s_character" style="left:47px;">&#42;</span>
              <input id="etc2" type="text" name="etc" value="" v-model="etc"/>
              <span class="l_btn_calendar m_inner__text">명</span>
            </div>
          </div>
        </div>
    
        <div class="m_popup__content_wrap">
          <template v-for="(list, key) in train_plan" :key="key">
            
            <div class="m_content__box">
              <div class="m_content_title">
                <h4>{{ list.title }}</h4>
              </div>
              <div class="m_content">
                <div class="l_field m_select_box">
                  <label :for="'s_quarter'+key">동/관</label>
                  <select :id="'s_quarter'+key" name="quarter" v-model="list.quarter_seq" @change="changeQuarter(key)">
                    <option value="0">==선택==</option>
                    <option v-for="qt in list.quarter" :value="qt.seq">{{ qt.title }}</option>
                  </select>
                </div>
                <div class="l_field m_select_box">
                  <label :for="'s_facility'+key">호실</label>
                  <select :id="'s_facility'+key" name="facility" v-model="list.facility_seq">
                    <option value="0">==선택==</option>
                    <option v-for="fc in list.facility" :value="fc.seq">{{ fc.number }}</option>
                  </select>
                </div>
              </div>
              <div class="m_content">
                <div class="m_content__date_wrap">
                  <div class="l_field m_content__date">
                    <select v-model="list.start_hour">
                      <option v-for="hour in hours" :value="hour">{{ hour }}</option>
                    </select>
                  </div>
                  <span class="m_field__time_division">&#58;</span>
                  <div class="l_field m_content__date">
                    <select v-model="list.start_minute">
                      <option v-for="minute in minutes" :value="minute">{{ minute }}</option>
                    </select>
                  </div>
                </div>
                <span class="m_field__wave">&#126;</span>
                <div class="m_content__date_wrap">
                  <div class="l_field m_content__date">
                    <select v-model="list.end_hour">
                      <option v-for="hour in hours" :value="hour">{{ hour }}</option>
                    </select>
                  </div>
                  <span class="m_field__time_division">&#58;</span>
                  <div class="l_field m_content__date">
                    <select v-model="list.end_minute">
                      <option v-for="minute in minutes" :value="minute">{{ minute }}</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="m_content m_content__text">
                <div class="l_field">
                  <label :for="'s_content'+key">내용</label>
                  <textarea :id="'s_content'+key" name="content" v-model="list.comment"></textarea>
                </div>
              </div>
            </div>
        </template>
        </div>

          <div class="l_search_btns m_center">
            <button class="s_blue" @click="addTrainingAssoc()">확인</button>
            <button class="s_white" @click="closePopup(l_popup__trainig_plan_add)">취소</button>
          </div>
      </div>
    </transition>

    <!-- 훈련계획서 수정 팝업 -->
    <transition name="fade">
      <div id="l_popup__trainig_plan_update" class="m_popup m_trainig_plan__popup active" v-if="showUpdatePopup">
        <div>
          <h1>훈련계획서 수정</h1>
        </div>
        <div class="l_search_box">
          <div class="l_search_field">
            <div class="l_field">
              <label for="writer3">작성자</label>
              <input id="writer3" type="text" name="writer" class="m_readonly" value="" v-model="writer" readonly />
            </div>
            <div class="l_field">
              <label for="training_date_update">훈련일자</label>
              <input type="text" id="training_date_update" name="training_date_update" value="" placeholder="입력" v-model="training_date"/>
              <button class="l_btn_calendar s_departureDate"><img src="/front/img/icon_calendar.svg" alt="달력선택"></button>
            </div>
            <div class="l_field">
              <label for="competition3">종목</label>
              <input id="competition3" type="text" class="m_readonly" :value="sportsReadOnly" readonly />
            </div>
            <div class="l_field">
              <label for="division3">훈련구분</label>
              <select id="division3" name="division" v-model="division">
                <option v-for="tp in train_purpose" :value="tp.seq">{{ tp.title }}</option>
              </select>
            </div>
            <div class="l_field">
              <div class="m_field__date">
                <label for="obstacle3">장애유형</label>
                <select id="obstacle3" name="obstacle" v-model="obstacle">
                  <option v-for="dt in disabled_type" :value="dt.seq">{{ dt.title }}</option>
                </select>
              </div>
            </div>
          </div>
          <div class="l_search_field">
            <div class="l_field">
              <label for="leader3">지도자</label>
              <span class="l_btn_calendar m_inner__s_character">&#42;</span>
              <input id="leader3" type="text" name="leader" value="" v-model="leader"/>
              <span class="l_btn_calendar m_inner__text">명</span>
            </div>
            <div class="l_field">
              <label for="player_male3">선수(남)</label>
              <span class="l_btn_calendar m_inner__s_character" style="left:74px;">&#42;</span>
              <input id="player_male3" type="text" name="player_male" value="" v-model="player_male"/>
              <span class="l_btn_calendar m_inner__text">명</span>
            </div>
            <div class="l_field">
              <label for="player_female3">선수(여)</label>
              <span class="l_btn_calendar m_inner__s_character" style="left:74px;">&#42;</span>
              <input id="player_female3" type="text" name="player_female" value="" v-model="player_female"/>
              <span class="l_btn_calendar m_inner__text">명</span>
            </div>
            <div class="l_field">
              <label for="etc3">기타</label>
              <span class="l_btn_calendar m_inner__s_character" style="left:47px;">&#42;</span>
              <input id="etc3" type="text" name="etc" value="" v-model="etc"/>
              <span class="l_btn_calendar m_inner__text">명</span>
            </div>
          </div>
        </div>
    
        <div class="m_popup__content_wrap">
          <template v-for="(list, key) in train_plan" :key="key">
            <div class="m_content__box">
              <div class="m_content_title">
                <h4>{{ list.title }}</h4>
              </div>
              <div class="m_content">
                <div class="l_field m_select_box">
                  <label :for="'t_quarter'+key">동/관</label>
                  <select :id="'t_quarter'+key" name="quarter" v-model="list.quarter_seq" @change="changeQuarter(key)">
                    <option value="0">==선택==</option>
                    <option v-for="qt in list.quarter" :value="qt.seq">{{ qt.title }}</option>
                  </select>
                </div>
                <div class="l_field m_select_box">
                  <label :for="'t_facility'+key">호실</label>
                  <select :id="'t_facility'+key" name="facility" v-model="list.facility_seq">
                    <option value="0">==선택==</option>
                    <option v-for="fc in list.facility" :value="fc.seq">{{ fc.number }}</option>
                  </select>
                </div>
              </div>
              <div class="m_content">
                <div class="m_content__date_wrap">
                  <div class="l_field m_content__date">
                    <select v-model="list.start_hour">
                      <option v-for="hour in hours" :value="hour">{{ hour }}</option>
                    </select>
                  </div>
                  <span class="m_field__time_division">&#58;</span>
                  <div class="l_field m_content__date">
                    <select v-model="list.start_minute">
                      <option v-for="minute in minutes" :value="minute">{{ minute }}</option>
                    </select>
                  </div>
                </div>
                <span class="m_field__wave">&#126;</span>
                <div class="m_content__date_wrap">
                  <div class="l_field m_content__date">
                    <select v-model="list.end_hour">
                      <option v-for="hour in hours" :value="hour">{{ hour }}</option>
                    </select>
                  </div>
                  <span class="m_field__time_division">&#58;</span>
                  <div class="l_field m_content__date">
                    <select v-model="list.end_minute">
                      <option v-for="minute in minutes" :value="minute">{{ minute }}</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="m_content m_content__text">
                <div class="l_field">
                  <label :for="'t_content'+key">내용</label>
                  <textarea :id="'t_content'+key" name="content" v-model="list.comment"></textarea>
                </div>
              </div>
            </div>
        </template>
      </div>

        <div class="l_search_btns">
          <button class="s_gray" @click="removeTrainingAssoc()">삭제</button>
          <div class="m_center_btns">
            <button class="s_blue" @click="updateTrainingAssoc()">수정</button>
            <button class="s_white" @click="closePopup(l_popup__trainig_plan_update)">취소</button>
          </div>
        </div>
      </div>
    </transition>
    <!-- 종목별 지도자 훈련계획서 e. -->
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
    api_training_list: 'http://ic.sportsdiary.co.kr/api/training_manager/training_list.asp',
    api_training_approval: 'http://ic.sportsdiary.co.kr/api/training_manager/training_approval_update.asp',
    // 세션에서 사용자 정보
    groupcode: '', // 그룹코드
    username: '', // 사용자 이름
    // 메인 셀렉트 박스
    sdate: '', // 시작일
    edate: '', // 종료일
    sports: '', // 종목 selected item
    sports_arr: [], // 종목 셀렉트박스 array
    train_purpose: '', // 훈련구분 
    train_purpose_arr: [], // 훈련구분 셀렉트박스 array
    // 훈련계획서 상세 리스트
    // 필수항목
    training: [], // 리스트
    training_seq: '', // 훈련구분
    writer: '', // 작성자 (고정)
    training_date: '', // 훈련일자
    competition: '', // 종목
    division: '', // 훈련구분
    obstacle: '', // 장애유형
    leader: '', // 지도자
    player_male: '', // 선수(남)
    player_female: '', // 선수 (여)
    etc: '', // 기타
    // 훈련항목 (4개)
    schedule_total: 0, // 훈련항목 total
    schedule: [], // 훈련항목 리스트
    // 체크박스 리스트
    checkBoxArr: [],
  },
  watch:{},
  methods:{
    // 세션에서 사용자 정보 가져오기
    getSessionInfo:function() {
      this.groupcode = sessionStorage.getItem('groupcode');
      this.username = sessionStorage.getItem('username');
    },

    // 날짜 설정
    setDate:function() {
      var date=new Date();

      var year = date.getFullYear();
      var month = date.getMonth() + 1;
      var day = date.getDate();

      if (String(month).split('').length < 2) month = '0' + month;
      if (String(day).split('').length < 2) day = '0' + day;

      this.sdate = year + '-' + month + '-' + day;
      this.edate = year + '-' + month + '-' + day;
    },

    // 달력 불러오기
    loadCalendar:function() {
      var sCalendar = document.querySelector(".sdate");
      flatpickr(sCalendar,{
        locale:"ko",
      });

      var eCalendar = document.querySelector(".edate");
      flatpickr(eCalendar,{
        locale:"ko",
      });
    },

    // 훈련계획서 셀렉트 박스 가져오기
    loadTrainingPlanSelectBoxList:function() {
      var _this = this;

      _this.sports_arr = selected_item.SP;
      _this.train_purpose_arr = selected_item.TP;
    },

    // 관리자 훈련계획서 리스트 조회
    loadTrainingList:function() {
      var _this = this;
      
      axios.post(_this.api_training_list,{
        sdate: _this.sdate,
        edate: _this.edate,
        sports_seq: _this.sports,
        trainpurpose_seq: _this.train_purpose
      }).then(function(response){
        if (response.data.state=="true"){
          _this.training = response.data.training;
          console.log('훈련계획서 조회 완료');
        } else {
          if (response.data.errorcode == 'ERR-130') {
            _this.training = [];
          }
        }
      }).catch(function(error){
        console.log("훈련계획서 조회 error : ");
        console.log(error);
      }).finally(function() {
        _this.loadCalendar();
      });
    },

    // 관리자 훈련계획서 리스트 조회
    loadTrainingListBtn:function() {
      var _this = this;
      
      axios.post(_this.api_training_list,{
        sdate: _this.sdate,
        edate: _this.edate,
        sports_seq: _this.sports,
        trainpurpose_seq: _this.train_purpose
      }).then(function(response){
        if (response.data.state=="true"){
          _this.training = response.data.training;
          console.log('훈련계획서 조회 완료');
        } else {
          if (response.data.errorcode == 'ERR-130') {
            _this.training = [];
          }
        }
      }).catch(function(error){
        console.log("훈련계획서 조회 error : ");
        console.log(error);
      });
    },

    // 관리자 훈련계획서 관리 승인
    updateTrainingApproval:function(apply) {
      var _this = this;
      var checkBoxAll = $('.s_list__checkBox_all');
      var checkBoxInput = $('.s_list__checkBox');

      if (_this.checkBoxArr.length == 0){
        alert('체크박스로 훈련계획서를 선택해 주세요.');
        return false;
      }

      axios.post(_this.api_training_approval,{
        seq: _this.checkBoxArr,
        applly: apply,
      }).then(function(response){
        if (response.data.state=="true"){
          console.log('훈련계획서 승인/반려 완료');

          if (apply == 'Y') alert('승인 되었습니다.');
          else alert('반려 되었습니다.');
        }
      }).catch(function(error){
        console.log("훈련계획서 승인/반려 error : ");
        console.log(error);
      }).finally(function() {

        _this.loadTrainingListBtn();
        _this.hideTrainList();
        _this.checkBoxArr = [];
        
        checkBoxAll.prop('checked', false);
        checkBoxInput.prop('checked', false);
      });
    },

    // 하단 리스트 데이터 셋팅
    toggleTrainingList:function(list) {
      this.training_seq = list.training_seq;
      this.writer = list.cochename;
      this.training_date = list.date;
      this.competition = list.sports;
      this.division = list.trainpurpose;
      this.obstacle = list.desabledstate;
      this.leader = list.trainers;
      this.player_male = list.man;
      this.player_female = list.woman;
      this.etc = list.etc;
      this.schedule = list.Schedule;

      this.schedule.forEach(function(item, idx) {
        switch(item.trainingtime) {
          case '1': item.title = '새벽훈련'; break;
          case '2': item.title = '오전훈련'; break;
          case '3': item.title = '오후훈련'; break;
          case '4': item.title = '야간훈련'; break;
          default: item.title = ''; break;
        }

        item.time = item.stime + ' ~ ' + item.etime;
        item.comment = item.comment.split('<br/>').join("\r\n");
      });

      this.showTrainList();
      this.highlight(list.no - 1);
    },

    // 훈련계획서 상세 리스트 숨기기
    hideTrainList:function() {
      var trainingPlan = $('.l_trainig_plan');
      trainingPlan.addClass('hide');
    },

    // 훈련계획서 상세 리스트 보이기
    showTrainList:function() {
      var trainingPlan = $('.l_trainig_plan');
      trainingPlan.removeClass('hide');
    },

    // 체크박스 이벤트
    clickCheckBoxAll:function() {
      var _this = this;
      var checkBoxAll = $('.s_list__checkBox_all');
      var checkBoxInput = $('.s_list__checkBox');
      var isChecked = checkBoxAll.prop('checked');

      this.checkBoxArr = [];

      if (isChecked) {
        checkBoxAll.prop('checked', false);
        checkBoxInput.prop('checked', false);
      } else {
        checkBoxAll.prop('checked', true);
        checkBoxInput.prop('checked', true);

        $('.s_list__checkBox').each(function(idx) {
          var checkbox = $(this);
          
          if (_this.training[idx].state !== '501') {
            checkbox.prop('checked', true);
            _this.checkBoxArr.push({ 'training_seq' : checkbox.val() });
          }
        });
      }
    },

    // 개별 체크박스 체크할 경우
    clickCheckBox:function(list) {
      var _this = this;
      var checkBox = $('.m_list__checkBox');
      var checkBoxInput = '';
      var key = list.no - 1;
      
      if (list.state == '501') {
        alert('이미 승인완료된 훈련계획서 입니다.');
        return false;
      }

      checkBox.each(function(idx) {
        if (idx == key) {
          checkBoxInput = $('.s_list__checkBox').eq(key);
          checkedVal = checkBoxInput.val();

          if (checkBoxInput.prop('checked')) {
            checkBoxInput.prop('checked', false);
            _this.sortCheckBoxArr(false, checkedVal);
          } else {
            checkBoxInput.prop('checked', true);
            _this.sortCheckBoxArr(true, checkedVal);
          }
        }
      });
    },

    // 체크박스 리스트 정렬
    sortCheckBoxArr:function(flag, seq) {
      var _this = this;
      var train_seq = '';

      if (flag) { // 모두 체크했을 때
        this.checkBoxArr.push({ 'training_seq' : seq });
      } else { // 개별 체크했을 때
        this.checkBoxArr.forEach(function(arr, idx) {
          train_seq = arr.training_seq;

          if (train_seq == seq) {
            _this.checkBoxArr.splice(idx, 1);
          }
        });
      }
    },

    // 테이블 선택 시 hightlight
    highlight:function(no) {
      $('.l_list__table_tr').removeClass('highlight');
      $('.l_list__table_tr').eq(no).addClass('highlight');
    },
  },
  mounted:function(){
    this.getSessionInfo();
  },
  created:function(){
    eventBus.$emit("menuinfo");
    eventBus.$emit("menudrop", [5,1]);

    if (sessionStorage.getItem('groupcode') == 'ADMIN') {
      this.setDate();
      this.loadTrainingPlanSelectBoxList();
      this.loadTrainingList();
      this.loadCalendar();
    }
  }
});

var cont_ledaer = new Vue({
  el:"#icContent_leader",
  data:{
    // api
    api_select_box: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_item_custom.asp',
    api_select_box_facility: 'http://ic.sportsdiary.co.kr/api/menu_control/selected_facility.asp',
    api_training_assoc_list: 'http://ic.sportsdiary.co.kr/api/training_manager/training_assoc_list.asp',
    api_training_assoc_add: 'http://ic.sportsdiary.co.kr/api/training_manager/training_assoc_add.asp',
    api_training_assoc_update: 'http://ic.sportsdiary.co.kr/api/training_manager/training_assoc_modify.asp',
    api_training_assoc_remove: 'http://ic.sportsdiary.co.kr/api/training_manager/training_assoc_del.asp', 
    // 세션에서 가져온 사용자 정보
    groupcode:'', // 그룹코드
    username: '', // 사용자 이름
    sportscode: '', // 종목
    
    trainigInfo: [],
    // 셀렉트 박스
    year: '', // 년도
    month: '', // 월
    s_year: [], // 년도 셀렉트박스 array
    s_month: [], // 월 셀렉트박스 array
    nowdate: '', // 현재 날짜
    
    // 팝업 훈련계획서 항목
    schedule_total: 0, // 훈련항목 total
    training_seq: '', // 훈련구분
    writer: '', // 작성자
    training_date: '', // 훈련일자
    competition: 'SP0023', // 종목
    division: 'TP0001', // 훈련구분
    obstacle: 'DT0001', // 장애유형
    leader: '', // 지도자
    player_male: '', // 선수 (남)
    player_female: '', // 선수 (여)
    etc: '', // 기타
    sportsReadOnly: '', // 종목 (읽기만 가능)
    sports: [], // 종목 셀렉트 박스 array
    train_purpose: [], // 훈련
    disabled_type: [],
    // 팝업 훈련계획서 등록 및 수정
    // 패널
    quarter: [], // 동/관 셀렉트박스 array
    facility: [], // 시설 셀렉트박스 array
    hours: [], // 시간 셀렉트박스 array
    minutes: [], // 분 셀렉트박스 array
    // 내용
    schedules: [], // api에 request로 넘겨줄 훈련내용
    schedule: [], // api에서 받아온 훈련내용
    train_plan_idx: '', // 해당 훈련내용의 id
    train_plan: [ // 훈련내용 (새벽,오전,오후,야간)
      {
        title: '새벽훈련',
        trainingtime: '1',
        quarter_seq: '0',
        quarter: '',
        facility_seq: '0',
        facility: [],
        stime: '',
        etime: '',
        start_hour: '00',
        end_hour: '00',
        start_minute: '00',
        end_minute: '00',
        special_note: '',
        comment: '',
      },{
        title: '오전훈련',
        trainingtime: '2',
        quarter_seq: '0',
        quarter: '',
        facility_seq: '0',
        facility: [],
        stime: '',
        etime: '',
        start_hour: '00',
        end_hour: '00',
        start_minute: '00',
        end_minute: '00',
        special_note: '',
        comment: '',
      },{
        title: '오후훈련',
        trainingtime: '3',
        quarter_seq: '0',
        quarter: '',
        facility_seq: '0',
        facility: [],
        stime: '',
        etime: '',
        start_hour: '00',
        end_hour: '00',
        start_minute: '00',
        end_minute: '00',
        special_note: '',
        comment: '',
      },{
        title: '야간훈련',
        trainingtime: '4',
        quarter_seq: '0',
        quarter: '',
        facility_seq: '0',
        facility: [],
        stime: '',
        etime: '',
        start_hour: '00',
        end_hour: '00',
        start_minute: '00',
        end_minute: '00',
        special_note: '',
        comment: '',
      }
    ],
    // 페이지네이션
    pageMax:null,
    pageCount:0,
    pageNo:0,
    // flag
    isChange: false, // 동/관을 선택했는가
    showAddPopup: false, 
    showUpdatePopup: false,
  },
  watch:{
    isChange:function() {
      this.changeFacilitySelectBoxList();
    },
  },
  methods:{
    // 세션 정보 가져오기
    getSessionInfo:function() {
      this.groupcode = sessionStorage.getItem('groupcode');
      this.username = sessionStorage.getItem('username');
      this.sportscode = sessionStorage.getItem('sports_code');
    },

    // 현재 날짜 설정
    setDate:function() {
      var date = new Date();
      var yy = date.getFullYear();
      var mm = date.getMonth() + 1;

      this.year = yy;
      this.month = mm;
    },

    // 달력 불러오기
    loadAddCalendar:function() {
      var train_calendar_add = document.querySelector("#training_date_add");
      flatpickr(train_calendar_add,{
        locale:"ko",
      });
    },

    loadUpdateCalender:function() {
      var train_calendar_update = document.querySelector("#training_date_update");
      flatpickr(train_calendar_update,{
        locale:"ko",
      });
    },

    // 년도, 월 셀렉트 박스 설정
    setSelectBox:function() {
      var date=new Date();
      var year = date.getFullYear();

      // 년도
      for (var j = 2015; j < year + 1; j++) {
        this.s_year.push(String(j));
      }

      // 월
      for(var i = 0; i < 12; i++) {
        this.s_month.push(String(i + 1));
      }

      // 시간
      for(var j = 0; j <= 23; j++) {
        if (String(j).split('').length == 1) this.hours.push('0' + j);
        else this.hours.push(String(j));
      }

      for(var k = 0; k < 6; k++) {
        this.minutes.push(k + '0');
      }
    },

    // 셀렉트 박스에서 월 가져오기 (계산)
    getSelectBoxMonth:function() {
      var mm = this.month.toString();

      if (mm.split('').length < 2) return mm = '0' + mm;
      else return mm;
    },

    // 훈련계획서 팝업창 종목 설정
    setTrainingSports:function() {
      var _this = this;
      _this.sports.forEach(function(item, idx) {
        if (item.seq == _this.sportscode) {
          _this.sportsReadOnly = item.title;
        }
      });
    },

    // 훈련계획서 셀렉트 박스 가져오기
    loadTrainingPlanSelectBoxList:function() {
      var _this = this;

      _this.sports = selected_item.SP;
      _this.train_purpose = selected_item.TP;
      _this.disabled_type = selected_item.DT;
      _this.quarter = selected_item.QT;
      _this.facility = selected_item.facility;
      
    },

    // 훈련계획 리스트 조회
    loadTrainingAssocList:function() {
      var _this=this;
      var month = this.getSelectBoxMonth();

      this.nowdate = this.year + '-' + month;

      axios.post(_this.api_training_assoc_list,{
        nowdate: _this.nowdate,
        page:_this.pageNo+1,
        pagesize:5
      }).then(function(response){
        if(response.data.state=="true"){
          _this.trainigInfo = response.data.training;
          _this.pageMax=Number(Math.ceil(response.data.total/5));
        }else {
          if (response.data.errorcode == 'ERR-130') {
            _this.trainigInfo = [];
          }
        }
      }).catch(function(error){
        console.log("훈련계획 list error : ");
        console.log(error);
      }).finally(function() {
        // _this.loadCalendar();
        _this.setTrainingSports();
      });
    },

    // 훈련계획서 셀렉트 박스 change 감지
    changeQuarter:function(idx) {
      this.isChange = true;
      this.train_plan_idx = idx;
    },

    // 훈련계획서 동/관에 따른 호실 셀렉트 박스 change
    changeFacilitySelectBoxList:function() {
      var _this = this;

      _this.train_plan[_this.train_plan_idx].facility_seq = '0';
      _this.train_plan.forEach(function(item, idx) {
        var tp = item;

        tp.facility = [];

        if (item.quarter_seq !== '0' && item.quarter_seq !== undefined) {
          _this.facility.forEach(function(fc) {
            if (tp.quarter_seq == fc.quarter_seq) {
              tp.facility.push(fc);
            }
          });
        } else {
          tp.facility_seq = '0';
        }
      });

      this.isChange = false;
    },

    // 훈련계획서 등록
    addTrainingAssoc:function() {
      var _this = this;
      var traintime = '';
      var q_seq = '';
      var f_seq = '';
      var stime = '';
      var etime = '';
      var special_note = '';
      var comment = '';
      var validation = true;
      
      validation = this.validationTrainigPlan();
      if (!validation) { return false; }

      this.train_plan.forEach(function(item) {
        traintime = item.trainingtime;
        q_seq = item.quarter_seq;
        f_seq = item.facility_seq;
        stime = item.start_hour + ':' + item.start_minute;
        etime = item.end_hour + ':' + item.end_minute;
        special_note = item.special_note;
        comment = item.comment.replace(/(?:\r\n|\r|\n)/g, '<br/>');
        
        _this.schedules.push({ 'trainingtime': traintime, 'quarter_seq': q_seq, 'facility_seq': f_seq, 'stime': stime, 'etime': etime, 'special_note': special_note, 'comment': comment });
      });

      axios.post(_this.api_training_assoc_add,{
        training_seq: _this.training_seq,
        date: _this.training_date,
        sports_seq: _this.sportscode,
        trainpurpose_seq: _this.division,
        desabledstate_seq: _this.obstacle,
        trainers: _this.leader,
        man: _this.player_male,
        woman: _this.player_female,
        etc: _this.etc,
        Schedule: _this.schedules
      }).then(function(response){
        if (response.data.state=="true"){
          console.log('훈련계획서 등록 완료');
        }
      }).catch(function(error){
        console.log("훈련계획서 등록 error : ");
        console.log(error);
      }).finally(function() {
        _this.closePopup('#l_popup__trainig_plan_add');
        _this.loadTrainingAssocList();
      });
    },

    // 훈련계획서 수정
    updateTrainingAssoc:function() {
      var _this = this;
      var traintime = '';
      var q_seq = '';
      var f_seq = '';
      var stime = '';
      var etime = '';
      var special_note = '';
      var comment = '';
      var validation = true;

      validation = this.validationTrainigPlan();
      if (!validation) { return false; }

      var result = confirm('수정하시겠습니까?');
      if (!result) { return false; }

      this.train_plan.forEach(function(item) {
        traintime = item.trainingtime;
        q_seq = item.quarter_seq;
        f_seq = item.facility_seq;
        stime = item.start_hour + ':' + item.start_minute;
        etime = item.end_hour + ':' + item.end_minute;
        special_note = item.special_note;
        comment = item.comment.replace(/(?:\r\n|\r|\n)/g, '<br/>');
        
        _this.schedules.push({ 'trainingtime': traintime, 'quarter_seq': q_seq, 'facility_seq': f_seq, 'stime': stime, 'etime': etime, 'special_note': special_note, 'comment': comment });
      });

      axios.post(_this.api_training_assoc_update,{
        training_seq: _this.training_seq,
        date: _this.training_date,
        sports_seq: _this.sportscode,
        trainpurpose_seq: _this.division,
        desabledstate_seq: _this.obstacle,
        trainers: _this.leader,
        man: _this.player_male,
        woman: _this.player_female,
        etc: _this.etc,
        Schedule: _this.schedules
      }).then(function(response){
        if (response.data.state=="true"){
          console.log('훈련계획서 수정 완료');
        }
      }).catch(function(error){
        console.log("훈련계획서 수정 error : ");
        console.log(error);
      }).finally(function() {
        _this.closePopup('#l_popup__trainig_plan_update');
        _this.loadTrainingAssocList();
      });
    },

    // 훈련계획서 삭제
    removeTrainingAssoc:function() {
      var _this = this;
      var result = confirm('삭제하시겠습니까?');

      if (!result) { return false; }
      axios.post(_this.api_training_assoc_remove,{
        training_seq: _this.training_seq,
      }).then(function(response){
        if (response.data.state=="true"){
          console.log('훈련계획서 삭제 완료');
        }
      }).catch(function(error){
        console.log("훈련계획서 삭제 error : ");
        console.log(error);
      }).finally(function() {
        _this.closePopup('#l_popup__trainig_plan_update');
        _this.loadTrainingAssocList();
      });
    },

    // 훈련계획서 최초 설정
    initTrainingAssoc:function() {
      var _this = this;

      _this.writer = _this.username;
      _this.showAddPopup = true;

      this.train_plan.forEach(function(item, idx) {
        item.quarter = _this.quarter;
      });

      this.openPopup('add');
    },

    // 개별 훈련계획서 불러오기 
    getTrainingAssoc:function(list){
      this.schedule_total = 0;
      this.training_seq = list.training_seq;
      this.writer = list.cochename;
      this.training_date = list.date;
      this.competition = list.sports_seq;
      this.division = list.trainpurpose_seq;
      this.obstacle = list.desabledstate_seq;
      this.leader = list.trainers;
      this.player_male = list.man;
      this.player_female = list.woman;
      this.etc = list.etc;
      this.schedule = list.Schedule;

      this.getScheduleFacility();
    },

    // 스케쥴 시설 셀렉트 박스 선작업 (싱크를 맞추기 위함)
    getScheduleFacility:function() {
      var _this = this;
      var tempFacility = [];

      this.schedule.forEach(function(item, idx) {
        var sc = item;
        var index = idx;

        _this.facility.forEach(function(fc) {
          if (sc.quarter_seq == fc.quarter_seq) {
            tempFacility.push(fc);
          }
        });

        _this.train_plan[index].facility = tempFacility;
      });
      
      _this.getSchedule();
    },

    // 스케쥴 나머지 데이터 가져오기
    getSchedule:function() {
      var _this = this;

      this.schedule.forEach(function(item, idx) {
        if (item.quarter_seq == '' || item.quarter_seq == undefined) _this.train_plan[idx].quarter_seq = '0';
        else _this.train_plan[idx].quarter_seq = item.quarter_seq;

        if (item.facility_seq == '' || item.facility_seq == undefined) _this.train_plan[idx].facility_seq = '0';
        else _this.train_plan[idx].facility_seq = item.facility_seq;

        if (item.stime == '') {
          _this.train_plan[idx].start_hour = '00';
          _this.train_plan[idx].start_minute = '00';
        } else {
          _this.train_plan[idx].start_hour = item.stime.split(':')[0];
          _this.train_plan[idx].start_minute = item.stime.split(':')[1];
        }
        
        if (item.etime == '') {
          _this.train_plan[idx].end_hour = '00';
          _this.train_plan[idx].end_minute = '00';
        } else {
          _this.train_plan[idx].end_hour = item.etime.split(':')[0];
          _this.train_plan[idx].end_minute = item.etime.split(':')[1];
        }

        _this.train_plan[idx].special_note = item.special_note;
        _this.train_plan[idx].comment = item.comment.split('<br/>').join("\r\n");
        _this.train_plan[idx].quarter = _this.quarter;
      });
      
      this.showUpdatePopup = true;
      this.openPopup('update');
    },

    // 훈련계획서 유효성 검사
    validationTrainigPlan:function() {
      if (this.training_date == '') {
        alert('훈련일자를 입력해 주세요.');
        return false;
      }
      
      if (this.leader == '') {
        alert('지도자 인원수를 입력해 주세요.');
        return false;
      }

      if (this.player_male == '') {
        alert('남자 선수 인원수를 입력해 주세요.');
        return false;
      }

      if (this.player_female == '') {
        alert('여자 선수 인원수를 입력해 주세요.');
        return false;
      }

      if (this.etc == '') {
        alert('기타 인원수를 입력해 주세요.');
        return false;
      }

      return true;
    },

    // 훈련계획서 리셋
    resetTrainingAssoc:function(){
      this.training_seq = '';
      this.writer = '';
      this.training_date = '';
      this.competition = 'SP0035';
      this.division = 'TP0001';
      this.obstacle = 'DT0001';
      this.leader = '';
      this.player_male = '';
      this.player_female = '';
      this.etc = '';
      this.schedule = [];
      this.schedules = [];
      this.train_plan = [
        {
          title: '새벽훈련',
          trainingtime: '1',
          quarter_seq: '0',
          quarter: '',
          facility_seq: '0',
          facility: [],
          stime: '',
          etime: '',
          start_hour: '00',
          end_hour: '00',
          start_minute: '00',
          end_minute: '00',
          special_note: '',
          comment: '',
        },{
          title: '오전훈련',
          trainingtime: '2',
          quarter_seq: '0',
          quarter: '',
          facility_seq: '0',
          facility: [],
          stime: '',
          etime: '',
          start_hour: '00',
          end_hour: '00',
          start_minute: '00',
          end_minute: '00',
          special_note: '',
          comment: '',
        },{
          title: '오후훈련',
          trainingtime: '3',
          quarter_seq: '0',
          quarter: '',
          facility_seq: '0',
          facility: [],
          stime: '',
          etime: '',
          start_hour: '00',
          end_hour: '00',
          start_minute: '00',
          end_minute: '00',
          special_note: '',
          comment: '',
        },{
          title: '야간훈련',
          trainingtime: '4',
          quarter_seq: '0',
          quarter: '',
          facility_seq: '0',
          facility: [],
          stime: '',
          etime: '',
          start_hour: '00',
          end_hour: '00',
          start_minute: '00',
          end_minute: '00',
          special_note: '',
          comment: '',
        }
      ];
    },

    // 훈련계획서 페이징
    pageMove:function(idx){
      var _this=this;
      _this.pageNo=idx;
      _this.loadTrainingAssocList();
    },
    pageJump:function(cnt){
      var _this=this;
      _this.pageNo=cnt*5;
      if(cnt<=-1){
        _this.pageNo=0;
        _this.loadTrainingAssocList();
        return;
      }
      if(_this.pageNo>_this.pageMax-1){
        _this.pageNo=_this.pageMax-1;
        _this.loadTrainingAssocList();
        return;
      }
      _this.pageCount=cnt;
      _this.loadTrainingAssocList();
    },

    // 팝업 열기
    openPopup:function(popup) {
      var _this = this;
      $('#l_popup__dimm').addClass('active');

      setTimeout(function() {
        if (popup == 'add') _this.loadAddCalendar();
        else _this.loadUpdateCalender();
      }, 500);
    },

    // 팝업 닫기
    closePopup:function(popup) {
      this.showAddPopup = false;
      this.showUpdatePopup = false;
      $('#l_popup__dimm').removeClass('active');

      this.resetTrainingAssoc();
    },
  },

  mounted:function(){// 달력 관련
    this.getSessionInfo();
  },

  created:function(){
    // 현재 메뉴(위치) 확인
    eventBus.$emit("menuinfo");
    eventBus.$emit("menudrop", [5,1]);

    if (sessionStorage.getItem('groupcode') == 'ASSOCIATION') {
      this.setDate();
      this.setSelectBox();
      this.loadTrainingAssocList();
      this.loadTrainingPlanSelectBoxList();
    }
  }
});
</script>
</body>
</html>