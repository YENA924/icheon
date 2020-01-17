<!--#include virtual="/api/_func/URICheck.asp"-->
<!--#include virtual="/api/_func/select_item.asp"-->
<div id="nav" class="l_menuwrap" v-cloak>
  <!-- <button class="tabidx" v-on:keyup.enter="cont.$refs.content.focus()">메뉴 건너뛰기</button> -->
  <div class="l_popup__dimm"></div>
  <div class="l_logoarea">
    <a class="l_logo m_ibarea" v-if="nav_list[0]!=undefined" v-bind:href="nav_list[0].uri">
      <div><img src="/front/img/icon_logo.svg" alt="이천훈련원 메인화면으로 이동"></div>
      <p>이천훈련원</p>
    </a>
  </div>
	<div class="l_logininfo m_ibarea">
    <div class="img"><img src="/front/img/icon_profile.svg" alt=""></div>
    <div class="l_userinfo">
      <p>{{username}}</p>
      <p>{{association_title}}</p>
    </div>
    <a href="/member_update.asp" class="l_top_linkbtn">정보변경</a>
	</div>
	<nav>
		<h2 class="hidden">이천훈련원 메뉴 목록</h2>
		<template v-for="(list,key) in nav_list" :key="key" v-if="key!=0">
			<div class="l_menuarea">
				<button class="l_menu" v-bind:class="{s_on: check_depth1==list.step1}" v-if="list.submenu[0].step2!=undefined" @click="menuChoice(list.step1, $event.target)" @focus="menuFocus(list.step1, $event.target)">{{list.title}}</button>
				<div class="l_submenu" v-bind:class="{s_on: check_depth1==list.step1}" v-if="list.submenu[0].step2!=undefined">
					<div>
						<a v-for="(sublist,key2) in list.submenu" :key="key2" v-bind:href="'/'+sublist.uri" v-bind:class="{s_on: depth1==list.step1 && sublist.step2==depth2}">{{sublist.title}}</a>
					</div>
				</div>
				<a v-bind:href="'/'+list.uri" v-if="list.submenu[0].step2==undefined" class="l_menu" v-bind:class="{s_on: check_depth1==list.step1}">{{list.title}}</a>
			</div>
		</template>
  </nav>
  
  <!-- 로딩이미지 -->
  <transition name="fade">
    <div class="l_popup_bg" v-if="loading">
      <div class="m_loading_wrap">
        <div class="m_loading_img"><img src="/front/img/loaderx.gif" alt="" style="width:100%;"></div>
        <p>Loading...</p>
      </div>
    </div>
  </transition>
</div>


