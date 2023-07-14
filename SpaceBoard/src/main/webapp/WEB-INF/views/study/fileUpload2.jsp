<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script>
	const FileUpload = async () => {

		const formData = new FormData(FileForm);
		
		await fetch('/board/fileUpload2', {
			method: 'POST',
			body: formData
		}).then((response) => response.text())
		  .then((data) => {
			  if(data == 'good')
				  alert("파일 전송이 성공했습니다.");
		      else 
		    	  alert("서버 장애로 파일 전송이 실패했습니다.");
		}).catch((error) => console.log("error =" + error));
	
	}	
</script>

<title>파일 업로드 예제</title>
</head>
<body>

<form id="FileForm" method="post" enctype="multipart/form-data">
	화가 : <input type="text" name="painter">
	<input type="file" name="fileUpload" multiple><br>
	<input type="button" onclick="FileUpload()" value="파일전송">
</form>
</body>
</html>