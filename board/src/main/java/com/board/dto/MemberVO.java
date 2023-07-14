package com.board.dto;

import java.time.LocalDateTime;
import java.util.Date;

public class MemberVO {

	private String userid;
	private String username;
	private String password;
	private String telno;
	private String email;
	private String zipcode;
	private String address;
	private Date regdate;
	private Date lastlogindate;
	private Date lastlogoutdate;
	private Date lastpwdate;
	private int pwcheck;
	private String role;
	private String org_filename;
	private String stored_filename;
	private long filesize;
	private int pwdiff;
	
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getTelno() {
		return telno;
	}
	public void setTelno(String telno) {
		this.telno = telno;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getZipcode() {
		return zipcode;
	}
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public Date getRegdate() {
		return regdate;
	}
	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}
	public Date getLastlogindate() {
		return lastlogindate;
	}
	public void setLastlogindate(Date lastlogindate) {
		this.lastlogindate = lastlogindate;
	}
	public Date getLastlogoutdate() {
		return lastlogoutdate;
	}
	public void setLastlogoutdate(Date lastlogoutdate) {
		this.lastlogoutdate = lastlogoutdate;
	}
	public Date getLastpwdate() {
		return lastpwdate;
	}
	public void setLastpwdate(Date lastpwdate) {
		this.lastpwdate = lastpwdate;
	}
	public int getPwcheck() {
		return pwcheck;
	}
	public void setPwcheck(int pwcheck) {
		this.pwcheck = pwcheck;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public String getOrg_filename() {
		return org_filename;
	}
	public void setOrg_filename(String org_filename) {
		this.org_filename = org_filename;
	}
	public String getStored_filename() {
		return stored_filename;
	}
	public void setStored_filename(String stored_filename) {
		this.stored_filename = stored_filename;
	}
	public long getFilesize() {
		return filesize;
	}
	public void setFilesize(long filesize) {
		this.filesize = filesize;
	}
	public int getPwdiff() {
		return pwdiff;
	}
	public void setPwdiff(int pwdiff) {
		this.pwdiff = pwdiff;
	}
	
}	