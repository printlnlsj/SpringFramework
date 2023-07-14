package com.SpaceBoard.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.SpaceBoard.dto.AddressVO;
import com.SpaceBoard.dto.FileVO;
import com.SpaceBoard.dto.UserVO;
import com.SpaceBoard.mapper.SpaceBoardMapper;
import com.SpaceBoard.service.BoardService;
import com.SpaceBoard.service.UserService;
import com.SpaceBoard.util.Page;

@Controller
public class UserController {
	
	@Autowired
	UserService service;
	
	@Autowired
	BoardService boardService;
	
	@Autowired //비밀번호 암호화 의존성 주입
	private BCryptPasswordEncoder pwdEncoder; 

	//로그인
	@GetMapping("/user/login")
	public void getLogin(Model model) {}
	
	@ResponseBody
	@PostMapping("/user/login")
	public String postLogIn(UserVO loginData, HttpSession session, @RequestParam("autologin") String autologin) {
		
		String authkey = "";
		
		// 로그인 시 자동 로그인 체크할 경우 신규 authkey 등록
		if(autologin.equals("NEW")) {
			authkey = UUID.randomUUID().toString().replaceAll("-", "");
			loginData.setAuthkey(authkey);
			service.authkeyUpdate(loginData);
			// update tbl_user set authkey = #{authkey} where userid = #{userid}
		}
		
		// authkey가 클라이언트에 쿠키로 존재할 경우 로그인 과정 없이 세션 생성 후 게시판 목폭 페이지로 이동
		if(autologin.equals("PASS")) {
			UserVO userinfo = service.userinfoByAuthkey(loginData.getAuthkey());
			// select * from tbl_user where authkey = #{authkey}
			
			if(userinfo != null) {
				// 세션 생성
				session.setMaxInactiveInterval(3600*7);
				session.setAttribute("userid", userinfo.getUserid());
				session.setAttribute("username", userinfo.getUsername());
				session.setAttribute("role", userinfo.getRole());
				
				return "{\"message\":\"good\"}";
			} else
				return "{\"message\":\"bad\"}";
				
		}
		
		//아이디 존재 여부 확인
		if(service.idCheck(loginData.getUserid()) == 0) {
			return "{\"message\":\"ID_NOT_FOUND\"}";
		}
		
		// 아이디가 존재하면 읽어온 userid로 로그인 정보 가져오기
		UserVO member = service.login(loginData.getUserid());
		
		//패스워드 확인
		if(!pwdEncoder.matches(loginData.getPassword(),member.getPassword())) {
			return "{\"message\":\"PASSWORD_NOT_FOUND\"}";
		}else {  // 패스워드가 존재하면...
			
			//세션 생성
			session.setMaxInactiveInterval(3600*7);
			session.setAttribute("userid", member.getUserid());
			session.setAttribute("username", member.getUsername());
			session.setAttribute("role", member.getRole());

			return "{\"message\":\"good\",\"authkey\":\"" + member.getAuthkey() + "\"}";
		}

	}
	
	//로그아웃
	@GetMapping("/user/logout")
	public String getLogout(HttpSession session) throws Exception {
		
		session.invalidate();
		return "redirect:/";
	}
	
	//회원 가입
	@GetMapping("/user/signup")
	public void getSignup() throws Exception { }
	
	//회원 가입
	@ResponseBody
	@PostMapping("/user/signup")
	public String postSignup(UserVO user, @RequestParam("fileUpload") MultipartFile mpr) throws Exception {
		
		String path = "c:\\Repository\\profile\\"; 
		String org_filename = "";
		long filesize = 0L;
		
		if(!mpr.isEmpty()) {
			File targetFile = null; 
				
			org_filename = mpr.getOriginalFilename();	
			String org_fileExtension = org_filename.substring(org_filename.lastIndexOf("."));	
			String stored_filename = UUID.randomUUID().toString().replaceAll("-", "") + org_fileExtension;	
			filesize = mpr.getSize() ;
			targetFile = new File(path + stored_filename);
			mpr.transferTo(targetFile);	//raw data를 targetFile에서 가진 정보대로 변환
			user.setOrg_filename(org_filename);
			user.setStored_filename(stored_filename);
			user.setFilesize(filesize);
		}
		
		user.setPassword(pwdEncoder.encode(user.getPassword()));
		service.signup(user);	
		return "{\"username\":\"" + URLEncoder.encode(user.getUsername(),"UTF-8") + "\",\"status\":\"good\"}";
		// {"username": "김철수", "status": "good"}
		
	}
	
	//아이디 중복 체크
	@ResponseBody
	@PostMapping("/user/idCheck")
	public int getIdCheck(@RequestBody String userid) {
		
		return service.idCheck(userid);
		
	}
	
