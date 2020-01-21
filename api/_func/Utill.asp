<%
Function AlertMsgLocation(msg, uriString)   '#### alert찍고 location 을 변경
  Response.Write "<Script type=""text/javascript"">"
  IF Trim(msg) <> "" or isnull(msg) Then Response.Write "alert("""& msg &""");"
  IF Trim(uriString) <> "" or isnull(uriString) Then Response.Write "location.href="""& uriString &""";"
  Response.Write "</Script>"
End Function

Function BytesToStr(bytes)    '#### 바이트를 받아서 String 으로 반환한다.
  Dim Stream
  Set Stream = Server.CreateObject("Adodb.Stream")
    Stream.Type = 1 'bytes
    Stream.Open
    Stream.Write bytes
    Stream.Position = 0
    Stream.Type = 2 'String
    Stream.Charset = "utf-8"
    BytesToStr = Stream.ReadText
    Stream.Close
  Set Stream = Nothing
End Function

Function RequestJsonObject(req)   '#### request 를 검사하고 jsonString 을 반환한다.
  If Not req.TotalBytes > 0 Then
    RequestJsonObject = Null
    Exit Function
  End If
  RequestJsonObject = BytesToStr(req.BinaryRead(req.TotalBytes))
End Function

Function ArrayToSession(params)   '#### session 을 저장
  If isArray(params) = False Then Exit Function
  Session.Timeout = 600
  For i = 0 To UBound(params,1)
    Session(""& params(i,0) &"") = Cstr(params(i,1))
  Next
End Function

Function SessionToArray()   '#### session 을 가져온다
  If Session.Contents.Count > 0 Then
    Dim sessionArray : Redim sessionArray(Session.Contents.Count-1,1)
    i = 0
    For Each names in Session.Contents
      sessionArray(i,0) = names
      sessionArray(i,1) = Session(""& names &"")
      i = i + 1
    Next
    SessionToArray = sessionArray
  Else
    SessionToArray = Null
  End If
End Function

Function SessionAbadon()    '#### 사용중인 세션 전부를 즉시 만료 시킨다. ※이 함수는 쓰이는 즉시 모든 세션이 만료되고 현페이지 어디서든 세션을 사용할 수 없습니다.
  Session.Abandon
End Function

Function SessionRemove(item)    '#### item 으로 특정 세션만 삭제 한다.
  If isNull(Session(""& item &"")) = false then
    Session.Contents.Remove(""& item &"")
  End If
End Function

Function SessionRemoveAll()   '#### 모든 세션을 삭제 한다.
  Session.Contents.RemoveAll()
End Function

Function SessionChk()   '#### 세션이 있는지 체크하고 있으면 만료시간을 늘린다.
  If Session.Contents.Count > 0 Then
    Session.Timeout = 600
    SessionChk = True
  Else
    SessionChk = False
  End If
End Function

Function FileDownloadTabsUpload(FilePath,FileName)    '#### 파일 다운로드. TABSUpload4 모듈이 설치되어 있을 경우만 다운로드 된다.
  DefaultPath = FilePath & FileName
  If InStr(Request.ServerVariables("HTTP_USER_AGENT"), "Chrome") > 0 Then
  Else
    Response.AddHeader "Content-Disposition","attachment; filename=""" & Server.URLPathEncode(FileName) & """"
  End If
  SET objDownload = Server.CreateObject("TABSUpload4.Download")
  objDownload.FilePath = DefaultPath
  objDownload.TransferFile True, True
  SET objDownload = Nothing
End Function

%>
