<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct facility_manager" v-cloak>
	<div class="l_content">
		<!-- 컨텐츠 영역. s. -->
		<h2>시설 현황 및 등록</h2>
  
    <div class="l_search_box">
      <div class="l_search_field">
        <div class="l_field">
          <label for="facility_type">구분</label>
          <span class="l_inputpoint" v-if="facility_type_seq==''">*</span>
          <select name="facility_type" id="facility_type" v-model="facility_type_seq">
            <option value="">선택</option>
            <option v-for="(option,key) in selectinfo.facility_type" :key="key" :value="option.seq">{{option.title}}</option>
          </select>
        </div>
        <div class="l_field">
          <label for="quarter">동/관</label>
          <span class="l_inputpoint" v-if="quarter_seq==''">*</span>
          <select name="quarter" id="quarter" v-model="quarter_seq">
            <option value="">선택</option>
            <option v-for="(option,key) in selectinfo.quarter" :key="key" :value="option.seq">{{option.title}}</option>
          </select>
        </div>
        <div class="l_field">
          <label for="floor">층</label>
          <span class="l_inputpoint" v-if="floor_seq==''">*</span>
          <select name="floor" id="floor" v-model="floor_seq">
            <option value="">선택</option>
            <option v-for="(option,key) in selectinfo.floor" :key="key" :value="option.seq">{{option.title}}</option>
          </select>
        </div>
        <div class="l_field">
          <label for="number">실</label>
          <input type="text" id="number" placeholder="실을 입력하세요" v-model="number">
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field">
          <label for="use">이용대상/종목</label>
          <span class="l_inputpoint" v-if="use_seq==''">*</span>
          <select name="use" id="use" v-model="use_seq">
            <option value="">선택</option>
            <option v-for="(option,key) in selectinfo.use" :key="key" :value="option.seq">{{option.title}}</option>
          </select>
        </div>
        <div class="l_field">
          <label for="fixed">정원</label>
          <span class="l_inputpoint" v-if="fixed==''">*</span>
          <input type="text" id="fixed" placeholder="정원을 입력하세요" v-model="fixed">
        </div>
        <div class="l_field">
          <label for="price">단가</label>
          <span class="l_inputpoint" v-if="price==''">*</span>
          <input type="text" id="price" placeholder="단가를 입력하세요" v-model="price">
        </div>
        <div class="l_field">
          <label for="extension">내선번호</label>
          <input type="text" id="extension" placeholder="내선번호를 입력하세요" v-model="extension">
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field">
          <label for="department">관리부서</label>
          <span class="l_inputpoint" v-if="department==''">*</span>
          <input type="text" id="department" placeholder="관리부서를 입력하세요" v-model="department">
        </div>
        <div class="l_field">
          <label for="relative">비고</label>
          <input type="text" id="relative" placeholder="비고를 입력하세요" v-model="relative">
        </div>
      </div>
      <div class="l_search_btns">
        <button type="submit" class="l_btn s_blue" v-bind:class="{gray: !info_update && choicedata}" @click="saveData">{{!choicedata? "등록" : "수정"}}</button>
        <button type="submit" class="l_btn s_orange" v-if="choicedata" @click="removeData">삭제</button>
        <button type="submit" class="l_btn s_white" v-if="choicedata" @click="choicedata=false;init()">신규</button>
      </div>
    </div>

    <div class="l_list_box">
      <div class="l_list_btns">
        <button class="l_btn_download" @click="nav.excelDown('exceldown', '시설정보목록')">엑셀다운<span class="img"><img src="/front/img/icon_arrow_down.svg" alt=""></span></button>
      </div>
      <div class="l_list_tablewrap">
        <table id="exceldown">
          <caption>시설 정보 목록</caption>
          <colgroup>
            <col style="width:3%;">
            <col style="width:7%;">
            <col style="width:5%;">
            <col style="width:13%;">
            <col style="width:3%;">
            <col style="width:9%;">
            <col style="width:9%;">
            <col style="width:6%;">
            <col style="width:8%;">
            <col style="width:10%;">
            <col style="width:10%;">
            <col style="width:17%;">
          </colgroup>
          <thead>
            <tr>
              <th></th>
              <th scope="col">코드</th>
              <th scope="col">구분</th>
              <th scope="col">동/관</th>
              <th scope="col">층</th>
              <th scope="col">실</th>
              <th scope="col">이용대상/종목</th>
              <th scope="col">정원</th>
              <th scope="col">단가(원)</th>
              <th scope="col">관리부서</th>
              <th scope="col">내선번호</th>
              <th scope="col">비고</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="listinfo.length==0">
              <td colspan="12"><p class="m_no_list"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
            </tr>
            <tr class="m_cursor" v-bind:class="{l_choice:choice==key}" v-if="listinfo.length>0" v-for="(list,key) in listinfo" :key="key" @click="listInfoChoice(key)">
              <td>{{(Number(total_no)+1)-Number(list.no)}}</td>
              <td>{{list.code}}</td>
              <td>{{list.facility_type}}</td>
              <td>{{list.quarter}}</td>
              <td>{{list.floor}}</td>
              <td>{{list.number}}</td>
              <td>{{list.use}}</td>
              <td>{{nav.addComma(list.fixed)}}</td>
              <td>{{nav.addComma(list.price)}}</td>
              <td>{{list.department}}</td>
              <td>{{list.extension}}</td>
              <td>{{list.relative}}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
		<!-- 컨텐츠 영역. e. -->
	</div>
