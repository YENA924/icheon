<!--#include virtual="/api/_func/encoding.asp"-->
<!--#include virtual="/api/_func/Utill.asp"-->
<!--#include virtual="/api/_Func/json2.asp"-->
<!--#include virtual="/api/_conn/DBCon.asp"-->
<%
DBOpen()
Dim Param

Set JsonObject = JSON.Parse(RequestJsonObject(Request))
groupcode = JsonObject.get("groupcode")
step1 = JsonObject.get("step1")

'If SessionChk() = true Then
  MENU_SQL =            " SELECT "
  MENU_SQL = MENU_SQL & " A.STEP2 "
  MENU_SQL = MENU_SQL & " ,A.TITLE "
  MENU_SQL = MENU_SQL & " ,A.URI "
  MENU_SQL = MENU_SQL & " ,A.POPUPKEY "
  MENU_SQL = MENU_SQL & " FROM TB_MENU A "
  MENU_SQL = MENU_SQL & " INNER JOIN TB_MENU_GROUP B ON A.SEQ = B.MENU_SEQ AND B.DELKEY = 0 "
  MENU_SQL = MENU_SQL & " INNER JOIN TB_GROUP C ON B.GROUP_SEQ = C.SEQ AND C.DELKEY = 0 "
  MENU_SQL = MENU_SQL & " WHERE C.CODE = # AND A.STEP1 = # AND A.STEP2 > 0 AND A.DELKEY = 0 "
  MENU_SQL = MENU_SQL & " ORDER BY A.STEP1,A.STEP2,A.STEP3 "

  Redim Param(1)
  Param(0) = groupcode
  Param(1) = step1
  'Call ResponseQueryString(MENU_SQL, Param)
  MENUS = ParamExecuteReturn(MENU_SQL, Param, DB)
  If isNull(MENUS) = False Then
    CHKSTEP = 0
    JsonStep1 = ""
    JsonMenuTotal = "{"
    For i=0 To Ubound(MENUS,2)
      If CHKSTEP <> MENUS(0,i) Then
        CHKSTEP = MENUS(0,i)
        If i > 0 Then
          JsonMenuTotal = JsonMenuTotal & JsonStep1 & "},{"
          JsonStep1 = ""
        End If
      End If

      JsonStep1 = JsonStep1 & """step1"": """& MENUS(0,i) &""" "
      JsonStep1 = JsonStep1 & ", ""title"":"""& MENUS(1,i) &""" "
      JsonStep1 = JsonStep1 & ", ""uri"":"""& MENUS(2,i) &""" "
      JsonStep1 = JsonStep1 & ", ""popup"":"""& MENUS(3,i) &""" "
    Next
    JsonMenuTotal = JsonMenuTotal & JsonStep1 & "}"
    JsonStr = "{""state"":""true"", ""menu"":["& JsonMenuTotal &"]}"

    Response.Clear
    Response.Write JsonStr
  Else
    Response.Clear
    Response.Write "{""state"":""false""}"
  End If
'Else
'  Response.Clear
'  Response.Write "{""state"":""false""}"
'End If
Set JsonObject = Nothing
DBClose()
%>
