<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta charset="UTF-8">
<title>사용자 정보 보기</title>

<style>
body { font-family: "나눔고딕", "맑은고딕" }
h1 { font-family: "HY견고딕" }
a:link { color: black; }
a:visited { color: black; }
a:hover { color: red; }
a:active { color: red; }
a { text-decoration : none; cursor: hand; }

.viewMemberInfo {
    text-align:left;
    width:900px;
    height:auto;
    padding: 20px, 20px;
    background-color:#FFFFFF;
    border:4px solid gray;
    border-radius: 20px;
}

.userid, .username, .ac, .telno, .email, .regdate, .lastlogindate, .pwmodidate, .address {
    width: 90%;
    height:25px;
    outline:none;
    color: #636e72;
    font-size:16px;
    background: none;
    border-bottom: 2px solid #adadad;
    margin: 30px;
    padding: 10px 10px;
}

#ImageView {
                border: 2px solid #92AAB0;
                width: 450px;
                height: 200px;
                color: #92AAB0;
                text-align: center;
                vertical-align: middle;
                margin: 30px;
  				padding: 10px 10px;
                font-size:200%;
                display: table-cell;
                
}

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

function memberInfoDelete() {
	
	if(confirm("사용자 탈퇴를 하시면 작성하셨던 모든 게시물도 함께 삭제됩니다. \n정말로 사용자 탈퇴 하시겠습니까?") == true)
	 	{ alert("사용자 정보가 삭제 되었습니다."); document.location.href='/member/memberInfoDelete';  } 	
}

</script>

</head>

<body>

<%

	String userid = (String)session.getAttribute("userid");
	if(userid == null) response.sendRedirect("/");

%>

<div class="main" align="center">

    <div class="viewMemberInfo">
        <h1 style="text-align:center;">사용자 정보</h1>
         <center><div id="ImageView"><img src="/profile/${member.stored_filename}" style='width:300px; height:auto;'></div></center>
         <div class="userid">아이디 : <%=userid %></div>
		 <div class="username">이름 : ${member.username}</div>
         <div class="telno">전화번호 : ${member.telno} </div>
         <div class="email">이메일주소 : ${member.email}</div>
         <div class="address">주소 : [${member.zipcode}]${member.address}</div>
         <div class="regdate">서비스 가입일 : <fmt:formatDate value="${member.regdate}" type="both" /></div>
         <div class="lastlogindate">마지막 로그인 일자 : <fmt:formatDate value="${member_date.lastlogindate}" type="both" /></div>
         <c:if test="${member.role == 'admin'}">
           	<div class="ac">권한 : 마스터 관리자</div>
         </c:if>  	
         <c:if test="${member.role != 'admin'}">
	       	<div class="ac">권한 : 일반 사용자 </div>
         </c:if>

    </div>     
	<br><br>

    <div class="bottom_menu" align="center">
        &nbsp;&nbsp;
        <a href="/board/list?page=1">처음으로</a> &nbsp;&nbsp;
        <a href="/member/memberInfoModify">기본정보 변경</a> &nbsp;&nbsp;
        <a href="/member/memberPasswordModify">패스워드 변경</a> &nbsp;&nbsp;
        <a href="javascript:memberInfoDelete()">회원탈퇴</a> &nbsp;&nbsp;
    </div>
	<br><br>
</div>


</body>
</html>