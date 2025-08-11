package com.newlearn.playground.beerstore.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class BeerStore {
	private int menuNo;
	private String menuUrl;
	private Date lastDate;
}
