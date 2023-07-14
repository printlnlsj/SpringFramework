package com.SpaceBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.SpaceBoard.dto.AddressVO;
import com.SpaceBoard.dto.UserVO;

@Repository  // DAO라는 걸 알려주는 아노테이션
public class UserDAOImpl implements UserDAO {
	
	@Autowired  // 의존성 주입을 통해 스프링빈을 가져와서 사용함. root-context.xml에 있는 SqlSessionFactoryBean을 가져와서 주입.
	private SqlSession sql;
	private static String namespace = "com.SpaceBoard.mappers.User";

	// 아이디 중복 체크
	@Override
	public int idCheck(String userid) {
		return sql.selectOne(namespace + ".idCheck", userid);
	}

	// 로그인 정보 가져오기
	@Override
	public UserVO login(String userid) {
		return sql.selectOne(namespace + ".login", userid);
	}

	// 사용자 등록
	@Override
	public void signup(UserVO user) {
		sql.insert(namespace + ".signup", user);
	}
	
	// 사용자 자동 로그인을 위한 authkey 등록
	@Override
	public void authkeyUpdate(UserVO user) {
		sql.update(namespace + ".authkeyUpdate", user);
	}
		
	// 사용자 자동 로그인을 위한 authkey로 사용자 정보 가져오기
	@Override
	public UserVO userinfoByAuthkey(String authkey) {
		return sql.selectOne(namespace + ".userinfoByAuthkey", authkey);
	}
	
	//우편번호 최대 행수 계산
	@Override
	public int addrTotalCount(String addrSearch) {
		return sql.selectOne(namespace+".addrTotalCount",addrSearch);
	}

	//우편번호 검색 
	@Override
	public List<AddressVO> addrSearch(int startPoint, int postNum, String addrSearch) {

		Map<String,Object> data = new HashMap<>();
		data.put("startPoint", startPoint);
		data.put("postNum",postNum);
		data.put("addrSearch", addrSearch);
		
		return sql.selectList(namespace + ".addrSearch", data);
	}
	
	@Override
	public UserVO userinfo(String userid) {
		return sql.selectOne(namespace+".userinfo",userid);
	}
	
	//사용자 정보 수정 보기
	@Override
	public UserVO memberInfoView(String userid) {
		return sql.selectOne(namespace + ".memberInfoView", userid);
	}

	//사용자 정보 수정
	@Override
	public void memberInfoUpdate(UserVO member) {
		sql.update(namespace + ".memberInfoUpdate", member);
	}
	
	// 사용자 아이디 찾기
	@Override
	public String searchID(UserVO member) {
		return sql.selectOne(namespace + ".searchID", member);
	}
	
	//사용자 패스워드 신규 발급을 위한 확인
	@Override
	public int searchPassword(UserVO member) {
		return sql.selectOne(namespace + ".searchPassword", member);
	}
	
	//사용자 패스워드 변경
	@Override
	public void passwordUpdate(UserVO member) {
		sql.update(namespace + ".passwordUpdate", member);
	}
	
	// 회원 탈퇴
	public void memberInfoDelete(String userid) {
		sql.delete(namespace + ".memberInfoDelete", userid);
	}
	
	// 패스워드 변경 후 30일 경과 확인
	public UserVO pwcheck(String userid) {
		return sql.selectOne(namespace + ".pwcheck", userid);
	};
	
	// 30일 이후에 패스워드 변경하도록 pwcheck 값 변경
	public void memberPasswordModifyAfter30(String userid) {
		sql.update(namespace + ".memberInfoRegistry", userid);
	};

}
