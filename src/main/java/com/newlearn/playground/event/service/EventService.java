package com.newlearn.playground.event.service;

import java.util.List;
import java.util.Map;

import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.event.vo.Event;

public interface EventService {

	Event findByNo(int eventNo);

	int insertEvent(Event event);

	List<Event> findAllByDate(Map<String, Object> paramMap);

	Integer joinMemberCnt(int eventNo);

	int updateEvent(Event event);

	int deleteEvent(int eventNo);

	List<Event> upcomingEvents(int classNo);

	Map<String, Integer> getEventCnt(Map<String, Object> paramMap);

	List<Event> findAllPersonalByClass(Map<String, Object> paramMap);

	int joinMember(Event event, int userNo);

	List<Integer> getSubscription(int userNo);

	List<Event> findPublicPersonal(Map<String, Object> paramMap);

	List<Event> findPrivatePersonal(Map<String, Object> paramMap);

	int exitEvent(Event event, int userNo);

}
