<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title></title>

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

</head>
<body>

<br><br>
<div id="main" align="center">
	<div id="ViewForm">
	<h1>로그아웃하였습니다. ${userid}(${username})님 안녕히 가세요. </h1>
	<h1>다시 [ <a href="/">로그인</a> ]</h1>
	</div>
</div>

</body>
</html>