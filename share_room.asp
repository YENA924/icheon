<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<div id="icContent_wrap">
  <section id="icContent_admin" class="l_ct l_share_room" v-if="groupcode == 'ADMIN'" v-cloak>
    <!-- s.관리자 페이지 숙소배정 -->
    <div class="l_content">
      <!-- 컨텐츠 영역. s. -->
      <h2>숙소배정 및 승인</h2>
    
      <div class="l_search_box">
        <div class="l_search_field">
          <div class="l_field">
            <label for="sdate">기간선택</label>
            <div class="l_field__date">
              <input type="text" name="a_date" id="sdate" class="sdate" placeholder="날짜선택" value="" v-model="sdate">
              <button class="l_btn_calendar" style="left:226px;"><img src="/front/img/icon_calendar.svg" alt="달력선택"></button>
            </div>
            <p class="l_field__s_character">~</p>
            <div class="l_field__date">
              <input type="text" name="edate" id="edate" class="edate" placeholder="날짜선택" value="" v-model="edate">
              <button class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></button>
            </div>
          </div>
          <div class="l_field">
            <label for="sports">종목선택</label>
            <select name="sports" id="sports" v-model="sports_seq">
              <option value="">전체</option>
              <option v-for="(option,key) in selectInfo.sports" :key="option.title" :value="option.seq">{{option.title}}</option>
            </select>
          </div>
          <div class="l_search_btns">
            <button type="submit" class="s_white" @click="loadRoomApply(false)">조회</button>
          </div>
        </div>
      </div>
  
        <!-- 목록 테이블 형식. s. -->
        <div class="l_list_box">
          <div class="l_list_tablewrap top">
            <table>
              <caption>숙소배정 목록</caption>
              <thead>
                <tr>
                  <th>
                    <input class="s_list__checkBox_all" type="checkbox" name="list" value="" />
                    <i class="m_list__checkBox_all" @click="clickCheckBoxAll()"></i>
                  </th>
                  <th>번호</th>
                  <th>상태</th>
                  <th>소속단체명</th>
                  <th>종목</th>
                  <th>성별</th>
                  <th>훈련구분</th>
                  <th>입촌기간</th>
                  <th>인원수</th>
                  <th>호실배정</th>
                </tr>
              </thead>
              <tbody>
                <tr class="l_list__table_tr" v-for="(list,key) in assignInfo" :key="key" @click="loadAssignPlayerList(list, $event.target)">
                  <td>
                    <input class="s_list__checkBox" type="checkbox" name="room_seq" :value="list.lodging_seq" />
                    <i class="m_list__checkBox" @click="clickCheckBox(list)"></i>
                  </td>
                  <td>{{ list.no }}</td>
                  <td v-bind:class="{s_orange_txt: list.state == '101' || list.state == '103' || list.state == '', s_blue_txt: list.state == '102'}">
                    <template v-if="list.state == 100">선수배정대기</template>
                    <template v-else-if="list.state == 101">승인요청</template>
                    <template v-else-if="list.state == 102">재배정요청</template>
                    <template v-else-if="list.state == 103">재승인완료</template>
                    <template v-else-if="list.state == 104">승인완료</template>
                    <template v-else>호실배정대기</template>
                  </td>
                  <td>{{list.association_title}}</td>
                  <td>{{list.sports}}</td>
                  <td>{{list.gender}}</td>
                  <td>{{list.trainingtype}}</td>
                  <td>{{list.inoutdate}}</td>
                  <td>{{list.players_count}}명</td>
                  <td>
                    <p>총 <span class="s_blue_txt">{{list.room_count}}</span>실</p>
                    <button v-if="list.room_count == '0'" class="m_choice_btn s_orange" @click="loadAssignRoomList(list)">호실선택</button>
                    <button v-else class="m_choice_btn s_white" @click="loadAssignRoomList(list)">호실변경</button>
                  </td>
                </tr>
                <tr v-if="assignInfo.length == 0">
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
        </div>
        <div class="l_search_btns l_content_btns">
          <button type="submit" class="s_blue" @click="updateApprovalAssign('Y')">승인</button>
          <button type="submit" class="s_gray" @click="updateApprovalAssign('N')">재배정 요청</button>
        </div>
        <!-- 목록 테이블 형식. s. -->
        <div class="l_list_box s_sub_list_box hide">
          <div class="l_list_tablewrap bottom">
            <table>
              <caption>기구 정보 목록</caption>
              <thead>
                <tr>
                  <th>번호</th>
                  <th>종목</th>
                  <th>직위</th>
                  <th>성명</th>
                  <th>성별</th>
                  <th>생년월일</th>
                  <th>장애여부</th>
                  <th>장애유형</th>
                  <th>입촌시작</th>
                  <th>입촌종료</th>
                  <th>호실</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(list,key) in playerInfo" :key="key" v-bind:class="{s_orange_border: list.state == '301'}">
                  <td>{{list.no}}</td>
                  <td>{{list.sports}}</td>
                  <td>{{list.position}}</td>
                  <td>{{list.name}}</td>
                  <td>{{list.gender}}</td>
                  <td>{{list.birthday}}</td>
                  <td>{{list.disabledstate}}</td>
                  <td>{{list.disabledtype}}</td>
                  <td>{{list.sdate}}</td>
                  <td>{{list.edate}}</td>
                  <td>{{list.number}}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      <!-- 컨텐츠 영역. e. -->
    </div>
    <!-- 호실선택 팝업 -->
    <transition name="fade">
      <div id="l_popup__choice_room" class="m_popup m_share_room__popup m_share_choice_room__popup" v-if="showPopup">
      <div class="m_popup__title">
        <h1>호실선택</h1>
        <div class="m_popup__panel">
          <div class="m_panel__room">
            <p>총 <span class="s_blue_txt">{{ number_of_room }}</span> 개실 선택( 2인실-<span class="s_blue_txt">{{ number_two_room }}개</span> 3인실-<span class="s_blue_txt">{{ number_three_room }}개</span>)</p>
          </div>
          <div class="m_panel__people">
            <p>정원</p>
            <span class="s_orange_txt">{{ click_player_count }}</span>/<span class="s_blue_txt">{{ players_count }}</span>
            <p>인</p>
          </div>
        </div> 
      </div>
      
      <div class="m_popup__room_wrap m_vertical">
          <!-- *01호 -->
          <div class="m_room__row">
            <div class="m_room__title">
              <p>1층</p>
            </div>
              <!-- 숙소 하나 -->
              <template v-for="(room,key) in roomInfo1" :key="key" >
                <div class="m_room__wrap">
                  <div class="m_room__number">
                    <div class="m_room__input">
                      <input class="s_room__checkBox" type="checkbox" name="room" :value="room.seq" />
                      <i class="m_room__checkBox" @click="clickAssignRoom(room, $event.target)"></i>
                    </div>
                    <p class="m_number">{{room.number}} 호</p>
                  </div>
                  <div class="m_room">
                    <template v-for="(player,key) in room.player" :key="key">
                      <div class="m_room__people">
                        <img src="/front/img/num_stayed_peopole.png" />
                        <span class="m_name">{{ player.name }}</span>
                      </div>
                    </template>
                  </div>
                </div>
              </template>
            </div>
          <!-- *01호 -->
          <!-- *02호 -->
          <div class="m_room__row">
            <div class="m_room__title">
              <p>2층</p>
            </div>
              <!-- 숙소 하나 -->
              <template v-for="(room,key) in roomInfo2" :key="key" >
                <div class="m_room__wrap">
                  <div class="m_room__number">
                    <div class="m_room__input">
                      <input class="s_room__checkBox" type="checkbox" name="room" :value="room.seq" />
                      <i class="m_room__checkBox" @click="clickAssignRoom(room, $event.target)"></i>
                    </div>
                    <p class="m_number">{{room.number}} 호</p>
                  </div>
                  <div class="m_room">
                    <template v-for="(player,key) in room.player" :key="key">
                      <div class="m_room__people">
                        <img src="/front/img/num_stayed_peopole.png" />
                        <span class="m_name">{{ player.name }}</span>
                      </div>
                    </template>
                  </div>
                </div>
              </template>
            </div>
          <!-- *02호 -->
          <!-- *03호 -->
          <div class="m_room__row">
            <div class="m_room__title">
              <p>3층</p>
            </div>
              <!-- 숙소 하나 -->
              <template v-for="(room,key) in roomInfo3" :key="key" >
                <div class="m_room__wrap">
                  <div class="m_room__number">
                    <div class="m_room__input">
                      <input class="s_room__checkBox" type="checkbox" name="room" :value="room.seq" />
                      <i class="m_room__checkBox" @click="clickAssignRoom(room, $event.target)"></i>
                    </div>
                    <p class="m_number">{{room.number}} 호</p>
                  </div>
                  <div class="m_room">
                    <template v-for="(player,key) in room.player" :key="key">
                      <div class="m_room__people">
                        <img src="/front/img/num_stayed_peopole.png" />
                        <span class="m_name">{{ player.name }}</span>
                      </div>
                    </template>
                  </div>
                </div>
              </template>
            </div>
          <!-- *03호 -->
          <!-- *04호 -->
          <div class="m_room__row">
              <div class="m_room__title">
                <p>4층</p>
              </div>
              <!-- 숙소 하나 -->
              <template v-for="(room,key) in roomInfo4" :key="key" >
                <div class="m_room__wrap">
                  <div class="m_room__number">
                    <div class="m_room__input">
                      <input class="s_room__checkBox" type="checkbox" name="room" :value="room.seq" />
                      <i class="m_room__checkBox" @click="clickAssignRoom(room, $event.target)"></i>
                    </div>
                    <p class="m_number">{{room.number}} 호</p>
                  </div>
                  <div class="m_room">
                    <template v-for="(player,key) in room.player" :key="key">
                      <div class="m_room__people">
                        <img src="/front/img/num_stayed_peopole.png" />
                        <span class="m_name">{{ player.name }}</span>
                      </div>
                    </template>
                  </div>
                </div>
              </template>
            </div>
            <!-- *04호 -->
          </div>
          <div class="l_search_btns l_popup_btns">
            <button class="s_blue" @click="updateAssignRoom()">확인</button>
            <button class="s_white" @click="closePopup(l_popup__choice_room)">취소</button>
          </div>
      </div>
    </transition>
    <!-- e.관리자 페이지 숙소배정 -->
  </section>

  <section id="icContent_leader" class="l_ct l_share_room l_share_room_assignment" v-if="groupcode == 'ASSOCIATION'" v-cloak>
    <!-- s.종목별 지도자 페이지 숙소배정 -->
    <div class="l_content">
      <!-- 컨텐츠 영역. s. -->
      <h2>숙소배정</h2>

      <div class="l_search_box">
        <div class="l_search_field">
          <div class="l_field">
            <label for="sdate">기간선택</label>
            <div class="l_field__date">
              <input type="text" name="sdate" id="sdate" class="sdate" placeholder="날짜선택" value="" v-model="sdate">
              <button class="l_btn_calendar" style="left:226px;"><img src="/front/img/icon_calendar.svg" alt="달력선택"></button>
            </div>
            <p class="l_field__s_character">~</p>
            <div class="l_field__date">
              <input type="text" name="edate" id="edate" class="edate" placeholder="날짜선택" value="" v-model="edate">
              <button class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></button>
            </div>
          </div>
          <div class="l_search_btns">
            <button type="submit" class="s_white" @click="loadSportsList(false)">조회</button>
          </div>
        </div>
      </div>
  
      <!-- 목록 테이블 형식. s. -->
      <div class="l_list_box">
        <div class="l_list_tablewrap top">
          <table>
            <caption>종목별 지도자 숙소 배정 목록</caption>
            <thead>
              <tr>
                <th>
                  <input class="s_list__checkBox_all" type="checkbox" name="list" value="" />
                  <i class="m_list__checkBox_all" @click="clickCheckBoxAll()"></i>
                </th>
                <th>번호</th>
                <th>상태</th>
                <th>소속단체명</th>
                <th>종목</th>
                <th>성별</th>
                <th>훈련구분</th>
                <th>입촌기간</th>
                <th>인원수</th>
                <th>호실배정</th>
              </tr>
            </thead>
            <tbody>
              <tr class="l_list__table_tr" v-for="(list, key) in assignInfo" :key="key" @click="loadAssignSportsPlayerList(list)">
                <td>
                  <input class="s_list__checkBox" type="checkbox" name="room_seq" :value="list.lodging_seq" />
                  <i class="m_list__checkBox" @click="clickCheckBox(list)"></i>
                </td>
                <td>{{ list.no }}</td>
                <td v-bind:class="{s_blue_txt: list.state == '101' || list.state == '103', s_orange_txt: list.state == '100' || list.state == '102' || list.state == ''}">
                  {{ list.state == '100' ? '선수배정요청' : list.state == '101' ? '승인요청' : list.state == '102' ? '재배정요청' : list.state == '103' ? '재승인요청' : list.state == '104' ? '승인' : '호실배정대기'}}
                </td>
                <td>{{ list.association_title }}</td>
                <td>{{ list.sports }}</td>
                <td>{{ list.gender }}</td>
                <td>{{ list.trainingtype }}</td>
                <td>{{ list.inoutdate }}</td>
                <td>{{ list.players_count }}</td>
                <td>
                  <p>총<span class="s_blue_txt">{{ list.room_count }}</span>실</p>
                </td>
              </tr>
              <tr v-if="assignInfo.length == 0">
                <td colspan="14">
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
      </div>
      <div class="l_search_btns l_content_btns">
        <button type="submit" class="s_blue" @click="updateAssignSports()">배정 승인 요청</button>
        <button type="submit" class="s_white" @click="loadAssignSportsRoomList(true)">배정호실 보기</button>
      </div>
      <!-- 목록 테이블 형식. s. -->
      <div class="l_list_box s_sub_list_box hide">
        <div class="l_list_tablewrap bottom">
          <table>
            <caption>종목별 선수 목록</caption>
            <thead>
              <tr>
                <th>번호</th>
                <th>종목</th>
                <th>직위</th>
                <th>성명</th>
                <th>성별</th>
                <th>생년월일</th>
                <th>장애여부</th>
                <th>장애유형</th>
                <th>입촌시작</th>
                <th>입촌종료</th>
                <th>호실</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(list,key) in playerInfo" :key="key">
                <td>{{list.no}}</td>
                <td>{{list.sports}}</td>
                <td>{{list.position}}</td>
                <td>{{list.name}}</td>
                <td>{{list.gender}}</td>
                <td>{{list.birthday}}</td>
                <td>{{list.disabledstate}}</td>
                <td>{{list.disabledtype}}</td>
                <td>{{list.sdate}}</td>
                <td>{{list.edate}}</td>
                <td>
                  <p v-if="list.number == ''">미지정</p>
                  <p v-else>{{list.number}}</p>
                    <template v-if="stateChk">
                      <button class="m_relocation_btn s_orange" v-if="list.state !== '300' && list.state !== '303'" @click="loadAssignSportsBedList(list.no)">배정</button>
                      <button class="m_relocation_btn s_white" v-else @click="loadAssignSportsBedList(list.no)">재배정</button>
                    </template>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <!-- 컨텐츠 영역. e. -->
    </div>
      <!-- 배정 팝업 -->
      <transition name="fade">
        <div id="l_popup__bed_room" class="m_popup m_share_room__popup m_re_share_room__popup" v-if="showBedPopup">
          <div class="m_popup__title">
            <h1>{{ roomInfo.name }} 숙소배정</h1>
            <div class="m_popup__panel">
              <div class="m_panel">
                <span v-if="roomInfo.isAssign"><span>{{ roomInfo.number }}</span><p>호 배정됨</p></span>
                <span v-else><span>-</span><p>호 배정됨</p></span>
              </div>
            </div>
          </div>
          <div class="m_popup__room_wrap">
            <!-- *01호 -->
            <div class="m_room__row" v-if="assignRoomInfo1.length !== 0">
              <template v-for="(room, key) in assignRoomInfo1" :key="key">
                <div class="m_room__wrap">
                  <div class="m_room__number">
                    <div class="m_room__input">
                      <input class="s_room__radioBtn s_popup__radioBtn" type="radio" name="popup_room" :value="room.seq" :data-number="room.number"/>
                      <i class="m_field__radioBtn" @click="updateAssignSportsBed(room, $event.target)" :data-number="room.number"></i>
                    </div>
                    <p class="m_number">{{ room.number }}</p>
                  </div>
                  <div class="m_room">
                    <template v-for="(list, key) in room.fixed" :key="num">
                      <div class="m_room__people" :data-bed-info="list.BED_INFO" :data-number="room.number">
                        <img src="/front/img/num_stayed_peopole.png" />
                        <span class="m_name">{{ list.name }}</span>
                      </div>
                    </template>
                  </div>
                </div>
              </template>
            </div>
            <!-- 2층 -->
            <!-- *01호 -->
            <div class="m_room__row" v-if="assignRoomInfo2.length !== 0">
              <template v-for="(room, key) in assignRoomInfo2" :key="key">
                <div class="m_room__wrap">
                  <div class="m_room__number">
                    <div class="m_room__input">
                      <input class="s_room__radioBtn s_popup__radioBtn" type="radio" name="popup_room" :value="room.seq" :data-number="room.number"/>
                      <i class="m_field__radioBtn" @click="updateAssignSportsBed(room, $event.target)" :data-number="room.number"></i>
                    </div>
                    <p class="m_number">{{ room.number }}</p>
                  </div>
                  <div class="m_room">
                    <template v-for="(list, key) in room.fixed" :key="num">
                      <div class="m_room__people" :data-bed-info="list.BED_INFO" :data-number="room.number">
                        <img src="/front/img/num_stayed_peopole.png" />
                        <span class="m_name">{{ list.name }}</span>
                      </div>
                    </template>
                  </div>
                </div>
              </template>
            </div>
            <!-- 3층 -->
            <!-- *01호 -->
            <div class="m_room__row" v-if="assignRoomInfo3.length !== 0">
              <template v-for="(room, key) in assignRoomInfo3" :key="key">
                <div class="m_room__wrap">
                  <div class="m_room__number">
                    <div class="m_room__input">
                      <input class="s_room__radioBtn s_popup__radioBtn" type="radio" name="popup_room" :value="room.seq" :data-number="room.number"/>
                      <i class="m_field__radioBtn" @click="updateAssignSportsBed(room, $event.target)" :data-number="room.number"></i>
                    </div>
                    <p class="m_number">{{ room.number }}</p>
                  </div>
                  <div class="m_room">
                    <template v-for="(list, key) in room.fixed" :key="num">
                      <div class="m_room__people" :data-bed-info="list.BED_INFO" :data-number="room.number">
                        <img src="/front/img/num_stayed_peopole.png" />
                        <span class="m_name">{{ list.name }}</span>
                      </div>
                    </template>
                  </div>
                </div>
              </template>
            </div>
            <!-- 4층 -->
            <!-- *01호 -->
            <div class="m_room__row" v-if="assignRoomInfo4.length !== 0">
              <template v-for="(room, key) in assignRoomInfo4" :key="key">
                <div class="m_room__wrap">
                  <div class="m_room__number">
                    <div class="m_room__input">
                      <input class="s_room__radioBtn s_popup__radioBtn" type="radio" name="popup_room" :value="room.seq" :data-number="room.number"/>
                      <i class="m_field__radioBtn" @click="updateAssignSportsBed(room, $event.target)" :data-number="room.number"></i>
                    </div>
                    <p class="m_number">{{ room.number }}</p>
                  </div>
                  <div class="m_room">
                    <template v-for="(list, key) in room.fixed" :key="num">
                      <div class="m_room__people" :data-bed-info="list.BED_INFO" :data-number="room.number">
                        <img src="/front/img/num_stayed_peopole.png" />
                        <span class="m_name">{{ list.name }}</span>
                      </div>
                    </template>
                  </div>
                </div>
              </template>
            </div>
          </div>
          <div class="l_search_btns l_popup_btns">
            <!-- <button class="s_blue" @click="updateAssignSportsBedSave()">확인</button> -->
            <button class="s_white" @click="closePopup(l_popup__bed_room)">닫기</button>
          </div>
        </div>
      </transition>

      <!-- 배정호실 보기 팝업 -->
      <transition name="fade">
        <div id="l_popup__share_room" class="m_popup m_share_room__popup m_share_room_read__popup" v-if="showSharePopup">
          <div class="m_popup__title">
            <h1>배정호실 보기</h1>
            <div class="m_popup__panel">
              <div class="m_panel">
                <p>{{ association_title }}</p>
              </div>
              <div class="m_panel">
                <p>총원</p>
                <span class="s_blue_txt">{{ playerTot }}</span>
                <p>명</p>
              </div>
              <div class="m_panel">
                <p>호실</p>
                <span class="s_blue_txt">{{ room_count }}</span>
                <p>개 배정됨</p>
              </div>
            </div>
          </div>
          <div class="m_popup__room_wrap">
            <!-- *01호 -->
            <div class="m_room__row" v-if="assignRoomInfo1.length !== 0">
              <template v-for="(room, key) in assignRoomInfo1" :key="key">
                <div class="m_room__wrap">
                  <div class="m_room__number">
                    <p class="m_number">{{ room.number }}</p>
                  </div>
                  <div class="m_room">
                    <template v-for="(list, key) in room.fixed" :key="num">
                      <div class="m_room__people" :data-bed-info="list.BED_INFO">
                        <img src="/front/img/num_stayed_peopole.png" />
                        <span class="m_name">{{ list.name }}</span>
                      </div>
                    </template>
                  </div>
                </div>
              </template>
            </div>
            <!-- 2층 -->
            <!-- *01호 -->
            <div class="m_room__row" v-if="assignRoomInfo2.length !== 0">
              <template v-for="(room, key) in assignRoomInfo2" :key="key">
                <div class="m_room__wrap">
                  <div class="m_room__number">
                    <p class="m_number">{{ room.number }}</p>
                  </div>
                  <div class="m_room">
                    <template v-for="(list, key) in room.fixed" :key="num">
                      <div class="m_room__people" :data-bed-info="list.BED_INFO">
                        <img src="/front/img/num_stayed_peopole.png" />
                        <span class="m_name">{{ list.name }}</span>
                      </div>
                    </template>
                  </div>
                </div>
              </template>
            </div>
            <!-- 3층 -->
            <!-- *01호 -->
            <div class="m_room__row" v-if="assignRoomInfo3.length !== 0">
              <template v-for="(room, key) in assignRoomInfo3" :key="key">
                <div class="m_room__wrap">
                  <div class="m_room__number">
                    <p class="m_number">{{ room.number }}</p>
                  </div>
                  <div class="m_room">
                    <template v-for="(list, key) in room.fixed" :key="num">
                      <div class="m_room__people" :data-bed-info="list.BED_INFO">
                        <img src="/front/img/num_stayed_peopole.png" />
                        <span class="m_name">{{ list.name }}</span>
                      </div>
                    </template>
                  </div>
                </div>
              </template>
            </div>
            <!-- 4층 -->
            <!-- *01호 -->
            <div class="m_room__row" v-if="assignRoomInfo4.length !== 0">
              <template v-for="(room, key) in assignRoomInfo4" :key="key">
                <div class="m_room__wrap">
                  <div class="m_room__number">
                    <p class="m_number">{{ room.number }}</p>
                  </div>
                  <div class="m_room">
                    <template v-for="(list, key) in room.fixed" :key="num">
                      <div class="m_room__people" :data-bed-info="list.BED_INFO">
                        <img src="/front/img/num_stayed_peopole.png" />
                        <span class="m_name">{{ list.name }}</span>
                      </div>
                    </template>
                  </div>
                </div>
              </template>
            </div>
          <div class="l_search_btns l_popup_btns">
            <button class="s_blue" @click="closePopup(l_popup__share_room)">확인</button>
          </div>
          </div>
        </div>
      </transition>
  <!-- e.종목별 지도자 페이지 숙소배정 -->
  </section>