<script>
  // 로딩바
  var loaderEvent=new Vue();
  var mixin_loader={
    data:{
      loading:false,
      request_no:0,
      response_no:0,
    },
    methods:{
      showLoader:function(){
        this.loading=true;
        this.request_no+=1;
      },
      hideLoader:function(){
        this.response_no+=1;
        if(this.request_no===this.response_no){
          this.loading=false;
        }
      }
    },
    created:function(){
      loaderEvent.$on("beforeRequest", this.showLoader);
      loaderEvent.$on("responseOrError", this.hideLoader);
    }
  };
  axios.defaults.headers.get["cache-control"]="no-cache";
  axios.interceptors.request.use(
    function(config){
      loaderEvent.$emit("beforeRequest");
      return config;
    },
    function(error){
      var e=JSON.parse(JSON.stringify(error));
      if(e.code=="ECONNABORTED"){
        alert("network가 불안정해서 화면을 갱신합니다");
        location.reload();
      }else{
        alert("network error, 관리자에게 문의하세요");
      }
      loaderEvent.$emit("responseOrError");
      return Promise.reject(error);
    }
  );
  axios.interceptors.response.use(
    function(response){
      loaderEvent.$emit("responseOrError");
      return response;
    },
    function(error){
      loaderEvent.$emit("responseOrError");
      return Promise.reject(error);
    }
  );
  axios.defaults.timeout=8000;


  // 
	var eventBus=new Vue();

	var nav=new Vue({
    mixins:[mixin_loader],
    
		el:"#nav",
		data:{
			api_logout:"http://ic.sportsdiary.co.kr/api/loginout/logout.asp",
			nav_url:"http://ic.sportsdiary.co.kr/api/menu_control/menu.asp",
      sessioncheck_api:"http://ic.sportsdiary.co.kr/api/loginout/loginChk.asp",//서버세션체크
      association_api:"http://ic.sportsdiary.co.kr/api/menu_control/selected_association.asp",// 협회목록
      sports_api:"http://ic.sportsdiary.co.kr/api/menu_control/selected_item_custom.asp",// 종목 목록
      filedown_api:"http://ic.sportsdiary.co.kr/api/file_upload/file_download.asp",// 파일 다운로드

			groupCode:"",
      username:"",
      userid:"",
      // group:"",
      association_name:"",// 협회명
      association_seq:"",// seq
      associationlist:[],// 협회 목록
      sports_code:"",// 종목코드
      sports_title:"",// 종목명
      sportslist:[],// 종목 목록
      employee_seq:"",// 회원seq
      access:"1",// 0 : 소유계정 보이기,  1: 안보이기
      association_title:"",// 계정 정보의 권한표시

      defaultYear:2019,// 기준년도 2019년.
      year:"",// 현재 연도. ....연도 selectbox 만들려고

			nav_list:[],
			check_depth1:0,// 메뉴에서 선택한거. 0 기본
			depth1:null,// 현재 화면 메뉴
			depth2:null,// 현재 화면 서브메뉴
      loctitle:"",// 화면 위치
      loctitle2:"",// 화면 위치
		},
		watch:{},
		methods:{
			// axios 불러오기
			// 로그인 세션 확인
			sessionCheck:function(){
				// 세션 키가 없을 때
				if(!sessionStorage.groupcode && sessionStorage.groupcode==null){
          alert("세션이 만료되었습니다. 다시 로그인 해주세요.");
          location.href="/index.asp";
          return false;
				}else{ // 있을 때
          this.groupCode=sessionStorage.getItem("groupcode");
          this.username=sessionStorage.getItem("username");
          this.userid=sessionStorage.getItem("userid");
          this.group=sessionStorage.getItem("group");
          this.association_seq=sessionStorage.getItem("association_code");
          this.sports_code=sessionStorage.getItem("sports_code");
          this.employee_seq=sessionStorage.getItem("employee_seq");
          this.access=sessionStorage.getItem("access");
          this.association_title=sessionStorage.getItem("association_title");
          return true;
				}
			},
      // logout
			logout:function(){
				var _this=this
				axios.get(_this.api_logout).then(function(response){
					if(response.data.state=="true"){
						localStorage.clear();
						sessionStorage.clear();
						location.href="/index.asp";
					}
				}).catch(function(error){
					console.log("logout error : ");
					console.log(error);
				}).finally(function(){
					console.log("logout ok");
				});
			},

			// 메뉴
			loadNav:function(url){
				var _this=this;
				axios.post(url,{
					groupcode:this.groupCode
				}).then(function(response){
					if(response.data.state=="true"){
						_this.nav_list=response.data.menu;

            // 현재 화면 위치 타이틀
            _this.nav_list.filter(function(value,idx){
              if(value.step1==_this.depth1){
                _this.loctitle=value.title;

                if(value.submenu){
                  value.submenu.filter(function(val2,idx2){
                    if(val2.step2==_this.depth2){
                      _this.loctitle2=val2.title;
                    }
                  });
                }
              }
            });

					}
				}).catch(function(error){
					console.log("loadNav error : ");
					console.log(error);
				});
			},
			// 메뉴 선택시 서브메뉴 보이기
			menuChoice:function(no,target){
				this.check_depth1=no;

				if(target.nextElementSibling.getAttribute("style")==null){
					target.nextElementSibling.setAttribute("style", "height:"+target.nextElementSibling.childNodes[0].clientHeight+"px");
				}
			},
			// 탭이동으로 메뉴에 접근하면 해당 서브메뉴 보이기
			menuFocus:function(key,etarget){
				this.menuChoice(key,etarget)
			},
			// 컨텐츠화면에서 보낸 메뉴 위치 받아서 설정하기
			menuDrop:function(deptharr){
				this.depth1=deptharr[0];
				this.depth2=deptharr[1];
        this.check_depth1=deptharr[0];
			},

      // 서버 세션체크
      serverSessionCheck:function(){
        var _this=this;
        setTimeout(function(){
          axios.post(_this.sessioncheck_api).then(function(response){
            if(response.data.State==="true"){
              _this.serverSessionCheck();
            }
            if(response.data.State==="false"){
              sessionStorage.clear();
              // alert("세션이 만료되었습니다. 다시 로그인 해주세요.");
              location.href="/index.asp";
            }
          });
        }, 600000);
      },

      // 협회 체크
      associationCheck:function(){
        var _this=this;
        if(selected_item.association.length<0){
          axios.post(_this.association_api,{}).then(function(response){
            if(response.data.state==="true"){
              _this.associationlist=response.data.program;
              _this.associationlist.filter(function(val,idx){
                if(_this.association_seq===val.seq){
                  _this.association_name=val.title;
                  return;
                }
              });
            }else{
              _this.associationlist=[];
            }
          });
        }
        else{
          _this.associationlist=selected_item.association;
          _this.associationlist.filter(function(val,idx){
            if(_this.association_seq===val.seq){
              _this.association_name=val.title;
              return;
            }
          });
        }
      },

      // 종목 체크
      sportsCheck:function(){
        var _this=this;
        if(selected_item.SP.length<0){
          axios.post(_this.sports_api,{
            code:"SP"
          }).then(function(response){
            if(response.data.state==="true"){
              _this.sportslist=response.data.sports
              _this.sportslist.filter(function(val,idx){
                if(_this.sports_code==val.seq){
                  _this.sports_title=val.title;
                  return;
                }
              });
            }else{
              _this.sportslist=[];
            }
          });
        }
        else{
          _this.sportslist=selected_item.SP;
          _this.sportslist.filter(function(val,idx){
            if(_this.sports_code==val.seq){
              _this.sports_title=val.title;
              return;
            }
          });
        }
      },

      // 파일 다운로드
      downloadFile:function(url){
        var _this=this;
        axios.post(_this.filedown_api,{
          fileuri:url
        }).then(function(){
          location.href="/api/file_upload/file_download.asp?fileuri="+url;
        });
      },

      // 천 단위 ,
      addComma:function(no){
        return no.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      },
      // 전화번호 4자리 -
      addDash:function(str){
        str=str.replace(/-/g,"");
        return str.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
      },
      // 생일 4자리.2자리.2자리.
      addBirthDot:function(str){
        str=str.replace(/[(.)]/g,"");
        return str.replace(/([0-9]{4})([0-9]{2})([0-9]{2})/,"$1.$2.$3");
      },
      // 엑셀 다운
      excelDown:function(id,filename){
        var tab_text="<html xmlns:x='urn:schemas-microsoft-com:office:excel'>";
        tab_text=tab_text+"<head><meta http-equiv='content-type' content='application/vnd.ms-excel; charset=UTF-8'>";
        tab_text=tab_text+'<xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>'
        tab_text=tab_text+'<x:Name>Sheet</x:Name>';
        tab_text=tab_text+'<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';
        tab_text=tab_text+'</x:ExcelWorksheets></x:ExcelWorkbook></xml></head><body>';
        tab_text=tab_text+"<table border='1px'>";

        var exportTable=$("#"+id).clone();
        exportTable.find("input").each(function(index, elem){$(elem).remove();});
        tab_text=tab_text+exportTable.html();
        tab_text=tab_text+"</table></body></html>";

        var data_type="data:application/vnd.ms-excel";
        var ua=window.navigator.userAgent;
        var msie=ua.indexOf("MSIE ");
        var fileName=filename+".xls";

        //Explorer 환경에서 다운로드
        if(msie>0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)){
          if(window.navigator.msSaveBlob){
            var blob=new Blob([tab_text], {
              type:"application/csv;charset=utf-8;"
            });
            navigator.msSaveBlob(blob, fileName);
          }
        }else{
          var blob2=new Blob([tab_text], {
            type:"application/csv;charset=utf-8;"
          });
          var filename=fileName;
          var elem=window.document.createElement("a");
          elem.href=window.URL.createObjectURL(blob2);
          elem.download=filename;
          document.body.appendChild(elem);
          elem.click();
          document.body.removeChild(elem);
        }
      },
      // 선택한 두 개의 날짜 사이의 날짜들
      getDateRange:function(sdate,edate,listdate){
        var dateMove=new Date(sdate);
        var strdate=sdate;
        if(sdate===edate){
          var strdate=dateMove.toISOString().substr(0,10);
          listdate.push(strdate);
        }else{
          while(strdate<edate){
            var strdate=dateMove.toISOString().substr(0,10);
            listdate.push(strdate);
            dateMove.setDate(dateMove.getDate()+1);
          }
        }
        return listdate;
      }

		},
		mounted:function(){
      // 서버세션체크
      var _this=this;
      this.serverSessionCheck();
      axios.post(_this.sessioncheck_api).then(function(response){
        if(response.data.State==="false"){
          sessionStorage.clear();
          location.href="/index.asp";
        }
      });

			// 다른 메뉴 선택 시 부드럽게 움직이도록 현재 메뉴에 높이값 주기.
			setTimeout(function(){
				if(document.querySelector(".l_submenu.s_on")!=null){
					var cur_menu=document.querySelector(".l_submenu.s_on");
					cur_menu.setAttribute("style", "height:"+cur_menu.childNodes[0].clientHeight+"px");
				}
			},300);


			// 임시로 css에 캐시 안생기게////////////////////////////////////////
			document.head.querySelectorAll("link").forEach(function(ele,idx){////
				if(ele.getAttribute("href")==="/front/css/ic.css"){////////////////////
					ele.setAttribute("href", "/front/css/ic.css?"+Date.now());///////////
					return;//////////////////////////////////////////////////////////
				}//////////////////////////////////////////////////////////////////
			});//////////////////////////////////////////////////////////////////
		},
		created:function(){
			var isLogin=this.sessionCheck();
			if(isLogin){
				this.loadNav(this.nav_url);
				eventBus.$on("menudrop", this.menuDrop);// 다른 vue 컴포넌트에서 "menudrop"으로 보내면 menuDrop 함수 실행

        this.year=new Date().getFullYear();
        this.associationCheck();
        this.sportsCheck();
			}
		}
	});
</script>
