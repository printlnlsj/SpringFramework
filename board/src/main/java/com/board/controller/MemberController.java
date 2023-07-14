package com.board.controller;

import java.io.File;import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.board.dto.AddressVO;
import com.board.dto.FileVO;
import com.board.dto.MemberVO;
import com.board.service.BoardService;
import com.board.service.MemberService;
import com.board.util.Page;

import oracle.sql.DATE;

@Controller
@RequestMapping("/member/*")
public class MemberController {

	Logger log = LoggerFactory.getLogger(MemberController.class);
	
	@Autowired
	MemberService service;
	
	@Autowired
	BoardService boardService;
	
	@Autowired //비밀번호 암호화 의존성 주입
	private BCryptPasswordEncoder pwdEncoder;
	
	//사용자 등록 화면 보기
	@RequestMapping(value="/signup",method=RequestMethod.GET)
	public void getMemberRegistry() throws Exception { }
	
	//사용자 등록 처리
	@RequestMapping(value="/signup",method=RequestMethod.POST)
	public String postMemberRegistry(MemberVO member,
			@RequestParam("fileUpload") MultipartFile multipartFile ) {
		
		String path = "c:\\Repository\\profile\\";
		File targetFile;

		log.info("org_filename = {}", multipartFile.getOriginalFilename());
		
		if(!multipartFile.isEmpty()) {
				
				String org_filename = multipartFile.getOriginalFilename();	
				
				String org_fileExtension = org_filename.substring(org_filename.lastIndexOf("."));	
				String stored_filename =  UUID.randomUUID().toString().replaceAll("-", "") + org_fileExtension;	
								
				try {
					targetFile = new File(path + stored_filename);
					
					multipartFile.transferTo(targetFile);
					
					member.setOrg_filename(org_filename);
					member.setStored_filename(stored_filename);
					member.setFilesize(multipartFile.getSize());
																				
				} catch (Exception e ) { e.printStackTrace(); }
				
				String inputPassword = member.getPassword();
				String pwd = pwdEncoder.encode(inputPassword); 
				member.setPassword(pwd);			
				
		}	

		service.memberInfoRegistry(member);
		return "redirect:/";
	}
	
	//사용자 등록 시 아이디 중복 확인
	@ResponseBody
	@RequestMapping(value="/idCheck",method=RequestMethod.POST)
	public int idCheck(@RequestParam("userid") String userid) throws Exception{
		
		int result = service.idCheck(userid);
		
		return result;
	}
	
	//로그인 화면 보기
	@RequestMapping(value="/loginCheck",method=RequestMethod.GET)
	public void getLogIn() { }
	
	//로그인 처리
	@RequestMapping(value="/loginCheck",method=RequestMethod.POST)
	public String postLogIn(MemberVO loginData,Model model,HttpSession session,
			RedirectAttributes rttr) {
		
		//아이디 존재 여부 확인
		if(service.idCheck(loginData.getUserid()) == 0) {
			rttr.addFlashAttribute("message", "ID_NOT_FOUND");
			return "redirect:/";
		}
		
		MemberVO member = service.login(loginData.getUserid());
		
		//패스워드 확인
		if(!pwdEncoder.matches(loginData.getPassword(),member.getPassword())) {
			rttr.addFlashAttribute("message", "PASSWORD_NOT_FOUND");
			return "redirect:/";
		}else {
		
			//로그인 날짜 등록
			service.logindateUpdate(loginData.getUserid());
			
			//세션 생성
			session.setMaxInactiveInterval(3600*7);
			session.setAttribute("userid", member.getUserid());
			session.setAttribute("username", member.getUsername());
			session.setAttribute("role", member.getRole());

			//패스워드 변경 후 30일이 경과했는지 확인
			MemberVO pwcheck = new MemberVO();
			pwcheck = service.pwcheck(loginData.getUserid());
			
			if(pwcheck.getPwdiff() > (30*pwcheck.getPwcheck())) {
				return "redirect:/member/pwCheckNotice";
			}else return "redirect:/member/welcome";
		}

	}
	
	//welcome 페이지 정보 가져 오기
	@RequestMapping(value="/welcome",method=RequestMethod.GET)
	public void getWelcomeView(HttpSession session,Model model) {
		
		String userid = (String)session.getAttribute("userid");
		String username = (String)session.getAttribute("username");
		
		MemberVO member = service.welcomeView(userid);
		
		model.addAttribute("userid", userid);
		model.addAttribute("username", username);
		model.addAttribute("regdate", member.getRegdate());
		model.addAttribute("lastlogindate", member.getLastlogindate());
		model.addAttribute("lastlogoutdate", member.getLastlogoutdate());
		
	}
	