</div>

<script>
var cont_admin = new Vue({
  el:"#icContent_admin",
  data:{
    // api
    api_selected_item:"http://ic.sportsdiary.co.kr/api/menu_control/selected_item_custom.asp",
    api_assign_list:"http://ic.sportsdiary.co.kr/api/assign_manager/assign_list.asp",
    api_assign_player_list:"http://ic.sportsdiary.co.kr/api/assign_manager/assign_player_list.asp",
    api_assign_room_list:'http://ic.sportsdiary.co.kr/api/assign_manager/assign_room_list.asp',
    api_assign_room_update: 'http://ic.sportsdiary.co.kr/api/assign_manager/assign_room_update.asp',
    api_assign_approval_update: 'http://ic.sportsdiary.co.kr/api/assign_manager/assign_approval_update.asp',
    api_assign_player_update: 'http://ic.sportsdiary.co.kr/api/assign_manager/assign_player_update.asp',
    // 세션 정보
    groupcode: '',
    //셀렉트박스
    sdate: '', // 시작일
    edate: '', // 종료일
    sports_seq: '', // 종목 selected item
    selectInfo: {
      sports: [], // 종목 셀렉트박스 array
    },
    // 숙소배정단체, 숙소배정선수
    assingTot: '', // 숙소배정단체 total
    assignInfo: [], // 숙소배정단체 리스트
    playerTot: '', // 숙소배정선수 total
    playerInfo: [], // 숙소배정선수 리스트
    // 숙소배정 팝업
    p_playerInfo: [], // 해단 단체의 선수 정보
    assignPlayerInfo: [], // 단체 선수들의 숙소배정정보

    seq: '', // 룸 seq
    lodging_seq: '', // 숙소 seq
    center_seq: '', // 센터 seq
    players_count: '', // 단체 선수 인원수
    click_player_count: 0, // 방을 선택했을 때 방에 들어가는 인원수
    number_of_room: 0, // 선택한 방의 개수
    number_two_room: 0, // 선택한 2인실 수
    number_three_room: 0, // 선택한 3인실 수
    
    roomTot: '', // 숙소 total
    roomInfo1: [], // 1층
    roomInfo2: [], // 2층
    roomInfo3: [], // 3층
    roomInfo4: [], // 4층
    
    facility_seq: [], // 선택한 단체의 방배정 저장
    checkBoxArr:[], // 체크박스 array
    // flag
    showPopup: false,
  },
  methods:{
    // 세션에서 사용자 정보 가져오기
    getSessionInfo:function() {
      this.groupcode = sessionStorage.getItem('groupcode');
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

    // 숙소배정 셀렉트 박스 : 종목 불러오기
    loadSelectBoxSports:function(){
      var _this=this
      _this.selectInfo.sports = selected_item.SP;
    },

    // 숙소 요청 및 승인완료 리스트 가져오기
    loadRoomApply:function(flag) {
      var _this=this;

      axios.post(_this.api_assign_list,{
        sdate: _this.sdate,
        edate: _this.edate,
        sports_seq: _this.sports_seq
      }).then(function(response){
        if(response.data.state=="true"){
          _this.assignTot = response.data.total;
          _this.assignInfo = response.data.assign;
        } else {
          if (response.data.errorcode == 'ERR-130') {
            _this.assignInfo = [];
          }
        }
      }).catch(function(error){
        console.log("숙소배정단체 list error : ");
        console.log(error);
      }).finally(function(){
        console.log("숙소배정단체 list success");
        if (flag) _this.loadCalendar();
      });
    },

    // 숙소배정 선수 리스트 가져오기
    loadAssignPlayerList:function(list, target) {
      var _this = this;

      var playerTable = $('.s_sub_list_box');
      var radioBox = '';
      var tmpRoomInfo = [];

      if (list.players_count == '0' || list.players_count == '') {
        alert('해당 단체에 선수가 없습니다.');
        return false;
      }

      // 선수 목록 불러오기
      var assignPlayerInfo = axios.post(_this.api_assign_player_list,{
        seq: list.seq,
      });

      // 방 정보 불러오기
      var assignRoomInfo = axios.post(_this.api_assign_room_list,{
        seq: list.seq,
        lodging_seq: list.lodging_seq
      });

      // 한 번에 불러오기
      axios.all([
        assignPlayerInfo,
        assignRoomInfo
      ]).then(axios.spread(function(responseplayer, responseroom){
        if(responseplayer.data.state=="true"){
          _this.playerTot = responseplayer.data.total;
          _this.playerInfo = responseplayer.data.assign_player;

          _this.seq = list.seq;
          _this.lodging_seq = list.lodging_seq;

          playerTable.removeClass('hide');
        }

        if(responseroom.data.state=="true"){
          tmpRoomInfo = responseroom.data.room1;
          _this.center_seq = tmpRoomInfo[0].center_seq;
        }
      })).catch(function(errorplayer, errorroom){
        console.log("errorplayer : ");
        console.log(errorplayer);
        console.log("");
        console.log("errorroom : ");
        console.log(errorroom);
      }).finally(function() {
        _this.highlight(list.no - 1);
      });
    },

    // 숙소 배정 방 가져오기
    loadAssignRoomList:function(list) {
      var _this=this;

      // 선수가 없을 경우
      if (list.players_count == '0') {
        return false;
      }

      // 선수 목록 불러오기
      var assignPlayerInfo = axios.post(_this.api_assign_player_list,{
        seq: list.seq,
      });

      // 방 정보 불러오기
      var assignRoomInfo = axios.post(_this.api_assign_room_list,{
        seq: list.seq,
        lodging_seq: list.lodging_seq
      });

      // 한 번에 불러오기
      axios.all([
        assignPlayerInfo,
        assignRoomInfo
      ]).then(axios.spread(function(responseplayer, responseroom){
      // ]).then(axios.spread((...response)=>{
        if(responseplayer.data.state=="true"){
          _this.p_playerInfo = responseplayer.data.assign_player;
        }

        if(responseroom.data.state=="true"){
          _this.roomInfo1 = responseroom.data.room1;
          _this.roomInfo2 = responseroom.data.room2;
          _this.roomInfo3 = responseroom.data.room3;
          _this.roomInfo4 = responseroom.data.room4;
        }
      })).catch(function(errorplayer, errorroom){
        console.log("errorplayer : ");
        console.log(errorplayer);
        console.log("");
        console.log("errorroom : ");
        console.log(errorroom);
      }).finally(function() {
        _this.openPopup('#l_popup__choice_room');
        _this.getAssignRoomPlayer();
        _this.setRoomInfo(list.no);
        // _this.lodging_seq = list.lodging_seq;
        // _this.center_seq = _this.roomInfo1[0].center_seq; // 센터가 여러개일 경우 수정. 임시
      });
    },

    // 이미 숙소에 배정되어 있는 사람들 불러오기
    getAssignRoomPlayer:function() {
      var _this = this;
      var number = '', bed_info = '', name = '';
      var room_number = '', isEmpty = true;
      var roomInfoName = '';
      
      _this.assignPlayerInfo = [];

      // 해당 단체의 선수들 배정정보 가져오기
      this.p_playerInfo.forEach(function(player, idx) {
        number = player.number;
        bed_info = player.bed_info;
        name = player.name;

        if (number !== '' && bed_info !== '') {
          _this.assignPlayerInfo.push({ number: number, bed_info: bed_info, name: name });
        }
      });

      // 1층
      this.roomInfo1.forEach(function(room, idx) {
        room_number = room.number;
        room_fixed = room.fixed;
        room.player = [];

        if (room.room_seq !== '' && room.room_seq !== undefined) {
          $('.s_room__checkBox[value='+ room.seq+']').prop('checked', true);
            _this.facility_seq.push({ seq: room.seq, room_seq: room.room_seq });
        }

        for(var i = 0; i < room.fixed; i++){
          _this.assignPlayerInfo.forEach(function(player, no) {
            if (player.number == room_number && i + 1 == Number(player.bed_info)) {
              room.player.push(player);
              isEmpty = false;
            }
          });

          if (isEmpty) {
            room.player.push({ number: room_number, bed_info: String(i + 1), name: '-'})
          }

          isEmpty = true;
        }
      });

      // 2층
      this.roomInfo2.forEach(function(room, idx) {
        room_number = room.number;
        room_fixed = room.fixed;
        room.player = [];

        if (room.room_seq !== '' && room.room_seq !== undefined) {
          $('.s_room__checkBox[value='+ room.seq+']').prop('checked', true);
            _this.facility_seq.push({ seq: room.seq, room_seq: room.room_seq });
        }

        for(var i = 0; i < room.fixed; i++){
          _this.assignPlayerInfo.forEach(function(player, no) {
            if (player.number == room_number && i + 1 == Number(player.bed_info)) {
              room.player.push(player);
              isEmpty = false;
            }
          });

          if (isEmpty) {
            room.player.push({ number: room_number, bed_info: String(i + 1), name: '-'})
          }

          isEmpty = true;
        }
      });

      // 3층
      this.roomInfo3.forEach(function(room, idx) {
        room_number = room.number;
        room_fixed = room.fixed;
        room.player = [];

        if (room.room_seq !== '' && room.room_seq !== undefined) {
          $('.s_room__checkBox[value='+ room.seq+']').prop('checked', true);
            _this.facility_seq.push({ seq: room.seq, room_seq: room.room_seq });
        }

        for(var i = 0; i < room.fixed; i++){
          _this.assignPlayerInfo.forEach(function(player, no) {
            if (player.number == room_number && i + 1 == Number(player.bed_info)) {
              room.player.push(player);
              isEmpty = false;
            }
          });

          if (isEmpty) {
            room.player.push({ number: room_number, bed_info: String(i + 1), name: '-'})
          }

          isEmpty = true;
        }
      });

      // 4층
      this.roomInfo4.forEach(function(room, idx) {
        room_number = room.number;
        room_fixed = room.fixed;
        room.player = [];

        if (room.room_seq !== '' && room.room_seq !== undefined) {
          $('.s_room__checkBox[value='+ room.seq+']').prop('checked', true);
            _this.facility_seq.push({ seq: room.seq, room_seq: room.room_seq });
        }

        for(var i = 0; i < room.fixed; i++){
          _this.assignPlayerInfo.forEach(function(player, no) {
            if (player.number == room_number && i + 1 == Number(player.bed_info)) {
              room.player.push(player);
              isEmpty = false;
            }
          });

          if (isEmpty) {
            room.player.push({ number: room_number, bed_info: String(i + 1), name: '-'})
          }

          isEmpty = true;
        }
      });
    },

    // 재배정 혹은 호실선택 버튼 클릭 시, 데이터 set
    setRoomInfo:function(key) {
      var organ = this.assignInfo[key - 1];

      this.seq = organ.seq;
      this.lodging_seq = organ.lodging_seq;
      this.center_seq = organ.center_seq;
      this.players_count = organ.players_count;
      
      this.openPopup();
    },

    // 호실 선택 시
    clickAssignRoom:function(room, target) {
      var _this = this;
      var radioBox = $(target).siblings('.s_room__checkBox');

      if (!radioBox.prop('checked')) {
        if (this.click_player_count >= this.players_count) {
          alert('단체 선수의 정원보다 초과하여 방을 선택할 수 없습니다.');
          return false;
        }

        radioBox.prop('checked', true);
        this.setFacilitySeq(room, true);
        this.calcRoomFixed(room.fixed, true);
      } else {
        radioBox.prop('checked', false);
        this.setFacilitySeq(room, false);
        this.calcRoomFixed(room.fixed, false);
      }
    },

    // 방 선택에 따른 인원수와 방 개수 계산
    calcRoomFixed:function(fixed, checked) {
      if (checked) {
        this.click_player_count += Number(fixed);
        this.number_of_room += 1;

        if (fixed == '2') {
          this.number_two_room += 1;
        } else {
          this.number_three_room += 1;
        }
      } else {
        this.click_player_count -= Number(fixed);
        this.number_of_room -= 1;
        
        if (fixed == '2') {
          this.number_two_room -= 1;
        } else {
          this.number_three_room -= 1;
        }
      }
    },

    // 숙소 배정 업데이트를 위한 배열 정렬 및 삽입
    setFacilitySeq:function(room, flag) {
      var facilityArr = [];
      var seq = room.seq;
      var room_seq = room.room_seq;
      var index = 1;

      if (flag == true) {
        this.facility_seq.push({ seq: seq, room_seq: room_seq });
      } else {
        if (this.facility_seq.length == 1) {
          this.facility_seq = [];
        } else {
          this.facility_seq.forEach(function(facility, idx){
            if (facility.seq !== seq) {
              facilityArr.push({ seq: facility.seq, room_seq: facility.room_seq });
            }
          });

          this.facility_seq = facilityArr;
        }
      }
    },

    // 숙소 배정 룸 저장
    updateAssignRoom:function() {
      var _this=this;

      axios.post(_this.api_assign_room_update,{
        lodging_seq: _this.lodging_seq,
        center_seq: _this.center_seq,
        facility_seq: _this.facility_seq,
      }).then(function(response){
        if(response.data.state=="true"){
          console.log('숙소배정 room 등록/수정 완료');
          _this.closePopup('#l_popup__choice_room');
        }
      }).catch(function(error){
        console.log("숙소배정 room 등록/수정 error : ");
        console.log(error);
      }).finally(function(){
        _this.loadRoomApply(false);
      });
    },

    // 숙소배정 승인 요청
    updateApprovalAssign:function(flag) {
      var _this=this;
      var isError = false;
      var alert_cmt = '';

      if (_this.checkBoxArr.length == 0) {
        alert('선택한 숙소가 없습니다.');
        return false;
      } else {
        _this.checkBoxArr.forEach(function(item, idx) {
          axios.post(_this.api_assign_approval_update,{
            lodging_seq: item.lodging_seq,
            center_seq: item.center_seq,
            approval: flag,
          }).then(function(response){
            if(response.data.state=="true"){
              if (flag == 'Y') {
                alert_cmt = '숙소 배정이 승인되었습니다.';
              } else {
                alert_cmt = '숙소 재배정 요청 하였습니다.';
              }
              isError = true;
            } else {
              if (!isError) {
                if (response.data.errorcode == 'ERR-200') {
                  alert_cmt = '(재)승인요청된 건에 대해서만 승인/재배정 요청 하실 수 있습니다.';
                }

                if (response.data.errorcode == 'ERR-210') {
                  alert_cmt = '배정된 숙소가 없습니다.';
                }
              }
            }
          }).catch(function(error){
            console.log("숙소배정 room 등록/수정 error : ");
            console.log(error);
          }).finally(function() {
            if (idx == _this.checkBoxArr.length - 1) {
              alert(alert_cmt);
              _this.loadRoomApply(false);
            }
          });
        });
      }
    },

    // 체크박스 이벤트
    clickCheckBoxAll:function() {
      var _this = this;
      var checkBoxAll = $('.s_list__checkBox_all');
      var checkBoxInput = $('.s_list__checkBox');
      var isChecked = checkBoxAll.prop('checked');
      var center_seq = '';

      this.checkBoxArr = [];

      if (isChecked) {
        checkBoxAll.prop('checked', false);
        checkBoxInput.prop('checked', false);
      } else {
        checkBoxAll.prop('checked', true);
        checkBoxInput.prop('checked', true);

        this.assignInfo.forEach(function(item, idx) {
          _this.checkBoxArr.push({ 'seq': item.seq, 'lodging_seq' : item.lodging_seq });
        });

        this.checkBoxArr.forEach(function(item, idx) {
          axios.post(_this.api_assign_room_list,{
            seq: item.seq,
            lodging_seq: item.lodging_seq
          }).then(function(response){
            if(response.data.state=="true"){
              console.log('숙소배정 room 센터 번호');
              center_seq = response.data.room1[0].center_seq; // 센터가 여러개일 경우 수정. 임시
            }
          }).catch(function(error){
            console.log("숙소배정 room 센터 번호 error : ");
            console.log(error);
          }).finally(function() {
            _this.checkBoxArr[idx] = { 'seq': item.seq, 'lodging_seq' : item.lodging_seq, 'center_seq': center_seq};
          });
        });
      }
    },

    // 개별 체크박스 체크할 경우
    clickCheckBox:function(list) {
      var _this = this;
      var checkBox = $('.m_list__checkBox');
      var checkBoxInput = '';
      var key = list.no - 1;
      
      if (list.players_count == '0' || list.players_count == '') {
        return false;
      }

      checkBox.each(function(idx) {
        if (idx == key) {
          checkBoxInput = $('.s_list__checkBox').eq(key);

          if (checkBoxInput.prop('checked')) {
            checkBoxInput.prop('checked', false);
            _this.sortCheckBoxArr(false, list);
          } else {
            checkBoxInput.prop('checked', true);
            _this.sortCheckBoxArr(true, list);
          }
        }
      });
    },

    // 체크박스 리스트 정렬
    sortCheckBoxArr:function(flag, list) {
      var _this = this;
      var seq = '';
      var lodging_seq = '';
      var center_seq = '';

      if (flag) { // 체크했을 때
        axios.post(_this.api_assign_room_list,{
          seq: list.seq,
          lodging_seq: list.lodging_seq
        }).then(function(response){
          if(response.data.state=="true"){
            console.log('숙소배정 room 센터 번호');
            center_seq = response.data.room1[0].center_seq; // 센터가 여러개일 경우 수정. 임시
          }
        }).catch(function(error){
          console.log("숙소배정 room 센터 번호 error : ");
          console.log(error);
        }).finally(function() {
          _this.checkBoxArr.push({ 'lodging_seq' : list.lodging_seq, 'center_seq' : center_seq });
        });
      } else { // 체크 해제했을 때
        seq = list.lodging_seq;

        this.checkBoxArr.forEach(function(arr, idx) {
          lodging_seq = arr.lodging_seq;

          if (lodging_seq == seq) {
            _this.checkBoxArr.splice(idx, 1);
          }
        });
      }
    },
    
    // 팝업 열기
    openPopup:function(popup) {
      this.showPopup = true;
      $('#l_popup__dimm').addClass('active');
    },

    // 팝업 닫기
    closePopup:function(popup) {
      this.showPopup = false;
      $('#l_popup__dimm').removeClass('active');

      $('.s_room__checkBox').prop('checked', false);
      this.facility_seq = [];
      this.click_player_count = 0;
      this.number_of_room = 0;
      this.number_two_room = 0;
      this.number_three_room = 0;
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
    eventBus.$emit("menudrop", [9,2]);

    if (sessionStorage.getItem('groupcode') == 'ADMIN') {
      this.setDate();
      this.loadSelectBoxSports();
      this.loadRoomApply(true);
      this.loadCalendar();
    }
  }
});

var cont_leader = new Vue({
  el:"#icContent_leader",
  data:{
    // api
    api_assign_sports_list: 'http://ic.sportsdiary.co.kr/api/assign_manager/assign_sports_list.asp',
    api_assign_sports_player_list: 'http://ic.sportsdiary.co.kr/api/assign_manager/assign_sports_player_list.asp',
    api_assign_sports_room_list: 'http://ic.sportsdiary.co.kr/api/assign_manager/assign_sports_room_list.asp',
    api_assign_sports_bed_update: 'http://ic.sportsdiary.co.kr/api/assign_manager/assign_sports_bed_update.asp',
    api_assign_sports_update: 'http://ic.sportsdiary.co.kr/api/assign_manager/assign_sports_update.asp',
    // 사용자 세션 정보
    groupcode: '',

    floor: '2', // 층
    sdate: '', // 시작일
    edate: '', // 종료일
    sports: '', // 종목

    assignTot: '', // 배정된 숙소 total
    assignInfo: [], // 배정된 숙소 리스트
    stateArr: [], // 상태값 array
    stateChk: true, // 상태값 확인
    playerTot: '', // 선수 total
    playerInfo: [], // 선수 리스트
    // 팝업
    assignRoomTot: '', // 방배정 리스트
    assignRoomInfo1: [], // 1층
    assignRoomInfo2: [], // 2층
    assignRoomInfo3: [], // 3층
    assignRoomInfo4: [], // 4층
    association_title: '', // 단체명
    room_count: '', // 배정된 호실 개수
    // 종목별 bed update 위한 info
    roomInfo: {
      name: '', // 이름
      number: '', // 호실
      bed_info: '', // 침대정보
      birthday: '', // 생일
      player_seq: '', // 선수 seq
      lodging_seq: '', // 
      room_seq: '', // 호실 seq
      center_seq: '', // 단체 seq
      isAssign: false,
      isChoice: 'N',
    },
    // 승인요청을 위한 info
    seq: '',
    lodging_seq: '',
    assignList: '',
    // 체크박스 array
    checkBoxArr: [],
    // flag
    showBedPopup: false,
    showSharePopup: false,
  },
  watch:{},
  methods:{
    // 세션 스토리지에서 사용자 정보 가져오기
    getSessionInfo:function() {
      this.groupcode = sessionStorage.getItem('groupcode');
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

    // 달력 
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

    // 숙소 요청 및 승인완료 리스트 가져오기
    loadSportsList:function(flag) {
      var _this=this;
      var stateArr = [];

      axios.post(_this.api_assign_sports_list,{
        sdate: _this.sdate,
        edate: _this.edate
      }).then(function(response){
        if(response.data.state=="true"){
          _this.assignTot = response.data.total;
          _this.assignInfo = response.data.assign;
          
          _this.assignInfo.forEach(function(item){
            var state = item.state;

            if (state == '101' || state == '103') {
              stateArr.push(item.no);
            }
          });

          _this.stateArr = stateArr;
        } else {
          if (response.data.errorcode == 'ERR-130') {
            _this.assignInfo = [];
          }
        }
      }).catch(function(error){
        console.log("종목별 단체 list error : ");
        console.log(error);
      }).finally(function() {
        if (flag) _this.loadCalendar();
      });
    },

    // 종목별 선수 list 가져오기
    loadAssignSportsPlayerList:function(list) {
      var playerTable = $('.s_sub_list_box');
      var _this=this;
      var radioBox = '';

      // if ($(target).hasClass('m_field__radioBtn')){
      //   radioBox = $(target).siblings('.s_room__radioBtn');
      // } else {
      //   radioBox = $(target).find('.s_room__radioBtn');
      // }

      _this.stateChk = true;
      _this.assignList = list;

      // 상태값 정보 저장
      _this.stateArr.forEach(function(state) {
        if (state == list.no) {
          _this.stateChk = false;
        }
      });
      
      axios.post(_this.api_assign_sports_player_list,{
        seq: list.seq
      }).then(function(response){
        if(response.data.state=="true"){
          _this.playerTot = response.data.total;
          _this.playerInfo = response.data.assign_player;

          _this.seq = list.seq;
          _this.lodging_seq = list.lodging_seq;
          _this.association_title = list.association_title;
          _this.room_count = list.room_count;

          playerTable.removeClass('hide');
          //radioBox.prop('checked', true);
        }
      }).catch(function(error){
        console.log("종목별 선수 list error : ");
        console.log(error);
      }).finally(function(){
        _this.loadAssignSportsRoomList(false);
        _this.highlight(list.no - 1);
      });
    },

    // 배정호실 보기
    loadAssignSportsRoomList:function(isClickBtn) {
      var _this=this;
      var data = '';

      _this.assignRoomInfo1 = [];
      _this.assignRoomInfo2 = [];
      _this.assignRoomInfo3 = [];
      _this.assignRoomInfo4 = [];

      axios.post(_this.api_assign_sports_room_list,{
        seq: _this.seq,
        lodging_seq: _this.lodging_seq
      }).then(function(response){
        if(response.data.state=="true"){
          data = response.data;

          _this.assignRoomTot = data.total;
          
          if (data.room1.length !== 0) {
            _this.assignRoomInfo1 = data.room1;
            _this.roomInfo.center_seq = _this.assignRoomInfo1[0].center_seq;
          }
          if (data.room2.length !== 0) {
            _this.assignRoomInfo2 = data.room2;
            _this.roomInfo.center_seq = _this.assignRoomInfo2[0].center_seq;
          }
          if (data.room3.length !== 0) {
            _this.assignRoomInfo3 = data.room3;
            _this.roomInfo.center_seq = _this.assignRoomInfo3[0].center_seq;
          }
          if (data.room4.length !== 0) {
            _this.assignRoomInfo4 = data.room4;
            _this.roomInfo.center_seq = _this.assignRoomInfo4[0].center_seq;
          }

          if (isClickBtn) {
            _this.showSharePopup = true;
            _this.openPopup();
          }
        } else {
          if (response.data.errorcode == 'ERR-110') {
            alert('단체 선택 후, 배정호실 보기를 클릭해 주세요.');
          }
        }
      }).catch(function(error){
        console.log("종목별 선수 룸 list error : ");
        console.log(error);
      });
    },

    // 선수 개별 방 가져오기
    loadAssignSportsBedList:function(key) {
      var _this=this;
      var data = '';
      var fullRoom = [];

      axios.post(_this.api_assign_sports_room_list,{
        seq: _this.seq,
        lodging_seq: _this.lodging_seq
      }).then(function(response){
        if(response.data.state=="true"){
          data = response.data;
          _this.assignRoomTot = data.total;

          if (data.room1.length !== 0) {
            _this.assignRoomInfo1 = data.room1;
            _this.assignRoomInfo1.forEach(function(item){
              var fixed = item.fixed;
              var isEmpty = false;

              fixed.forEach(function(fix){
                if (fix.name == '-') {
                  isEmpty = true;
                }
              });

              if (!isEmpty) {
                fullRoom.push(item.number);
              }
            });
          }
          
          if (data.room2.length !== 0) {
            _this.assignRoomInfo2 = data.room2;
            _this.assignRoomInfo2.forEach(function(item){
              var fixed = item.fixed;
              var isEmpty = false;

              fixed.forEach(function(fix){
                if (fix.name == '-') {
                  isEmpty = true;
                }
              });

              if (!isEmpty) {
                fullRoom.push(item.number);
              }
            });
          }
          
          if (data.room3.length !== 0) {
            _this.assignRoomInfo3 = data.room3;
            _this.assignRoomInfo3.forEach(function(item){
              var fixed = item.fixed;
              var isEmpty = false;

              fixed.forEach(function(fix){
                if (fix.name == '-') {
                  isEmpty = true;
                }
              });

              if (!isEmpty) {
                fullRoom.push(item.number);
              }
            });
          } 
          
          if (data.room4.length !== 0) {
            _this.assignRoomInfo4 = data.room4;
            _this.assignRoomInfo4.forEach(function(item){
              var fixed = item.fixed;
              var isEmpty = false;

              fixed.forEach(function(fix){
                if (fix.name == '-') {
                  isEmpty = true;
                }
              });

              if (!isEmpty) {
                fullRoom.push(item.number);
              }
            });
          }
          if (key !== undefined && key !== ''){
            _this.setplayerInfo(key);
            _this.showBedPopup = true;
            _this.openPopup();
          }
        }
      }).catch(function(error){
        console.log("종목별 선수 룸 list error : ");
        console.log(error);
      }).finally(function(){
        if(key !== undefined && key !== '') _this.setRoomAssign();
        _this.disableRadioBtn(fullRoom);
      });
    },
    
    // 선수 정보 설정
    setplayerInfo:function(key) {
      var player = this.playerInfo[key - 1];

      this.roomInfo.name = player.name;
      this.roomInfo.number = player.number;
      this.roomInfo.birthday = player.birthday;
      this.roomInfo.player_seq = player.player_seq;

      if (this.roomInfo.number !== '') {
        this.roomInfo.isAssign = true;
      } else {
        this.roomInfo.isAssign = false;
      }
    },

    // 방을 클릭했을 때
    clickAssignRoom: function(room, radioBox){
      var _this = this;

      this.roomInfo.room_seq = room.room_seq;
      this.roomInfo.center_seq = room.center_seq;
      this.roomInfo.lodging_seq = room.lodging_seq;

      if (!radioBox.prop('checked')) {
        this.roomInfo.number = room.number;
        room.fixed.forEach(function(fixed){
          if (fixed.name == _this.roomInfo.name) {
            _this.roomInfo.bed_info = fixed.BED_INFO;
          }
        });
        this.roomInfo.isChoice = 'Y';
        this.roomInfo.isAssign = true;
        radioBox.prop('checked', true);
      } else {
        this.roomInfo.number = '';
        this.roomInfo.bed_info = '';
        this.roomInfo.isChoice = 'N';
        this.roomInfo.isAssign = false;
        radioBox.prop('checked', false);
      }
    },

    // 방에 있는 선수 정보 설정
    setRoomAssign:function() {
      if (this.roomInfo.number == '' || this.roomInfo.bed_info == ''){
        var allInput = $('.s_popup__radioBtn');
        allInput.prop('checked', false);
      } else {
        var r_input = $('.s_popup__radioBtn[data-number='+ this.roomInfo.number +']');
        r_input.prop('checked', true);
      }
    },

    // 숙소 침대가 비어있는지, 꽉차있는지 확인
    disableRadioBtn:function(fullRoom) {
      var allWrap = $('#l_popup__bed_room').find('.m_room__wrap');
      var allRadioBtn = $('#l_popup__bed_room').find('.s_popup__radioBtn');
      var allRadioBtnBox = $('#l_popup__bed_room').find('.m_field__radioBtn');

      allWrap.removeClass('empty');
      allRadioBtn.removeAttr('disabled');
      allRadioBtnBox.removeClass('disabled');

      fullRoom.forEach(function(room) {
        var fullRadioBtn = $('.s_popup__radioBtn[data-number='+ room +']');
        var radioBox = fullRadioBtn.siblings('.m_field__radioBtn');
        var wrap = fullRadioBtn.closest('.m_room__wrap');

        fullRadioBtn.attr('disabled', 'true');
        radioBox.addClass('disabled');
        wrap.addClass('empty');
      });
    },

    // 종목별 bed 추가 :: 체크박스 클릭시
    updateAssignSportsBed: function(room, target) {
      var _this=this;
      var radioBtn = $(target).siblings('.s_popup__radioBtn');

      if (radioBtn.attr('disabled')) {
        alert('이 호실은 선택할 수 없습니다. 다른 호실을 선택해 주세요.');
        return false;
      }

      _this.clickAssignRoom(room, radioBtn);

      axios.post(_this.api_assign_sports_bed_update,{
        player_seq: _this.roomInfo.player_seq,
        center_seq: _this.roomInfo.center_seq,
        lodging_seq: _this.roomInfo.lodging_seq,
        room_seq: _this.roomInfo.room_seq,
        choice: 'Y',
      }).then(function(response){
        if(response.data.state=="true"){
          console.log('종목별 bed update 완료');
          _this.loadAssignSportsBedList();
          _this.loadAssignSportsPlayerList(_this.assignList);
          _this.closePopup('#l_popup__bed_room');
        }
      }).catch(function(error){
        console.log("종목별 bed update error : ");
        console.log(error);
      });
    },

    // 종목별 bed 추가 :: 확인 버튼 클릭시
    updateAssignSportsBedSave: function() {
      var _this=this;

      axios.post(_this.api_assign_sports_bed_update,{
        player_seq: _this.roomInfo.player_seq,
        center_seq: _this.roomInfo.center_seq,
        lodging_seq: _this.roomInfo.lodging_seq,
        room_seq: _this.roomInfo.room_seq,
        choice: 'Y',
      }).then(function(response){
        if(response.data.state=="true"){
          console.log('종목별 bed update 완료');

          _this.loadAssignSportsPlayerList(_this.assignList);
          _this.closePopup('#l_popup__bed_room');
        }
      }).catch(function(error){
        console.log("종목별 bed update error : ");
        console.log(error);
      });
    },

    // 종목별 신청 업데이트
    updateAssignSports:function() {
      var _this=this;
      var playerTable = $('.s_sub_list_box');
      var isError = false;
      var alert_cmt = '';

      if (_this.checkBoxArr.length == 0) {
        alert('체크박스로 선택한 후 승인요청 해주세요.');
        return false;
      } else {
        _this.checkBoxArr.forEach(function(item, idx) {
          axios.post(_this.api_assign_sports_update,{
            center_seq: item.center_seq,
            lodging_seq: item.lodging_seq
          }).then(function(response){
            if(response.data.state=="true"){
                alert_cmt = '숙소 배정 승인 요청 하셨습니다.';
                isError = true;
              } else {
              if (!isError) {
                if (response.data.errorcode == 'ERR-200') {
                  alert_cmt = '(재)승인요청된 건에 대해서만 승인/재배정 요청 하실 수 있습니다.';
                }

                if (response.data.errorcode == 'ERR-210') {
                  alert_cmt = '배정된 숙소가 없습니다.';
                }
              }
              console.log('종목별 update 완료');
            }
          }).catch(function(error){
            console.log("종목별 update error : ");
            console.log(error);
          }).finally(function() {
            if (idx == _this.checkBoxArr.length - 1) {
              alert(alert_cmt);
              _this.loadSportsList(false);
              playerTable.addClass('hide');
            }
          });
        });
      }
    },

    // 체크박스 이벤트
    clickCheckBoxAll:function() {
      var _this = this;
      var checkBoxAll = $('.s_list__checkBox_all');
      var checkBoxInput = $('.s_list__checkBox');
      var isChecked = checkBoxAll.prop('checked');
      var center_seq = '';

      this.checkBoxArr = [];

      if (isChecked) {
        checkBoxAll.prop('checked', false);
        checkBoxInput.prop('checked', false);
      } else {
        checkBoxAll.prop('checked', true);
        checkBoxInput.prop('checked', true);

        this.assignInfo.forEach(function(item, idx) {
          _this.checkBoxArr.push({ 'seq': item.seq, 'lodging_seq' : item.lodging_seq });
        });

        this.checkBoxArr.forEach(function(item, idx) {
          axios.post(_this.api_assign_sports_room_list,{
            seq: item.seq,
            lodging_seq: item.lodging_seq
          }).then(function(response){
            if(response.data.state=="true"){
              console.log('숙소배정 room 센터 번호');
              center_seq = response.data.room1[0].center_seq; // 센터가 여러개일 경우 수정. 임시
            }
          }).catch(function(error){
            console.log("숙소배정 room 센터 번호 error : ");
            console.log(error);
          }).finally(function() {
            _this.checkBoxArr[idx] = { 'seq': item.seq, 'lodging_seq' : item.lodging_seq, 'center_seq': center_seq};
          });
        });
      }
    },

    // 개별 체크박스 체크할 경우
    clickCheckBox:function(list) {
      var _this = this;
      var checkBox = $('.m_list__checkBox');
      var checkBoxInput = '';
      var key = list.no - 1;
      
      checkBox.each(function(idx) {
        if (idx == key) {
          checkBoxInput = $('.s_list__checkBox').eq(key);

          if (checkBoxInput.prop('checked')) {
            checkBoxInput.prop('checked', false);
            _this.sortCheckBoxArr(false, list);
          } else {
            checkBoxInput.prop('checked', true);
            _this.sortCheckBoxArr(true, list);
          }
        }
      });
    },

    // 체크박스 리스트 정렬
    sortCheckBoxArr:function(flag, list) {
      var _this = this;
      var seq = '';
      var lodging_seq = '';
      var center_seq = '';

      if (flag) { // 체크했을 때
        axios.post(_this.api_assign_sports_room_list,{
          seq: list.seq,
          lodging_seq: list.lodging_seq
        }).then(function(response){
          if(response.data.state=="true"){
            console.log('숙소배정 room 센터 번호');

            if (response.data.room1.length !== 0) {
              center_seq = response.data.room1[0].center_seq;
            }
            if (response.data.room2.length !== 0) {
              center_seq = response.data.room2[0].center_seq;
            }
            if (response.data.room3.length !== 0) {
              center_seq = response.data.room3[0].center_seq;
            }
            if (response.data.room4.length !== 0) {
              center_seq = response.data.room4[0].center_seq;
            }
          }
        }).catch(function(error){
          console.log("숙소배정 room 센터 번호 error : ");
          console.log(error);
        }).finally(function() {
          _this.checkBoxArr.push({ 'lodging_seq' : list.lodging_seq, 'center_seq' : center_seq });
        });
      } else { // 체크 해제했을 때
        seq = list.lodging_seq;

        this.checkBoxArr.forEach(function(arr, idx) {
          lodging_seq = arr.lodging_seq;

          if (lodging_seq == seq) {
            _this.checkBoxArr.splice(idx, 1);
          }
        });
      }
    },

    // 팝업 열기
    openPopup:function(popup) {
      $('#l_popup__dimm').addClass('active');
    },

    // 팝업 닫기
    closePopup:function(popup) {
      this.showBedPopup = false;
      this.showSharePopup = false;
      $('#l_popup__dimm').removeClass('active');
      
      this.roomInfo.number = '';
      this.roomInfo.bed_info = '';
      this.roomInfo.isChoice = 'N';
      this.roomInfo.isAssign = false;
      $('.s_popup__radioBtn').prop('checked', false);
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
    // 현재 메뉴(위치) 확인
    eventBus.$emit("menuinfo");
    eventBus.$emit("menudrop", [9,2]);
    
    if (sessionStorage.getItem('groupcode') == 'ASSOCIATION') {
      this.setDate();
      this.loadSportsList(true);
      this.loadCalendar();
    }
  }
});
</script>
</body>
</html>