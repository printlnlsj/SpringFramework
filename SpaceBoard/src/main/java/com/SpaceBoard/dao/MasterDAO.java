package com.SpaceBoard.dao;

import java.util.List;

import com.SpaceBoard.dto.FileVO;

public interface MasterDAO {
	
	// 삭제할 파일 갯수 가져오기
	public int filedeleteCount();
	
	// 삭제할 파일 목록 정보
	public List<FileVO> filedeleteList();
	
	// 파일 정보 삭제
	public void deleteFile(int fileseqno);
}
