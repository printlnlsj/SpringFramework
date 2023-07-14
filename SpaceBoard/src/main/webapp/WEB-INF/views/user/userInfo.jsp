<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="/resources/css/board.css">

<style>
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

	const memberInfoDelete = () => {
		if(confirm("사용자 탈퇴를 하시면 작성하셨던 모든 게시물도 함께 삭제됩니다. \n정말로 사용자 탈퇴 하시겠습니까?") == true)
		 	{ alert("사용자 정보가 삭제 되었습니다."); document.location.href='/user/memberInfoDelete';  } 	
	}
	
</script>

<title>회원 정보 보기</title>
</head>

<body>
	<div>
		<img id="topBanner" src="${pageContext.request.contextPath}/resources/images/spaceship.png" title="우주선">	
	</div>

	<div class="main">
		<h1>회원 정보 보기</h1>
		<br>
		<div class="boardView">
		<br>
			 <div class="imgView"><img src="/profile/${member.stored_filename}" style="display:block;width:500px;height:auto;margin:auto"> </div>
			 <div class="field">아이디 : ${member.userid}</div>
			 <div class="field">이름 : ${member.username}</div>
			 <div class="field">성별 : ${member.gender}</div>
			 <div class="field">직업 : ${member.job}</div>
			 <div class="field">취미 : ${member.hobby}</div>
			 <div class="field">전화번호 : ${member.telno} </div>
	         <div class="field">이메일 : ${member.email}</div>
	         <div class="field">주소 : [${member.zipcode}]${member.address}</div>
	        
	         <c:if test="${member.role == 'MASTER'}">
           	 <div class="field">권한 : 마스터 관리자</div>
	         </c:if>  	
	         <c:if test="${member.role != 'MASTER'}">
		       	<div class="field">권한 : 일반 사용자 </div>
	         </c:if>
			
			 <div class="content">${member.description}</div>
		</div>
		
		<br>
	    <div class="bottom_menu" align="center">
	        &nbsp;&nbsp;
	        <a href="/board/list?page=1">처음으로</a> &nbsp;&nbsp;
	        <a href="/user/memberInfoModify">기본정보 변경</a> &nbsp;&nbsp;
	        <a href="/user/memberPasswordModify">패스워드 변경</a> &nbsp;&nbsp;
	        <a href="javascript:memberInfoDelete()">회원탈퇴</a> &nbsp;&nbsp;
	    </div>
	<br><br>
	</div>

</body>
</html>