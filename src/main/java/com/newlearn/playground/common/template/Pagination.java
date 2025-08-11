package com.newlearn.playground.common.template;

import com.newlearn.playground.common.model.vo.PageInfo;

public class Pagination {
	
	public static PageInfo getPageInfo(int listCount, int currentPage, int pageLimit, int boardLimit) {
		PageInfo pi = new PageInfo();
		pi.setListCount(listCount);
		pi.setCurrentPage(currentPage);
		pi.setPageLimit(pageLimit);
		pi.setBoardLimit(boardLimit);
		
		// 1. 최대 페이지 개수
		int maxPage = (int)Math.ceil((double)listCount / (double)boardLimit);
		
		// 2. 시작 페이지
		int startPage = (currentPage - 1) / pageLimit * pageLimit + 1;
		
		// 3. 종료 페이지
		int endPage = startPage + pageLimit - 1;
		
		if (endPage > maxPage) {
			endPage = maxPage;
		}
		
		pi.setStartPage(startPage);
		pi.setEndPage(endPage);
		pi.setMaxPage(maxPage);
		
		return pi;
	}

}
