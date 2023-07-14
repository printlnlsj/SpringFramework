package com.SpaceBoard.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.SpaceBoard.dto.FileVO;

@Repository  // DAO라는 걸 알려주는 아노테이션
public class MasterDAOImpl implements MasterDAO {

	@Autowired  // 의존성 주입을 통해 스프링빈을 가져와서 사용함. root-context.xml에 있는 SqlSessionFactoryBean을 가져와서 주입.
	private SqlSession sql;
	private static String namespace = "com.SpaceBoard.mappers.Master";
	
	@Override
	public int filedeleteCount() {
		return sql.selectOne(namespace + ".filedeleteCount");
	}

	@Override
	public List<FileVO> filedeleteList() {
		return sql.selectList(namespace + ".filedeleteList");
	}

	@Override
	public void deleteFile(int fileseqno) {
		sql.delete(namespace + ".deleteFile", fileseqno);
	}

}
