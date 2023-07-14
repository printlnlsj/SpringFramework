<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주소 검색</title>

<script>
function addrCheck(zipcode, newaddr){
	
	window.opener.document.getElementById("zip").value = zipcode;
	window.opener.document.getElementById("addr1").value = newaddr;
	window.close();
	
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

}
</style>

</head>
<body>

<div class="tableDiv">

	<h1>주소 검색</h1>
	<table class="InfoTable">
  		<tr>
   			<th>우편번호</th>
   			<th>주소</th>
   			<th>선택</th>
  		</tr>

 		<tbody>
 		<c:if test="${list != null}">
			<c:forEach items="${list}" var="list">
			 	<tr onMouseover="this.style.background='#46D2D2';" onmouseout="this.style.background='white';">
					<td>${list.zipcode}</td>
					<td style="text-align:left;">${list.province}${list.road}${list.building}<br>${list.oldaddr}</td>  
					<td><input type="button" value="선택" onclick="addrCheck('${list.zipcode}','${list.province}${list.road}${list.building}');" > </td>
				</tr>
			</c:forEach>
		</c:if>	
		<c:if test="${list == null}">
			<tr>
				<td colspan="3">검색된 주소가 없습니다.</td>
			</tr>
		</c:if>

		</tbody>
	</table>

	<div>
		${pageListView}
	</div>
</div>
</body>
</html>