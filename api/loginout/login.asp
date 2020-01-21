<!--#include virtual="/api/_func/encoding.asp"-->
<!--#include virtual="/api/_func/Utill.asp"-->
<!--#include virtual="/api/_Func/json2.asp"-->
<!--#include virtual="/api/_conn/DBCon.asp"-->
<%
DBOpen()
Dim Param

Set JsonObject = JSON.Parse(RequestJsonObject(Request))
id = JsonObject.get("userid")
pw = JsonObject.get("userpw")

LOGIN_SQL =             " SELECT "
LOGIN_SQL = LOGIN_SQL & " USERID "
LOGIN_SQL = LOGIN_SQL & " ,USERNAME "
LOGIN_SQL = LOGIN_SQL & " ,TITLE "
LOGIN_SQL = LOGIN_SQL & " ,CODE "
LOGIN_SQL = LOGIN_SQL & " FROM TB_EMPLOYEE A "
LOGIN_SQL = LOGIN_SQL & " INNER JOIN TB_EMPLOYEE_GROUP B ON A.SEQ = B.EMPLOYEE_SEQ AND B.DELKEY = 0 "
LOGIN_SQL = LOGIN_SQL & " INNER JOIN TB_GROUP C ON B.GROUP_SEQ = C.SEQ AND C.DELKEY = 0 "
LOGIN_SQL = LOGIN_SQL & " WHERE A.[PASSWORD] = HASHBYTES('SHA2_512', #) AND A.USERID = # AND A.DELKEY = 0 "
Redim Param(1)
Param(0) = pw
Param(1) = id
'Call ResponseQueryString(LOGIN_SQL, Param)
CHECKS = ParamExecuteReturn(LOGIN_SQL, Param, DB)
If isNull(CHECKS) = False Then
  Dim sessionParam(4,1)
  sessionParam(0,0) = "userid"
  sessionParam(0,1) = id
  sessionParam(1,0) = "username"
  sessionParam(1,1) = CHECKS(1,0)
  sessionParam(2,0) = "group"
  sessionParam(2,1) = CHECKS(2,0)
  sessionParam(3,0) = "groupcode"
  sessionParam(3,1) = CHECKS(3,0)
  sessionParam(4,0) = "logindate"
  sessionParam(4,1) = date()

  ArrayToSession(sessionParam) '세션 만듬

  Response.Clear
  Response.Write "{""state"":""true""}"
Else
  Response.Clear
  Response.Write "{""state"":""false""}"
End If

Set JsonObject = Nothing
DBClose()
%>