	//패스워드 변경 안내 공지
	@RequestMapping(value="/pwCheckNotice",method=RequestMethod.GET)
	public void getPwCheckNotice() { }
	
	//패스워드 30일 이후에 변경 공지 나오도록 pwchek 값 변경
	@RequestMapping(value="/memberPasswordModifyAfter30",method=RequestMethod.GET)
	public String postMemberPasswordAfter30(HttpSession session) {
		
		service.memberPasswordModifyAfter30((String)session.getAttribute("userid"));
		
		return "redirect:/member/welcome";
	}
	
	//로그아웃
	@RequestMapping(value="/logout",method=RequestMethod.GET)
	public void getLogout(HttpSession session,Model model) {
		
		String userid = (String)session.getAttribute("userid");
		String username = (String)session.getAttribute("username");

		//로그 아웃 날짜 등록
		service.logoutUpdate(userid);
		
		model.addAttribute("userid", userid);
		model.addAttribute("username", username);
		
		session.invalidate(); //모든 세션 종료--> 로그아웃...
		
	}

	//사용자 정보 보기
	@RequestMapping(value="/memberInfo",method=RequestMethod.GET)
	public void gerMemberInfoView(Model model,HttpSession session) {
		
		String userid = (String)session.getAttribute("userid");
		MemberVO member = service.memberInfoView(userid);
		MemberVO member_date = service.welcomeView(userid);
		
		model.addAttribute("member", member);
		model.addAttribute("member_date", member_date);
		
	}
	
	//사용자 정보 수정 보기
	@RequestMapping(value="/memberInfoModify",method=RequestMethod.GET)
	public void getMemberInfoModify(Model model,HttpSession session) {
		
		String userid = (String)session.getAttribute("userid");
		MemberVO member = service.memberInfoView(userid);
		MemberVO member_date = service.welcomeView(userid);
		
		model.addAttribute("member", member);
		model.addAttribute("member_date", member_date);
		
	}
	
	//사용자 정보 수정
	@RequestMapping(value="/memberInfoModify",method=RequestMethod.POST)
	public String postMemberInfoModify(MemberVO member,
			@RequestParam("fileUpload") MultipartFile multipartFile ) {
	
	String path = "c:\\Repository\\profile\\";
	File targetFile;
	
	if(!multipartFile.isEmpty()) {

		//기존 프로파일 이미지 삭제
		MemberVO vo = new MemberVO();
		vo = service.memberInfoView(member.getUserid());
		File file = new File(path + vo.getStored_filename());
		file.delete();
		
		String org_filename = multipartFile.getOriginalFilename();	
		String org_fileExtension = org_filename.substring(org_filename.lastIndexOf("."));	
		String stored_filename =  UUID.randomUUID().toString().replaceAll("-", "") + org_fileExtension;	
						
		try {
			targetFile = new File(path + stored_filename);
			
			multipartFile.transferTo(targetFile);
			
			member.setOrg_filename(org_filename);
			member.setStored_filename(stored_filename);
			member.setFilesize(multipartFile.getSize());
																		
		} catch (Exception e ) { e.printStackTrace(); }
			
	}	

	service.memberInfoUpdate(member);
	return "redirect:/member/memberInfo";
		
	}
	
	//사용자 패스워드 변경 보기
	@RequestMapping(value="/memberPasswordModify",method=RequestMethod.GET)
	public void getMemberPasswordModify() { }
	
	//사용자 패스워드 변경 
	@RequestMapping(value="/memberPasswordModify",method=RequestMethod.POST)
	public String postMemberPasswordModify(@RequestParam("old_userpassword") String old_password,
			@RequestParam("new_userpassword") String new_password, HttpSession session) { 
		
		String userid = (String)session.getAttribute("userid");
		
		MemberVO member = service.memberInfoView(userid);
		if(pwdEncoder.matches(old_password, member.getPassword())) {
			member.setPassword(pwdEncoder.encode(new_password));
			service.passwordUpdate(member);
		}	
		return "redirect:/member/logout";
	}
	
	//사용자 아이디 찾기 보기
	@RequestMapping(value="/searchID",method=RequestMethod.GET)
	public void getSearchID() { } 
	
