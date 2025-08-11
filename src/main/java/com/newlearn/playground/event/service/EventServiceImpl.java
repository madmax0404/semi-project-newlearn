package com.newlearn.playground.event.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.newlearn.playground.common.model.vo.PageInfo;
import com.newlearn.playground.event.dao.EventDao;
import com.newlearn.playground.event.vo.Event;
import com.newlearn.playground.event.vo.Event.EventType;

@Service
public class EventServiceImpl implements EventService {
	@Autowired
	private EventDao eventDao;
	
	@Override
	public Event findByNo(int eventNo) {
		return eventDao.findByNo(eventNo);
	}

	@Override
	public List<Event> findAllByDate(Map <String, Object> paramMap) {
		return eventDao.findAllByDate(paramMap);
	}

	@Override
	public List<Event> upcomingEvents(int classNo) {
		return eventDao.upcomingEvents(classNo);
	}

	@Override
	public Integer joinMemberCnt(int eventNo) {
		return eventDao.joinMemberCnt(eventNo);
	}

	@Override
	@Transactional(rollbackFor = {Exception.class})
	public int insertEvent(Event event) {
		int result = eventDao.insertEvent(event);
		if (result == 0) {
			throw new RuntimeException("이벤트 생성 실패");
		}
		if (event.getEventType() == EventType.SHARED) {
			result = eventDao.insertEventJoin(event);
			if (result == 0) {
				throw new RuntimeException("공유이벤트 참여 중 에러발생");
			}
		}
		return result;
	}
	
	@Override
	public int updateEvent(Event event) {
		return eventDao.updateEvent(event);
	}

	@Override
	public int deleteEvent(int eventNo) {
		return eventDao.deleteEvent(eventNo);
	}

	@Override
	public Map<String, Integer> getEventCnt(Map<String, Object> paramMap) {
		return eventDao.getEventCnt(paramMap);
	}

	@Override
	public List<Event> findAllPersonalByClass(Map<String, Object> paramMap) {
		return eventDao.findAllPersonalByClass(paramMap);
	}

	@Override
	public int joinMember(Event event, int userNo) {
		event.setUserNo(userNo);
		return eventDao.insertEventJoin(event);
	}

	@Override
	public List<Integer> getSubscription(int userNo) {
		return eventDao.getSubscription(userNo);
	}

	@Override
	public List<Event> findPublicPersonal(Map<String, Object> paramMap) {
		return eventDao.findPublicPersonal(paramMap);
	}

	@Override
	public List<Event> findPrivatePersonal(Map<String, Object> paramMap) {
		return eventDao.findPrivatePersonal(paramMap);
	}

	@Override
	public int exitEvent(Event event, int userNo) {
		event.setUserNo(userNo);
		return eventDao.exitEvent(event);
	}

}
