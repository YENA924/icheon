<!--#include virtual="/api/_func/encoding.asp"-->
<!--#include virtual="/api/_func/Utill.asp"-->
<!--#include virtual="/api/_Func/json2.asp"-->
<!--#include virtual="/api/_conn/DBCon.asp"-->
<!--#include virtual="/api/_func/report_env_client.asp"-->
<!--#include virtual="/include/join_header.asp"-->
<%
'파일 로그
JsonData = RequestJsonObject2(Request)
Call TraceSysInfo(JsonData, Request)
%>

<%
DBOpen()
Dim Param

Set JsonObject = JSON.Parse(JsonData)

chk = Hour(Now()) & Minute(Now()) & Second(Now())
For i = 0 To 50
  Randomize
  num = num + Rnd*chk
Next
SESSION("chknum") = LEFT(REPLACE(num,".",""),6)

INSERT_SQL = " INSERT INTO TB_PHONE_CHECK (CONFIRM_NUMBER) VALUES (#) "
Redim Param(0)
Param(0) = LEFT(num,6)
'Call ResponseQueryString(INSERT_SQL, Param)
Call ParamsExecuteUpdate(INSERT_SQL, Param, DB)

%>
<body>
  <div id="l_join" v-cloak>
    <div id="l_join__wrap">
      <div id="admin_join_box">
        <div id="in_list">
          <!-- login mark -->
          <div class="l_mark">
            <img src="./front/img/Logo_Icheon.png" alt="로고 이미지"/>
          </div>
          <!-- login -->
          <div class="l_join__box_wrap">
            <div>
              <p>"안녕하세요.</p>
              <p>선수가 중심이라는 마음으로</p>
              <p>미래를 생각하는 이천훈련원 입니다."</p>
            </div>
          </div>
        </div>

        <div id="l_find_pw_board" class="logo s_tab_board__con">
          <ul class="l_find_board__li">
            <li class="libtn" class="libtn" v-bind:class="{active: show_tab==1}" @click="show_tab=1;">
              아이디 찾기
            </li>
            <li class="libtn" class="libtn" v-bind:class="{active: show_tab==2}" @click="show_tab=2;">
              비밀번호 찾기
            </li>
          </ul>
          <div id="l_find__form">
            <div class="l_find__form l_id" v-if="show_tab==1">
              <div class="m_form__title">
                <p>회원 가입시 등록된 회원정보로 아이디를 찾을 수 있습니다.</p>
                <p>아래 정보를 입력해 주세요.</p>
              </div>
              <div class="m_join__field_box">
                <label for="idchk_phone">휴대폰 번호</label>
                <input id="idchk_phone" class="m_middle_txt" type="text" placeholder="'-'없이 입력해 주세요." maxlength="13"/>
              </div>
              <div class="m_join__field_box">
                <label for="idchk_name">이름</label>
                <input id="idchk_name" class="m_middle_txt" type="text" placeholder="고길동" />
              </div>
              <div class="s_find_id" v-if="id_process == true">
                <span>ID : </span>
                <span id="chkid" class="s_blue_txt">{{id}}</span>
              </div>
              <div class="m_form__btns">
                <button class="m_btn s_blue m_right" v-if="id_process == false" @click="id_find_chk">아이디 찾기</button>
                <button class="m_btn s_white" v-if="id_process == false" onclick="location.href='/index.asp';">취소</button>
                <button class="m_btn s_blue" v-if="id_process == true" onclick="location.href='/index.asp';">로그인 바로가기</button>
              </div>
            </div>
            <div class="l_find__form l_pw" v-if="show_tab==2">
              <div id="l_pw__process" v-if="pw_process == 0 || pw_process == 1">
                <div class="m_form__title">
                  <p>회원 가입시 등록된 회원정보를 확인 후 비밀번호 재설정이 가능합니다.</p>
                  <p>아래 정보를 입력한 후 확인해 주세요.</p>
                </div>
                <div class="m_join__field_box">
                  <label for="pwchk_id">아이디</label>
                  <input id="pwchk_id" class="m_middle_txt" type="text" placeholder="아이디를 입력해 주세요." />
                </div>
                <div class="m_join__field_box">
                  <label for="pwchk_phone">휴대폰 번호</label>
                  <input id="pwchk_phone" class="m_middle_txt" type="text" placeholder="'-'없이 입력해 주세요." maxlength="13"/>
                </div>
                <div class="m_join__field_box">
                  <label for="pwchk_name">이름</label>
                  <input id="pwchk_name" class="m_middle_txt" type="text" placeholder="고길동" />
                </div>
                <div class="s_find_pw" v-show="pw_process == '1'">
                  <span class="s_blue_txt">*휴대폰으로 인증번호가 전송되었습니다.</span>
                  <div class="m_join__field_box" style="margin-top:15px;">
                    <label for="pwchk_security_num">인증번호</label>
                    <input id="pwchk_security_num" class="m_middle_txt" type="text" placeholder="인증번호를 입력해 주세요." />
                  </div>
                  <div class="m_join__field_box">
                    <label for="pwchk_pw">비밀번호 재설정</label>
                    <input id="pwchk_pw" class="m_middle_txt" type="password" placeholder="변경할 비밀번호 6-12자의 영문+숫자 조합입력" />
                  </div>
                </div>
                <div class="m_form__btns">
                  <button class="m_btn s_blue m_right" v-show="pw_process == '0'" @click="pw_find_chk">정보 확인</button>
                  <button class="m_btn s_blue m_right" v-show="pw_process == '1'" @click="pw_find_save">비밀번호 재설정</button>
                  <button class="m_btn s_white" v-show="pw_process == '0' || pw_process == '1'" onclick="location.href='/index.asp';">취소</button>
                </div>
              </div>
              <div id="l_pw__success" v-else>
                <p class="s_blue_txt">비밀번호가 변경되었습니다.</p>
                <div class="m_form__btns">
                  <button class="m_btn s_blue" onclick="location.href='/index.asp';">로그인 바로가기</button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div id="l_notice">
          <span class="copy_text">온라인 입퇴촌 신청 사용문의/장애처리</span>
          <span class="copy_text">전화 : 041)589-0940</span>
          <span class="copy_text">내선 : 102</span>
        </div>
      </div>
    </div>
  </div>
