<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../includes/header.jsp" %>

	<div id="wrap" align="center">
		<h1>영화정보 삭제</h1>
		<form fole="form" action="/movie/remove" method="post">
			<input type="hidden" name="code" value="${movie.code }">
			<table>
				<tr>
					<td >
						<div class="panel-body">
							<div class="form-group uploadDiv">
											
							</div>			
							<div class='uploadResult'>
								<ul>
					
								</ul>
							</div>
				
						</div><br>
					</td>
					<td>
						<table>
							<tr>
								<th style="text-align: center;">제  목</th>
								<td>${movie.title }</td>
							</tr>
							<tr>
								<th style="text-align: center;">가  격</th>
								<td>${movie.price } 원</td>
							</tr>
							<tr>
								<th style="text-align: center;">감  독</th>
								<td>${movie.director }</td>
							</tr>	
							<tr>
								<th style="text-align: center;">배  우</th>
								<td>${movie.actor }</td>
							</tr>
							<tr>
								<th style="text-align: center;">시놉시스</th>
								<td><div style="height:220px; width:400px"  >${movie.synopsis }</div></td>
							</tr>																																							
						</table>
					</td>
				</tr>						
			</table>
			<br>
			<button type="submit" data-oper='remove' class="btn btn-danger" >삭제</button>
			<button type="submit" data-oper='list' class="btn btn-info" >리스트로 이동</button>
		</form>
	</div>
	<div class="bigPictureWrapper">
		<div class="bigPicture"></div>
	</div>


	<style>
	.uploadResult{
		width: 100%;
	}
	
	.uploadResult ul{
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li{
		list-style: none;
	}
	
	.uploadResult ul li img{
		width: 100%;
	}
	
	.bigPictureWrapper{
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top:0%;
		width:100%;
		height:100%;
		background-color: gray;
		z-index: 100;
	}
	
	.bigPicture{
		position: relative;
		display:flex;
		justify-content: center;
		align-items: center;
	}
	
	.bigPicture img{
		width: 600px;
	}
</style>	
		
<script type="text/javascript">
$(document).ready(function(){
	(function(){
		var code = '<c:out value="${movie.code}"/>';
		$.getJSON("/movie/getAttachList", {code: code}, function(arr){
			console.log(arr);
			
			var str="";
			
			$(arr).each(function(i, attach){
				if(attach.fileType){
					var fileCallPath =  encodeURIComponent("/"+attach.uuid +"_"+attach.fileName);
					
		               str += "<li data-path='"+attach.uploadPath+"'";
		               str +=" data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
		               str += "<img src='/display?fileName="+fileCallPath+"'>";
		               str += "</div>";
		               str +"</li>";
				}
			});
			$(".uploadResult ul").html(str);
		});//end getjson
	})();//end function
	
	//이미지 클릭시 이벤트부여하는 코드1
	function showImage(fileCallPath){
		alert(fileCallPath);
		
		$(".bigPictureWrapper").css("display","flex").show();
		
		$(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>")
						.animate({width:'100%', height:'100%'},1000);
	}
	
	//이미지 클릭시 이벤트부여하는 코드2
	$(".uploadResult").on("click","li",function(e){		
		
		var liObj = $(this);
		var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
		
		if(liObj.data("type")){
			showImage(path.replace(new RegExp(/\\/g),"/"));
		}else{
			self.location = "/download?fileName="+path;
		}
	});
	
	//원본이미지 창 닫는 코드
	$(".bigPictureWrapper").on("click", function(e){
		$(".bigPicture").animate({width:'0%', height:'0%'},1000);
		setTimeout(function(){
			$('.bigPictureWrapper').hide();
		},1000);
	});
	
	var formObj = $("form");
	$('button').on("click", function(e){
		e.preventDefault();
		var operation = $(this).data("oper");
		console.log(operation);
		
		if(operation === 'remove'){
			formObj.attr("action", "/movie/remove");
			
		}else if(operation ==='list'){
			formObj.attr("action", "/movie/list").attr("method","get");
			formObj.empty();
		}
		formObj.submit();
	});
});
</script>	
<%@ include file="../includes/footer.jsp" %>