	// 주소 검색
	@GetMapping("/user/addrSearch")
	public void getSearchAddr(@RequestParam("addrSearch") String addrSearch,
			@RequestParam("page") int pageNum,Model model) throws Exception {
		
		int postNum = 5;
		int startPoint = (pageNum -1)*postNum; //테이블에서 읽어 올 행의 위치
		int listCount = 10;
		
		Page page = new Page();
		
		int totalCount = service.addrTotalCount(addrSearch);
		List<AddressVO> list = new ArrayList<>();
		list = service.addrSearch(startPoint, postNum, addrSearch);

		model.addAttribute("list", list);
		model.addAttribute("pageListView", page.getPageAddress(pageNum, postNum, listCount, totalCount, addrSearch));
		
	}
	
	//사용자 정보 보기
	@GetMapping("/user/userInfo")
	public void getuserInfo(Model model, HttpSession session) throws Exception{
		String session_userid = (String)session.getAttribute("userid");
		UserVO member = service.userinfo(session_userid);
		
		model.addAttribute("member",member);
	}
	
	// 사용자 정보 수정 보기
	@GetMapping("/user/memberInfoModify")
	public void getUserInfoModify(Model model, HttpSession session) {
		String userid = (String)session.getAttribute("userid");
		UserVO member = service.memberInfoView(userid);
		
		model.addAttribute("member", member);
	}
	
	//사용자 정보 수정
	@PostMapping("/user/memberInfoModify")
	public String postMemberInfoModify(UserVO member, @RequestParam("fileUpload") MultipartFile multipartFile ) {
	
		String path = "c:\\Repository\\profile\\";
		File targetFile;
		
		if(!multipartFile.isEmpty()) {
	
			//기존 프로파일 이미지 삭제
			UserVO vo = new UserVO();
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
	return "redirect:/user/userInfo";
		
	}
	
	//사용자 패스워드 변경 보기
	@GetMapping("/user/memberPasswordModify")
	public void getMemberPasswordModify() { }
	
	//사용자 패스워드 변경 
	@PostMapping(value="/user/memberPasswordModify")
	public String postMemberPasswordModify(@RequestParam("old_userpassword") String old_password,
			@RequestParam("new_userpassword") String new_password, HttpSession session) { 
		
		String userid = (String)session.getAttribute("userid");
		
		UserVO member = service.memberInfoView(userid);
		if(pwdEncoder.matches(old_password, member.getPassword())) {
			member.setPassword(pwdEncoder.encode(new_password));
			service.passwordUpdate(member);
		}	
		return "redirect:/user/logout";
	}
	
	// 사용자 아이디 찾기 보기
	@GetMapping("/user/searchID")
	public void getSearchID() {}
	
	// 사용자 아이디 찾기
	@PostMapping("/user/searchID")
	public String postSearchID(UserVO member, RedirectAttributes rttr) {
		String userid = service.searchID(member);
		
		// 조건에 해당하는 사용자가 아닐 경우
		if(userid == null) {
			rttr.addFlashAttribute("msg", "ID_NOT_FOUND");
			return "redirect:/user/searchID";
		}
		return "redirect:/user/IDView?userid=" + userid;
	}
	
	// 찾은 아이디 보기
	@GetMapping("/user/IDView")
	public void postSearchID(@RequestParam("userid") String userid, Model model) {
		model.addAttribute("userid", userid);
	}
	
	// 사용자 패스워드 임시 발급 보기
	@GetMapping("/user/searchPassword")
	public void getSearchPassword() {}
	
	// 사용자 패스워드 임시 발급
	@PostMapping("/user/searchPassword")
	public String postSearchPassword(UserVO member, RedirectAttributes rttr) {
		
		if(service.searchPassword(member)==0) {
			rttr.addFlashAttribute("msg", "PASSWORD_NOT_FOUND");
			return "redirect:/user/searchPassword"; 
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
		return "redirect:/user/tempPWView?password=" + tempPW;
	}
	
	// 발급한 임시패스워드 보기
	@GetMapping("/user/tempPWView")
	public void getTempPWView(Model model, @RequestParam("password") String password) {
		model.addAttribute("password", password);
	}
	
	// 회원 탈퇴
	@GetMapping("/user/memberInfoDelete")
	public String getUserInfoDelete(HttpSession session) throws Exception {
		
		String userid = (String)session.getAttribute("userid");
		
		String path_profile = "c:\\Repository\\profile\\";
		String path_file = "c:\\Repository\\file\\";
		
		// 회원 프로필 사진 삭제
		List<FileVO> fileList = boardService.fileInfoByUserid(userid);
		for(FileVO vo:fileList) {
			File f = new File(path_file + vo.getStored_filename());
			f.delete();
		}
		
		// 게시물, 댓글, 파일업로드 정보, 회원정보 전체 삭제
		service.memberInfoDelete((String)session.getAttribute("userid"));
		
		session.invalidate();
		
		
		return "redirect:/";
	}
	
	// 패스워드 변경 안내 공지
	@GetMapping("/user/pwCheckNotice")
	public void getPwCheckNotice() {}
	
	// 패스워드 30일 이후에 변경 공지 나오도록 pwcheck 값 변경
	@GetMapping("/user/memberPasswordModifyAfter30")
	public String postMemberPasswordModifyAfter30(HttpSession session) {
		
		service.memberPasswordModifyAfter30((String)session.getAttribute("userid"));
		
		return "redirect:/user/userInfo";
	}
	
	
}
