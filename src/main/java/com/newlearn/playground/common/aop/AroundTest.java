package com.newlearn.playground.common.aop;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Component
@Aspect
@Slf4j
public class AroundTest {
	@Around("CommonPointcut.boardPointcut()") // Before + After
	public Object checkRunningTime(ProceedingJoinPoint pjp) throws Throwable {
		long startTime = System.currentTimeMillis(); // 메서드 실행 이전
		Object obj = pjp.proceed(); // 타겟 메서드 실행 후 결과값 반환.
		long endTime = System.currentTimeMillis(); // 메서드 실행 이후
		
		log.debug("Running time: {} ms", (endTime - startTime));
		
		return obj;
	}
}
