<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
	<meta name="apple-mobile-web-app-title" content="이천훈련원" />
  <meta name="format-detection" content="telephone=no" />
  
	<title>이천훈련원</title>

	<link rel="stylesheet" type="text/css" href="/front/css/common.css">
	<link rel="stylesheet" type="text/css" href="/front/css/ic.css">
	<link rel="stylesheet" type="text/css" href="/front/css/fonts/NotoKR.css">
	<link rel="stylesheet" type="text/css" href="/front/css/library/fullcalendar/fullcalendar.min.css">
	<link rel="stylesheet" type="text/css" href="/front/css/library/fullcalendar/daygrid.min.css">

  <script src="/front/js/library/fullcalendar/fullcalendar.min.js"></script>
  <script src="/front/js/library/fullcalendar/daygrid.min.js"></script>
  <script src="/front/js/library/moment/moment.min.js"></script>
  
	<script src="/front/js/library/vue/vue.min.js"></script>
  <script src="/front/js/library/vue/axios.min.js"></script>

	<script src="/front/js/library/es6-promise.min.js"></script>
	<script src="/front/js/library/es6-promise.auto.min.js"></script>
	<script src="/front/js/library/polyfill.min.js"></script>
	
	<script src="/front/js/library/jquery/jquery-3.4.1.min.js"></script>
	<script>
		// ie10 이하에선 안내 문구
		function iecheckTimer(){
			setTimeout(function(){
				if(document.getElementById("icContent")==null){
					iecheckTimer();
				}else{
					if(navigator.userAgent.match(/msie 7/gi)!=null || navigator.userAgent.match(/msie 8/gi)!=null || navigator.userAgent.match(/msie 9/gi)!=null || navigator.userAgent.match(/msie 10/gi)!=null){
						document.getElementsByTagName("html")[0].className="ielow";
						document.body.innerHTML="<p class='ietxt'>IE 브라우저는 기본 사양인 11버전 이상에서 접속하시거나 크롬, 웨일 등의 표준 브라우저로 접속해 주십시오.</p>";
					}
				}
			},7);
		}
    iecheckTimer();
	</script>
</head>
<body>
	<h1 class="hidden">이천훈련원</h1>
	<div id="l_popup__dimm"></div>