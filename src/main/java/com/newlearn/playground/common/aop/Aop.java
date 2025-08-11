package com.newlearn.playground.common.aop;

import java.util.List;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

import com.newlearn.playground.common.XssCleanable;

@Aspect
@Component
public class Aop {
	
	@Pointcut("execution(* com.newlearn.playground..*ServiceImpl.*(..)) && args(arg,..)")
	public void xssNewLinePointcut(Object arg) {}
	
	@Before("xssNewLinePointcut(arg)")
	public void xssNewLineHandling(Object arg) {
		if (arg instanceof XssCleanable) {
			((XssCleanable)arg).xssHandling();
			((XssCleanable)arg).newLineHandling();
		}
	}
	
	@Pointcut("execution(* com.newlearn.playground..*ServiceImpl.*(..))")
	public void newLineClearPointcut() {}
	
	@AfterReturning(pointcut="newLineClearPointcut()", returning="obj")
	public void newLineClear(JoinPoint jp, Object obj) {
		if (obj instanceof XssCleanable) {
			((XssCleanable)obj).clearNewLine();
		}
		if (obj instanceof List<?>) {
			List<?> list = (List<?>) obj;
			for (Object o : list) {
				if (o instanceof XssCleanable) {
					((XssCleanable)o).clearNewLine();
				}
			}
		}
	}
	
}
