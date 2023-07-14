<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>게시물 등록</title>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script>

$(document).ready(function(){ 
	var objDragAndDrop = $("#fileClick");
	//input type=file에 onchange 발생 이벤트
	$("#input_file").on("change", function(e) {
		//본 이벤트는 file 타입으로 파일을 받는게 아니라 드래그앤드랍 같이 다른 이벤트 형식을 통해 file을 받는 것으로 이런 경우는 OriginalEvent를 이용하여 파일 정보를 받아야 함.
		var files = e.originalEvent.target.files; 
    	fileCheck(files);
	});

	//fileClick 영역 클릭 시 이벤트 --> file 이벤트의 파일탐색창 열기가 실행 
	objDragAndDrop.on('click',function (e){
        $('#input_file').trigger('click');
    });
	
	//dragenter(마우스가 대상 객체의 위로 처음 진입할 때 발생하는 이벤트)가 발생하면 
	//e.stopPropagation(), e.preventDefault()를 사용하여 웹브라우저의 기본 동작을 중지시키고 이벤트 전파를 중단
	//e.preventDefault는 고유 동작을 중단시키고, e.stopPropagation 는 상위 엘리먼트들로의 이벤트 전파를 중단
	$(document).on("dragenter","#fileClick",function(e){
    	e.stopPropagation(); 
    	e.preventDefault();
    	$(this).css('border', '2px solid #0B85A1');
    });

	//dragover(드래그하면서 마우스가 대상 객체의 위에 자리 잡고 있을 때 발생하는 이벤트)가 발생하면 
	//e.stopPropagation(), e.preventDefault()를 사용하여 웹브라우저의 기본 동작을 중지시키고 이벤트 전파를 중단
	//e.preventDefault는 고유 동작을 중단시키고, e.stopPropagation 는 상위 엘리먼트들로의 이벤트 전파를 중단
	$(document).on("dragover","#fileClick",function(e){
    	e.stopPropagation();
    	e.preventDefault();
	});
	
	//fileClick 영역에 파일 Drop시 e.preventDefault()를 사용하여 웹브라우저의 기본 동작을 중지시키고
	//e.originalEvent.dataTransfer.files를 실행 시켜 파일 정보를 var files에 입력
	$(document).on("drop","#fileClick",function(e){
        e.preventDefault();
    	var files = e.originalEvent.dataTransfer.files;
	    fileCheck(files);
	});

});

var uploadCountLimit = 5; // 업로드 가능한 파일 갯수
var fileCount = 0; // 파일 현재 필드 숫자 totalCount랑 비교값
var fileNum = 0; // 파일 고유넘버
var content_files = new Array(); // 첨부파일 배열
var rowCount=0;

function fileCheck(files) {

	
	//배열로 변환
	var filesArr = Array.prototype.slice.call(files); 
	
    // 파일 개수 확인 및 제한
    if (fileCount + filesArr.length > uploadCountLimit) {
      	alert('파일은 최대 '+uploadCountLimit+'개까지 업로드 할 수 있습니다.');
      	return;
    } else {
    	 fileCount = fileCount + filesArr.length;
    }

    var i =0;
	filesArr.forEach(function (f) {
	      var reader = new FileReader();
	      reader.onload = function (e) {
	        content_files.push(f);
			
	        if(filesArr[i].size > 1073741824) { alert('파일 사이즈는 1GB를 초과할수 없습니다.'); return; }
		
	    	rowCount++;
	        var row="odd";
	        if(rowCount %2 ==0) row ="even";
	        var statusbar = $("<div class='statusbar "+row+"' id='file" + fileNum +"'></div>");
	        var filename = $("<div class='filename'>" + filesArr[i].name + "</div>").appendTo(statusbar);
	        
	        var sizeStr="";
	        var sizeKB = filesArr[i].size/1024;
	        if(parseInt(sizeKB) > 1024){
	        	var sizeMB = sizeKB/1024;
	            sizeStr = sizeMB.toFixed(2)+" MB";
	        }else sizeStr = sizeKB.toFixed(2)+" KB";	        
	        
	        var size = $("<div class='filesize'>" + sizeStr + "</div>").appendTo(statusbar);
	        var progressBar = $("<div class='progressBar'><div></div></div>").appendTo(statusbar);
	        var btn_delete = $("<div class='btn_delete' onclick=fileDelete('file" + fileNum + "')>삭제</div></div>").appendTo(statusbar);
	       
			$("#fileClick").after(statusbar); 
			
	        fileNum ++;
       
	        console.log(filesArr[i]);
	        i++;  
	      
	      };
	      reader.readAsDataURL(f);
    });
	
	$("#input_file").val("");	

}	

function fileDelete(fileNum){
    var no = fileNum.replace(/[^0-9]/g, "");
    content_files[no].is_delete = true;
	$('#' + fileNum).remove();
	fileCount --;
}  

var progressBarWidth = 100;

function setProgress(progress){       
    //var ActiveprogressBarWidth =progress*progressBarWidth/ 100;  
    $(".progressBar div").animate({ width: progress }, 10).html(progress + "% ");
}