</section>


<script>
	var cont=new Vue({
		el:"#icContent",
		data:{
      select_api:"http://ic.sportsdiary.co.kr/api/menu_control/selected_item.asp",// 온셥 정보 목록 url
      list_api:"http://ic.sportsdiary.co.kr/api/facility_manager/facility_list.asp",// 시설 목록 url
      save_api:"http://ic.sportsdiary.co.kr/api/facility_manager/facility_add.asp",// 등록 
      update_api:"http://ic.sportsdiary.co.kr/api/facility_manager/facility_modify.asp",// 수정
      remove_api:"http://ic.sportsdiary.co.kr/api/facility_manager/facility_del.asp",// 삭제
      
      selectinfo:[],// 시설 정보 목록. select option
      listinfo:[],// 시설 목록

      // selected
      facility_type_seq:"",// 구분 value
      quarter_seq:"",// 동/관 value값
      floor_seq:"",// 층 value값
      number:"",// 실
      use:"",// 이용대상/종목
      use_seq:"",// 이용대상/종목 seq
      fixed:"",// 정원
      price:"",// 단가
      extension:"",// 내선번호
      department:"",// 관리부서
      relative:"",// 비고

      // 비교용
      facility_type_seq_ori:"",//
      quarter_seq_ori:"",//
      floor_seq_ori:"",//
      number_ori:"",//
      use_seq_ori:"",//
      fixed_ori:"",//
      price_ori:"",//
      extension_ori:"",//
      department_ori:"",//
      relative_ori:"",//

      total_no:"",// 전체 목록 수

      // 테이블 선택 시(true). 등록 -> 수정, 삭제, 신규
      choicedata:false,
      choice:-1,
      info_update:false,// 수정했나?
      info_updateno:0,// 처음에 로딩되면서 값이 바뀜..
		},
		watch:{
      facility_type_seq:function(newval,oldval){
        this.facility_type_seq=newval;
        this.facility_type_seq_ori!=this.facility_type_seq ? this.info_update=true : this.info_update=false;
      },
      quarter_seq:function(newval,oldval){
        this.quarter_seq=newval;
        this.quarter_seq_ori!=this.quarter_seq ? this.info_update=true : this.info_update=false;
      },
      floor_seq:function(newval,oldval){
        this.floor_seq=newval;
        this.floor_seq_ori!=this.floor_seq ? this.info_update=true : this.info_update=false;
      },
      number:function(newval,oldval){
        this.number=newval;
        this.number_ori!=this.number ? this.info_update=true : this.info_update=false;
      },
      use_seq:function(newval,oldval){
        this.use_seq=newval;
        this.use_seq_ori!=this.use_seq ? this.info_update=true : this.info_update=false;
      },
      fixed:function(newval,oldval){
        this.fixed=newval;
        this.fixed_ori!=this.fixed ? this.info_update=true : this.info_update=false;
      },
      price:function(newval,oldval){
        this.price=newval;
        this.price_ori!=this.price ? this.info_update=true : this.info_update=false;
      },
      extension:function(newval,oldval){
        this.extension=newval;
        this.extension_ori!=this.extension ? this.info_update=true : this.info_update=false;
      },
      department:function(newval,oldval){
        this.department=newval;
        this.department_ori!=this.department ? this.info_update=true : this.info_update=false;
      },
      relative:function(newval,oldval){
        this.relative=newval;
        this.relative_ori!=this.relative ? this.info_update=true : this.info_update=false;
      }
    },
		methods:{
      // 목록 불러오기
      loadData:function(){
        var _this=this;

        // 옵션 목록 불러오기
        var selectInfo=axios.post(_this.select_api,{
          step1:2,step2:1
        });

        // 시설 목록 불러오기
        var listInfo=axios.post(_this.list_api,{});

        // 한 번에 불러오기
        axios.all([
          selectInfo,
          listInfo
        ]).then(axios.spread(function(responseselect, responselist){
        // ]).then(axios.spread((...response)=>{
          if(responseselect.data.state==="true"){
            _this.selectinfo=responseselect.data;
          }

          if(responselist.data.state==="true"){
            _this.listinfo=responselist.data.facility;
            _this.total_no=responselist.data.total;
          }
        })).catch(function(errorselect, errorlist){
          console.log("errorselect : ");
          console.log(errorselect);
          console.log("");
          console.log("errorlist : ");
          console.log(errorlist);
        });
      },

      // 선택한 테이블 정보
      listInfoChoice:function(idx){
        this.choicedata=true;
        this.choice=idx;
        this.facility_type_seq=this.listinfo[idx].facility_type_seq;
        this.quarter_seq=this.listinfo[idx].quarter_seq;
        this.floor_seq=this.listinfo[idx].floor_seq;
        this.number=this.listinfo[idx].number;
        this.use=this.listinfo[idx].use;
        this.use_seq=this.listinfo[idx].use_seq;
        this.fixed=this.listinfo[idx].fixed;
        this.price=this.listinfo[idx].price;
        this.extension=this.listinfo[idx].extension;
        this.department=this.listinfo[idx].department;
        this.relative=this.listinfo[idx].relative;
        this.seq=this.listinfo[idx].seq;

        // 비교용
        this.facility_type_seq_ori=this.facility_type_seq;//
        this.quarter_seq_ori=this.quarter_seq;//
        this.floor_seq_ori=this.floor_seq;//
        this.number_ori=this.number;//
        this.use_seq_ori=this.use_seq;//
        this.fixed_ori=this.fixed;//
        this.price_ori=this.price;//
        this.extension_ori=this.extension;//
        this.department_ori=this.department;//
        this.relative_ori=this.relative;//
      },

      // 
      init:function(){
        this.choicedata=false;
        this.choice=-1;
        this.info_update=false;
        this.facility_type_seq="";
        this.quarter_seq="";
        this.floor_seq="";
        this.number="";
        this.use_seq="";
        this.fixed="";
        this.price="";
        this.extension="";
        this.department="";
        this.relative="";
        this.seq="";
        
        // 비교용
        this.facility_type_seq_ori="";//
        this.quarter_seq_ori="";//
        this.floor_seq_ori="";//
        this.number_ori="";//
        this.use_seq_ori="";//
        this.fixed_ori="";//
        this.price_ori="";//
        this.extension_ori="";//
        this.department_ori="";//
        this.relative_ori="";//
      },
      // 등록/수정
      saveData:function(txt){
        var _this=this;
        if(_this.quarter_seq=="" || _this.floor_seq=="" || _this.use_seq=="" || _this.fixed=="" || _this.price=="" || _this.department=="" || _this.facility_type_seq==""){
          alert("*는 빠짐없이 입력/선택 하세요.");
          return;
        }

        if(!_this.choicedata){
          // 등록
          axios.post(_this.save_api,{
            facility_type_seq:_this.facility_type_seq,
            quarter_seq:_this.quarter_seq,
            floor_seq:_this.floor_seq,
            number:_this.number,
            use_seq:_this.use_seq,
            fixed:_this.fixed,
            price:_this.price,
            extension:nav.addDash(_this.extension),
            department:_this.department,
            relative:_this.relative
          }).then(function(response){
            if(response.data.state==="true"){
              _this.loadData();
              _this.init();
            }
          });
        }else{
          // 수정
          if(_this.info_update){
            axios.post(_this.update_api,{
              facility_type_seq:_this.facility_type_seq,
              quarter_seq:_this.quarter_seq,
              floor_seq:_this.floor_seq,
              number:_this.number,
              use_seq:_this.use_seq,
              fixed:_this.fixed,
              price:_this.price,
              extension:nav.addDash(_this.extension),
              department:_this.department,
              relative:_this.relative,
              seq:_this.seq
            }).then(function(response){
              if(response.data.state==="true"){
                _this.loadData();
                _this.init();
              }
            });
          }
        }
      },

      // 삭제
      removeData:function(){
        var _this=this;
        axios.post(_this.remove_api,{
          seq:_this.seq
        }).then(function(response){
          if(response.data.state==="true"){
            _this.loadData();
            _this.init();
          }
        });
      }
		},
		mounted:function(){
      this.loadData();
    },
		created:function(){
			// 현재 메뉴(위치) 확인
			eventBus.$emit("menuinfo");
			eventBus.$emit("menudrop", [2,1]);
		}
	});
</script>
</body>
</html>