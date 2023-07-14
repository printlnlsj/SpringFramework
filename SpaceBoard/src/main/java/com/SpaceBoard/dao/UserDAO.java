package com.SpaceBoard.dao;

import java.util.List;

import com.SpaceBoard.dto.AddressVO;
import com.SpaceBoard.dto.UserVO;

public interface UserDAO {

	// 아이디 중복 체크. 카운터가 0이면 아이디 사용 가능, 1이면 기존 사용중인 아이디
	public int idCheck(String userid);  // public resultType id(parameterType);
	
	// 로그인 정보 가져 오기
	public UserVO login(String userid);
	
	// 사용자 등록
	public void signup(UserVO user);
	
	// 사용자 자동 로그인을 위한 authkey 등록
	public void authkeyUpdate(UserVO user);
	
	// 사용자 자동 로그인을 위한 authkey로 사용자 정보 가져오기
	public UserVO userinfoByAuthkey(String authkey);
	
	//주소 전체 갯수 계산
	public int addrTotalCount(String addrSearch);

	//주소 검색
	public List<AddressVO> addrSearch(int startPoint, int postNum, String addrSearch);
	
	//사용자 정보 보기
	public UserVO userinfo(String userid);
	
	//사용자 정보 수정 보기
	public UserVO memberInfoView(String userid);
	
	//사용자 정보 수정
	public void memberInfoUpdate(UserVO member);
	
	//사용자 아이디 찾기
	public String searchID(UserVO member);
	
	//사용자 패스워드 신규 발급을 위한 확인
	public int searchPassword(UserVO member);
	
	//패스워드 수정
	public void passwordUpdate(UserVO member);
	
	// 회원 탈퇴
	public void memberInfoDelete(String userid);
	
	// 패스워드 변경 후 30일 경과 확인
	public UserVO pwcheck(String userid);
	
	// 30일 이후에 패스워드 변경하도록 pwcheck 값 변경
	public void memberPasswordModifyAfter30(String userid);
}
