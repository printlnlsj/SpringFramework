package com.board.util;

import java.security.Key;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.springframework.util.StringUtils;

import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

public class JWTManager {
	
	private String secretKey = "xaviergold123456789xaviergold123456789xaviergold123456789xaviergold123456789xaviergold123456789";
	private static final long ACCESS_TOKEN_EXPIRE_TIME = 1000*60*60*24; //토큰 만료 시간 설정
	private Key key;
	
	public JWTManager() {
		byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        this.key = Keys.hmacShaKeyFor(keyBytes);
	}

	//토큰 생성	
	public String generateToken(String userid) throws Exception{
		
		long now = (new Date()).getTime();
		Date tokenExpiresIn = new Date(now + ACCESS_TOKEN_EXPIRE_TIME);
		
		String token = Jwts.builder()
				.setSubject(userid)
				.setExpiration(tokenExpiresIn)
				.signWith(key)
				.compact();	
		return token;
	}

	//토큰 인증
	public boolean validateToken(HttpServletRequest request) {
		
		String bearerToken = request.getHeader("Authorization");
		String token = "";
		
		if(StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer "))
			token = bearerToken.substring(7); 
		
		try {
			Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
			return true;
		} catch (SecurityException | MalformedJwtException e) {
            System.out.println("잘못된 JWT 서명입니다.");
        } catch (ExpiredJwtException e) {
        	System.out.println("만료된 JWT 토큰입니다.");
        } catch (UnsupportedJwtException e) {
        	System.out.println("지원되지 않는 JWT 토큰입니다.");
        } catch (IllegalArgumentException e) {
        	System.out.println("JWT 토큰이 잘못되었습니다.");
        }
		return false;
	}
}
