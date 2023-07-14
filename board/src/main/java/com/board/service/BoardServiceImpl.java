package com.board.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.board.dao.BoardDAO;
import com.board.dto.BoardVO;
import com.board.dto.FileVO;
import com.board.dto.LikeVO;
import com.board.dto.ReplyVO;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	BoardDAO dao; 
	
	//게시물 목록 보기
	@Override
	public List<BoardVO> list(int startPoint, int endPoint, String searchType,String keyword) throws Exception {
		
		return dao.list(startPoint,endPoint,searchType,keyword);
	}
	
	//게시물 전체 목록 보기
	@Override
	public List<BoardVO> listAll(){
		return dao.listAll();
	}
	
	//전체 게시물 갯수 계산
	@Override
	public int totalCount(String searchType,String keyword) throws Exception{
		return dao.totalCount(searchType, keyword);
	}

	//게시물 내용 보기
	@Override
	public BoardVO view(int seqno) throws Exception {
		
		return dao.view(seqno);
	}

	//게시물 등록 
	@Override
	public void write(BoardVO board) throws Exception {
		dao.write(board);		
	}
	
	//게시물 번호 구하기 - 시퀀스의 nexval 사용
	@Override
	public int getSeqnoWithNextval() throws Exception {
		return dao.getSeqnoWithNextval();
	}

	//게시물 이전 보기
	@Override
	public int pre_seqno(int seqno,String searchType, String keyword) throws Exception {
		return dao.pre_seqno(seqno, searchType, keyword);
	}
	
	//게시물 다음 보기
	@Override
	public int next_seqno(int seqno,String searchType, String keyword) throws Exception {
		return dao.next_seqno(seqno, searchType, keyword);
	}
	
	//파일 업로드 정보 등록
	@Override
	public void fileInfoRegistry(Map<String,Object> fileInfo) throws Exception {
		dao.fileInfoRegistry(fileInfo);
	}
	
	//게시글 내에서 업로드된 파일 목록 보기
	@Override
	public List<FileVO> fileListView(int seqno) throws Exception {
		return dao.fileListView(seqno);
	}

	//다운로드를 위한 파일 정보 보기
	@Override
	public FileVO fileInfo(int fileseqno) throws Exception{
		return dao.fileInfo(fileseqno);
	}
	
	//게시물 수정
	@Override
	public void modify(BoardVO board) throws Exception {
		dao.modify(board);		
	}

	//게시물 삭제
	@Override
	public void delete(int seqno) throws Exception {
		dao.delete(seqno);		
	}

	//게시물 수정에서 파일 삭제
	@Override
	public void deleteFileList(int fileseqno) throws Exception{
		dao.deleteFileList(fileseqno);
	}

	//게시물 삭제에서 파일 삭제를 위한 파일 목록 가져 오기
	@Override
	public List<FileVO> deleteFileOnBoard(int seqno) throws Exception{
		return dao.deleteFileOnBoard(seqno);
	}

	//회원 탈퇴 시 회원이 업로드한 파일 정보 가져 오기
	@Override
	public List<FileVO> fileInfoByUserid(String userid) throws Exception{
		return dao.fileInfoByUserid(userid);
	}
	
	//좋아요/싫어요 확인 가져 오기
	@Override
	public LikeVO likeCheckView(int seqno,String userid) throws Exception {
		return dao.likeCheckView(seqno, userid);
	}
	
	//좋아요/싫어요 갯수 수정하기
	@Override
	public void boardLikeUpdate(int seqno, int likecnt, int dislikecnt) throws Exception {
		dao.boardLikeUpdate(seqno, likecnt, dislikecnt);
	}
	
	//좋아요/싫어요 확인 등록하기
	@Override
	public void likeCheckRegistry(Map<String,Object> map) throws Exception {
		dao.likeCheckRegistry(map);
	}
	
	//좋아요/싫어요 확인 수정하기
	@Override
	public void likeCheckUpdate(Map<String,Object> map) throws Exception {
		dao.likeCheckUpdate(map);
	}
	
	//댓글 보기
	@Override
	public List<ReplyVO> replyView(ReplyVO reply) throws Exception{
		return dao.replyView(reply);
	}
	
	//댓글 수정
	@Override
	public void replyUpdate(ReplyVO reply) throws Exception{
		dao.replyUpdate(reply);
	}
	
	//댓글 등록
	@Override
	public void replyRegistry(ReplyVO reply) throws Exception{
		dao.replyRegistry(reply);
	}
	
	//댓글 삭제
	@Override
	public void replyDelete(ReplyVO reply) throws Exception{
		dao.replyDelete(reply);
	}
	
	//게시물 조회수 증가
	@Override
	public void hitnoUpgrade(int seqno) throws Exception{
		dao.hitnoUpgrade(seqno);				
	}
	
}
