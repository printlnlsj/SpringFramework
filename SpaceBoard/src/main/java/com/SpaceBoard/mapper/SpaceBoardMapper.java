package com.SpaceBoard.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.SpaceBoard.dto.BoardVO;
import com.SpaceBoard.dto.UserVO;

@Mapper
public interface SpaceBoardMapper {
	
	//게시물 목록 보기
	@Select("select userid,seqno,writer,title,to_char(regdate,'YYYY-MM-DD HH24:MI:SS') as regdate,hitno from tbl_board order by seqno desc")
	public List<BoardVO> list();

	//게시물 등록
	@Insert("insert into tbl_board (userid,writer,title,content,org_filename,stored_filename,filesize) values ('${board.userid}','${board.writer}','${board.title}','${board.content}','${board.org_filename}','${board.stored_filename}',${board.filesize})")
	public void write(@Param("board") BoardVO board);
	
	//게시물 상세 보기
	@Select("select seqno,writer,userid,title,to_char(regdate,'YYYY-MM-DD HH24:MI:SS') as regdate,content,org_filename,stored_filename,filesize from tbl_board where seqno = ${seqno}")
	public BoardVO view(@Param("seqno") int seqno);
	
	//조회수 업데이트
	@Update("update tbl_board set hitno = (select hitno from tbl_board where seqno=${board.seqno}) + 1 where seqno=${board.seqno}")
	public void hitno(@Param("board") BoardVO board);
	
	//게시물 수정
	@Update("update tbl_board set writer='${board.writer}',title='${board.title}',content='${board.content}' where seqno=${board.seqno}")
	public void modify(@Param("board") BoardVO board);
	
	//게시물 삭제
	@Delete("delete from tbl_board where seqno=${seqno}")
	public void delete(@Param("seqno") int seqno);
	
	//아이디 중복 체크. 카운터가 0이면 아이디 사용 가능, 1이면 기존 사용 중인 아이디
	@Select("select count(*) from tbl_user where userid = '${userid}'")
	public int idCheck(@Param("userid") String userid);
	
	//로그인 정보 가져 오기
	@Select("select password,username from tbl_user where userid = '${userid}'")
	public UserVO login(@Param("userid") String userid);
	
	//사용자 등록
	@Insert("insert into tbl_user (userid,username,password,gender,hobby,job,description) values ('${user.userid}','${user.username}','${user.password}','${user.gender}','${user.hobby}','${user.job}','${user.description}')")
	public void signup(@Param("user") UserVO user);

}
