package com.newlearn.playground.beerstore.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.beerstore.model.vo.BeerStore;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class BeerStoreDaoImpl implements BeerStoreDao {
	private final SqlSessionTemplate session;

	@Override
	public BeerStore checkToday() {
		return session.selectOne("beer.checkToday");
	}

	@Override
	public int insertBeer(String imgUrl) {
		return session.insert("beer.insertBeer", imgUrl);
	}

}
