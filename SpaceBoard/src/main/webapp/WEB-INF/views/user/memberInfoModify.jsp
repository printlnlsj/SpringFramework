<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>사용자 정보 수정</title>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<style>
body { font-family: "나눔고딕", "맑은고딕" }
h1 { font-family: "HY견고딕" }

.registerForm {
  width:900px;
  height:auto;
  padding: 10px, 10px;
  background-color:#FFFFFF;
  border:4px solid gray;
  border-radius: 20px;
}
.userid, .username, .userpasswd, .userpasswd1, .telno, .email, .zip, .addr1, .addr2 {
  width: 80%;
  border:none;
  border-bottom: 2px solid #adadad;
  margin: 5px;
  padding: 10px 10px;
  outline:none;
  color: #636e72;
  font-size:16px;
  height:25px;
  background: none;
}
.addrSearch{
  width: 71%;
  border:none;
  border-bottom: 2px solid #adadad;
  margin: 5px;
  padding: 10px 10px;
  outline:none;
  color: #636e72;
  font-size:16px;
  height:25px;
  background: none;
}
.btn_modify  {
  position:relative;
  left:20%;
  transform: translateX(-50%);
  margin-top: 20px;
  margin-bottom: 10px;
  width:40%;
  height:40px;
  background: red;
  background-position: left;
  background-size: 200%;
  color:white;
  font-weight: bold;
  border:none;
  cursor:pointer;
  transition: 0.4s;
  display:inline;
}
.btn_cancel  {
  position:relative;
  left:20%;
  transform: translateX(-50%);
  margin-top: 20px;
  margin-bottom: 10px;
  width:40%;
  height:40px;
  background: pink;
  background-position: left;
  background-size: 200%;
  color:white;
  font-weight: bold;
  border:none;
  cursor:pointer;
  transition: 0.4s;
  display:inline;
}

#ImageRegistration {
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

</style>

<script>

	$(document).ready(function(){
	
		$("#btn_modify").click(function(){
			
			if($("#zipcode").val() == '') { alert("우편번호를 입력하세요."); $("#zipcode").focus(); return false; }
			document.registerForm.zipcode.value = $("#zipcode").val();
			$("#address").val($("#addr1").val() + " " + $("#addr2").val());

			if($("#telno").val() == '') { alert("전화번호를 입력하세요."); $("#telno").focus(); return false; }
		 	//전화번호 문자열 정리
			var beforeTelno = $("#telno").val();
		 	var afterTelno = beforeTelno.replace(/\-/gi,"").replace(/\ /gi,"").trim();
		 	//console.log("afterTelno : " + afterTelno);
		 	$("#telno").val(afterTelno);
		 	
			if($("#email").val() == '') { alert("이메일주소를 입력하세요."); $("#email").focus(); return false; }
			
			$("#registerForm").attr("action","/user/memberInfoModify").submit();
						
		});
		
	    var objDragAndDrop = $("#ImageRegistration");
	    
	    $(document).on("dragenter","#ImageRegistration",function(e){
	        e.stopPropagation();
	        e.preventDefault();
	        $(this).css('border', '2px solid #0B85A1');
	    });
	   
	    $(document).on("dragover","#ImageRegistration",function(e){
	        e.stopPropagation();
	        e.preventDefault();
	    });

	    $(document).on("drop","#ImageRegistration",function(e){
	        
	        $(this).css('border', '2px dotted #0B85A1');
	        e.preventDefault();
	        var files = e.originalEvent.dataTransfer.files;
	    
	        imageView(files, objDragAndDrop);
	    });
	    
	    $(document).on('dragenter', function (e){
	        e.stopPropagation();
	        e.preventDefault();
	    });

	    $(document).on('dragover', function (e){
	      e.stopPropagation();
	      e.preventDefault();
	      objDragAndDrop.css('border', '2px dotted #0B85A1');
	    });

	    $(document).on('drop', function (e){
	        e.stopPropagation();
	        e.preventDefault();
	        imageView(files, objDragAndDrop);
	    });

	    //drag 영역 클릭시 파일 선택창
	    objDragAndDrop.on('click',function (e){
	        $("#fileUpload").trigger('click');
	    });

	    $("#fileUpload").on('change', function(e) {
	       var files = e.originalEvent.target.files;
	       imageView(files, objDragAndDrop);
	    });
		
	});

	var imgcheck = "N";
	var imgFile = null;
	function imageView(f,obj){

		obj.html("");
		imgFile = f[0];

		//if(imgFile.size > 1024*1024) { alert("1MB 이하 파일만 올려주세요."); return false; }
		if(imgFile.type.indexOf("image") < 0) { alert("이미지 파일만 올려주세요"); return false; }

		const reader = new FileReader();
		reader.onload = function(event){
			obj.html("<img src=" + event.target.result + " id='uploadImg' style='width:350px; height:auto;'>");
		};
		reader.readAsDataURL(imgFile);
		imgcheck = "Y";
	}
	
	function searchAddr(){

		var addrSearch = $("#addrSearch").val();
		if(addrSearch =='') {
			alert("검색할 주소를 입력하세요.");
			$("#addrSearch").focus();
			return false;
		}

		window.open(
		          "addrSearch?page=1&addrSearch=" + addrSearch,
		          "주소검색",
		          "width=900, height=540, top=50, left=50"
		);
		
	}
	
