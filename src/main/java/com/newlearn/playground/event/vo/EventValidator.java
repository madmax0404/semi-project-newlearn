package com.newlearn.playground.event.vo;

import java.util.Date;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.newlearn.playground.event.vo.Event.EventType;

public class EventValidator implements Validator {

	@Override
	public boolean supports(Class<?> clazz) {
		return Event.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		Event event = (Event) target;
		// 1. endDate가 startDate보다 더 이전이라면
		if (event.getEndDate().compareTo(event.getStartDate()) < 0) {
			errors.rejectValue("endDate", "invalid.dateOrder", "종료날짜는 시작날짜보다 빠를 수 없습니다.");
		}
		// 2. endDate가 오늘 날짜보다 더 이전이라면
		if (event.getEndDate().compareTo(new Date()) < 0) {
			errors.rejectValue("endDate", "invalid.pastDate", "종료날짜는 오늘날짜보다 빠를 수 없습니다.");
		}
		// 3. joinDeadline이 startDate보다 더 이전이라면
		if (event.getEventType() == EventType.SHARED && event.getJoinDeadline().compareTo(event.getStartDate()) > 0) {
			errors.rejectValue("joinDeadline", "invalid.joinDeadline", "이벤트 참여기한은 시작날짜보다 늦을 수 없습니다.");
		}
	}

}
