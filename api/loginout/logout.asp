<!--#include virtual="/api/_func/encoding.asp"-->
<!--#include virtual="/api/_func/Utill.asp"-->
<%
Call SessionAbadon()

Response.Clear
Response.Write "{""state"":""true""}"
%>
