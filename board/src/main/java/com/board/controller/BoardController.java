package com.board.controller;

import java.io.File;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.board.dto.BoardVO;
import com.board.dto.FileVO;
import com.board.dto.LikeVO;
import com.board.dto.ReplyVO;
import com.board.service.BoardService;
import com.board.util.Page;

@Controller
public class BoardController {

	@Autowired
	BoardService service; //의존성 주입
	
	Logger log = LoggerFactory.getLogger(BoardController.class);
	
	//게시물 목록 보기
	@GetMapping("/board/list")
	public void GetList(Model model, @RequestParam(name="page") int pageNum, 
			@RequestParam(name="searchType", defaultValue="mtitle", required=false) String searchType, 
			@RequestParam(name="keyword", defaultValue="", required=false) String keyword ) throws Exception{
		
		int listCount = 5;
		int postNum = 5; //한 페이지에 보여질 게시물 목록 갯수
		int startPoint = (pageNum -1)*postNum + 1; 
		int endPoint = postNum*pageNum;
	
		Page page = new Page();
		int totalCount = service.totalCount(searchType, keyword);
				
		model.addAttribute("list", service.list(startPoint, endPoint, searchType, keyword));
		model.addAttribute("page", pageNum);
		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);
		model.addAttribute("pageListView", page.getPageList(pageNum, postNum, listCount, totalCount, searchType, keyword));
		
		
	}

	//게시물 내용 보기
	@GetMapping("/board/view")
	public void GetView(Model model,HttpSession session, @RequestParam("seqno") int seqno,@RequestParam(name="page") int pageNum,
			@RequestParam(name="searchType", defaultValue="mtitle", required=false) String searchType, 
			@RequestParam(name="keyword", defaultValue="", required=false) String keyword) throws Exception{
		
		BoardVO board = service.view(seqno);
		
		//조회수 증가
		String userid = (String)session.getAttribute("userid");
		if(!userid.equals(board.getUserid())) 
			service.hitnoUpgrade(seqno);
		
		LikeVO likeCheckView = service.likeCheckView(seqno, userid);
		
		//초기에 좋아요/싫어요 등록이 안되어져 있을 경우 "N"으로 초기화 
		
		if(likeCheckView == null) {
			model.addAttribute("myLikeCheck", "N");
			model.addAttribute("myDislikeCheck", "N");
		} else if(likeCheckView != null) {
			model.addAttribute("myLikeCheck", likeCheckView.getMylikecheck());
			model.addAttribute("myDislikeCheck", likeCheckView.getMydislikecheck());
		}
		model.addAttribute("view", board);
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);
		model.addAttribute("pre_seqno", service.pre_seqno(seqno, searchType, keyword));
		model.addAttribute("next_seqno",service.next_seqno(seqno, searchType, keyword));
		model.addAttribute("fileListView", service.fileListView(seqno));
		model.addAttribute("likeCheckView", likeCheckView);
	}
	
	//게시물 등록 화면 보기
	@GetMapping("/board/write")
	public void GetWrite() { }
	
	//첨부 파일 없는 게시물 등록
	@ResponseBody
	@PostMapping("/board/write")
	public void PostWrite(BoardVO board) throws Exception{

		int seqno = service.getSeqnoWithNextval();
		board.setSeqno(seqno);
		service.write(board);		

	}
	
	//파일 업로드
	@ResponseBody
	@PostMapping("/board/fileUpload")
	public void postFileUpload(BoardVO board,@RequestParam("SendToFileList") List<MultipartFile> multipartFile, 
			@RequestParam("kind") String kind,@RequestParam(name="deleteFileList", required=false) int[] deleteFileList) throws Exception{

		String path = "c:\\Repository\\file\\"; 
		int seqno =0;
		if(kind.equals("I")) { 
			seqno = service.getSeqnoWithNextval();
			board.setSeqno(seqno);
			service.write(board);
		}
		
		if(kind.equals("U")) {
			seqno = board.getSeqno();
			service.modify(board);
			
			if(deleteFileList != null) {
				
				for(int i=0; i<deleteFileList.length; i++) {

					//파일 삭제
					FileVO fileInfo = new FileVO();
					fileInfo = service.fileInfo(deleteFileList[i]);
					File file = new File(path + fileInfo.getStored_filename());
					file.delete();
					
					//파일 테이블에서 파일 정보 삭제
					service.deleteFileList(deleteFileList[i]);
					
				}
			}	
		}
		
		if(!multipartFile.isEmpty()) {
			File targetFile = null; 
			Map<String,Object> fileInfo = null;		
			
			for(MultipartFile mpr:multipartFile) {
				
				String org_filename = mpr.getOriginalFilename();	
				String org_fileExtension = org_filename.substring(org_filename.lastIndexOf("."));	
				String stored_filename = UUID.randomUUID().toString().replaceAll("-", "") + org_fileExtension;	
				long filesize = mpr.getSize() ;
				
				log.info("org_filename={}", org_filename);
				log.info("stored_filename={}", stored_filename);
				
				targetFile = new File(path + stored_filename);
				mpr.transferTo(targetFile);
				
				fileInfo = new HashMap<>();
				fileInfo.put("org_filename",org_filename);
				fileInfo.put("stored_filename", stored_filename);
				fileInfo.put("filesize", filesize);
				fileInfo.put("seqno", seqno);
				fileInfo.put("userid", board.getUserid());
				service.fileInfoRegistry(fileInfo);
	
			}
		}	

}

	//파일 다운로드
	@GetMapping("/board/fileDownload")
	public void fileDownload(@RequestParam(name="fileseqno" , required=false) int fileseqno, HttpServletResponse rs) throws Exception {
		
		String path = "c:\\Repository\\file\\";
		
		FileVO fileInfo = service.fileInfo(fileseqno);
		String org_filename = fileInfo.getOrg_filename();
		String stored_filename = fileInfo.getStored_filename();
		
		byte fileByte[] = FileUtils.readFileToByteArray(new File(path+stored_filename));
		
		//헤드값을 Content-Disposition로 주게 되면 Response Body로 오는 값을 filename으로 다운받으라는 것임
		//예) Content-Disposition: attachment; filename="hello.jpg"
		rs.setContentType("application/octet-stream");
		rs.setContentLength(fileByte.length);
		rs.setHeader("Content-Disposition",  "attachment; filename=\""+URLEncoder.encode(org_filename, "UTF-8")+"\";");
		rs.getOutputStream().write(fileByte);
		rs.getOutputStream().flush();
		rs.getOutputStream().close();
		
	}
	
	//게시물 수정 화면 보기
	@GetMapping("/board/modify")
	public void GetModify(BoardVO board, Model model, 
			@RequestParam(name="deleteFileList", required=false) int[] deleteFileList,
			@RequestParam("page") int pageNum, @RequestParam("seqno") int seqno,
			@RequestParam(name="searchType", required=false) String searchType,
			@RequestParam(name="keyword", required=false) String keyword) 
			throws Exception {
		
		model.addAttribute("view", service.view(seqno));
		model.addAttribute("page",pageNum);
		model.addAttribute("searchType",searchType);
		model.addAttribute("keyword",keyword);
		model.addAttribute("fileListView", service.fileListView(seqno));
	}
	
	//게시물 수정
	@ResponseBody
	@PostMapping("/board/modify")
	public void PostModify(BoardVO board, @RequestParam(name="deleteFileList", required=false) int[] deleteFileList,
			@RequestParam("page") int pageNum, @RequestParam("seqno") int seqno,
			@RequestParam(name="searchType", required=false) String searchType,
			@RequestParam(name="keyword", required=false) String keyword) throws Exception{
		
		String path = "c:\\Repository\\file\\";
		
		//게시물 업데이트
		service.modify(board);
		
		if(deleteFileList != null) {
			
			for(int i=0; i<deleteFileList.length; i++) {

				//파일 삭제
				FileVO fileInfo = new FileVO();
				fileInfo = service.fileInfo(deleteFileList[i]);
				File file = new File(path + fileInfo.getStored_filename());
				file.delete();
				
				//파일 테이블에서 파일 정보 삭제
				service.deleteFileList(deleteFileList[i]);
				
			}
		}

	}
	
	//게시물 삭제
	@Transactional
	@GetMapping("/board/delete")
	public String GetDelete(@RequestParam("seqno") int seqno) throws Exception{

		//게시물에 업로드된 파일 삭제
		String path = "\\Repository\\file\\";
		List<FileVO> fileList = new ArrayList<>(); 
		fileList = service.deleteFileOnBoard(seqno);

		if(!fileList.isEmpty())
			for(FileVO vo:fileList) {
				File file = new File(path + vo.getStored_filename()); 
				file.delete();
			}
		
		//게시물 내용 삭제
		//cascade on delete 옵션으로 tbl_reply, tbl_file, tbl_like 전체 삭제
		service.delete(seqno);
		
		return "redirect:/board/list?page=1";
	}

	//좋아요/싫어요 관리
	@ResponseBody
	@PostMapping(value = "/board/likeCheck")
	public Map<String, Object> postLikeCheck(@RequestBody Map<String, Object> likeCheckData) throws Exception {
		
		int seqno = (int)likeCheckData.get("seqno");
		String userid = (String)likeCheckData.get("userid");
		int checkCnt = (int)likeCheckData.get("checkCnt");

		//현재 날짜, 시간 구해서 좋아요/싫어요 한 날짜/시간 입력 및 수정
		String likeDate = "";
		String dislikeDate = "";
		if(likeCheckData.get("mylikecheck").equals("Y")) 
			likeDate = LocalDateTime.now().toString();
		else if(likeCheckData.get("mydislikecheck").equals("Y")) 
			dislikeDate = LocalDateTime.now().toString();

		likeCheckData.put("likedate", likeDate);
		likeCheckData.put("dislikedate", dislikeDate);

		//TBL_LIKE 테이블 입력/수정
		LikeVO likeCheckView = service.likeCheckView(seqno,userid);
		if(likeCheckView == null) service.likeCheckRegistry(likeCheckData);
			else service.likeCheckUpdate(likeCheckData);

		//TBL_BOARD 내의 likecnt,dislikecnt 입력/수정 
		BoardVO board = service.view(seqno);
		
		int likeCnt = board.getLikecnt();
		int dislikeCnt = board.getDislikecnt();
			
		switch(checkCnt){
	    	case 1 : likeCnt --; break;
	    	case 2 : likeCnt ++; dislikeCnt --; break;
	    	case 3 : likeCnt ++; break;
	    	case 4 : dislikeCnt --; break;
	    	case 5 : likeCnt --; dislikeCnt ++; break;
	    	case 6 : dislikeCnt ++; break;
		}
		
		service.boardLikeUpdate(seqno,likeCnt,dislikeCnt);
		
		//AJAX에 전달할 map JSON 데이터 만들기
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("seqno", seqno);
		map.put("likeCnt", likeCnt);
		map.put("dislikeCnt", dislikeCnt);
		
		return map;
	}
	
	//댓글 처리
	@ResponseBody
	@PostMapping("/board/reply")
	public List<ReplyVO> postReply(ReplyVO reply,@RequestParam("option") String option)throws Exception{
		
		switch(option) {
		
		case "I" : service.replyRegistry(reply); //댓글 등록
				   break;
		case "U" : service.replyUpdate(reply); //댓글 수정
				   break;
		case "D" : service.replyDelete(reply); //댓글 삭제
				   break;
		}

		return service.replyView(reply);
	}
}
