package com.newlearn.playground.common.aop;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

import com.newlearn.playground.board.model.vo.BoardExt;

import lombok.extern.slf4j.Slf4j;

@Component
@Aspect
@Slf4j
public class AfterReturningTest {
	// 메서드 실행 이후에 반환값을 얻어오는 기능의 어노테이션
	@AfterReturning(pointcut="CommonPointcut.boardPointcut()", returning="returnObj")
	public void returnValue(JoinPoint jp, Object returnObj) {
		if (returnObj instanceof BoardExt) {
			BoardExt b = (BoardExt)returnObj;
//			b.setBoardTitle("하이");
		}
	}
}









