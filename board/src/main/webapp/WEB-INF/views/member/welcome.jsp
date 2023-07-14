<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>   
<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">

<style>
body { font-family: "나눔고딕", "맑은고딕" }
h1 { font-family: "HY견고딕" }
a:link { color: black; }
a:visited { color: black; }
a:hover { color: blue; }
a:active { color: red; }
#hypertext { text-decoration-line: none; cursor: hand; }
#topBanner {
       margin-top:10px;
       margin-bottom:10px;
       max-width: 500px;
       height: auto;
       display: block; margin: 0 auto;
}
   
#ViewForm {
  width:900px;
  height:auto;
  padding: 35px;
  background-color:#FFFFFF;
  text-align:left;
  border:5px solid gray;
  border-radius: 30px;
} 

</style>

<title>환영 페이지</title>
</head>
<body>

<div id="main" align=center>
	<div id="ViewForm">
		<h1>${userid}(${username})</h1>
		
		<h1>■ 회원 가입일 : <fmt:formatDate value="${regdate}" type="both" /></h1>
		<h1>■ 마지막 로그인 날짜 : <fmt:formatDate value="${lastlogindate}" type="both" /></h1>
		<h1>■ 마지막 로그아웃 날짜 : <fmt:formatDate value="${lastlogoutdate}" type="both" /></h1>
		
		<h1><p style="text-align:center;">[ <a href="/board/list?page=1">게시판 가기</a> ] | [ <a href="/member/logout">로그아웃</a> ]</p></h1>
	</div>
</div>
</body>
</html>