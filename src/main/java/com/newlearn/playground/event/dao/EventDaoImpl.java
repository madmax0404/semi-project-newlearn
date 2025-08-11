package com.newlearn.playground.event.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.event.vo.Event;

@Repository	
public class EventDaoImpl implements EventDao {
	@Autowired
	private SqlSessionTemplate session;
	
	@Override
	public List<Event> findAllByDate(Map <String, Object> paramMap) {
		return session.selectList("event.findAllByDate", paramMap);
	}

	@Override
	public Event findByNo(int eventNo) {
		return session.selectOne("event.findByNo", eventNo);
	}

	@Override
	public List<Event> upcomingEvents(int classNo) {
		return session.selectList("event.upcomingEvents", classNo);
	}

	@Override
	public Integer joinMemberCnt(int eventNo) {
		return session.selectOne("event.joinMemberCnt", eventNo);
	}

	@Override
	public int insertEvent(Event event) {
		return session.insert("event.insertEvent", event);
	}

	@Override
	public int updateEvent(Event event) {
		return session.update("event.updateEvent", event);
	}

	@Override
	public int deleteEvent(int eventNo) {
		return session.delete("event.deleteEvent", eventNo);
	}

	@Override
	public int insertEventJoin(Event event) {
		return session.insert("event.insertEventJoin", event);
	}

	@Override
	public Map<String, Integer> getEventCnt(Map<String, Object> paramMap) {
		Map<String, Object> temp = session.selectMap("event.getEventCnt", paramMap, "startDate");
		Map<String, Integer> result = new HashMap<>();
		for (Map.Entry<String, Object> e : temp.entrySet()) {
		    Map<?, ?> innerMap = (Map<?, ?>) e.getValue();
		    Integer cnt = Integer.parseInt(innerMap.get("cnt").toString());
		    result.put(e.getKey(), cnt);
		}
		return result;
	}

	@Override
	public List<Event> findAllPersonalByClass(Map<String, Object> paramMap) {
		return session.selectList("event.findAllPersonalByClass", paramMap);
	}

	@Override
	public List<Integer> getSubscription(int userNo) {
		return session.selectList("event.getSubscription", userNo);
	}

	@Override
	public List<Event> findPublicPersonal(Map<String, Object> paramMap) {
		return session.selectList("event.findPublicPersonal", paramMap);
	}

	@Override
	public List<Event> findPrivatePersonal(Map<String, Object> paramMap) {
		return session.selectList("event.findPrivatePersonal", paramMap);
	}

	@Override
	public int exitEvent(Event event) {
		return session.delete("event.exitEvent", event);
	}

}