</script>

</head>
<body>
<br><br><br>

	<%
		String userid = (String)session.getAttribute("userid");
		if(userid == null) response.sendRedirect("index.jsp");
	%>		

	<div class="main" align="center">
	  <div class="registerForm">
		      
	    <h1>사용자 정보 수정</h1>
	 
	    <form name="registerForm" id="registerForm" method="post" enctype="multipart/form-data"> 
	       	<input type="file" name="fileUpload" id="fileUpload" style="display:none;" />
	       	<span style="color:red;">※ 사진 편집을 원하시면 이미지를 클릭해 주세요</span>
	    	<center><div id="ImageRegistration"><img src='/profile/${member.stored_filename}' style='width:300px; height:auto;'></div></center>
		    <input type="hidden" name="org_filename" value="${member.org_filename}">
		    <input type="hidden" name="stored_filename" value="${member.stored_filename}">
		    <input type="hidden" name="filesize" value="${member.filesize}">
		    <input type="hidden" name="userid" value="${userid}">
		    <input type="text" id="username" name="username" class="username" value="${member.username}">
		    
		    <div style="width:90%; text-align:left; position:relative; left: 35px; border-bottom:2px solid #adadad; margin:10px; padding: 10px;">
					성별 : 
					<label><input type="radio" name="gender" value="남성">남성</label>
					<label><input type="radio" name="gender" value="여성">여성</label><br>
					취미 : 
					<label><input type="checkbox" id="all" name="all" onclick="selectAll(this)">전체선택</label>
					<label><input type="checkbox" name="hobby" value="음악감상" onclick="checkSelectAll(this)">음악감상</label>
					<label><input type="checkbox" name="hobby" value="영화보기" onclick="checkSelectAll(this)">영화보기</label>
					<label><input type="checkbox" name="hobby" value="스포츠" onclick="checkSelectAll(this)">스포츠</label><br>
					직업 : 
					<select name="job">
						<option disabled selected>-- 아래의 내용 중에서 선택 --</option>
						<option value="회사원">회사원</option>
						<option value="공무원">공무원</option>
						<option value="자영업">자영업</option>
					</select>
					<br>
				</div>
		    
	        <input type="text" id="addrSearch" name="addrSearch" class="addrSearch" placeholder="변경할 주소를 입력해서 검색해 주세요.">
	        <input type="button" id="btn_addrSearch" class="btn_addrSearch" value="주소검색" onclick="searchAddr()">
	        <input type="text" id="zipcode" class="zip" name="zipcode" value="${member.zipcode}" readonly>
	        <input type="text" id="addr1" class="addr1" name="addr1" value="${member.address}" readonly>
	        <input type="text" id="addr2" class="addr2" name="addr2" placeholder="변경할 상세주소를 입력하세요" >
	        <input type="hidden" id="address" name="address">
	        <input type="text" id="telno" name="telno" class="telno" value="${member.telno}">
	        <input type="text" id="email" name="email" class="email" value="${member.email}">
	        <textarea rows=20 cols=100 class="description" id="description" name="description">${member.description}</textarea><br>
	        <input type="button" id="btn_modify" class="btn_modify" value="사용자 정보 수정">
	        <input type="button" id="btn_cancel" class="btn_cancel" value="취소" onclick="history.back()">
		  </form>
	
	  </div>
	</div>
	<br><br>
</body>
</html>