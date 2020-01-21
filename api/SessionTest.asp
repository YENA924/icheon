<!--#include virtual="/api/_func/encoding.asp"-->
<!--#include virtual="/api/_func/Utill.asp"-->
<!--#include virtual="/api/_Func/json2.asp"-->
<!--#include virtual="/api/_conn/DBCon.asp"-->
<%
Dim param(2,1) 'session 으로 만들 array 선언 1차는 세션 갯수 2차는 0:key,1:value
param(0,0) = "id"
param(0,1) = "phsk2000"
param(1,0) = "date"
param(1,1) = date()
param(2,0) = "count"
param(2,1) = 12546

ArrayToSession(param) '세션에 저장
Response.Write Session("id") &"<BR>"
Response.Write Session("date") &"<BR>"
Response.Write Session("count") &"<BR>"

Arr_param = SessionToArray() '모든세션 array 반환
For i = 0 To UBound(Arr_param,1)
  Response.Write Arr_param(i,0) &" : "& Arr_param(i,1) &"<BR/>"
Next

Response.Write SessionChk()
Call SessionRemoveAll()
Response.Write SessionChk()
%>
