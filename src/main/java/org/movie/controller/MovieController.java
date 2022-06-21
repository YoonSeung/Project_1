package org.movie.controller;



import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.movie.domain.MovieAttachVO;
import org.movie.domain.MovieVO;
import org.movie.service.MovieService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/movie")
@AllArgsConstructor
public class MovieController {

	private MovieService service;
	
		//리스트뿌려오기
		@GetMapping("/list")
		public void list(Model model) {
			log.info("list");
			model.addAttribute("list", service.getList());
		}
		
		//등록화면 보여주기
		@GetMapping("/register")
		public void register() {
			
		}
		
		//등록한거 보내기
		@PostMapping("/register")
		public String register(MovieVO mVo, RedirectAttributes rttr) {
			log.info("register:" + mVo);
			
			if(mVo.getAttachList() != null) {
				mVo.getAttachList().forEach(attach->log.info(attach));
			}
			service.register(mVo);
			rttr.addFlashAttribute("result", mVo.getCode());
			
			return "redirect:/movie/list";
		}
		
		//정보보여주기
		@GetMapping({"/modify","/remove"})
		public void get(@RequestParam("code") Long code, Model model) {
			log.info("/modify or remove");
			model.addAttribute("movie",service.get(code));
		}
		
		//수정맵핑
		@PostMapping("/modify")
		public String modify(MovieVO eVo, RedirectAttributes rttr) {
			log.info("modify:" + eVo);
			
			if(service.modify(eVo)) {
				rttr.addFlashAttribute("result", "success");
			}

			return "redirect:/movie/list";
		}
		
		//삭제 맵핑
		@PostMapping("/remove")
		public String remove(@RequestParam("code") Long code, RedirectAttributes rttr) {
			log.info("remove.." + code);
			
			List<MovieAttachVO> attachList = service.getAttachList(code);
			
			if(service.remove(code)) {
				deleteFiles(attachList);
				rttr.addFlashAttribute("result", "success");
			}
			return "redirect:/movie/list";
		}
		
		//파일 삭제
		private void deleteFiles(List<MovieAttachVO> attachList) {
			if(attachList == null || attachList.size() ==0) {
				return;
			}
			log.info("delete attach files.............");
			log.info(attachList);
			
			attachList.forEach(attach -> {
				try {
					Path file = Paths.get(attach.getUploadPath()+"\\"+attach.getUuid()+"_"+attach.getFileName());
					//getUploadPath가 c:\\movieUpload로 선언되있기때문에 써도됨
					//책처럼 폴더를 yy-MM-dd로 만들어서 할경우 getuploadPath는 yy-MM-dd 형식일테니 그땐 "c:\\upload\\" 를 앞에 써주고 getUploadPath를 추가해야함을 잊지말기
					
					Files.deleteIfExists(file);
					
					if(Files.probeContentType(file).startsWith("image")) {
						Path thumbNail = Paths.get(attach.getUploadPath()+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
						Files.delete(thumbNail);
					}
				}catch(Exception e) {
					log.error("delete file error" + e.getMessage());
				}//end catch
			});//end foreachd
		}
		
		//첨부파일 확인하는 맵핑
		@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
		@ResponseBody
		public ResponseEntity<List<MovieAttachVO>> getAttachList(Long code){
			log.info("getAttachList " + code);
			
			return new ResponseEntity<>(service.getAttachList(code), HttpStatus.OK);
		}
		
}
