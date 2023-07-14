package com.board.dao;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.board.dto.AddressVO;
import com.board.dto.MemberVO;

@Repository
public class MemberDAOImpl implements MemberDAO{

	@Autowired
	SqlSession sql;
	
	private static String namespace = "com.board.mappers.member";
	
	//아이디 확인
	@Override
	public int idCheck(String userid) {
		return sql.selectOne("com.board.mappers.member.idCheck", userid);
	}

	//로그인 정보 확인
	@Override
	public MemberVO login(String userid) {
		return sql.selectOne(namespace + ".login", userid);
	}

	//로그인 시 마지막 로그인 날짜 등록
	@Override
	public void logindateUpdate(String userid) {
		sql.update(namespace + ".logindateUpdate", userid);
	}	

	//welcome 페이지 정보 가져 오기
	@Override
	public MemberVO welcomeView(String userid) {
		return sql.selectOne(namespace + ".welcomeView", userid);
	}

	//로그 아웃 날짜 등록
	@Override
	public void logoutUpdate(String userid) {
		sql.insert(namespace + ".logoutUpdate",userid);
		
	}

	//패스워드 변경 후 30일 경과 확인
	@Override
	public MemberVO pwcheck(String userid) {
		return sql.selectOne(namespace + ".pwcheck",userid);		
	}
	
	//30일 이후에 패스워드 변경하도록 pwcheck 값 변경
	@Override
	public void memberPasswordModifyAfter30(String userid) {
		sql.update(namespace + ".memberPasswordModifyAfter30",userid);
	}

	//사용자 정보 등록
	@Override
	public void memberInfoRegistry(MemberVO member) {
		sql.insert(namespace + ".memberInfoRegistry", member);
	}

	//사용자 정보 보기
	@Override
	public MemberVO memberInfoView(String userid) {
		return sql.selectOne(namespace + ".memberInfoView", userid);
	}

	//사용자 정보 수정
	@Override
	public void memberInfoUpdate(MemberVO member) {
		sql.update(namespace + ".memberInfoUpdate", member);
	}

	//사용자 패스워드 변경
	@Override
	public void passwordUpdate(MemberVO member) {
		sql.update(namespace + ".passwordUpdate", member);
	}

	//사용자 아이디 찾기
	@Override
	public String searchID(MemberVO member) {
		return sql.selectOne(namespace + ".searchID", member);
	}

	//사용자 패스워드 신규 발급을 위한 확인
	@Override
	public int searchPassword(MemberVO member) {
		return sql.selectOne(namespace + ".searchPassword", member);
	}

	//회원 탈퇴
	@Override
	public void memberInfoDelete(String userid) {
		sql.delete(namespace + ".memberInfoDelete", userid);
		
	}

	
	//우편번호 최대 행수 계산
	@Override
	public int addrTotalCount(String addrSearch) {
		return sql.selectOne(namespace+".addrTotalCount",addrSearch);
	}

	//우편번호 검색 
	@Override
	public List<AddressVO> addrSearch(int startPoint, int endPoint, String addrSearch) {

		Map<String,Object> data = new HashMap<>();
		data.put("startPoint", startPoint);
		data.put("endPoint",endPoint);
		data.put("addrSearch", addrSearch);
		
		return sql.selectList(namespace + ".addrSearch", data);
	}

}
