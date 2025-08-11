package com.newlearn.playground.beerstore.model.dao;

import com.newlearn.playground.beerstore.model.vo.BeerStore;

public interface BeerStoreDao {

	BeerStore checkToday();

	int insertBeer(String imgUrl);

}
