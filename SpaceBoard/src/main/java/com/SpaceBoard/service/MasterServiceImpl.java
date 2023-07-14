package com.SpaceBoard.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.SpaceBoard.dao.MasterDAO;
import com.SpaceBoard.dto.FileVO;

@Service
public class MasterServiceImpl implements MasterService {

	@Autowired
	MasterDAO dao;  // 인터페이스를 가져옴.
	
	@Override
	public int filedeleteCount() {
		return dao.filedeleteCount();
	}

	@Override
	public List<FileVO> filedeleteList() {
		return dao.filedeleteList();
	}

	@Override
	public void deleteFile(int fileseqno) {
		dao.deleteFile(fileseqno);
	}

}
