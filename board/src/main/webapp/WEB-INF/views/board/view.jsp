<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<title>게시물 내용 보기</title>
</head>

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

.boardView {
  width:900px;
  height:auto;
  padding: 20px, 20px;
  background-color:#FFFFFF;
  border:4px solid gray;
  border-radius: 20px;
}

.writer, .title, .regdate, .content, .filename {
  width: 90%;
  height:25px;
  outline:none;
  color: #636e72;
  font-size:16px;
  background: none;
  border-bottom: 2px solid #adadad;
  margin: 30px;
  padding: 10px 10px;
  text-align: left;
}

.textArea {
  width: 90%;
  height: 350px;
  overflow: auto;
  margin: 22px;
  padding: 10px;
  box-sizing: border-box;
  border: solid #adadad;
  text-align: left;
  font-size: 16px;
  resize: both;
}

.likeClick, .dislikeClick {
    padding: 10px 10px;
	text-align: center;	
	text-decoration: none;
    border: solid 1px #a0a0a0;
    display: inline-block;
    background-color: #d2d2d2;
    border-radius: 20px
}

.replyDiv {
  margin-top: 30px;
  margin-left: 200px;
  margin-right: 200px;
  background-color:#FFFFFF;
  border:4px solid white;
  border-radius: 20px;
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

<!-- 좋아요, 싫어요 제이쿼리 처리 함수 시작 -->

var likeCnt; 
var dislikeCnt; 
var myLikeCheck; 
var myDislikeCheck; 
var username;

$(document).ready(function(){
	likeCnt = ${view.likecnt}; 
	dislikeCnt = ${view.dislikecnt}; 
	myLikeCheck = '${myLikeCheck}'; 
	myDislikeCheck = '${myDislikeCheck}'; 
	username = '${username}';
	$("#like").html(likeCnt);
	$("#dislike").html(dislikeCnt);
	
	if(myLikeCheck == "Y") $(".likeClick").css("background-color", "#00B9FF"); 
	    else if(myDislikeCheck == "Y") $(".dislikeClick").css("background-color", "#00B9FF"); 
	
	if(myLikeCheck == "Y") $("#myChoice").html(username + "님의 선택은 좋아요입니다."); 
	        else if(myDislikeCheck == "Y") $("#myChoice").html(username + "님의 선택은 싫어요입니다."); 
	        else if(myLikeCheck == "N" && myDislikeCheck == "N") $("#myChoice").html(username + "님은 아직 선택을 안 했네요"); 
});

function likeView(){ 
    
    if(myLikeCheck == "Y" && myDislikeCheck =="N") {
        alert("좋아요를 취소합니다."); 
        var checkCnt = 1;  //likeCnt --;
        myLikeCheck = "N";
        sendDataToServer(myLikeCheck,myDislikeCheck,checkCnt); 
        $(".likeClick").css("background-color", "#d2d2d2"); 
    }else if(myLikeCheck == "N" && myDislikeCheck =="Y") {
        alert("싫어요가 취소되고 좋아요가 등록됩니다.");
        var checkCnt = 2; // likeCnt ++ , dislikeCnt --
        myLikeCheck = "Y";
        myDislikeCheck = "N";
        sendDataToServer(myLikeCheck,myDislikeCheck,checkCnt);  
        $(".likeClick").css("background-color", "#00B9FF"); 
        $(".dislikeClick").css("background-color", "#d2d2d2");
    } else if(myLikeCheck == "N" && myDislikeCheck =="N") {
        alert("좋아요를 선택 했습니다.")
    	var checkCnt = 3; //likeCnt ++
        myLikeCheck = "Y";
        sendDataToServer(myLikeCheck,myDislikeCheck,checkCnt);
        $(".likeClick").css("background-color", "#00B9FF"); 
    }
    if(myLikeCheck == "Y") $("#myChoice").html(username + "님의 선택은 좋아요입니다."); 
        else if(myDislikeCheck == "Y") $("#myChoice").html(username + "님의 선택은 싫어요입니다."); 
        else if(myLikeCheck == "N" && myDislikeCheck == "N") $("#myChoice").html(username + "님은 아직 선택을 안 했네요"); 
}

function disLikeView() {
    
    if(myDislikeCheck == "Y" && myLikeCheck =="N") {
        alert("싫어요를 취소합니다."); 
        var checkCnt = 4; // dislikeCnt --
        myDislikeCheck = "N";
        sendDataToServer(myLikeCheck,myDislikeCheck,checkCnt);
        $(".dislikeClick").css("background-color", "#d2d2d2"); 
    } else if(myDislikeCheck = "N" && myLikeCheck =="Y") {
        alert("좋아요가 취소되고 싫어요가 등록됩니다.");
        var checkCnt = 5; //likeCnt -- , dislikeCnt ++            
        myLikeCheck = "N";            
        myDislikeCheck = "Y";
        sendDataToServer(myLikeCheck,myDislikeCheck,checkCnt);
        $(".likeClick").css("background-color", "#d2d2d2"); 
        $(".dislikeClick").css("background-color", "#00B9FF"); 
    } else if(myDislikeCheck = "N" && myLikeCheck =="N") {
        alert("싫어요를 선택했습니다.");
    	var checkCnt = 6; //dislikeCnt ++
        myDislikeCheck = "Y";
        sendDataToServer(myLikeCheck,myDislikeCheck,checkCnt);
        $(".dislikeClick").css("background-color", "#00B9FF"); 
    }
    if(myLikeCheck == "Y") $("#myChoice").html(username + "님의 선택은 좋아요입니다."); 
        else if(myDislikeCheck == "Y") $("#myChoice").html(username + "님의 선택은 싫어요입니다."); 
        else if(myLikeCheck == "N" && myDislikeCheck == "N") $("#myChoice").html(username + "님은 아직 선택을 안 했네요"); 
}

function sendDataToServer(myLike, myDislike, checkCount) {

    var myLikeCheck = myLike;
    var myDislikeCheck = myDislike;
    var checkCnt = checkCount;
    
    var queryString = {"seqno":${view.seqno},"userid":"${userid}",
    		"mylikecheck":myLikeCheck,"mydislikecheck":myDislikeCheck,"checkCnt":checkCnt};
    $.ajax({ //JSON --> MAP 타입일 경우 contentType를 반드시 입력...
        url: "/board/likeCheck",
        method: "POST",
        data: JSON.stringify(queryString),
        contentType: 'application/json; charset=UTF-8',
        dataType : "json",
        success: function(map) {
            $("#like").html(map["likeCnt"]);
            $("#dislike").html(map["dislikeCnt"]);
        },
        error: function(map) {
			alert("서버오류 문제로 좋아요/싫어요 등록이 실패 했습니다. 잠시 후 다시 시도해주시기 바랍니다.");
  	    	return false;
		}
    }); //End of ajax

}
<!-- 좋아요, 싫어요 제이쿼리 처리 함수 끝-->

function mDelete(){
	if(confirm("정말 삭제 하시겠습니까?")==true) location.href='/board/delete?seqno=${view.seqno}'
}

function fileDownload(fileseqno){
	
	location.href='/board/fileDownload?fileseqno=' + fileseqno;
}

<!-- 댓글 처리 -->
function replyRegister() { //form 데이터 전송 --> 반드시 serialize()를 해야 한다.
	
	if($("#replycontent").val() == "") {alert("댓글을 입력하세요."); $("#replycontent").focus(); return false;}
	
	var queryString = $("form[name=replyForm]").serialize();
	$.ajax({
		url : "reply?option=I",
		type : "post",
		datatype : "json",
		data : queryString,
		success : replyList,
		error : function(data) {
					alert("서버오류 문제로 댓글 등록이 실패 했습니다. 잠시 후 다시 시도해주시기 바랍니다.");
              	    return false;
		}
	}); //End of ajax
	$("#replycontent").val("");	
}

function replyList(data){
	
	var session_userid = '${userid}';
	const jsonInfo = data;
	
	var result = "";
	for(const i in jsonInfo){
		
		result += "<div id='replyListView'>";
		result += "<div id = '" + jsonInfo[i].replyseqno + "' style='font-size: 0.8em'>";
		result += "작성자 : " + jsonInfo[i].replywriter;
						
		if(jsonInfo[i].userid == session_userid) {
			result += "[<a href=" + "'javascript:replyModify(" + jsonInfo[i].replyseqno + ")' style='cursor:pointer;'>수정</a> | " ;
			result += "<a href=" + "'javascript:replyDelete(" + jsonInfo[i].replyseqno + ")' style='cursor:pointer;'>삭제</a>]" ;
		}
		
		result += "&nbsp;&nbsp;" + jsonInfo[i].replyregdate
		result += "<div style='width:90%; height: auto; border-top: 1px solid gray; overflow: auto;'>";
		result += "<pre class='" + jsonInfo[i].replyseqno + "'>" + jsonInfo[i].replycontent + "</pre></div>";
		result += "</div>";
		result += "</div><br>";
	}
	$("#replyListView").remove();
	$("#replyList").html(result);
}

function startupPage(){
	
	var queryString = { "seqno": "${view.seqno}" };
	$.ajax({
		url : "reply?option=L",
		type : "post",
		datatype : "json",
		data : queryString,
		success : replyList,
		error : function(data) {
						alert("서버 오류로 댓글 불러 오기가 실패했습니다.");
              	    	return false;
				}
	}); //End od ajax
}

function replyDelete(replyseqno) { 
	var rseqno = replyseqno
	if(confirm("정말로 삭제하시겠습니까?") == true) {
		var queryString = { "replyseqno": replyseqno, "seqno":${view.seqno} };
		$.ajax({
			url : "reply?option=D",
			type : "post",
			data : queryString,
			dataType : "json",
			success : replyList,
			error : function(data) {
						alert("서버오류 문제로 댓글 등록이 실패 했습니다. 잠시 후 다시 시도해주시기 바랍니다.");
	            		return false;
			}
		}); //End od ajax
	}
}

function replyModify(replyseqno) {

	var replyContent = $("." + replyseqno).html();
	
	var strReplyList = "<form id='formModify' name='formModify' method='POST'>"
					+ "작성자 : ${session_userid}&nbsp;"
					+ "<input type='button' id='btn_replyModify' value='수정'>"
					+ "<input type='button' id='btn_replyModifyCancel' value='취소'>"
					+ "<input type='hidden' name='replyseqno' value='" + replyseqno + "'>"
					+ "<input type='hidden' name='seqno' value='${view.seqno}'>"
					+ "<input type='hidden' id='writer' name='replywriter' value='${session_username}'>"
					+ "<input type='hidden' id='uerid' name='userid' value='${session_userid}'><br>"
					+ "<textarea id='replycontent' name='replycontent' cols='80' rows='5' maxlength='150' placeholder='글자수:150자 이내'>" + replyContent + "</textarea><br>"
					+ "</form>";
	$('#' + replyseqno).after(strReplyList);				
	$('#' + replyseqno).remove();

	$("#btn_replyModify").on("click", function(){
		var queryString = $("form[name=formModify]").serialize();
		$.ajax({
			url : "reply?option=U",
			type : "post",
			dataType : "json",
			data : queryString,
			success : replyList,
			error : function(data) {
							alert("서버오류 문제로 댓글 등록이 실패 했습니다. 잠시 후 다시 시도해주시기 바랍니다.");
	              	    	return false;
			}
		}); //End of $.ajax
	 }); //End of $("#btn_replyModify")
	
	 $("#btn_replyModifyCancel").on("click", function(){
		 if(confirm("정말로 취소하시겠습니까?") == true  ) { $("#replyListView").remove(); startupPage(); }
	 });	 
	
}
	
function replyCancel() { 
		if(confirm("정말로 취소 하시겠습니까?") == true) { $("#replyContent").val(""); $("#replyContent").focus(); }
}

</script>

<body onload="startupPage()">

<%

	String userid = (String)session.getAttribute("userid");
	String username = (String)session.getAttribute("username");
	String role = (String)session.getAttribute("role");
	if(userid == null) response.sendRedirect("/");

%>

<div class="main" align="center">

  <div>
    <img id="topBanner" src ="${pageContext.request.contextPath}/resources/images/logo.jpg" title="서울기술교육센터">
  </div>
	<h1>게시물 내용 보기</h1>
	<br>
	<div class="boardView">
		<div class="writer">이름 : ${view.writer}</div>
		<div class="title">제목 : ${view.title}</div>
		<div class="regdate">날짜 : <fmt:formatDate value="${view.regdate}" type="both" /></div>
		<div class="textArea"><pre>${view.content}</pre></div>
		<div class="likeForm">
         	<span id='like'></span>&nbsp;<a href='javascript:likeView()' id="likeClick" class="likeClick">좋아요</a>
        	<a href="javascript:disLikeView()" id="disLikeClick" class="dislikeClick">싫어요</a>&nbsp;<span id="dislike"></span><br>
  			<span id='myChoice' style='color:red'></span>
        </div>
        <c:if test="${fileListView != 'null'}">
        	<c:forEach items="${fileListView}" var="fileView">
				<div class="filename">파일명 : <a href="javascript:fileDownload('${fileView.fileseqno}')">${fileView.org_filename}</a> ( ${fileView.filesize} Byte )</div>
			</c:forEach>
		</c:if>
		<c:if test="${fileListView == 'null'}">
			<div class="filename">업로드된 파일이 없습니다.</div>
		</c:if>	
	</div>

	<div class="bottom_menu">
		<c:if test="${pre_seqno !=0}">
			&nbsp;&nbsp;<a href="/board/view?seqno=${pre_seqno}&page=${pageNum}&searchType=${searchType}&keyword=${keyword}" onMouseover="this.style.textDecoration='underline';" 
					onmouseout="this.style.textDecoration='none';">이전글 ▼</a> &nbsp;&nbsp;
		</c:if>		
			<a href="/board/list?page=${pageNum}&searchType=${searchType}&keyword=${keyword}" onMouseover="this.style.textDecoration='underline';" 
					onmouseout="this.style.textDecoration='none';">목록보기</a> &nbsp;&nbsp;
		<c:if test="${next_seqno !=0}">			
			<a href="/board/view?seqno=${next_seqno}&page=${pageNum}&searchType=${searchType}&keyword=${keyword}" onMouseover="this.style.textDecoration='underline';" 
					onmouseout="this.style.textDecoration='none';">다음글 ▲</a> &nbsp;&nbsp;
		</c:if>	
			<a href="/board/write" onMouseover="this.style.textDecoration='underline';" 
					onmouseout="this.style.textDecoration='none';">글 작성</a> &nbsp;&nbsp;
		<c:if test="${userid == view.userid}">				
			<a href="/board/modify?seqno=${view.seqno}&page=${pageNum}&searchType=${searchType}&keyword=${keyword}" onMouseover="this.style.textDecoration='underline';" 
					onmouseout="this.style.textDecoration='none';">글 수정</a> &nbsp;&nbsp;
			<a href="javascript:mDelete()" onMouseover="this.style.textDecoration='underline';" 
					onmouseout="this.style.textDecoration='none';">글 삭제</a> &nbsp;&nbsp;
		</c:if>				
	</div>
	
	<div class="replyDiv" style="text-align:left;">

		<p id="replyNotice">댓글을 작성해 주세요</p>
		<form id="replyForm" name="replyForm" method="POST"> 
			작성자 : <input type="text" id="replywriter" name="replywriter" value=${username} disabled><br>
	    	<textarea id='replycontent' name='replycontent' cols='80' rows='5' maxlength='150' placeholder='글자수:150자 이내'></textarea><br>
	    	<input type="hidden" name="seqno" value="${view.seqno}">
	    	<input type="hidden" name="replywriter" value="${username}">
	    	<input type="hidden" name="userid" value="${userid}">
		</form>
		<input type="button" id="btn_reply" value="댓글등록" onclick="replyRegister()">
		<hr>
		
		<div id="replyList" style="width:100%; height:600px; overflow:auto;">
			<div id="replyListView"></div> 
		</div><!-- replyList End  -->		
	</div>
	
</div>
</body>
</html>