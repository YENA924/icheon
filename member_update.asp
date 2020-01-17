<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct member_update" v-cloak>
	<div class="l_content">
    <!-- 컨텐츠 영역. s. -->
    
    <h2>회원정보조회/변경</h2>
    <div class="l_list_tablewrap">
      <div class="l_update_line m_ibarea">
        <div class="l_update_field l_long">
          <p class="l_update_title">소속단체명</p>
          <p class="l_update_info m_nochange">{{memberinfo.association}}</p>
        </div>
        <div class="l_update_field">
          <p class="l_update_title">권한</p>
          <p class="l_update_info m_nochange">{{memberinfo.permission}}</p>
        </div>
      </div>
      <div class="l_update_line m_ibarea">
        <div class="l_update_field">
          <label for="email" class="l_update_title">이메일</label>
          <input type="text" id="email" class="l_update_info" placeholder="이메일을 입력하세요" v-model="email">
        </div>
        <div class="l_update_field">
          <label for="name" class="l_update_title">이름</label>
          <input type="text" id="name" class="l_update_info" placeholder="이름을 입력하세요" v-model="name">
        </div>
      </div>
      <div class="l_update_line m_ibarea">
        <div class="l_update_field">
          <label for="id" class="l_update_title">ID</label>
          <input type="text" id="id" class="l_update_info m_nochange" :value="memberinfo.id">
        </div>
        <div class="l_update_field">
          <label for="pw" class="l_update_title">PW</label>
          <input type="password" id="pw" class="l_update_info m_nochange s_white" value="1111122222">
        </div>
        <div class="l_update_field l_pos_b" v-if="nav.access==='0'">
          <button @click="changePw(true)">비밀번호변경</button>
        </div>
      </div>
      <div class="l_update_line m_ibarea">
        <div class="l_update_field">
          <label for="phone" class="l_update_title">휴대폰 번호</label>
          <input type="text" id="phone" class="l_update_info m_nochange s_white" placeholder="휴대폰 번호를 입력하세요" v-model="phone">
        </div>
        <div class="l_update_field l_pos_b">
          <button @click="changePhone(true)">번호 변경</button>
        </div>
      </div>
      <div class="l_search_btns">
        <button class="l_btn s_blue" v-bind:class="{s_gray:!info_update}" @click="showUpdate(true)">정보변경</button>
        <a href="main.asp" class="l_btn s_white">취 소</a>
      </div>
    </div>

    <div class="l_search_btns" v-if="nav.access=='0' && nav.groupCode=='ASSOCIATION'">
      <button class="l_btn s_orange" @click="showAcccount(true)">소유 계정 목록 보기</button>
    </div>
    <p class="l_account_cmt" v-if="nav.access=='0' && nav.groupCode=='ASSOCIATION'">※ 소유한 계정의 정보조회 및 변경이 가능합니다.</p>

    <!-- 팝업 -->
    <transition name="fade">
      <div class="l_popup_bg" v-if="show_pwpop">
        <div class="l_popup_area">
          <p class="l_popup_title">비밀번호를 변경하시겠습니까?</p>
          <div class="l_pop_ch_updatewrap l_pw">
            <div class="l_pop_ch_updateline m_ibarea">
              <label for="pw_cur">현재 비밀번호</label>
              <input id="pw_cur" type="password" placeholder="현재 비밀번호를 입력해주세요" v-model="pw_cur">
            </div>
            <div class="l_pop_ch_updateline m_ibarea">
              <label for="pw_new">새 비밀번호 입력</label>
              <input id="pw_new" type="password" placeholder="새 비밀번호를 입력해주세요" v-model="pw_new">
            </div>
            <div class="l_pop_ch_updateline m_ibarea">
              <label for="pw_re">새 비밀번호 확인</label>
              <input id="pw_re" type="password" placeholder="새 비밀번호를 입력해주세요" v-model="pw_re">
            </div>
          </div>
          <div class="l_search_btns">
            <button class="l_btn s_blue" @click="changePw('ok')">확 인</button>
            <button class="l_btn s_white" @click="changePw(false)">취 소</button>
          </div>
        </div>
      </div>
    </transition>
    
    <transition name="fade">
      <div class="l_popup_bg" v-if="show_phonepop">
        <div class="l_popup_area">
          <p class="l_popup_title">휴대폰 번호 변경</p>
          <div class="l_pop_ch_updatewrap">
            <div class="l_pop_ch_updateline m_ibarea">
              <label for="newphone">휴대폰 번호</label>
              <input id="newphone" type="text" placeholder="휴대폰 번호를 입력해주세요" v-model="phone_new">
              <button @click="authCode">인증번호 받기</button>
            </div>
            <div class="l_pop_ch_updateline m_ibarea">
              <label for="authnum">인증번호 입력</label>
              <input id="authnum" type="text" placeholder="인증번호를 입력해주세요" v-model="phone_auth">
              <button @click="authCheck">인증 하기</button>
            </div>
          </div>
          <p class="l_pop_changephone_cmt" v-if="auth_ok">* 휴대폰 인증이 완료되었습니다.</p>
          <div class="l_search_btns">
            <button class="l_btn s_blue" @click="changePhone('ok')">확 인</button>
            <button class="l_btn s_white" @click="changePhone(false)">취 소</button>
          </div>
        </div>
      </div>
    </transition>
    
    <transition name="fade">
      <div class="l_popup_bg" v-if="show_accountpop">
        <div class="l_popup_area l_accountlist">
          <p class="l_popup_title">소유 계정 목록 보기</p>
          <div class="l_list_tablewrap m_tbodyscroll">
            <table>
              <caption>소유 계정 선택 목록</caption>
              <thead>
                <tr>
                  <th scope="col"></th>
                  <th scope="col">신청일</th>
                  <th scope="col">이름</th>
                  <th scope="col">유선 연락처</th>
                  <th scope="col">휴대폰 번호</th>
                  <th scope="col">이메일</th>
                  <th scope="col">ID</th>
                </tr>
              </thead>
              <tbody>
                <tr v-if="accountlit.length==0" style="width:100%;display:table;">
                  <td colspan="7" style="display:table-cell;width:100%;"><p class="m_no_list" style="height:17rem;line-height:17rem;"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
                </tr>
                <tr v-if="accountlit.length>0" v-for="(list,key) in accountlit" :key="key">
                  <td>
                    <div class="l_radio">
                      <input type="radio" class="l_radio" :id="account+key" name="account" :value="list.employee_seq" v-model="account">
                      <label :for="account+key">{{list.regdate}} {{list.name}} 선택</label>
                    </div>
                  </td>
                  <td><label :for="account+key">{{list.regdate}}</label></td>
                  <td><label :for="account+key">{{list.name}}</label></td>
                  <td><label :for="account+key">{{list.homephone}}</label></td>
                  <td><label :for="account+key">{{list.cellphone}}</label></td>
                  <td><label :for="account+key">{{list.email}}</label></td>
                  <td><label :for="account+key">{{list.id}}</label></td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="l_search_btns">
            <button class="l_btn s_blue" v-bind:class="{s_gray:account==''}" @click="showAcccount('ok')">정보보기</button>
            <button class="l_btn s_white" @click="showAcccount(false)">취 소</button>
          </div>
        </div>
      </div>
    </transition>

    <transition name="fade">
      <div class="l_popup_bg" v-if="showpop">
        <div class="l_popup_area">
          <p class="l_popup_title">회원정보를 수정하시겠습니까?</p>
          <p class="l_popup_cmt">확인을 누르시면 정보가 변경됩니다.</p>
          <div class="l_search_btns">
            <button type="submit" class="l_btn s_blue" @click="showUpdate('ok')">확 인</button>
            <button type="reset" class="l_btn s_white" @click="showUpdate(false)">취 소</button>
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
      // 
      member_api:"http://ic.sportsdiary.co.kr/api/employee_manager/employee_view.asp",// member api
      pwchange_api:"http://ic.sportsdiary.co.kr/api/employee_manager/pw_change.asp",// 
      phoneauthcode_api:"http://ic.sportsdiary.co.kr/api/employee_manager/phone_confirm_add.asp",// 인증번호 받기
      phoneauth_api:"http://ic.sportsdiary.co.kr/api/employee_manager/phone_confirm.asp",// 인증하기
      memberupdate_api:"http://ic.sportsdiary.co.kr/api/employee_manager/employee_update.asp",// update
      accountlist_api:"http://ic.sportsdiary.co.kr/api/employee_manager/assoc_employee_list.asp",// 소유 계정 목록 api

      memberinfo:[],// member info
      accountlit:[],// 소유 계정 목록

      // 
      email:"",//
      name:"",//
      pw:"",// pw
      pw_cur:"",// 현재 pw
      pw_new:"",// 새 pw
      pw_re:"",// 새 pw 확인
      phone:"",// phone
      phone_new:"",// new phone
      phone_auth:"",// phone auth
      auth_ok:false,// 인증 완료 여부
      authnum:"",// phone change auth
      account:"",// 소유 계정 seq

      // 비교용
      c_email:"",//
      c_name:"",//
      info_update:false,// 수정했나?

      // 팝업 보이기 여부
      show_pwpop:false,// pw
      show_phonepop:false,// phone
      show_accountpop:false,// accounts
      showpop:false,//
    },
    watch:{
      email:function(newval,oldval){
        this.email=newval;
        this.c_email!=this.email? this.info_update=true : this.info_update=false;
      },
      name:function(newval,oldval){
        this.name=newval;
        this.c_name!=this.name? this.info_update=true : this.info_update=false;
      },
    },
    methods:{
      // 회원정보
      memberView:function(){
        var _this=this;
        axios.post(_this.member_api,{
          employee_seq:_this.account==""? nav.employee_seq : _this.account
        }).then(function(response){
          if(response.data.state==="true"){
            _this.memberinfo=response.data.employee_view[0];
            _this.email=_this.memberinfo.email;
            _this.name=_this.memberinfo.name;
            _this.phone=_this.memberinfo.cellphone;

            _this.c_email=_this.email;
            _this.c_name=_this.name;
            _this.info_update=false;// 수정했나?
          }else if(response.data.state==="false"){
            _this.memberinfo=[];
            console.log("내용 없음");
          }
        });
      },

      // PW 변경
      changePw:function(bo){
        // bo : true, false = 팝업 띄우기 여부
        // bo : "ok" = pw 변경 확인
        var _this=this;
        if(bo===true){
          _this.show_pwpop=bo
        }else if(bo===false){
          _this.show_pwpop=bo;
          _this.pw_cur="";
          _this.pw_new="";
          _this.pw_re="";
        }

        // 번호 변경 확인
        if(bo==="ok"){
          if(_this.pw_new!==_this.pw_re){
            alert("새 비밀번호를 확인해 주십시오");
            return;
          }

          axios.post(_this.pwchange_api,{
            employee_seq:_this.account==""? nav.employee_seq : _this.account,
            pw:_this.pw_cur,
            newpw:_this.pw_new
          }).then(function(response){
            if(response.data.state==="true"){
              _this.info_update=true;
              _this.pw=_this.pw_new;
              _this.show_pwpop=false;
              _this.pw_cur="";
              _this.pw_new="";
              _this.pw_re="";
            }else if(response.data.state==="false"){
              if(response.data.errorcode==="ERR-310"){
                alert("현재 비밀번호를 잘못 입력하였습니다");
              }
            }
          });
        }
      },

      // 인증번호받기
      authCode:function(){
        var _this=this;
        axios.post(_this.phoneauthcode_api,{
          phone:nav.addDash(_this.phone_new)
        }).then(function(response){
          if(response.data.errorcode==="ERR-110"){
            alert("휴대폰 번호를 입력하세요");
          }
        });
      },
      // 인증하기
      authCheck:function(){
        var _this=this;
        axios.post(_this.phoneauth_api,{
          security_num:_this.phone_auth
        }).then(function(response){
          if(response.data.errorcode==="ERR-330"){
            alert("인증번호가 잘못되었습니다");
            return;
          }
          if(response.data.state==="true"){
            _this.auth_ok=true;
          }
        });
      },
      // 휴대폰 번호 변경
      changePhone:function(bo){
        // bo : true, false = 팝업 띄우기 여부
        // bo : "ok" = phone 변경 확인
        var _this=this;
        if(bo===true || bo===false){
          _this.show_phonepop=bo
          _this.phone_new="";
          _this.phone_auth="";
          _this.auth_ok=false;
        }

        // 번호 변경 확인
        if(bo==="ok"){
          if(_this.auth_ok===true){
            _this.info_update=true;
            _this.show_phonepop=false;
            _this.phone=_this.phone_new;
          }
        }
      },

      // 소유 계정 목록 보기
      showAcccount:function(bo){
        // bo : true, false = 팝업 띄우기 여부
        // bo : "ok" = 정보보기
        var _this=this;
        if(bo===true){
          _this.account="";
          _this.show_accountpop=bo
          _this.accountlit=[];
          axios.post(_this.accountlist_api,{}).then(function(response){
            if(response.data.state==="true"){
              _this.accountlit=response.data.new_employee;
            }else if(response.data.state==="false"){
              if(response.data.errorcode==="ERR-130"){
                // console.log("목록 없음");
              }
              _this.accountlit=[];
            }
          });
        }else if(bo===false){
          _this.show_accountpop=bo
          _this.accountlit=[];
        }

        // 정보보기 변경 확인
        if(bo==="ok"){
          if(_this.account!=""){
            _this.show_accountpop=false;
            _this.memberView();
          }
        }
      },

      // 회원정보 수정
      showUpdate:function(bo){
        // bo : true, false = 팝업 띄우기 여부
        // bo : "ok" = 정보보기
        var _this=this;
        if(bo===true){
          if(_this.info_update===true){
            _this.showpop=bo
          }
        }else if(bo===false){
          _this.showpop=bo;
        }

        // 번호 변경 확인
        if(bo==="ok"){
          if(_this.info_update===true){
            if(_this.email=="" || _this.name=="" || _this.phone==""){
              alert("모든 정보를 입력해주세요");
              return;
            }
            axios.post(_this.memberupdate_api,{
              employee_seq:_this.account==""? nav.employee_seq : _this.account,
              email:_this.email,
              username:_this.name,
              cellphone:nav.addDash(_this.phone)
            }).then(function(response){
              if(response.data.state==="true"){
                _this.email="";
                _this.name="";
                _this.phone="";
                _this.memberView();
                _this.showpop=false;
              }else if(response.data.state==="false"){
                if(response.data.errorcode==="ERR-340"){
                  _this.memberView();
                  _this.showpop=false;
                  alert("인증되지 않은 휴대폰 번호입니다.");
                }
              }
            });
          }
        }
      },

    },
		mounted:function(){
      this.memberView();
    },
		created:function(){
			// 현재 메뉴(위치) 확인
			eventBus.$emit("menuinfo");
      eventBus.$emit("menudrop", [1,0]);
		}
	});
</script>
</body>
</html>