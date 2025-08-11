package com.newlearn.playground.beerstore.model.service;

import com.newlearn.playground.beerstore.model.vo.BeerStore;

public interface BeerStoreService {

	BeerStore checkToday();

	int insertBeer(String imgUrl);

}
