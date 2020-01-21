<!--#include virtual="/api/_func/encoding.asp"-->
<!--#include virtual="/api/_func/Utill.asp"-->
<!--#include virtual="/api/_Func/json2.asp"-->
<%
Set JsonObject = JSON.Parse(RequestJsonObject(Request))
loginChk = JsonObject.get("loginChk")

JsonStr = "{"
If loginChk = "0" Then
  If SessionChk() = true Then
    Arr_param = SessionToArray() '모든세션 array 반환
    SessionDate = ""
    For i = 0 To UBound(Arr_param,1)
      SessionDate = SessionDate &","""& Arr_param(i,0) &""" : """& Arr_param(i,1) &""""
    Next
    JsonStr = JsonStr & """State"": ""true"", ""session"" : [{"& mid(SessionDate,2) &"}]"
  Else
    JsonStr = JsonStr & """State"": ""false"""
  End If
Else
  JsonStr = JsonStr & """State"": ""false"""
End If
JsonStr = JsonStr &"}"

Response.Clear
Response.Write JsonStr
%>
