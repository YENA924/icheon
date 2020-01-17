<!--#include virtual="/include/header_calendar.asp"-->

<!--#include virtual="/include/nav.asp"-->
<!--#include virtual="/include/content_header.asp"-->

<section id="icContent" class="l_ct join_apply" v-cloak>
	<div class="l_content">
		<!-- 컨텐츠 영역. s. -->
    <h2>입촌신청내역 조회</h2>
    <div class="l_selectarea">
      <select title="연도 선택" v-model="currentyear" @change="loadData">
        <option v-for="n in nav.year" v-if="(nav.year+1)-n>=nav.defaultYear" :value="(nav.year+1)-n">{{(nav.year+1)-n}}</option>
      </select>
    </div>
    
    <div class="l_title_cmt">* 확인이 완료된 신청서는 삭제가 불가능합니다.</div>
    <div class="l_search_btns">
      <button class="l_btn s_blue" @click="newUpdatePage(1)">신규등록</button>
    </div>

    <div class="l_list_box">
      <div class="l_list_tablewrap">
        <table>
          <caption>입촌신청내역 목록</caption>
          <colgroup>
            <col style="width:4%;">
            <col style="width:7%;">
            <col style="width:7%;">
            <col style="width:12%;">
            <col style="width:12%;">
            <col style="width:6%;">
            <col style="width:7%;">
            <col style="width:5%;">
            <col style="width:10%;">
            <col style="width:11%;">
            <col style="width:14%;">
            <col style="width:5%;">
          </colgroup>
          <thead>
            <tr>
              <th scope="col">번호</th>
              <th scope="col">신청상태</th>
              <th scope="col">신청일</th>
              <th scope="col">소속단체명</th>
              <th scope="col">종목</th>
              <th scope="col">훈련구분</th>
              <th scope="col">장애유형</th>
              <th scope="col">신청자명</th>
              <th scope="col">연락처</th>
              <th scope="col">이메일</th>
              <th scope="col">단체서약서</th>
              <th scope="col">입촌인원</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="listdata.length==0">
              <!-- <td colspan="12">{{errorcode}}</td> -->
              <td colspan="12"><p class="m_no_list"><span class="no_list_icon"><img src="/front/img/icon_search.svg" alt=""></span>검색된 결과가 없습니다.</p></td>
            </tr>
            <tr class="m_cursor" v-if="listdata.length>0" v-for="(list,key) in listdata" :key="key" @click="newUpdatePage(2, list.enter_seq)">
              <td>{{list.reverseIdx}}</td>
              <td v-bind:class="{s_orange_txt2:list.enter_state=='반려', s_blue_txt:list.enter_state=='확인 요청' || list.enter_state=='확인 후 수정' || list.enter_state=='임시 저장' }">{{list.enter_state}}</td>
              <td>{{list.reg_date}}</td>
              <td>{{list.association}}</td>
              <td>{{list.sports}}</td>
              <td>{{list.training_type}}</td>
              <td>{{list.disabled_type}}</td>
              <td>{{list.applicant_name}}</td>
              <td>{{list.phone}}</td>
              <td>{{list.email}}</td>
              <td>{{list.agree_file}}</td>
              <td>{{list.player_cnt}}</td>
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
      leader_api:"http://ic.sportsdiary.co.kr/api/enter_center_manager/enter_list_leader.asp",// 입촌신청내역 조회
      currentyear:"",
      listdata:[],
      errorcode:"",
		},
		watch:{},
		methods:{
      // 신규등록 버튼, 목록에서 선택한 신청 정보 수정하기
      newUpdatePage:function(no, enterseq){
        // 신규
        if(no==1){
          location.href="/join_apply_new.asp";
        }
        // 수정
        else if(no==2){
          // enter_seq 를 주소로 같이 보내서...
          location.href="/join_apply_new.asp?enter_seq="+enterseq;
        }
      },

      // 목록 불러오기
      loadData:function(){
        var _this=this;
        axios.post(_this.leader_api,{
          reg_year:_this.currentyear
        }).then(function(response){
          if(response.data.state==="true"){
            _this.listdata=response.data.player;
          }else{
            if(response.data.errorcode==="ERR-130"){
              _this.listdata=[];
              _this.errorcode="현재 목록이 없습니다.";
            }
          }
        }).catch(function(error){
          console.log("join_apply.asp 에서 : ");
          console.log(error);
        });
      }
		},
		mounted:function(){
      this.currentyear=new Date().getFullYear();
      this.loadData();
    },
		created:function(){
			// 현재 메뉴(위치) 확인
			eventBus.$emit("menuinfo");
			eventBus.$emit("menudrop", [4,2]);
		}
	});
</script>
</body>
</html>