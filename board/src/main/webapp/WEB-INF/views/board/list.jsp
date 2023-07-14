<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="UTF-8">
<head>
<script src="http://code.jquery.com/jquery-1.11.3.js"></script>

<title>게시물 목록</title>

<style>
body { font-family: "나눔고딕", "맑은고딕" }
h1 { font-family: "HY견고딕" }
a:link { color: black; }
a:visited { color: black; }
a:hover { color: red; }
a:active { color: red; }
#hypertext { text-decoration-line: none; cursor: hand; }
#topBanner {
       margin-top:10px;
       margin-bottom:10px;
       max-width: 500px;
       height: auto;
       display: block; margin: 0 auto;
}
.tableDiv {
	text-align: center;
}

.InfoTable {
      border-collapse: collapse;
      border-top: 3px solid #168;
      width: 800px;  
      margin-left: auto; margin-right: auto;
    }  
    .InfoTable th {
      color: #168;
      background: #f0f6f9;
      text-align: center;
    }
    .InfoTable th, .InfoTable td {
      padding: 10px;
      border: 1px solid #ddd;
    }
    .InfoTable th:first-child, .InfoTable td:first-child {
      border-left: 0;
    }
    .InfoTable th:last-child, .InfoTable td:last-child {
      border-right: 0;
    }
    .InfoTable tr td:first-child{
      text-align: center;
    }
    .InfoTable caption{caption-side: top; }

.bottom_menu { margin-top: 20px; }

.bottom_menu > a:link, .bottom_menu > a:visited {
			background-color: #FFA500;
			color: maroon;
			padding: 15px 25px;
			text-align: center;	
			display: inline-block;
			text-decoration : none; 
}
.bottom_menu > a:hover, .bottom_menu > a:active { 
	background-color: #1E90FF;
	text-decoration : none; 
}
</style>

<script>

function search(){
	
	var searchType = $("#searchType").val();
	var keyword =  $("#keyword").val();
	location.href = 'list?page=1&searchType=' + searchType + '&keyword=' + encodeURI(keyword);
	
}
</script>
</head>

<body>
<%

	String userid = (String)session.getAttribute("userid");
	if(userid == null) response.sendRedirect("/");

%>


<div class="tableDiv">

 	 <div>
    	<img id="topBanner" src ="${pageContext.request.contextPath}/resources/images/logo.jpg" title="서울기술교육센터" >
  	</div>

	<h1>게시물 목록 보기</h1>
	<table class="InfoTable">
  		<tr>
   			<th>번호</th>
   			<th>제목</th>
   			<th>작성자</th>
   			<th>조회수</th>
   			<th>작성일</th>
  		</tr>

 		<tbody>
	<c:forEach items="${list}" var="list">
 	<tr onMouseover="this.style.background='#46D2D2';" onmouseout="this.style.background='white';">
		<td>${list.seq}</td>
		<td style="text-align:left;">
			<a id="hypertext" href="view?seqno=${list.seqno}&page=${page}&searchType=${searchType}&keyword=${keyword}" onMouseover='this.style.textDecoration="underline"' 
			  onmouseout="this.style.textDecoration='none';">${list.title}</a>
		</td>  
		<td>${list.writer}</td>
		<td>${list.hitno}</td>
		<td><fmt:formatDate value="${list.regdate}" type="both" /> </td> 
	</tr>
	</c:forEach>	
	</tbody>

	</table>
	<br>

	<div>
		${pageListView}
	</div>

	<br>
	<div>
  		<select id="searchType" name="searchType">
      		<option value="title">제목</option>
      		<option value="content">내용</option>
      		<option value="title_content">제목+내용</option>
      		<option value="writer">작성자</option>
  		</select>
    	<input type="text" id="keyword" name="keyword" />
  		<button type="button" onclick="search()">검색</button>
 	</div>
<br><br>	

	<div class="bottom_menu">
		<a href="/board/list?page=1">처음으로</a>&nbsp;&nbsp;
		<a href="/board/write">글쓰기</a>&nbsp;&nbsp;
		<a href="/member/memberInfo">사용자관리</a>&nbsp;&nbsp;
		<a href="/member/logout">로그아웃</a>&nbsp;&nbsp; 
	</div>

	
</div>
</body>
</html>