<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>게시물 등록</title>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script>
	
	window.onload = () => {
		const fileZone = document.querySelector('#fileZone');
		const inputFile = document.querySelector('#inputFile');
	
		// fileZone을 클릭하면 발생하는 이벤트
		fileZone.addEventListener('click', (e) => {  // click 했을 때 보여주는 콜백함수(e)
			inputFile.click(e);
			const files = e.target.files;
			fileCheck(files);
		});
		
		// 파일 탐색창을 열어 선택한 파일 정보를 files에 할당
		inputFile.addEventListener('change', (e) => {
			const files = e.target.files;  // 파일 선택하면 파일에 대한 정보가 e.target으로 들어온다.
			fileCheck(files);
		});
		
		// fileZone으로 dragenter 이벤트 발생 시 처리하는 이벤트 핸들러
		fileZone.addEventListener('dragenter', (e) => {
			// e.stopPropagation() : 웹 브라우저의 고유 동작을 중단
			// e.preventDefault() : 상위 엘레먼트로의 이벤트 전파를 중단
			e.stopPropagation();  
			e.preventDefault();  
			fileZone.style.border = '2px solid #0B85A1';
		});
			
		// fileZone으로 dragvoer 이벤트 발생 시 처리하는 이벤트 핸들러
		fileZone.addEventListener('dragover', (e) => {
			e.stopPropagation();  
			e.preventDefault();
		});
		
		// fileZone으로 drop 이벤트 발생 시 처리하는 이벤트 핸들러
		fileZone.addEventListener('drop', (e) => {
			e.stopPropagation();  
			e.preventDefault();
			const files = e.dataTransfer.files;  // 파일을 드래그 앤 드롭 했을 때는 e.dataTransfer 사용해야한다.
			fileCheck(files);
		});
		
	}
	/*
	$(document).ready(function(){ 
		var objDragAndDrop = $("#fileClick");
		//input type=file에 onchange 발생 이벤트
		$("#input_file").on("change", function(e) {
			var files = e.originalEvent.target.files;
	    	fileCheck(files);
		});
	
		//fileClick 영역 클릭 시 이벤트
		objDragAndDrop.on('click',function (e){
	        $('#input_file').trigger('click');
	    });
		
		$(document).on("dragenter","#fileClick",function(e){
	    	e.stopPropagation(); 
	    	e.preventDefault();
	    	$(this).css('border', '2px solid #0B85A1');
	    });
	
		$(document).on("dragover","#fileClick",function(e){
	    	e.stopPropagation();
	    	e.preventDefault();
		});
		//fileClick 영역에 파일 Drop시 이벤트
		$(document).on("drop","#fileClick",function(e){
	        e.preventDefault();
	    	var files = e.originalEvent.dataTransfer.files;
		    fileCheck(files);
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
		});
	
	});
	*/
	var uploadCountLimit = 5; // 업로드 가능한 파일 갯수
	var fileCount = 0; // 파일 현재 필드 숫자 totalCount랑 비교값
	var fileNum = 0; // 파일 고유넘버
	var content_files = new Array(); // 첨부파일 배열
	var rowCount=0;

	const fileCheck = (files) => {
	
		let filesArr = Object.values(files);
		
	    // 파일 개수 확인 및 제한
	    if (fileCount + filesArr.length > uploadCountLimit) {
	      	alert('파일은 최대 '+uploadCountLimit+'개까지 업로드 할 수 있습니다.');
	      	return;
	    } else {
	    	 fileCount = fileCount + filesArr.length;
	    }
		console.log("fileCount = " +fileCount);
		console.log("content_files.length = "+ content_files.length);
		filesArr.forEach((file) => {
		      var reader = new FileReader();
		      
		      // 파일 읽기
		      reader.readAsDataURL(file);
		      
		      reader.onload = (e) => {
			        content_files.push(file);
			        
			        if(file.size > 1073741824) { alert('파일 사이즈는 1GB를 초과할수 없습니다.'); return; }
				
			    	rowCount++;
			        var row="odd";
			        if(rowCount %2 ==0) row ="even";
			        
			        let statusbar = document.createElement('div');
			        statusbar.setAttribute('class', 'statusbar ' + row);  // <div class='statusbar odd'></div>
			        statusbar.setAttribute('id', 'file' + fileNum);  // <div class='statusbar odd' id='file0'></div>
			        
			     	// statusbar 내의 파일명
			        let filename = "<div class='filename'>" + file.name + "</div>";
			        
			     	// statusbar 내의 파일 사이즈
			        let sizeStr="";
			        let sizeKB = file.size/1024;
			        if(parseInt(sizeKB) > 1024){
			        	var sizeMB = sizeKB/1024;
			            sizeStr = sizeMB.toFixed(2)+" MB";
			        }else sizeStr = sizeKB.toFixed(2)+" KB";	        
			        let size = "<div class='filesize'>" + sizeStr + "</div>";
					
			        // statusbar의 삭제버튼
			        let btn_delete = "<div class='btn_delete'><input type='button' value='삭제' onclick=fileDelete('file" + fileNum + "')></div>";
			       
			        statusbar.innerHTML = filename + size + btn_delete;
			        
			        fileUploadList.appendChild(statusbar);
					
			        fileNum ++;
		       
			        console.log(file);
			        console.log("fileCount = " +fileCount);
			    	console.log("content_files.length = "+ content_files.length);
		      };
	    });
		console.log("fileCount = " +fileCount);
		console.log("content_files.length = "+ content_files.length);
		inputFile.value = '';	
	}	

	const fileDelete = (fileNum) => {
	    var no = fileNum.replace(/[^0-9]/g, "");
	    content_files[no].is_delete = true;
		document.querySelector('#' + fileNum).remove();
		fileCount --;
	}  


	const ModifyForm = async () => {
	
		if(title.value == '') { alert("제목을 입력하세요!!!"); title.focus(); return false;  }
		if(content.value == '') { alert("내용을 입력하세요!!!"); content.focus(); return false;  }
	
		let mForm = document.getElementById('ModifyForm');	
	 	let formData = new FormData(mForm);
		for (let i = 0; i < content_files.length; i++) {
				if(!content_files[i].is_delete) { 
					formData.append("SendToFileList", content_files[i]);
				}
		}
		
		let uploadURL = '';
		console.log("fileCount = " +fileCount);
		console.log("content_files.length = "+ content_files.length);
		if(content_files.length != 0)
			uploadURL = '/board/fileUpload?kind=U';
		else 			
			uploadURL = '/board/modify';
		
		formData.append("seqno", ${view.seqno});
		
	 /*   
		$.ajax({
	        url: uploadURL,
	        type: "POST",
	        contentType:false,
	        processData: false,
	        cache: false,
	        enctype: "multipart/form-data",
	        data: formData,
	        success: function(data){
	        	console.log(data.message);
	        	alert("게시물이 수정되었습니다.\n게시물 내용 화면으로 이동합니다.");
				document.location.href='/board/view?seqno=${view.seqno}&page=${page}&searchType=${searchType}&keyword=${keyword}';
	        },
	        error: function (error) {
	        	console.log(data.message);
	       	    	alert("서버오류로 파일 업로드가 안됩니다. 잠시 후 다시 시도해주시기 바랍니다.");
	       	     return false;
	       	}   
	       
	    }); 
		*/
		
		await fetch(uploadURL, {
			method: 'POST',
			body: formData
		}).then((response) => response.json())
		  .then((data) => {
			  if(data.message == 'good'){
				  alert("게시물이 수정되었습니다.\n게시물 목록 화면으로 이동합니다.");
			  	  document.location.href='/board/list?page=1';
	//			  document.location.href='/board/view?seqno=${view.seqno}&page=${pageNum}&keyword=${keyword}';
			  }
		  }).catch((error) => {
			  alert("서버오류로 게시물 수정이 실패하였습니다. 잠시 후 다시 시도해주시기 바랍니다.");
			  console.log("error = " + error);
		  });
	//	});
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

.main {
  text-align: center;
}

.FormDiv {
  width:50%;
  height:auto;
  margin: auto;
  padding: 20px, 20px;
  background-color:#FFFFFF;
  text-align: center;
  border:4px solid gray;
  border-radius: 30px;
}

#writer, #title {
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

#content{
  width: 90%;
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

#fileZone {
  border: solid #adadad;
  background-color: #a0a0a0;
  width: 97%;
  height:80px;
  color: white;
  text-align: center;
  vertical-align: middle;
  padding: 5px;
  font-size:120%;
  display: block;
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

</style>

</head>   
<body>

	<%
		String userid = (String)session.getAttribute("userid");
		String username = (String)session.getAttribute("username");
		if(userid == null) response.sendRedirect("/");
	%>

	<div>
		<img id="topBanner" src="/resources/images/spaceship.png" title="우주선">	
	</div>
	
	<div class="main">
		<div class="FormDiv">
		
			<h1>게시물 수정</h1>
			
			<form id="ModifyForm" method="POST" >
				<input type="text" id="writer" value="작성자 : ${view.writer } 님" disabled>
				<input type="text" id="title" name="title"  value="${view.title}">
				<input type="hidden" name="seqno" value="${view.seqno}">
				<input type="hidden" name="writer" value="${view.writer}">
				<input type="hidden" name="userid" value="${view.userid}">
				<input type="hidden" name="page" value="${page}">
				<input type="hidden" name="keyword" value="${keyword}">
				<textarea id="content" cols="100" rows="500" name="content">${view.content}</textarea>
				<c:if test="${fileListView != null }">
		         	<div id="fileListForm"><p style="text-align:left;">&nbsp&nbsp&nbsp&nbsp파일 목록 삭제를 원하는 파일명을 체크하세요.</p></div>
		         	<div id="fileList">	
		         		<p style="text-align:left;">
		        	 		<c:forEach items="${fileListView}" var="file" >
		         				&nbsp&nbsp&nbsp&nbsp<input type="checkbox" name="deleteFileList" value="${file.fileseqno}"> 
		         				 ${file.org_filename}&nbsp( ${file.filesize} Byte)<br>
			         		</c:forEach>
		         		</p>
		         	</div>       
		        </c:if>
			</form>	
		        <div class="fileuploadForm">
					<input type="file" id="inputFile" name="uploadFile" style="display:none;" multiple />
					<div class="fileZone" id="fileZone">파일 첨부를 하기 위해서는 클릭하거나 여기로 파일을 드래그 하세요.<br>첨부파일은 최대 5개까지 등록이 가능합니다.</div>
			  		<div class="fileUploadList" id="fileUploadList"></div>
				</div>
				<input type="button" class="btn_write" value="수정" onclick="ModifyForm()" />
				<input type="button" class="btn_cancel" value="취소" onclick="history.back()" />
		</div>
	</div>
	<br><br>
</body>
</html>