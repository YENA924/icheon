<!--#include virtual="/api/_func/encoding.asp"-->
<!--#include virtual="/api/_func/Utill.asp"-->
<!--#include virtual="/api/_Func/json2.asp"-->
<!--#include virtual="/api/_conn/DBCon.asp"-->
<%
DBOpen()
Dim Param

'Sql = "update TB_TABLETEST set title = # where seq = #"
'Redim Param(1)
'Param(0) = "req"
'param(1) = 1
''Call ResponseQueryString(Sql, Param)
'Call ExecuteUpdate(Sql, Param, DB)

Sql = "select * from TB_TABLETEST where seq = # "
Redim Param(0)
Param(0) = 2
'Call ResponseQueryString(Sql, Param)
List = ParamExecuteReturn(Sql, Param, DB)
If isNull(List) = False Then
  For i = 0 To UBound(List,2)
    Response.Write List(0,i) &"//"
    Response.Write List(1,i) &"<BR>"
  Next
Else
  Response.Write "검색 결과가 없습니다."
End If

DBClose()
%>
