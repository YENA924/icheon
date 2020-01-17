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

ITEM_SQL = " SELECT SEQ,TITLE FROM TB_ASSOCIATION WHERE DELKEY = 0 ORDER BY TITLE "
ITEMS = ExecuteReturn(ITEM_SQL, DB)
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

        <div id="l_join_board" class="logo s_tab_board__con">
          <div class="m_join__title">
            <h1>회원가입신청</h1>
          </div>
          <div id="l_join__form" v-if="!join_success">
            <div class="m_join__field_box">
              <label for="department">소속단체명</label>
              <select id="association" onchange="selectchk(this.value);">
                <option>:::선택하세요:::</option>
                <option value="selfadd">직접입력</option>
                <%
                  If IsNull(ITEMS) = False Then
                    For i = 0 To Ubound(ITEMS,2)
                %>
                <option value="<%=ITEMS(1,i)%>"><%=ITEMS(1,i)%></option>
                <%
                    Next
                  End If
                %>
              </select>
              <input id="department" class="m_large_txt" type="text" disabled />
            </div>
            <div class="m_join__field_box">
              <div class="m_join__field">
                <label for="name">이름</label>
                <input id="name" class="m_small_txt" type="text" placeholder="고길동"/>
              </div>
              <div class="m_join__field">
                <label for="email">이메일</label>
                <input id="email" class="m_small_txt" type="text" placeholder="sample@naver.com"/>
              </div>
              <div class="m_join__field">
                <label for="telephone">유선전화번호</label>
                <input id="telephone" class="m_small_txt" type="text" placeholder="00-000-0000" maxlength="13"/>
              </div>
            </div>
            <div class="m_join__field_box">
              <label for="id">ID</label>
              <input id="id" class="m_small_txt" type="text" placeholder="아이디를 입력해 주세요." />
            </div>
            <div class="m_join__field_box">
              <div class="m_join__field">
                <label for="pw">PW</label>
                <input id="pw" class="m_small_txt" type="password"  placeholder="비밀번호 6~12자리 영문+숫자 조합"/>
              </div>
              <div class="m_join__field">
                <label for="pwChk">PW 확인</label>
                <input id="pwChk" class="m_small_txt" type="password" placeholder="비밀번호를 재입력 하세요."/>
              </div>
            </div>
            <div class="m_join__field_box">
              <label for="phone">휴대폰 번호</label>
              <input id="phone" class="m_small_txt" type="text" placeholder="000-0000-0000" maxlength="13"/>
              <button id="phone_btn" class="m_form__btn s_gray" onclick="phone_confirm();">인증번호 받기</button>
            </div>
            <div class="m_join__field_box">
              <label for="security_num">인증번호 입력</label>
              <input id="security_num" class="m_small_txt" type="text" placeholder="인증번호를 입력하세요." disabled/>
              <button id="security_num_btn" class="m_form__btn s_gray" onclick="phone_confirm_chk();">인증 하기</button>
            </div>
            <div class="m_form__btns">
              <button class="m_btn s_blue m_right" @click="applyJoin()">회원 가입 신청</button>
              <button class="m_btn s_white" onclick="location.href='/index.asp';">취소</button>
            </div>
          </div>
          <div class="m_join__success" v-if="join_success">
            <div class="m_join__success_notice">
              <p class="s_blue_txt">회원가입 신청이 완료되었습니다 !</p>
              <p class="s_gray_txt">가입 승인여부는 승인과 동시에 메일 혹은 문자로 발송됩니다.</p>
              <p class="s_orange_txt m_small_txt">※가입 승인여부는 승인과 동시에 메일 혹은 문자로 발송됩니다.</p>
            </div>
            <div class="m_form__btns">
              <button class="m_btn s_blue" onclick="location.href='/index.asp';">확인</button>
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
    join_success: false, // 회원가입 성공
  },
  watch:{

  },
  methods:{
    applyJoin:function(){
      var _this=this;
      // 유효성 검사
      if($("#department").val()==""){alert("소속단체명을 입력하세요.");return;}
      if($("#name").val()==""){alert("이름을 입력하세요.");return;}
      if($("#email").val()==""){alert("이메일을 입력하세요.");return;}
      if(chkEmail($("#email").val()) == false){alert("이메일 형식이 맞지 않습니다. 다시 확인해주세요");return;}
      if($("#telephone").val()==""){alert("유선전화번호를 입력하세요.");return;}
      if($("#id").val()==""){alert("아이디를 입력하세요.");return;}
      if(CheckId($("#id").val())==false){alert('아이디는 영문+숫자조합 입니다. 다시 입력해주세요.');return;}
      if($("#id").val().length < 6){alert('아이디가 너무 짧습니다.');return;}
      if($("#id").val().length > 21){alert('아이디가 너무 깁니다.');return;}
      if($("#pw").val()==""){alert("패스워드를 입력하세요.");return;}
      if(CheckPass($("#pw").val())==false){alert('비밀번호 6~12자리 영문+숫자조합 입니다. 다시 입력해주세요.');return;}
      if($("#pw").val()!=$("#pwChk").val()){alert("확인된 패스워드가 다릅니다. 다시 입력하세요.");return;}
      if(document.getElementById('phone').disabled==false){alert("휴대폰 번호를 인증 해주세요.");return;}

      var department = $("#department").val();
      var name = $("#name").val();
      var email = $("#email").val();
      var telephone = $("#telephone").val();
      var id = $("#id").val();
      var pw = $("#pw").val();
      var phone = $("#phone").val();
      var security_num = $("#security_num").val();
      // 회원가입 api 연동
      axios.post("/api/loginout/join.asp",{
        department: department
        ,name: name
        ,email: email
        ,telephone: telephone
        ,id: id
        ,pw: pw
        ,phone: phone
        ,security_num: security_num
      }).then(function(response){
        if(response.data.state=="true"){
          // _this.join_success = true;
          location.href = "/join_complete.asp";
        }else if(response.data.state=="false"){
          // 이미 아이디가 있을 때
          if (response.data.errorcode=="ERR-510"){
            alert("이미 있는 아이디 입니다. 아이디를 다시 입력해 주세요.");
          }
          if (response.data.errorcode=="ERR-560"){
            alert("휴대폰 번호가 인증되지 않았습니다. 휴대폰 번호를 인증해 주세요.");
          }
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

// 셀렉트 박스 init
var selectchk = function(v){
  if(v=='selfadd'){
    $('#department').attr("disabled",false);
    $('#department').val('');
  }else if(v==':::선택하세요:::'){
    $('#department').attr("disabled",true);
    $('#department').val('');
  }else{
    $('#department').attr("disabled",true);
    $('#department').val(v);
  }
}

// 이메일 검사
var chkEmail = function(str){
  var regExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
  if (regExp.test(str)) return true;
  else return false;
}

// 패스워드 검사
var CheckPass = function(str){
   var reg1 = /^[a-z0-9]{6,12}$/;
   var reg2 = /[a-z]/g;
   var reg3 = /[0-9]/g;
   return(reg1.test(str) &&  reg2.test(str) && reg3.test(str));
};

// 아이디 검사
var CheckId = function(str){
  var reg1 = /^[a-z]/g;
  var reg2 = /[0-9]/g;
  return(reg1.test(str) && reg2.test(str));
};

// 핸드폰 번호, 전화번호 입력시
$(document).on("keyup", "#telephone", function() { $(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})/,"$1-$2-$3").replace("--", "-") ); });
$(document).on("keyup", "#phone", function() { $(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})/,"$1-$2-$3").replace("--", "-") ); });

