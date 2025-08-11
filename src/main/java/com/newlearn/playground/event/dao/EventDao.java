package com.newlearn.playground.event.dao;

import java.util.List;
import java.util.Map;

import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.event.vo.Event;

public interface EventDao {

	List<Event> findAllByDate(Map<String, Object> paramMap);

	Event findByNo(int eventNo);

	List<Event> upcomingEvents(int classNo);

	Integer joinMemberCnt(int eventNo);

	int insertEvent(Event event);

	int updateEvent(Event event);

	int deleteEvent(int eventNo);

	int insertEventJoin(Event event);

	Map<String, Integer> getEventCnt(Map<String, Object> paramMap);

	List<Event> findAllPersonalByClass(Map<String, Object> paramMap);

	List<Integer> getSubscription(int userNo);

	List<Event> findPublicPersonal(Map<String, Object> paramMap);

	List<Event> findPrivatePersonal(Map<String, Object> paramMap);

	int exitEvent(Event event);

}
