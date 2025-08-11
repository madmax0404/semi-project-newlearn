package com.newlearn.playground.security.model.service;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.newlearn.playground.security.model.dao.SecurityDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SecurityServiceImpl implements SecurityService {
	private final SecurityDao dao;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		UserDetails member = dao.loadUserByUsername(username);

		if (member == null) {
			throw new UsernameNotFoundException("사용자를 찾을 수 없습니다 : " + username);
		}

		return member;
	}

}