// 핸드폰 번호 인증번호 보내기
var phone_confirm = function(){
  if($("#phone").val()==""){alert("휴대폰 번호를 입력하세요.");return;}
  var phonenumber = $("#phone").val();

  axios.post("/api/loginout/phone_confirm_add.asp",{
    phone: phonenumber
  }).then(function(response){
    if(response.data.state=="true"){
      alert("인증번호를 발송했습니다.\r\n30분 이내에 인증번호를 입력해 주세요.");
      $('#security_num').attr("disabled",false);
    }
  }).catch(function(error){
    console.log(error);
  }).finally(function(){
    console.log("success");
  });
}

// 핸드폰 번호 인증번호 확인
var phone_confirm_chk = function(){
  var security_num = $("#security_num").val();
  axios.post("/api/loginout/phone_confirm.asp",{
    security_num: security_num
  }).then(function(response){
    if(response.data.state=="true"){
      alert("인증 완료 했습니다.");
      $('#security_num').attr("disabled",true);
      $('#security_num_btn').attr("disabled",true);
      $('#phone').attr("disabled",true);
      $('#phone_btn').attr("disabled",true);
    }
  }).catch(function(error){
    console.log(error);
  }).finally(function(){
    console.log("success");
  });
}
</script>
</body>
</html>
<%
Set JsonObject = Nothing
DBClose()
%>
