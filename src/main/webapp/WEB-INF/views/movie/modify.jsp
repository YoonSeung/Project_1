<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<%@include file="../includes/header.jsp" %>

	<div id="wrap" align="center">
		<h1>영화정보수정</h1>
		<form name="frm"  action="/movie/modify" method="post">
			<input type="hidden" name="code" value="${movie.code }">
			<table> 
				<tr>
					<td>
						<div class="panel-body">
							<div class="form-group uploadDiv">											
							</div>			
							<div class='uploadResult2'>
								<ul>
					
								</ul>
							</div>		
						</div><br>
					</td>
					<td>
						<table>
							<tr>
								<th style="text-align: center;">제  목</th>
								<td><input type="text" name="title" value="${movie.title }" size="80"></td>
							</tr>
							<tr>
								<th style="text-align: center;">가  격</th>
								<td><input type="text" name="price" value="${movie.price }"> 원</td>
							</tr>
							<tr>
								<th style="text-align: center;">감  독</th>
								<td><input type="text" name="director" value="${movie.director }" size="80"></td>
							</tr>	
							<tr>
								<th style="text-align: center;">배  우</th>
								<td><input type="text" name="actor" value="${movie.actor }" size="80"></td>
							</tr>
							<tr>
								<th style="text-align: center;">시놉시스</th>
								<td><textarea rows="10" cols="90" name="synopsis">${movie.synopsis }</textarea></td>
							</tr>
							<tr>
								<th style="text-align: center;">사  진</th>
								<td><div class="panel-body">
										<div class="form-group uploadDiv">
											<input type="file" name='uploadFile'>
										</div>
				
										<div class='uploadResult'>
										<ul>
					
										</ul>
										</div>
				
									</div><br></td>
							</tr>																																		
						</table>
					</td>
				</tr>						
			</table>
			<br>
			<button type="submit" data-oper='modify' class="btn btn-default" >수정</button>
			<button type="submit" data-oper='list' class="btn btn-info" >리스트로 이동</button>
		</form>
	</div>
	<style>
	
	.uploadResult2 ul li{
		list-style:none;

	}
	
	</style>
<script type="text/javascript">
	$(document).ready(function(){
		var formObj = $("form");
		
		$('button').on("click", function(e){
			e.preventDefault();
			var operation = $(this).data("oper");
			console.log(operation);
			
			if(operation ==='list'){
				formObj.attr("action", "/movie/list").attr("method","get");				
				formObj.empty();
				
				

			}else if(operation == 'modify'){
				console.log("submit clicked");
				var str ="";
				
				$(".uploadResult ul li").each(function(i, obj){
					var jobj = $(obj);
					console.dir(jobj);
					
					str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
					
				});
				formObj.append(str).submit();
				
			}
			formObj.submit();
		});
	});
</script>  
  
<script>
$(document).ready(function(){
	(function(){//기존 첨부파일 사진칸에 보여주기 x 표시와함께
		var code = '<c:out value="${movie.code}"/>';
		$.getJSON("/movie/getAttachList", {code: code}, function(arr){
			console.log(arr);
			
			var str="";
			
			$(arr).each(function(i, attach){
				var fileCallPath = encodeURIComponent("/s_" + attach.uuid + "_" + attach.fileName);
				
				str+= "<li data-path = '" + attach.uploadPath + "' data-uuid = '" + attach.uuid + "'data-filename='"+ attach.fileName + "' data-type = '" + attach.fileType + "'><div>";
				str+= "<span> " + attach.fileName + "</span>";
				str+= "<button type = 'button' data-file=\'" + fileCallPath + "\' data-type='image'";
				str+= "class = 'btn btn-warning btn-circle'><i class = 'fa fa-times'></i></button><br>";
				str+= "<img src = '/display?fileName=" + fileCallPath + "'>";
				str+= "</div>";
				str+ "</li>";
			});

			$(".uploadResult ul").html(str);
		});//end getjson
		
		//기존에 뜬 이미지 x 눌렀을때 반응하기
		$(".uploadResult").on("click","button", function(e){
			console.log("delete file");
			
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			
			if(confirm("파일을 지우시겠습니까?")){
				var targetLi = $(this).closest("li");
				$.ajax({
					url: '/deleteFile',
					data: {fileName: targetFile, type:type},
					dataType: 'text',
					type: 'POST',
						success: function(result){
							alert(result);
							targetLi.remove();
						}
				});
			}
		});
	})();//end function   
	

	
	(function(){//기존 이미지 왼쪽에 뜨게 하기
		var code = '<c:out value="${movie.code}"/>';
		$.getJSON("/movie/getAttachList", {code: code}, function(arr){
			console.log(arr);
			
			var str="";
			
			$(arr).each(function(i, attach){
					var fileCallPath =  encodeURIComponent("/"+attach.uuid +"_"+attach.fileName);
					
					str += "<li data-path='"+attach.uploadPath+"'";
		               str +=" data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
		               str += "<img src='/display?fileName="+fileCallPath+"'>";
		               str += "</div>";
		               str +"</li>";
			});
			$(".uploadResult2 ul").html(str);
		});//end getjson
	})();//end function   
	
	var regex = new RegExp("(.*?)\.(JPEG|JPG|PNG|jpg)$"); 
	var maxSize = 5242880;
	
	function checkExtension(fileName, fileSize){
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과");
			return false;
		}
		if(!regex.test(fileName)){
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		return true;
	}
		
	$("input[type='file']").change(function(e){
		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;
		
		for(var i=0; i<files.length; i++){
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			formData.append("uploadFile", files[i]);
		}
		
		$.ajax({
			url: '/uploadAjaxAction',
			processData: false,
			contentType: false,
			data: formData,
			type: 'POST',
			dataType:'json',
				success: function(result){
					console.log(result);
					showUploadFile(result);
				}
		});
	});//$("input[type='file']").change(function(e)끝
	
	function showUploadFile(uploadResultArr){//새로운 첨부파일 넣으면 보여주기
		if(!uploadResultArr || uploadResultArr.length ==0){
			return;
		}
		var uploadURL = $(".uploadResult ul");
		var str = "";
		
		$(uploadResultArr).each(function(i, obj){
			
	               var fileCallPath =  encodeURIComponent("/s_"+obj.uuid +"_"+obj.fileName);
	               str += "<li data-path='"+obj.uploadPath+"'";
	               str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
	               str += "<span> "+ obj.fileName+"</span>";
	               str += "<button type='button' data-file=\'"+fileCallPath+"\' "
	               str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
	               str += "<img src='/display?fileName="+fileCallPath+"'>";
	               str += "</div></li>";
		});
		uploadURL.append(str);
	}

});	
</script>		
<%@include file="../includes/footer.jsp" %>