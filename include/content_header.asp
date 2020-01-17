<div id="contentHeader" class="l_content_header" v-cloak>
  <div class="l_loc m_ibarea">
    <div class="img icon_home"><img src="/front/img/icon_home.svg" alt=""></div>
    <p>Home</p>
    <div class="img icon_depth"><img src="/front/img/icon_depth.svg" alt=""></div>
    <p>{{menu}}</p>
    <div class="img icon_depth" v-if="submenu!=''"><img src="/front/img/icon_depth.svg" alt=""></div>
    <p>{{submenu}}</p>
  </div>
  <button class="m_ibarea" @click="nav.logout">
    <span class="img"><img src="/front/img/icon_logout.svg" alt=""></span>
    <span>로그아웃</span>
  </button>
</div>

<script>
	var headtitle=new Vue({
		el:"#contentHeader",
		data:{
			menu:"",
			submenu:"",
		},
		methods:{
			// 현재 화면 위치 정보
			menuLoc:function(){
				var _this=this;
				if(nav.nav_list[0]==undefined){
					setTimeout(function(){
						_this.menuLoc();
					},10);
					return;
				}
				this.menu=nav.loctitle;
				this.submenu=nav.loctitle2;
        document.title="이천훈련원"+(this.menu!=null? " - "+this.menu:"")+" - "+document.querySelectorAll(".l_content h2")[0].innerHTML+(document.querySelectorAll(".l_content h2")[1]!=undefined?" / "+document.querySelectorAll(".l_content h2")[1].innerHTML:"");
			}
		},
		mounted:function(){},
		created:function(){
			eventBus.$on("menuinfo", this.menuLoc);// 다른 vue 컴포넌트에서 "menuinfo"으로 보내면 menuLoc 함수 실행
		}
	});
</script>