package com.board.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.board.dto.MemberVO;
import com.board.service.MemberService;
import com.board.util.JWTManager;

@RestController
@CrossOrigin(origins="*")
public class MemberRestController {
	
	@Autowired
	MemberService service;

	@Autowired //비밀번호 암호화 이존성 주입
	private BCryptPasswordEncoder pwdEncoder;

	//로그인 
	@GetMapping("/RESTAPI/login")
	public void getLogin() {}
		
	//로그인 처리
	@PostMapping("/RESTAPI/login")
	public Map<String,Object> postLogIn(@RequestBody MemberVO loginData, HttpServletResponse response) throws Exception{
		
		Map<String,Object> map;
		
		//아이디 존재 여부 확인
		if(service.idCheck(loginData.getUserid()) == 0) {
			map = new HashMap<>();
			map.put("success", false);
			return map;
		}
		
		MemberVO member = service.login(loginData.getUserid());
		
		//패스워드 확인
		if(!pwdEncoder.matches(loginData.getPassword(),member.getPassword())) {
			map = new HashMap<>();
			map.put("success", false);
			return map;
		}else {

			JWTManager jwtManager = new JWTManager();
			String accessToken = jwtManager.generateToken(loginData.getUserid());
			
			map = new HashMap<>();
			map.put("success", true);
			map.put("userid", member.getUserid());
			map.put("username", member.getUsername());
			map.put("Authorization", accessToken);
			
			return map;
		}
	}
	
	//토큰 인증
	@PostMapping("/RESTAPI/validateToken")
	public boolean postRefreshToken(HttpServletRequest request) throws Exception {
		
		JWTManager jwtManager = new JWTManager();
		return jwtManager.validateToken(request);

	}
	
}
