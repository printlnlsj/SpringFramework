package com.board.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.board.dao.MemberDAO;
import com.board.dto.AddressVO;
import com.board.dto.MemberVO;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	MemberDAO dao; 
	
	//아이디 확인
	@Override
	public int idCheck(String userid) {
		return dao.idCheck(userid);
	}

	//로그인 정보 확인
	@Override
	public MemberVO login(String userid) {
		return dao.login(userid);
	}

	//마지막 로그인 날짜 등록/수정
	@Override
	public void logindateUpdate(String userid) {
		dao.logindateUpdate(userid);
	}

	//welcome 페이지 정보 가져 오기 
	public MemberVO welcomeView(String userid) {
		return dao.welcomeView(userid);
	}

	//로그 아웃 날짜 등록
	@Override
	public void logoutUpdate(String userid) {
		dao.logoutUpdate(userid);
	}

	//패스워드 변경 후 30일 경과 확인
	@Override
	public MemberVO pwcheck(String userid) {
		return dao.pwcheck(userid);
	}
	
	//30일 이후에 패스워드 변경하도록 pwcheck 값 변경
	@Override
	public void memberPasswordModifyAfter30(String userid) {
		dao.memberPasswordModifyAfter30(userid);
	}
	
	//사용자 등록
	@Override
	public void memberInfoRegistry(MemberVO member) {
		dao.memberInfoRegistry(member);
	}

	//사용자 정보 보기
	@Override
	public MemberVO memberInfoView(String userid) {
		return dao.memberInfoView(userid);
	}
	
	//사용자 정보 수정
	@Override
	public void memberInfoUpdate(MemberVO member) {
		dao.memberInfoUpdate(member);		
	}

	//사용자 패스워드 변경
	@Override
	public void passwordUpdate(MemberVO member) {
		dao.passwordUpdate(member);		
	}

	//사용자 아이디 찾기
	@Override
	public String searchID(MemberVO member) {
		return dao.searchID(member);
	}

	//사용자 패스워드 신규 발급을 위한 확인
	@Override
	public int searchPassword(MemberVO member) {
		return dao.searchPassword(member);
	}

	//회원 탈퇴
	@Override
	public void memberInfoDelete(String userid) {
		dao.memberInfoDelete(userid);		
	}

	//우편번호 전체 갯수 가져 오기
	@Override
	public int addrTotalCount(String addrSearch) {
		return dao.addrTotalCount(addrSearch);
	}

	//우편번호 검색
	@Override
	public List<AddressVO> addrSearch(int startPoint, int endPoint, String addrSearch) {
		return dao.addrSearch(startPoint, endPoint, addrSearch);
	}

}
