package com.SpaceBoard.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.SpaceBoard.dto.UserVO;

@Controller
public class StudyController {

	@PostMapping("/user/userinfo")
	public void postUserInfo(UserVO user, Model model) {
		
		model.addAttribute("user", user);
		
	}
	
	@GetMapping("/study/imgView")
	public void getImgView() throws Exception {
		
	}
	
	@GetMapping("/study/imgViews")
	public void getImgViews() throws Exception {
		
	}
	
	@GetMapping("/study/fileUpload")
	public void getFileUpload() {}
	
	@GetMapping("/study/fileUpload2")
	public void getFileUpload2() {}
	
	@PostMapping("/study/fileUpload")
	public void postFileUpload(@RequestParam("painter") String painter,
			@RequestParam("fileUpload") List<MultipartFile> multipartFile) throws Exception {
		
		String path = "c:\\Repository\\test\\"; 
		String org_filename = "";
		long filesize = 0L;
		
		if(!multipartFile.isEmpty()) {
			File targetFile = null; 
			
			for(MultipartFile mpr:multipartFile) {
				
				org_filename = mpr.getOriginalFilename();	
				//String org_fileExtension = org_filename.substring(org_filename.lastIndexOf("."));	
				//String stored_filename = UUID.randomUUID().toString().replaceAll("-", "") + org_fileExtension;	
				filesize = mpr.getSize() ;
				
				//File file = new File("c:\\Repository\\test\\kkk.txt"); //파일생성에 필요한 경로 및 파일 정보를 입력
				targetFile = new File(path + org_filename);
				mpr.transferTo(targetFile);	//raw data를 targetFile에서 가진 정보대로 변환
				System.out.println("파일명 = " + org_filename);
			}
			
			
			System.out.println("파일사이즈 = " + filesize);
			
		}
		
	}
	
	@ResponseBody
	@PostMapping("/study/fileUpload2")
	public String postFileUpload2(@RequestParam("painter") String painter,
			@RequestParam("fileUpload") List<MultipartFile> multipartFile) throws Exception {
		
		String path = "c:\\Repository\\test\\"; 
		String org_filename = "";
		long filesize = 0L;
		
		if(!multipartFile.isEmpty()) {
			File targetFile = null; 
			
			for(MultipartFile mpr:multipartFile) {
				
				org_filename = mpr.getOriginalFilename();	
				//String org_fileExtension = org_filename.substring(org_filename.lastIndexOf("."));	
				//String stored_filename = UUID.randomUUID().toString().replaceAll("-", "") + org_fileExtension;	
				filesize = mpr.getSize() ;
				
				//File file = new File("c:\\Repository\\test\\kkk.txt"); //파일생성에 필요한 경로 및 파일 정보를 입력
				targetFile = new File(path + org_filename);
				mpr.transferTo(targetFile);	//raw data를 targetFile에서 가진 정보대로 변환
				
			}
			
		}
		
		return "good";
	}
	
	@GetMapping("/study/filelist")
	public void getFileList() {}
	
	//파일 다운로드
	@GetMapping("/study/fileDownload")
	public void fileDownload(@RequestParam("file") String file, HttpServletResponse rs) throws Exception {
		
		String path = "c:\\Repository\\test\\";
		
		byte fileByte[] = FileUtils.readFileToByteArray(new File(path+file));
		
		//헤드값을 Content-Disposition로 주게 되면 Response Body로 오는 값을 filename으로 다운받으라는 것임
		//예) Content-Disposition: attachment; filename="hello.jpg"
		rs.setContentType("application/octet-stream");
		rs.setContentLength(fileByte.length);
		rs.setHeader("Content-Disposition",  "attachment; filename=\""+URLEncoder.encode(file, "UTF-8")+"\";");
		rs.getOutputStream().write(fileByte);
		rs.getOutputStream().flush();//버퍼에 있는 내용을 write
		rs.getOutputStream().close();
		
	}
	
}
