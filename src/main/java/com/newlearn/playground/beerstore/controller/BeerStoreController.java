package com.newlearn.playground.beerstore.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class BeerStoreController {
	
	@GetMapping("/beerStore")
	public String beerStore(
			) {
		return "beer/beerStore";
	}
}