function registerForm(){

	if($("#writer").val()=='') { alert("이름을 입력하세요!!!"); $("#writer").focus(); return false;  }
	if($("#title").val()=='') { alert("제목을 입력하세요!!!");  $("#title").focus(); return false;  }
	if($("#content").val()=='') { alert("내용을 입력하세요!!!");  $("#content").focus(); return false;  }
	
	let uploadURL = '';
	
	if(content_files.length != 0)
		uploadURL = '/board/fileUpload?kind=I';
	else 			
		uploadURL = '/board/write';
		
	let wForm = document.getElementById('WriteForm');
 	let formData = new FormData(wForm);
	for (let i = 0; i < content_files.length; i++) {
			if(!content_files[i].is_delete) { 
						
				formData.append("SendToFileList", content_files[i]);
			}
	}

	$.ajax({
        url: uploadURL,
        type: "POST",
        contentType:false,
        processData: false,
        cache: false,
        enctype: "multipart/form-data",
        data: formData,
        xhr:function(){
        	var xhr = $.ajaxSettings.xhr();
        	xhr.upload.onprogress = function(e){
        		var per = e.loaded * 100/e.total;
        		setProgress(per);
        	};
        	return xhr;        	
        },
        success: function(data){
        	alert("게시물이 등록되었습니다.\n게시물 목록 화면으로 이동합니다.");
			document.location.href='/board/list?page=1';	
        },
        error: function (xhr, status, error) {
       	    	alert("서버오류로 게시물 등록이 실패하였습니다. 잠시 후 다시 시도해주시기 바랍니다.");
       	     return false;
       	}   
       
    }); 
	
}

</script>

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

.FormDiv {
  width:900px;
  height:auto;
  padding: 20px, 20px;
  background-color:#FFFFFF;
  text-align: center;
  border:4px solid gray;
  border-radius: 30px;
}

.writer, .title {
  width: 90%;
  border:none;
  border-bottom: 2px solid #adadad;
  margin: 10px;
  padding: 5px 5px;
  outline:none;
  color: #636e72;
  font-size:16px;
  height:25px;
  background: none;
}

.content{
  width: 850px;
  height: 300px;
  padding: 10px;
  box-sizing: border-box;
  border: solid #adadad;
  font-size: 16px;
  resize: both;
}

.btn_write  {
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

.btn_cancel{
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

.filename{
  display:inline-block;
  vertical-align:top;
  width:250px;
}

.filesize{
  display:inline-block;
  vertical-align:top;
  color:#30693D;
  width:100px;
  margin-left:10px;
  margin-right:5px;
}

.fileuploadForm {
 margin: 5px;
 padding: 5px 5px 2px 30px;
 text-align: left;
 width:90%;
 
}

.fileListForm {
  border-bottom: 2px solid #adadad;
  margin: 5px;
  padding: 3px 3px;
  
}

#fileClick {
  border: solid #adadad;
  background-color: #a0a0a0;
  width: 900px;
  height:80px;
  color: white;
  text-align: center;
  vertical-align: middle;
  padding: 5px;
  font-size:120%;
  display: table-cell;
}

.btn_delete{
  background-color:#A8352F;
  -moz-border-radius:4px;
  -webkit-border-radius:4px;
  border-radius:4px;display:inline-block;
  color:#fff;
  font-family:arial;font-size:13px;font-weight:normal;
  padding:4px 15px;
  cursor:pointer;
  vertical-align:top
}

.statusbar{
  border-bottom:1px solid #92AAB0;;
  min-height:25px;
  width:99%;
  padding:10px 10px 0px 10px;
  vertical-align:top;
}
.statusbar:nth-child(odd){
  background:#EBEFF0;
}
.filename{
  display:inline-block;
  vertical-align:top;
  width:250px;
}

.filesize{
  display:inline-block;
  vertical-align:top;
  color:#30693D;
  width:100px;
  margin-left:10px;
  margin-right:5px;
}

.progressBar {
  width: 200px;
  height: 22px;
  border: 1px solid #ddd;
  border-radius: 5px; 
  overflow: hidden;
  display:inline-block;
  margin:0px 10px 5px 5px;
  vertical-align:top;
  }
             
.progressBar div {
  height: 100%;
  color: #fff;
  text-align: right;
  line-height: 22px; 
  width: 0;
  background-color: #0ba1b5; border-radius: 3px; 
}

</style>

</head>   
<body>

<%

	String userid = (String)session.getAttribute("userid");
	String username = (String)session.getAttribute("username");
	String role = (String)session.getAttribute("role");
	if(userid == null) response.sendRedirect("/");

%>
<center>
<div class="FormDiv">

  	<div>
    	<img id="topBanner" src ="${pageContext.request.contextPath}/resources/images/logo.jpg" title="서울기술교육센터" >
  	</div>

	<h1>게시물 등록</h1>
	<br>
	
	<form id="WriteForm" method="POST" >
		<input type="text" class="writer" value="작성자 : <%=username %> 님" disabled>
		<input type="text" class="title" id="title" name="title"  placeholder="여기에 제목을 입력하세요">
		<input type="hidden" id="writer" name="writer" value="<%=username %>">
		<input type="hidden" class="userid" id="userid" name="userid" value="<%=userid %>">
		<textarea class="content" id="content" cols="100" rows="500" name="content" placeholder="여기에 내용을 입력하세요"></textarea>
	</form>		
		<div class="fileuploadForm">
			<input type="file" id="input_file" name="uploadFile" style="display:none;" multiple />
			<div id="fileClick">파일 첨부를 하기 위해서는 클릭하거나 여기로 파일을 드래그 하세요.<br>첨부파일은 최대 5개까지 등록이 가능합니다.</div>
	  		<div id="fileUploadList"></div>
		</div>
		<input type="button" class="btn_write" value="등록" onclick="registerForm()" />
		<input type="button" class="btn_cancel" value="취소" onclick="history.back()" />

</div>
</center>
<br><br>
</body>
</html>