<script>

var l_join = new Vue({
  el:'#l_join',
  data:{
    show_tab: '1',

    id_process: false,
    pw_process: '0',
    id: '',
  },
  watch:{

  },
  methods:{
    // 패스워드 찾기
    pw_find_chk:function() {
      var _this=this;
      var pwchk_id = $("#pwchk_id").val();
      var pwchk_phone = $("#pwchk_phone").val();
      var pwchk_name = $("#pwchk_name").val();

      // 아이디 미입력시
      if(pwchk_id == ""){alert("아이디를 입력해주세요.");return;}
      // 휴대폰번호 미입력시
      if(pwchk_phone == ""){alert("휴대폰 번호를 입력해주세요.");return;}
      // 이름 미입력시
      if(pwchk_name == ""){alert("이름을 입력해주세요.");return;}

      // 패스워드를 찾기 위한 인증번호 api
      axios.post("/api/loginout/pw_find.asp",{
        pwchk_id: pwchk_id
        ,pwchk_phone: pwchk_phone
        ,pwchk_name: pwchk_name
      }).then(function(response){
        if(response.data.state=="true"){
          $("#pwchk_id").attr("disabled",true);
          $("#pwchk_phone").attr("disabled",true);
          $("#pwchk_name").attr("disabled",true);
          _this.pw_process = '1';
        }else if(response.data.state=="false"){
          if(response.data.errorcode=="ERR-550"){
            alert("해당 아이디로 가입된 가입정보를 찾을 수 없습니다.");
          }
          // 가입 정보를 찾을 수 없을때
          if(response.data.errorcode=="ERR-560"){
            alert("이 아이디로 로그인 할 수 없습니다. 관리자에게 문의하세요.");
          }
        }
      }).catch(function(error){
        console.log(error);
      }).finally(function(){
        console.log("success");
      });
    },

    // 패스워드 재설정
    pw_find_save:function() {
      var _this=this;
      var pwchk_security_num = $("#pwchk_security_num").val();
      var pwchk_pw = $("#pwchk_pw").val();
      var pwchk_id = $("#pwchk_id").val();

      // 인증번호 미입력시
      if(pwchk_security_num == ""){alert("인증번호를 입력하세요.");return;}
      // 패스워드 미입력시
      if(pwchk_pw == ""){alert("패스워드를 입력하세요.");return;}
      // 패스워드 유효성 검사
      if(CheckPass(pwchk_pw)==false){alert("비밀번호 6~12자리 영문+숫자조합 입니다.다시 입력해주세요.");return;}

      // 패스워드 재설정 api
      axios.post("/api/loginout/pw_find_save.asp",{
        pwchk_security_num: pwchk_security_num
        ,pwchk_pw: pwchk_pw
        ,pwchk_id: pwchk_id
      }).then(function(response){
        if(response.data.state=="true"){
          _this.pw_process = '2';
        }else if(response.data.state=="false"){
          if(response.data.errorcode=="ERR-530"){
            alert("인증번호를 입력할 수 없습니다.");
          }
          if(response.data.errorcode=="ERR-540"){
            alert("인증번호를 다시 입력해 주세요.");
          }
          if(response.data.errorcode=="ERR-560"){
            alert("이 아이디로 로그인 할 수 없습니다. 관리자에게 문의해 주세요.");
          }
        }
      }).catch(function(error){
        console.log(error);
      }).finally(function(){
        console.log("success");
      });
    },

    // 아이디 찾기
    id_find_chk:function(){
      var _this=this;
      var idchk_phone = $("#idchk_phone").val()
      var idchk_name = $("#idchk_name").val()

      // 휴대폰 번호 미입력시
      if(idchk_phone==""){alert("휴대폰 번호를 입력 하세요");return;}
      // 이름 미입력시
      if(idchk_name==""){alert("이름을 입력 하세요");return;}

      // 아이디 찾기 api
      axios.post("/api/loginout/id_find.asp",{
        idchk_phone: idchk_phone
        ,idchk_name: idchk_name
      }).then(function(response){
        if(response.data.state=="true"){
          _this.id = response.data.id;
          _this.id_process = true;
        } else if(response.data.state=="false"){
          alert("해당 아이디로 가입된 가입정보를 찾을 수 없습니다.");
        }
      }).catch(function(error){
        console.log(error);
      }).finally(function(){
        console.log("success");
      });
    },
  },
  mounted:function(){

  },
  created:function(){
  }
});

// 휴대폰번호 입력 시, 자릿수 계산
$(document).on("keyup", "#idchk_phone", function() { $(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})/,"$1-$2-$3").replace("--", "-") ); });
$(document).on("keyup", "#pwchk_phone", function() { $(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})/,"$1-$2-$3").replace("--", "-") ); });

// 패스워드 체크
var CheckPass = function(str){
   var reg1 = /^[a-z0-9]{6,12}$/;    // a-z 0-9 중에 7자리 부터 14자리만 허용 한다는 뜻이구요
   var reg2 = /[a-z]/g;
   var reg3 = /[0-9]/g;
   return(reg1.test(str) &&  reg2.test(str) && reg3.test(str));
};
</script>
</body>
</html>
