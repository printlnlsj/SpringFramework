package com.SpaceBoard.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.SpaceBoard.dao.UserDAO;
import com.SpaceBoard.dto.AddressVO;
import com.SpaceBoard.dto.UserVO;

@Service  // Service라는 걸 스프링빈에게 알려주는 아노테이션
public class UserServiceImpl implements UserService {
	
	@Autowired
	UserDAO dao;  // 인터페이스를 가져옴.

	// 아이디 중복 체크
	@Override
	public int idCheck(String userid) {
		return dao.idCheck(userid);
	}

	// 로그인 정보 가져오기
	@Override
	public UserVO login(String userid) {
		return dao.login(userid);
	}

	// 사용자 등록
	@Override
	public void signup(UserVO user) {
		dao.signup(user);
	}
	
	// 사용자 자동 로그인을 위한 authkey 등록
	@Override
	public void authkeyUpdate(UserVO user) {
		dao.authkeyUpdate(user);
	}
		
	// 사용자 자동 로그인을 위한 authkey로 사용자 정보 가져오기
	@Override
	public UserVO userinfoByAuthkey(String authkey) {
		return dao.userinfoByAuthkey(authkey);
	}
	
	//우편번호 전체 갯수 가져 오기
	@Override
	public int addrTotalCount(String addrSearch) {
		return dao.addrTotalCount(addrSearch);
	}

	//우편번호 검색
	@Override
	public List<AddressVO> addrSearch(int startPoint, int postNum, String addrSearch) {
		return dao.addrSearch(startPoint, postNum, addrSearch);
	}
	
	@Override
	public UserVO userinfo(String userid) {
		return dao.userinfo(userid);
	}
	
	//사용자 정보 수정 보기
	@Override
	public UserVO memberInfoView(String userid) {
		return dao.memberInfoView(userid);
	}
	
	//사용자 정보 수정
	@Override
	public void memberInfoUpdate(UserVO member) {
		dao.memberInfoUpdate(member);		
	}
	
	//사용자 아이디 찾기
	@Override
	public String searchID(UserVO member) {
		return dao.searchID(member);
	}
	
	//사용자 패스워드 신규 발급을 위한 확인
	@Override
	public int searchPassword(UserVO member) {
		return dao.searchPassword(member);
	}
	
	//사용자 패스워드 변경
	@Override
	public void passwordUpdate(UserVO member) {
		dao.passwordUpdate(member);		
	}
	
	//회원 탈퇴
	@Override
	public void memberInfoDelete(String userid) {
		dao.memberInfoDelete(userid);		
	}
	
	// 패스워드 변경 후 30일 경과 확인
	public UserVO pwcheck(String userid) {
		return dao.pwcheck(userid);
	};
	
	// 30일 이후에 패스워드 변경하도록 pwcheck 값 변경
	public void memberPasswordModifyAfter30(String userid) {
		dao.memberPasswordModifyAfter30(userid);
	};

}
