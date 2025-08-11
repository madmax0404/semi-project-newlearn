package com.newlearn.playground.beerstore.model.service;

import org.springframework.stereotype.Service;

import com.newlearn.playground.beerstore.model.dao.BeerStoreDao;
import com.newlearn.playground.beerstore.model.vo.BeerStore;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BeerStoreServiceImpl implements BeerStoreService {
	private final BeerStoreDao dao;
	
	@Override
	public BeerStore checkToday() {
		return dao.checkToday();
	}

	@Override
	public int insertBeer(String imgUrl) {
		return dao.insertBeer(imgUrl);
	}

}
