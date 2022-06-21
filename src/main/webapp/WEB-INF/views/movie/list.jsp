<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../includes/header.jsp" %>

	<div id="wrap" align="center">
		<h1>영화 리스트</h1>
		<table class="list">
			<tr>
				<td colspan=6 style="border:white; text-align:right">
					<div>
						<button id="regBtn" type="button" class="btn btn-xs pull-right">
						 영화정보등록
						</button>
					</div>
				</td>
			</tr>
			<tr>
				<th style="text-align: center;">제목</th>
				<th style="text-align: center;">감독</th>
				<th style="text-align: center;">배우</th>
				<th style="text-align: center;">가격</th>
				<th style="text-align: center;">수정</th>
				<th style="text-align: center;">삭제</th>
			</tr>
			<c:forEach var="movie" items="${list }">
				<tr class="record">							
					<td style="text-align: center;">${movie.title }</td>			
					<td style="text-align: center;">${movie.director }</td>				
					<td style="text-align: center;">${movie.actor }</td>
					<td style="text-align: right;">${movie.price } 원</td>			
					<td style="text-align: center;"><a class="move1" href='<c:out value="${movie.code}"/>'>정보수정</a></td>
					<td style="text-align: center;"><a class="move2" href='<c:out value="${movie.code}"/>'>정보삭제</a></td>		

					
				</tr>
			</c:forEach>
		</table>
	</div>
 					<form id='actionForm' action="/movie/modify" method="get">			
					</form>
					
					 <form id='actionForm2' action="/movie/remove" method="get">			
					</form>
	
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
						aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Modal title</h4>
			</div>
			<div class="modal-body">처리가 완료되었습니다.</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
		<!-- /.modal-content -->
</div>
<!-- /.modal-dialog -->
</div>
<!-- /.modal -->
<script>
$(document).ready(function(){
	var result = '<c:out value="${result}"/>';
	var actionForm = $("#actionForm");
	var actionForm2 = $("#actionForm2");
		
	checkModal(result);
	
	$("#regBtn").on("click", function(){
		self.location = '/movie/register';
	});
	
	history.replaceState({}, null, null);
		
	function checkModal(result){
		if(result === '' || history.state){
			return;
		}
		$("#myModal").modal("show");
	}
	
	$(".move1").on("click", function(e){
		e.preventDefault();
		actionForm.append("<input type='hidden' name='code' value='" + $(this).attr("href")+"'>");
		actionForm.attr("action","/movie/modify").submit();
		actionForm.submit();
	});
	
	$(".move2").on("click", function(e){
		e.preventDefault();
		actionForm2.append("<input type='hidden' name='code' value='" + $(this).attr("href")+"'>");
		actionForm2.attr("action","/movie/remove");
		actionForm2.submit();
	});
});


</script>
	
	
	
	
	
<%@ include file="../includes/footer.jsp" %>