<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct fixings_manager" v-cloak>
	<div class="l_content">
		<!-- 컨텐츠 영역. s. -->
		<h2>기구 정보 등록</h2>
  
    <div class="l_search_box">
      <div class="l_search_field">
        <div class="l_field">
          <label for="quarter">동/관</label>
          <select name="quarter" id="quarter" v-model="quarter_seq">
            <option value="">선택</option>
            <option v-for="(option,key) in selectinfo.quarter" :key="key" :value="option.seq">{{option.title}}</option>
          </select>
        </div>
        <div class="l_field">
          <label for="sports">종목</label>
          <select name="sports" id="sports" v-model="sports_seq">
            <option value="">선택</option>
            <option v-for="(option,key) in selectinfo.sports" :key="key" :value="option.seq">{{option.title}}</option>
          </select>
        </div>
        <div class="l_field">
          <label for="floor">층</label>
          <select name="floor" id="floor" v-model="floor_seq">
            <option value="">선택</option>
            <option v-for="(option,key) in selectinfo.floor" :key="key" :value="option.seq">{{option.title}}</option>
          </select>
        </div>
        <div class="l_field">
          <label for="number">실</label>
          <input type="text" name="number" id="number" placeholder="실을 입력하세요" v-model="number">
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field">
          <label for="productname">품명</label>
          <input type="text" name="productname" id="productname" placeholder="품명을 입력하세요" v-model="productname">
        </div>
        <div class="l_field">
          <label for="standard">규격</label>
          <input type="text" name="standard" id="standard" placeholder="규격을 입력하세요" v-model="standard">
        </div>
        <div class="l_field">
          <label for="quantity">수량</label>
          <input type="text" name="quantity" id="quantity" placeholder="수량을 입력하세요" v-model="quantity">
        </div>
        <div class="l_field">
          <label for="purpose">사용용도</label>
          <input type="text" name="purpose" id="purpose" placeholder="사용용도를 입력하세요" v-model="purpose">
        </div>
      </div>
      <div class="l_search_field">
        <div class="l_field">
          <label for="department">운영부서</label>
          <input type="text" name="department" id="department" placeholder="운영부서를 입력하세요" v-model="department">
        </div>
        <div class="l_field">
          <label for="price">취득단가</label>
          <input type="text" name="price" id="price" placeholder="취득단가를 입력하세요" v-model="price">
        </div>
        <div class="l_field">
          <label for="acquistiondate">취득일자</label>
          <input name="acquistiondate" id="acquistiondate" class="flatpickr" placeholder="날짜선택" v-model="acquistiondate"></input>
          <div class="l_btn_calendar"><img src="/front/img/icon_calendar.svg" alt="달력선택"></div>
        </div>
        <div class="l_field">
          <label for="supplier">납품업체</label>
          <input type="text" name="supplier" id="supplier" placeholder="납품업체를 입력하세요" v-model="supplier">
        </div>
      </div>
      <div class="l_search_btns">
        <button type="submit" class="l_btn s_blue" v-bind:class="{gray:!info_update && choicedata}" @click="saveData">{{!choicedata? "등록" : "수정"}}</button>
        <button type="submit" class="l_btn s_orange" v-if="choicedata" @click="removeData">삭제</button>
        <button type="submit" class="l_btn s_white" v-if="choicedata" @click="choicedata=false;init()">신규</button>
      </div>
    </div>

    <div class="l_list_box">
      <div class="l_list_btns">
        <button class="l_btn_download" @click="nav.excelDown('exceldown', '기구정보목록')">엑셀다운<span class="img"><img src="/front/img/icon_arrow_down.svg" alt=""></span></button>
      </div>
      <div class="l_list_tablewrap">
        <table id="exceldown">
          <caption>기구 정보 목록</caption>
          <colgroup>
            <col style="width:2.5%;">
            <col style="width:4.5%;">
            <col style="width:8%;">
            <col style="width:15%;">
            <col style="width:2.5%;">
            <col style="width:8.5%;">
            <col style="width:5%;">
            <col style="width:13%;">
            <col style="width:4%;">
            <col style="width:6%;">
            <col style="width:6%;">
            <col style="width:6%;">
            <col style="width:8%;">
            <col style="width:11%;">
          </colgroup>
          <thead>
            <tr>
              <th></th>
              <th scope="col">코드</th>
              <th scope="col">동/관</th>
              <th scope="col">종목</th>
              <th scope="col">층</th>
              <th scope="col">실</th>
              <th scope="col">품명</th>
              <th scope="col">규격</th>
              <th scope="col">수량</th>
              <th scope="col">사용용도</th>
              <th scope="col">운영부서</th>
              <th scope="col">취득단가</th>
              <th scope="col">취득일자</th>
              <th scope="col">납품업체</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="listinfo.length==0">
              <td colspan="14"><p class="m_no_list"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
            </tr>
            <tr class="m_cursor" v-bind:class="{l_choice:choice==key}" v-if="listinfo.length>0" v-for="(list,key) in listinfo" :key="key" @click="listInfoChoice(key)">
              <td>{{(totallist+1)-Number(list.no)}}</td>
              <td>{{list.code}}</td>
              <td>{{list.quarter}}</td>
              <td>{{list.sports}}</td>
              <td>{{list.floor}}</td>
              <td>{{list.number}}</td>
              <td>{{list.productname}}</td>
              <td>{{list.standard}}</td>
              <td>{{list.quantity}}</td>
              <td>{{list.purpose}}</td>
              <td>{{list.department}}</td>
              <td>{{nav.addComma(list.price)}}</td>
              <td>{{list.acquistiondate}}</td>
              <td>{{list.supplier}}</td>
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
      select_api:"http://ic.sportsdiary.co.kr/api/menu_control/selected_item.asp",// 옵션 정보 목록 url
      list_api:"http://ic.sportsdiary.co.kr/api/fixings_manager/fixings_list.asp",// 기구 목록 url
      save_api:"http://ic.sportsdiary.co.kr/api/fixings_manager/fixings_add.asp",// 등록 
      update_api:"http://ic.sportsdiary.co.kr/api/fixings_manager/fixings_modify.asp",// 수정
      remove_api:"http://ic.sportsdiary.co.kr/api/fixings_manager/fixings_del.asp",// 삭제
      
      selectinfo:[],// 기구 정보 목록. select option
      listinfo:[],// 기구 목록
      totallist:0,// 목록 전체

      // selected
      quarter_seq:"",// 동/관 value값
      sports_seq:"",// 종목 value값
      floor_seq:"",// 층 value값
      number:"",// 실
      productname:"",// 품명
      standard:"",// 규격
      quantity:"",// 수량
      purpose:"",// 사용용도
      department:"",// 운영부서
      price:"",// 취득단가
      acquistiondate:"",// 취득일자
      supplier:"",// 납품업체
      seq:"",// (수정)기준점

      // 비교용
      c_quarter_seq:"",//
      c_sports_seq:"",//
      c_floor_seq:"",//
      c_number:"",//
      c_productname:"",//
      c_standard:"",//
      c_quantity:"",//
      c_purpose:"",//
      c_department:"",//
      c_price:"",//
      c_acquistiondate:"",//
      c_supplier:"",//

      // 테이블 선택 시(true). 등록 -> 수정, 삭제, 신규
      choicedata:false,
      info_update:false,// 수정했나?
      choice:-1,
		},
		watch:{
      quarter_seq:function(newval,oldval){
        this.quarter_seq=newval;
        this.c_quarter_seq!=this.quarter_seq? this.info_update=true : this.info_update=false;
      },
      sports_seq:function(newval,oldval){
        this.sports_seq=newval;
        this.c_sports_seq!=this.sports_seq? this.info_update=true : this.info_update=false;
      },
      floor_seq:function(newval,oldval){
        this.floor_seq=newval;
        this.c_floor_seq!=this.floor_seq? this.info_update=true : this.info_update=false;
      },
      number:function(newval,oldval){
        this.number=newval;
        this.c_number!=this.number? this.info_update=true : this.info_update=false;
      },
      productname:function(newval,oldval){
        this.productname=newval;
        this.c_productname!=this.productname? this.info_update=true : this.info_update=false;
      },
      standard:function(newval,oldval){
        this.standard=newval;
        this.c_standard!=this.standard? this.info_update=true : this.info_update=false;
      },
      quantity:function(newval,oldval){
        this.quantity=newval;
        this.c_quantity!=this.quantity? this.info_update=true : this.info_update=false;
      },
      purpose:function(newval,oldval){
        this.purpose=newval;
        this.c_purpose!=this.purpose? this.info_update=true : this.info_update=false;
      },
      department:function(newval,oldval){
        this.department=newval;
        this.c_department!=this.department? this.info_update=true : this.info_update=false;
      },
      price:function(newval,oldval){
        this.price=newval;
        this.c_price!=this.price? this.info_update=true : this.info_update=false;
      },
      acquistiondate:function(newval,oldval){
        this.acquistiondate=newval;
        this.c_acquistiondate!=this.acquistiondate? this.info_update=true : this.info_update=false;
      },
      supplier:function(newval,oldval){
        this.supplier=newval;
        this.c_supplier!=this.supplier? this.info_update=true : this.info_update=false;
      },
    },
		methods:{
      // 목록 불러오기
      loadData:function(){
        var _this=this;

        // 기구 옵션 목록 불러오기
        var selectInfo=axios.post(_this.select_api,{
          step1:2,step2:2
        });

        // 기구 목록 불러오기
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
            _this.listinfo=responselist.data.fixings;
            _this.totallist=Number(responselist.data.total);
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
        this.quarter_seq=this.listinfo[idx].quarter_seq;
        this.sports_seq=this.listinfo[idx].sports_seq;
        this.floor_seq=this.listinfo[idx].floor_seq;
        this.number=this.listinfo[idx].number;
        this.productname=this.listinfo[idx].productname;
        this.standard=this.listinfo[idx].standard;
        this.quantity=this.listinfo[idx].quantity;
        this.purpose=this.listinfo[idx].purpose;
        this.department=this.listinfo[idx].department;
        this.price=this.listinfo[idx].price;
        this.acquistiondate=this.listinfo[idx].acquistiondate;
        this.supplier=this.listinfo[idx].supplier;
        this.seq=this.listinfo[idx].seq;

        // 비교용
        this.c_quarter_seq=this.quarter_seq;
        this.c_sports_seq=this.sports_seq;
        this.c_floor_seq=this.floor_seq;
        this.c_number=this.number;
        this.c_productname=this.productname;
        this.c_standard=this.standard;
        this.c_quantity=this.quantity;
        this.c_purpose=this.purpose;
        this.c_department=this.department;
        this.c_price=this.price;
        this.c_acquistiondate=this.acquistiondate;
        this.c_supplier=this.supplier;
      },

      // 
      init:function(){
        this.choicedata=false;
        this.choice=-1;
        this.info_update=false;
        this.quarter_seq="";
        this.sports_seq="";
        this.floor_seq="";
        this.number="";
        this.productname="";
        this.standard="";
        this.quantity="";
        this.purpose="";
        this.department="";
        this.price="";
        this.acquistiondate="";
        this.supplier="";
        this.seq="";

        // 비교용
        this.c_quarter_seq="";
        this.c_sports_seq="";
        this.c_floor_seq="";
        this.c_number="";
        this.c_productname="";
        this.c_standard="";
        this.c_quantity="";
        this.c_purpose="";
        this.c_department="";
        this.c_price="";
        this.c_acquistiondate="";
        this.c_supplier="";
      },
      // 등록/수정
      saveData:function(txt){
        var _this=this;

        if(_this.quarter_seq=="" || _this.sports_seq=="" || _this.floor_seq=="" || _this.number=="" || _this.productname=="" || _this.standard=="" || _this.quantity=="" || _this.purpose=="" || _this.department=="" || _this.price=="" || _this.acquistiondate=="" || _this.supplier==""){
          alert("모든 정보 미입력시 등록되지 않습니다.");
          return;
        }

        if(!_this.choicedata || txt=="신규"){
          // 등록
          axios.post(_this.save_api,{
            quarter_seq:_this.quarter_seq,
            sports_seq:_this.sports_seq,
            floor_seq:_this.floor_seq,
            number:_this.number,
            productname:_this.productname,
            standard:_this.standard,
            quantity:_this.quantity,
            purpose:_this.purpose,
            department:_this.department,
            price:_this.price,
            acquistiondate:_this.acquistiondate,
            supplier:_this.supplier
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
              quarter_seq:_this.quarter_seq,
              sports_seq:_this.sports_seq,
              floor_seq:_this.floor_seq,
              number:_this.number,
              productname:_this.productname,
              standard:_this.standard,
              quantity:_this.quantity,
              purpose:_this.purpose,
              department:_this.department,
              price:_this.price,
              acquistiondate:_this.acquistiondate,
              supplier:_this.supplier,
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

      var calendar=document.querySelector(".flatpickr");
      flatpickr(calendar,{
        locale:"ko",
      });
    },
		created:function(){
			// 현재 메뉴(위치) 확인
			eventBus.$emit("menuinfo");
			eventBus.$emit("menudrop", [2,2]);
		}
	});
</script>
</body>
</html>