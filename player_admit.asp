<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct player_admit" v-cloak>
	<div class="l_content">
		<!-- 컨텐츠 영역. s. -->
		<h2>선수등록 / 조회</h2>
  
    <div class="l_search_box m_ibarea">

      <div class="l_photo_area">
        <canvas id="canvas" class="l_photo_img" v-bind:class="{l_contain:photosize=='v', l_cover:photosize=='h'}" v-bind:style="{backgroundImage:'url('+photo+')'}"></canvas>
        <div class="l_photo_box" v-if="photo=='/front/img/icon_profilephoto.svg'">
          <div class="l_photo_bg"></div>
          <div class="l_photo_img" v-bind:class="{l_contain:photosize=='v', l_cover:photosize=='h'}" v-bind:style="{backgroundImage:'url('+photo+')'}"></div>
          <p v-if="photo=='/front/img/icon_profilephoto.svg'">(jpg, png)</p>
        </div>
        <div class="l_photo_box" v-else>
          <div class="l_photobox">
            <div class="l_photobox">
              <img :src="photo" alt="">
            </div>
          </div>
        </div>
        <div class="l_photowrap">
          <p v-if="photo=='/front/img/icon_profilephoto.svg'">사진선택</p>
          <p v-else>수정</p>
          <input type="file" title="사진첨부하기" @change="selectImage($event.target)" accept="image/jpeg, image/jpg, image/png">
        </div>
      </div>
      <div class="l_search_field_area">
        <div class="l_search_field">
          <div class="l_field">
            <label for="player_name">성명</label>
            <span class="l_inputpoint" v-if="player_name==''">*</span>
            <input type="text" id="player_name" placeholder="성명을 입력해주세요" v-model="player_name">
          </div>
          <div class="l_field">
            <label for="player_en_name">성명(영문)</label>
            <span class="l_inputpoint" v-if="player_en_name==''">*</span>
            <input type="text" id="player_en_name" placeholder="영문성명을 입력해주세요" v-model="player_en_name">
          </div>
          <div class="l_field">
            <label for="gender_seq">성별</label>
            <span class="l_inputpoint" v-if="gender_seq==''">*</span>
            <select id="gender_seq" v-bind:class="{s_placetxt:gender_seq==''}" v-model="gender_seq">
              <option value="">성별을 선택하세요</option>
              <option v-for="(option,key) in select_genderlist" :key="key" :value="option.seq">{{option.title}}</option>
            </select>
          </div>
          <div class="l_field">
            <label for="birthday">생년월일</label>
            <span class="l_inputpoint" v-if="birthday==''">*</span>
            <input type="text" id="birthday" placeholder="생년월일 입력(YYYYMMDD)" :value="nav.addBirthDot(birthday)" v-on:input="birthday=$event.target.value.replace(/[.]/g,'');">
          </div>
        </div>
        <div class="l_search_field">
          <div class="l_field">
            <label for="player_type_seq">선수구분</label>
            <span class="l_inputpoint" v-if="player_type_seq==''">*</span>
            <select id="player_type_seq" v-bind:class="{s_placetxt:player_type_seq==''}" v-model="player_type_seq">
              <option value="">선수구분을 선택하세요</option>
              <option v-for="(option,key) in select_playerlist" :key="key" :value="option.seq">{{option.title}}</option>
            </select>
          </div>
          <div class="l_field">
            <label for="sports_seq">종목</label>
            <input id="sports_seq" type="text" class="m_nochange" v-model="nav.sports_title">
          </div>
          <div class="l_field">
            <label for="sports_detail">종목상세</label>
            <input type="text" id="sports_detail" placeholder="입력해주세요" v-model="sports_detail">
          </div>
          <div class="l_field">
            <label for="area_seq">소속</label>
            <span class="l_inputpoint" v-if="area_seq==''">*</span>
            <select id="area_seq" v-bind:class="{s_placetxt:area_seq==''}" v-model="area_seq">
              <option value="">소속을 선택하세요</option>
              <option v-for="(option,key) in select_arealist" :key="key" :value="option.seq">{{option.title}}</option>
            </select>
          </div>
        </div>
        <div class="l_search_field">
          <div class="l_field">
            <label for="position_seq">직위</label>
            <span class="l_inputpoint" v-if="position_seq==''">*</span> 
            <select id="position_seq" v-bind:class="{s_placetxt:position_seq==''}" v-model="position_seq">
              <option value="">소속을 선택하세요</option>
              <option v-for="(option,key) in select_positionlist" :key="key" :value="option.seq">{{option.title}}</option>
            </select>
          </div>
          <div class="l_field">
            <label for="disabled_state_seq">장애여부</label>
            <span class="l_inputpoint" v-if="disabled_state_seq==''">*</span>
            <select id="disabled_state_seq" v-bind:class="{s_placetxt:disabled_state_seq==''}" v-model="disabled_state_seq">
              <option value="">장애여부를 선택하세요</option>
              <option v-for="(option,key) in select_disabled_statelist" :key="key" :value="option.seq">{{option.title}}</option>
            </select>
          </div>
          <div class="l_field">
            <label for="disabled_type_seq">장애유형</label>
            <span class="l_inputpoint" v-if="disabled_type_seq==''">*</span>
            <select id="disabled_type_seq" v-bind:class="{s_placetxt:disabled_type_seq==''}" v-model="disabled_type_seq">
              <option value="">장애유형를 선택하세요</option>
              <option v-for="(option,key) in select_disabled_typelist" :key="key" :value="option.seq">{{option.title}}</option>
            </select>
          </div>
          <div class="l_field">
            <label for="disabled_grade_seq">경기등급</label>
            <span class="l_inputpoint" v-if="disabled_grade_seq==''">*</span>
            <select id="disabled_grade_seq" v-bind:class="{s_placetxt:disabled_grade_seq==''}" v-model="disabled_grade_seq">
              <option value="">등급을 선택하세요</option>
              <option v-for="(option,key) in select_gradelist" :key="key" :value="option.seq">{{option.title}}</option>
            </select>
          </div>
        </div>
        <div class="l_search_field l_semi_long">
          <div class="l_field">
            <label for="joinlist">대회참가현황</label>
            <textarea id="joinlist" placeholder="대회참가현황을 입력해주세요" :value="competition.replace(/(<br>|<br\/>|<br \/>)/g, '\r\n')" v-on:input="competition=$event.target.value"></textarea>
          </div>
          <div class="l_field">
            <label for="prize">훈포상현황</label>
            <textarea id="prize" placeholder="훈포상현황을 입력해주세요" :value="reward.replace(/(<br>|<br\/>|<br \/>)/g, '\r\n')" v-on:input="reward=$event.target.value"></textarea>
          </div>
        </div>
      </div>

      <div class="l_search_btns">
        <button class="l_btn s_blue" v-bind:class="{gray:!info_update && choicedata}" @click="saveData">{{!choicedata? "등 록" : "수 정"}}</button>
        <button class="l_btn s_orange" v-if="choicedata" @click="deletepop=true">삭 제</button>
        <button class="l_btn s_white" v-if="choicedata" @click="choicedata=false;init();">신 규</button>
      </div>
    </div>

    <div class="l_list_box">
      <div class="l_list_tablewrap">
        <table>
          <caption>입촌 선수 목록</caption>
          <colgroup>
            <col style="width:3%;">
            <col style="width:6%;">
            <col style="width:6%;">
            <col style="width:9%;">
            <col style="width:3%;">
            <col style="width:7%;">
            <col style="width:4%;">
            <col style="width:7%;">
            <col style="width:7%;">
            <col style="width:5%;">
            <col style="width:12%;">
            <col style="width:10%;">
            <col style="width:7%;">
            <col style="width:14%;">
          </colgroup>
          <thead>
            <tr>
              <th scope="col"></th>
              <th scope="col">선수번호</th>
              <th scope="col">성명</th>
              <th scope="col">성명(영문)</th>
              <th scope="col">성별</th>
              <th scope="col">생년월일</th>
              <th scope="col">직위</th>
              <th scope="col">장애여부</th>
              <th scope="col">장애유형</th>
              <th scope="col">경기등급</th>
              <th scope="col">소속</th>
              <th scope="col">선수구분</th>
              <th scope="col">종목</th>
              <th scope="col">종목상세</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="playerlist.length==0">
              <!-- <td colspan="14">{{errorcode}}</td> -->
              <td colspan="14"><p class="m_no_list"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
            </tr>
            <tr class="m_cursor" v-bind:class="{l_choice:choice==key}" v-if="playerlist.length>0" v-for="(list,key) in playerlist" :key="key" @click="listInfoChoice(key)">
              <td>{{list.no}}</td>
              <td>{{list.code}}</td>
              <td>{{list.player_name}}</td>
              <td>{{list.player_en_name}}</td>
              <td>{{list.gender_title}}</td>
              <td>{{nav.addBirthDot(list.birthday)}}</td>
              <td>{{list.position_title}}</td>
              <td>{{list.disabled_state_title}}</td>
              <td>{{list.disabled_type_title}}</td>
              <td>{{list.disabled_grade_title}}</td>
              <td>{{list.area_title}}</td>
              <td>{{list.player_type_title}}</td>
              <td>{{list.sports_title}}</td>
              <td>{{list.sports_detail}}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 팝업 -->
    <transition name="fade">
      <div class="l_popup_bg" v-if="updatepop">
        <div class="l_popup_area">
          <p class="l_popup_title">내용이 수정되었습니다.</p>
          <p class="l_popup_cmt">저장된 데이터는 해당 리스트에서 확인하실 수 있습니다.</p>
          <div class="l_search_btns">
            <button type="submit" class="l_btn s_blue" @click="updatepop=false">확 인</button>
          </div>
        </div>
      </div>
    </transition>

    <transition name="fade">
      <div class="l_popup_bg" v-if="deletepop">
        <div class="l_popup_area">
          <p class="l_popup_title">내용이 삭제됩니다.</p>
          <p class="l_popup_cmt">확인을 누르시면 해당 데이터는 삭제됩니다.</p>
          <div class="l_search_btns">
            <button type="submit" class="l_btn s_blue" @click="deleteData">확 인</button>
            <button type="submit" class="l_btn s_white" @click="deletepop=false">취 소</button>
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
      // api
      select_api:"http://ic.sportsdiary.co.kr/api/menu_control/selected_item_custom.asp",//
      playerlist_api:"http://ic.sportsdiary.co.kr/api/player_manager/player_list.asp",// 선수 목록 api
      playersave_api:"http://ic.sportsdiary.co.kr/api/player_manager/player_add.asp",// 선수 등록 api
      playerupdate_api:"http://ic.sportsdiary.co.kr/api/player_manager/player_modify.asp",// 선수 수정 api
      playerdelete_api:"http://ic.sportsdiary.co.kr/api/player_manager/player_del.asp",// 선수 삭제 api

      playerlist:[],// 선수목록

      select_genderlist:[],// 옵션, 성별 목록
      select_playerlist:[],// 옵션, 선수구분 목록
      select_sportslist:[],// 옵션, 종목 목록
      select_arealist:[],// 옵션, 소속 목록
      select_positionlist:[],// 옵션, 직위 목록
      select_disabled_statelist:[],// 옵션, 장애여부 목록
      select_disabled_typelist:[],// 옵션, 장애유형 목록
      select_gradelist:[],// 옵션, 경기등급 목록

      // selected
      seq:"",// 선택한 선수 seq
      player_name:"",// 성명
      player_en_name:"",// 성명(영문)
      gender_seq:"",// 성별 seq
      birthday:"",// 생년월일
      player_type_seq:"",// 선수 seq
      // sports_seq:"",// 종목 seq
      sports_detail:"",// 종목상세
      area_seq:"",// 소속 seq
      position_seq:"",// 직위 seq
      disabled_state_seq:"",// 장애여부 seq
      disabled_type_seq:"",// 장애유형 seq
      disabled_grade_seq:"",// 경기등급 seq
      competition:"",// 대회참가현황
      reward:"",// 훈포상현황
      photo:"/front/img/icon_profilephoto.svg",// base64 이미지
      photosize:"",// h : 이미지가 세로가 길 때(l_contain),   v : 이미지가 가로가 길 때(l_cover)

      // 비교용
      c_player_name:"",// 
      c_player_en_name:"",// 
      c_gender_seq:"",//  
      c_birthday:"",// 
      c_player_type_seq:"",// 
      // c_sports_seq:"",// 
      c_sports_detail:"",// 
      c_area_seq:"",// 
      c_position_seq:"",// 
      c_disabled_state_seq:"",// 
      c_disabled_type_seq:"",// 
      c_disabled_grade_seq:"",// 
      c_competition:"",// 
      c_reward:"",// 
      c_photo:"",// 

      // 승인이 아닌거 보다가 내용 바뀌면.  등록 -> 수정, 삭제, 취소
      choicedata:false,
      choice:-1,
      info_update:false,// 수정했나?

      // 팝업 보이기 여부
      updatepop:false,
      deletepop:false,
      
      errorcode:"",//
		},
    watch:{
      player_name:function(newval,oldval){
        this.player_name=newval;
        this.c_player_name!=this.player_name? this.info_update=true : this.info_update=false;
      },
      player_en_name:function(newval,oldval){
        this.player_en_name=newval;
        this.c_player_en_name!=this.player_en_name? this.info_update=true : this.info_update=false;
      },
      gender_seq:function(newval,oldval){
        this.gender_seq=newval;
        this.c_gender_seq!=this.gender_seq? this.info_update=true : this.info_update=false;
      },
      birthday:function(newval,oldval){
        this.birthday=newval;
        this.c_birthday!=this.birthday? this.info_update=true : this.info_update=false;
      },
      player_type_seq:function(newval,oldval){
        this.player_type_seq=newval;
        this.c_player_type_seq!=this.player_type_seq? this.info_update=true : this.info_update=false;
      },
      // sports_seq:function(newval,oldval){
      //   this.sports_seq=newval;
      //   this.c_sports_seq!=this.sports_seq? this.info_update=true : this.info_update=false;
      // },
      sports_detail:function(newval,oldval){
        this.sports_detail=newval;
        this.c_sports_detail!=this.sports_detail? this.info_update=true : this.info_update=false;
      },
      area_seq:function(newval,oldval){
        this.area_seq=newval;
        this.c_area_seq!=this.area_seq? this.info_update=true : this.info_update=false;
      },
      position_seq:function(newval,oldval){
        this.position_seq=newval;
        this.c_position_seq!=this.position_seq? this.info_update=true : this.info_update=false;
      },
      disabled_state_seq:function(newval,oldval){
        this.disabled_state_seq=newval;
        this.c_disabled_state_seq!=this.disabled_state_seq? this.info_update=true : this.info_update=false;
      },
      disabled_type_seq:function(newval,oldval){
        this.disabled_type_seq=newval;
        this.c_disabled_type_seq!=this.disabled_type_seq? this.info_update=true : this.info_update=false;
      },
      disabled_grade_seq:function(newval,oldval){
        this.disabled_grade_seq=newval;
        this.c_disabled_grade_seq!=this.disabled_grade_seq? this.info_update=true : this.info_update=false;
      },
      competition:function(newval,oldval){
        this.competition=newval;
        this.c_competition!=this.competition? this.info_update=true : this.info_update=false;
      },
      reward:function(newval,oldval){
        this.reward=newval;
        this.c_reward!=this.reward? this.info_update=true : this.info_update=false;
      },
      photo:function(newval,oldval){
        this.photo=newval;
        this.c_photo!=this.photo? this.info_update=true : this.info_update=false;
      },
    },
		methods:{
      // 이미지 등록
			selectImage:function(file){
        // file : 선택한 이미지 파일
        var _this=this;
        
        var file_eda;
        if(file.files[0]!=undefined){
          file_eda=file.files[0].name;
        }else{
          return;
        }

        var canvas=document.getElementById("canvas");
        var ctx=canvas.getContext("2d");
        var cw=canvas.width, ch=canvas.height;
        var maxw=120, maxh=135;


        var reader=new FileReader();
        reader.readAsDataURL(file.files[0]);
        reader.onload=function(e){
          var image=new Image();
          image.src=reader.result;
          image.onload=function(){
            if(image.width>=image.height){
              _this.photosize="v";
            }else{
              _this.photosize="h";
            }

            // if(image.width>480){
            //   alert("이미지의 가로 사이즈를 줄여주세요");
            //   _this.photo="/front/img/icon_profilephoto.svg";
            //   _this.photosize="";
            //   return;
            // }else if(image.height>640){
            //   alert("이미지의 세로 사이즈를 줄여주세요.");
            //   _this.photo="/front/img/icon_profilephoto.svg";
            //   _this.photosize="";
            //   return;
            // }

            var scale=Math.min(maxh/image.width, maxh/image.height);
            var iwscale=image.width*scale, ihscale=image.height*scale;
            canvas.width=iwscale;
            canvas.height=ihscale;
            ctx.drawImage(image, 0, 0, iwscale, ihscale);
            // canvas.backgroundImage=canvas.toDataURL("image/jpeg", 1);
            _this.photo=canvas.toDataURL("image/png", 1);
          };
          // _this.photo=e.target.result;
        }
      },

      // 선수 등록/수정
      saveData:function(){
        var _this=this;
        if(_this.player_name=="" || _this.player_en_name=="" || _this.gender_seq=="" || _this.birthday=="" || _this.player_type_seq=="" || _this.area_seq=="" || _this.position_seq=="" || _this.disabled_state_seq=="" || _this.disabled_type_seq=="" || _this.disabled_grade_seq==""){
          alert("* 항목을 빠짐없이 선택/입력 하십시오.");
          return;
        }

        // 등록
        if(!_this.choicedata){
          axios.post(_this.playersave_api,{
            player_name:_this.player_name,
            player_en_name:_this.player_en_name,
            gender_seq:_this.gender_seq,
            birthday:_this.birthday.replace(/[.]/g,""),
            player_type_seq:_this.player_type_seq,
            sports_seq:nav.sports_code,
            sports_detail:_this.sports_detail,
            area_seq:_this.area_seq,
            position_seq:_this.position_seq,
            disabled_state_seq:_this.disabled_state_seq,
            disabled_type_seq:_this.disabled_type_seq,
            disabled_grade_seq:_this.disabled_grade_seq,
            competition:_this.competition.replace(/(?:\r\n|\r|\n)/g, '<br/>'),
            reward:_this.reward.replace(/(?:\r\n|\r|\n)/g, '<br/>'),
            photo:_this.photo=="/front/img/icon_profilephoto.svg"? "" : _this.photo
          }).then(function(response){
            if(response.data.state==="true"){
              _this.playerList();
              _this.init();
              alert("등록되었습니다.");
            }
          });
        }
        // 수정
        else if(_this.choicedata){
          // 수정된게 없으면 취소
          if(!_this.info_update){
            return;
          }

          _this.updatepop=true;
          axios.post(_this.playerupdate_api,{
            player_name:_this.player_name,
            player_en_name:_this.player_en_name,
            gender_seq:_this.gender_seq,
            birthday:_this.birthday.replace(/[.]/g,""),
            player_type_seq:_this.player_type_seq,
            sports_seq:nav.sports_code,
            sports_detail:_this.sports_detail,
            area_seq:_this.area_seq,
            position_seq:_this.position_seq,
            disabled_state_seq:_this.disabled_state_seq,
            disabled_type_seq:_this.disabled_type_seq,
            disabled_grade_seq:_this.disabled_grade_seq,
            competition:_this.competition.replace(/(?:\r\n|\r|\n)/g, '<br/>'),
            reward:_this.reward.replace(/(?:\r\n|\r|\n)/g, '<br/>'),
            photo:_this.photo=="/front/img/icon_profilephoto.svg"? "" : _this.photo,
            seq:_this.seq
          }).then(function(response){
            if(response.data.state==="true"){
              _this.playerList();
              // _this.init();

              // 비교용
              _this.info_update=false;
              _this.c_player_name=_this.player_name;//
              _this.c_player_en_name=_this.player_en_name;//
              _this.c_gender_seq=_this.gender_seq;//
              _this.c_birthday=_this.birthday;//
              _this.c_player_type_seq=_this.player_type_seq;//
              // _this.c_sports_seq=_this.sports_seq;//
              _this.c_sports_detail=_this.sports_detail;//
              _this.c_area_seq=_this.area_seq;//
              _this.c_position_seq=_this.position_seq;//
              _this.c_disabled_state_seq=_this.disabled_state_seq;//
              _this.c_disabled_type_seq=_this.disabled_type_seq;//
              _this.c_disabled_grade_seq=_this.disabled_grade_seq;//
              _this.c_competition=_this.competition;//
              _this.c_reward=_this.reward;//
              _this.c_photo=_this.photo;//
            }
          });
        }
      },

      init:function(){
        this.choicedata=false;
        this.choice=-1;
        this.player_name="";
        this.player_en_name="";
        this.gender_seq="";
        this.birthday="";
        this.player_type_seq="";
        // this.sports_seq="";
        this.sports_detail="";
        this.area_seq="";
        this.position_seq="";
        this.disabled_state_seq="";
        this.disabled_type_seq="";
        this.disabled_grade_seq="";
        this.competition="";
        this.reward="";
        this.photo="/front/img/icon_profilephoto.svg";
        this.seq="";

        // 비교용
        this.info_update=false;
        this.c_player_name="";// 
        this.c_player_en_name="";// 
        this.c_gender_seq="";//
        this.c_birthday="";// 
        this.c_player_type_seq="";// 
        // this.c_sports_seq="";// 
        this.c_sports_detail="";// 
        this.c_area_seq="";// 
        this.c_position_seq="";// 
        this.c_disabled_state_seq="";// 
        this.c_disabled_type_seq="";// 
        this.c_disabled_grade_seq="";// 
        this.c_competition="";// 
        this.c_reward="";// 
        this.c_photo="";// 
      },

      // 선수 삭제
      deleteData:function(){
        var _this=this;
        axios.post(_this.playerdelete_api,{
          seq:_this.seq
        }).then(function(response){
          if(response.data.state==="true"){
            _this.playerList();
            _this.init();
            _this.deletepop=false
          }
        });
      },
      
      // 선택한 선수 정보
      listInfoChoice:function(idx){
        this.choicedata=true;
        this.choice=idx;
        this.player_name=this.playerlist[idx].player_name;
        this.player_en_name=this.playerlist[idx].player_en_name;
        this.gender_seq=this.playerlist[idx].gender_seq;
        this.birthday=this.playerlist[idx].birthday;
        this.player_type_seq=this.playerlist[idx].player_type_seq;
        // this.sports_seq=this.playerlist[idx].sports_seq;
        this.sports_detail=this.playerlist[idx].sports_detail;
        this.area_seq=this.playerlist[idx].area_seq;
        this.position_seq=this.playerlist[idx].position_seq;
        this.disabled_state_seq=this.playerlist[idx].disabled_state_seq;
        this.disabled_type_seq=this.playerlist[idx].disabled_type_seq;
        this.disabled_grade_seq=this.playerlist[idx].disabled_grade_seq;
        this.competition=this.playerlist[idx].competition;
        this.reward=this.playerlist[idx].reward;
        this.photo=this.playerlist[idx].photo==""? "/front/img/icon_profilephoto.svg" : this.playerlist[idx].photo;
        this.seq=this.playerlist[idx].seq;

        // 비교용
        this.c_player_name=this.player_name;//
        this.c_player_en_name=this.player_en_name;//
        this.c_gender_seq=this.gender_seq;//
        this.c_birthday=this.birthday;//
        this.c_player_type_seq=this.player_type_seq;//
        // this.c_sports_seq=this.sports_seq;//
        this.c_sports_detail=this.sports_detail;//
        this.c_area_seq=this.area_seq;//
        this.c_position_seq=this.position_seq;//
        this.c_disabled_state_seq=this.disabled_state_seq;//
        this.c_disabled_type_seq=this.disabled_type_seq;//
        this.c_disabled_grade_seq=this.disabled_grade_seq;//
        this.c_competition=this.competition;//
        this.c_reward=this.reward;//
        this.c_photo=this.photo;//
      },

      // 선수 목록
      playerList:function(){
        var _this=this;
        axios.post(_this.playerlist_api,{}).then(function(response){
          if(response.data.state==="true"){
            _this.playerlist=response.data.player;
          }else{
            _this.playerlist=[];
            if(response.data.errorcode==="ERR-130"){
              _this.errorcode="현재 목록이 없습니다.";
            }
          }
        });
      },

      // select data(options) 불러오기
      loadData:function(){
        var _this=this;

        _this.select_genderlist=selected_item.GD;
        _this.select_playerlist=selected_item.PT;
        _this.select_sportslist=selected_item.SP;
        _this.select_arealist=selected_item.AA;
        _this.select_positionlist=selected_item.PS;
        _this.select_disabled_statelist=selected_item.DS;
        _this.select_disabled_typelist=selected_item.DT;
        _this.select_gradelist=selected_item.DG;
      },

		},
		mounted:function(){
      this.playerList();
      this.loadData();
      // this.sports_seq=nav.sports_code;
    },
		created:function(){
			// 현재 메뉴(위치) 확인
			eventBus.$emit("menuinfo");
      eventBus.$emit("menudrop", [4,1]);
		}
	});
</script>
</body>
</html>