	//사용자 아이디 찾기 
	@RequestMapping(value="/searchID",method=RequestMethod.POST)
	public String postSearchID(MemberVO member, RedirectAttributes rttr) { 
		
		String userid = service.searchID(member);
				
		//조건에 해당하는 사용자가 아닐 경우 
		if(userid == null ) { 
			rttr.addFlashAttribute("msg", "ID_NOT_FOUND");
			return "redirect:/member/searchID"; 
		}
		
		return "redirect:/member/IDView?userid=" + userid;		
	} 

	//찾은 아이디 보기
	@RequestMapping(value="/member/IDView",method=RequestMethod.GET)
	public void postSearchID(@RequestParam("userid") String userid, Model model) {
		
		model.addAttribute("userid", userid);
		
	}
	
	//사용자 패스워드 임시 발급 보기
	@RequestMapping(value="/member/searchPassword",method=RequestMethod.GET)
	public void getSearchPassword() { } 
	
	
	//사용자 패스워드 임시 발급
	@RequestMapping(value="/member/searchPassword",method=RequestMethod.POST)
	public String postSearchPassword(MemberVO member, RedirectAttributes rttr) { 
		
		if(service.searchPassword(member)==0) {
			
			rttr.addFlashAttribute("msg", "PASSWORD_NOT_FOUND");
			return "redirect:/member/searchPassword"; 
			
		}
		
		//숫자 + 영문대소문자 7자리 임시패스워드 생성
		StringBuffer tempPW = new StringBuffer();
		Random rnd = new Random();
		for (int i = 0; i < 7; i++) {
		    int rIndex = rnd.nextInt(3);
		    switch (rIndex) {
		    case 0:
		        // a-z : 아스키코드 97~122
		    	tempPW.append((char) ((int) (rnd.nextInt(26)) + 97));
		        break;
		    case 1:
		        // A-Z : 아스키코드 65~122
		    	tempPW.append((char) ((int) (rnd.nextInt(26)) + 65));
		        break;
		    case 2:
		        // 0-9
		    	tempPW.append((rnd.nextInt(10)));
		        break;
		    }
		}
		
		member.setPassword(pwdEncoder.encode(tempPW));
		service.passwordUpdate(member);
			
		return "redirect:/member/tempPWView?password=" + tempPW;
		
	} 
	
	//발급한 임시패스워드 보기
	@RequestMapping(value="/member/tempPWView",method=RequestMethod.GET)
	public void getTempPWView(Model model, @RequestParam("password") String password) {
		
		model.addAttribute("password", password);
		
	}
		
	//회원탈퇴
	@RequestMapping(value="/member/memberInfoDelete",method=RequestMethod.GET)
	public String getDeleteMember(HttpSession session) throws Exception {
		
		String userid = (String)session.getAttribute("userid"); 
		
		String path_profile = "c:\\Repository\\profile\\";
		String path_file = "c:\\Repository\\file\\";
		
		//회원 프로필 사진 삭제
		MemberVO member = new MemberVO();
		member = service.memberInfoView(userid);		
		File file = new File(path_profile + member.getStored_filename());
		file.delete();
		
		//회원이 업로드한 파일 삭제
		List<FileVO> fileList = boardService.fileInfoByUserid(userid);
		for(FileVO vo:fileList) {
			File f = new File(path_file + vo.getStored_filename());
			f.delete();
		}
		
		//게시물,댓글,파일업로드 정보, 회원정보 전체 삭제
		service.memberInfoDelete((String)session.getAttribute("userid"));
		
		session.invalidate();
		
		return "redirect:/";
	}
		
	//우편번호 검색
	@RequestMapping(value="/addrSearch",method=RequestMethod.GET)
	public void getSearchAddr(@RequestParam("addrSearch") String addrSearch,
			@RequestParam("page") int pageNum,Model model) throws Exception {
		
		int postNum = 5;
		int startPoint = (pageNum -1)*postNum + 1; //테이블에서 읽어 올 행의 위치
		int endPoint = pageNum*postNum;
		int listCount = 5;
		
		Page page = new Page();
		
		int totalCount = service.addrTotalCount(addrSearch);
		List<AddressVO> list = new ArrayList<>();
		list = service.addrSearch(startPoint, endPoint, addrSearch);

		model.addAttribute("list", list);
		model.addAttribute("pageListView", page.getPageAddress(pageNum, postNum, listCount, totalCount, addrSearch));
		
	}
	
}
