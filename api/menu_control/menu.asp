<!--#include virtual="/api/_func/encoding.asp"-->
<!--#include virtual="/api/_func/Utill.asp"-->
<!--#include virtual="/api/_Func/json2.asp"-->
<!--#include virtual="/api/_conn/DBCon.asp"-->
<%
DBOpen()
Dim Param

Set JsonObject = JSON.Parse(RequestJsonObject(Request))
groupcode = JsonObject.get("groupcode")

'If SessionChk() = true Then
  MENU_SQL =            " SELECT "
  MENU_SQL = MENU_SQL & " A.STEP1 "
  MENU_SQL = MENU_SQL & " ,A.STEP2 "
  MENU_SQL = MENU_SQL & " ,A.TITLE "
  MENU_SQL = MENU_SQL & " ,A.URI "
  MENU_SQL = MENU_SQL & " ,A.POPUPKEY "
  MENU_SQL = MENU_SQL & " FROM TB_MENU A "
  MENU_SQL = MENU_SQL & " INNER JOIN TB_MENU_GROUP B ON A.SEQ = B.MENU_SEQ AND B.DELKEY = 0 "
  MENU_SQL = MENU_SQL & " INNER JOIN TB_GROUP C ON B.GROUP_SEQ = C.SEQ AND C.DELKEY = 0 "
  MENU_SQL = MENU_SQL & " WHERE C.CODE = # AND A.DELKEY = 0 "
  MENU_SQL = MENU_SQL & " ORDER BY A.STEP1,A.STEP2,A.STEP3 "

  Redim Param(0)
  Param(0) = groupcode
  'Call ResponseQueryString(MENU_SQL, Param)
  MENUS = ParamExecuteReturn(MENU_SQL, Param, DB)
  If isNull(MENUS) = False Then
    CHKSTEP = 0
    JsonStep1 = ""
    JsonStep2 = ""
    JsonMenuTotal = "{"
    For i=0 To Ubound(MENUS,2)
      If CHKSTEP <> MENUS(0,i) Then
        CHKSTEP = MENUS(0,i)
        If i > 0 Then
          If JsonStep2 <> "" Then JsonStep2 = JsonStep2 & "}]"
          JsonMenuTotal = JsonMenuTotal & JsonStep1 & JsonStep2 & "},{"
          JsonStep1 = ""
          JsonStep2 = ""
        End If
      End If

      If MENUS(1,i) = 0 Then
        JsonStep1 = JsonStep1 & """step1"": """& MENUS(0,i) &""" "
        JsonStep1 = JsonStep1 & ", ""title"":"""& MENUS(2,i) &""" "
        JsonStep1 = JsonStep1 & ", ""uri"":"""& MENUS(3,i) &""" "
        JsonStep1 = JsonStep1 & ", ""popup"":"""& MENUS(4,i) &""" "
      Else
        If MENUS(1,i) = 1 Then JsonStep2 = ", ""submenu"":[{"
        If MENUS(1,i) > 1 Then JsonStep2 = JsonStep2 & "},{"
        JsonStep2 = JsonStep2 & " ""step2"":"""& MENUS(1,i) &""" "
        JsonStep2 = JsonStep2 & ", ""title"":"""& MENUS(2,i) &""" "
        JsonStep2 = JsonStep2 & ", ""uri"":"""& MENUS(3,i) &""" "
        JsonStep2 = JsonStep2 & ", ""popup"":"""& MENUS(4,i) &""" "
      End If
    Next
    If JsonStep2 <> "" Then JsonStep2 = JsonStep2 & "}]"
    JsonMenuTotal = JsonMenuTotal & JsonStep1 & JsonStep2 & "}"
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
