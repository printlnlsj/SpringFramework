<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>사용자 정보 등록</title>
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
.btn_register  {
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

.ImageRegistration {
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

	    var objDragAndDrop = $(".ImageRegistration");
	  	

	    //ImageRegistration 영역 클릭 이벤트 처리
	    objDragAndDrop.on('click',function (e){
	    	 $('input[type=file]').trigger('click');
	    });
	    
	    $('input[type=file]').on("change", function(e) {
		       var files = e.originalEvent.target.files;
		       imageView(files, objDragAndDrop);
		});
		
		$("#btn_register").click(function(){
			
			if($("#userid").val() == '') { alert("아이디를 입력하세요."); $("#userid").focus();  return false; }
			if($("#username").val() == '') { alert("이름을 입력하세요."); $("#username").focus(); return false; }
			var Pass = $("#userpasswd").val();
			var Pass1 = $("#userpasswd1").val();
			if(Pass == '') { alert("암호를 입력하세요."); $("#userpasswd").focus(); return false; }
			if(Pass1 == '') { alert("암호를 입력하세요."); $("#userpasswd1").focus(); return false; }
			if(Pass != Pass1) 
				{ alert("입력된 비밀번호를 확인하세요"); $("#userpasswd1").focus(); return false; }
			
			// 암호유효성 검사
			var num = Pass.search(/[0-9]/g);
		 	var eng = Pass.search(/[a-z]/ig);
		 	var spe = Pass.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);	
			if(Pass.length < 8 || Pass.length > 20) { alert("암호는 8자리 ~ 20자리 이내로 입력해주세요."); return false; }
			else if(Pass.search(/\s/) != -1){ alert("암호는 공백 없이 입력해주세요."); return false; }
			else if(num < 0 || eng < 0 || spe < 0 ){ alert("암호는 영문,숫자,특수문자를 혼합하여 입력해주세요."); return false; }
			
			if($("#zip").val() == '') { alert("우편번호를 입력하세요."); $("#zip").focus(); return false; }
			document.registerForm.zipcode.value=$("#zip").val();
			if($("#addr2").val() == '') { alert("상세 주소를 입력하세요."); $("#addr2").focus(); return false; }
			$("#address").val($("#addr1").val() + " " + $("#addr2").val());
		 	if($("#telno").val() == '') { alert("전화번호를 입력하세요."); $("#telno").focus(); return false; }
		 	//전화번호 문자열 정리
			var beforeTelno = $("#telno").val();
		 	var afterTelno = beforeTelno.replace(/\-/gi,"").replace(/\ /gi,"").trim();
		 	//console.log("afterTelno : " + afterTelno);
		 	$("#telno").val(afterTelno);
		 	
			if($("#email").val() == '') { alert("이메일주소를 입력하세요."); $("#email").focus(); return false; }
			
			$("#registerForm").attr("action","/member/signup").submit();
						
		});
		
		$("#userid").change(function(){
			
			$.ajax({
				url : "/member/idCheck",
				type : "post",
				dataType : "json",
				data : {"userid" : $("#userid").val()},
				success : function(data){
						if(data == 1){
						$("#checkID").html("동일한 아이디가 이미 존재합니다. 새로운 아이디를 입력하세요.");
						$("#userid").val("").focus();
									
						}else $("#checkID").html("사용 가능한 아이디입니다.");
					
						}
			});
			
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
		          "/member/addrSearch?page=1&addrSearch=" + addrSearch,
		          "주소검색",
		          "width=850, height=300, top=50, left=50"
		);
		
		
	}
	
</script>

</head>
<body>
<br><br><br>

<div class="main" align="center">
  <div class="registerForm">
	      
    <h1>사용자 등록</h1>
 
    <form name="registerForm" id="registerForm" method="post" enctype="multipart/form-data"> 
       	<input type="file" name="fileUpload" id="fileUpload" style="display:none;" />
    	<center><div class="ImageRegistration">클릭 후 탐색창에서 사진을 <br>선택해 주세요.</div></center>
        <input type="text" id="userid" name="userid" class="userid" placeholder="아이디를 입력하세요.">
        <p id="checkID" style="color:red;text-align:center;"></p>
		    <input type="text" id="username" name="username" class="username" placeholder="이름을 입력하세요.">
        <input type="password" id="userpasswd" name="password" class="userpasswd" placeholder="암호를 입력하세요.">
        <p style="color:red;text-align:center;">※ 8~20이내의 영문자, 숫자, 특수문자 조합으로 암호를 만들어 주세요.</p>
        <input type="password" id="userpasswd1" name="userpasswd1" class="userpasswd1" placeholder="암호를 한번 더 입력하세요.">
        <input type="text" id="addrSearch" name="addrSearch" class="addrSearch" placeholder="주소를 검색합니다.">
        <input type="button" id="btn_addrSearch" class="btn_addrSearch" value="주소검색" onclick="searchAddr()">
        <input type="text" id="zip" class="zip" name="zip" placeholder="우편번호가 검색되어 입력됩니다." disabled>
        <input type="hidden" id="zipcode" name="zipcode">
        <input type="text" id="addr1" class="addr1" name="addr1" placeholder="주소가 검색되어 입력됩니다." disabled>
        <input type="text" id="addr2" class="addr2" name="addr2" placeholder="상세주소를 입력하세요" >
        <input type="hidden" id="address" name="address">
        <input type="text" id="telno" name="telno" class="telno" placeholder="전화번호를 입력하세요.">
        <input type="text" id="email" name="email" class="email" placeholder="이메일주소를 입력하세요.">
        <p style="color:red;">일반 사용자 권한으로 등록됩니다.</p>
        <input type="button" id="btn_register" class="btn_register" value="사용자 등록">
        <input type="button" id="btn_cancel" class="btn_cancel" value="취소" onclick="history.back()">
	  </form>

  </div>
</div>
<br><br>
</body>
</html>