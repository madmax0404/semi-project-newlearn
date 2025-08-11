<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<input type="hidden" name="selectedDate" id="selectedDate" value="">
<h3>${year}년 ${month}월</h3>
<table class="calendar-table">
    <tr>
        <th class="sunday">일</th>
        <th class="monday">월</th>
        <th class="tuesday">화</th>
        <th class="wednesday">수</th>
        <th class="thursday">목</th>
        <th class="friday">금</th>
        <th class="saturday">토</th>
    </tr>
    <tr>
        <c:set var="cellCount" value="0" />

        <!-- 빈칸 채우기 -->
        <c:forEach begin="1" end="${startDay - 1}" var="emptyDay">
            <td></td>
            <c:set var="cellCount" value="${cellCount + 1}" />
        </c:forEach>

        <!-- 날짜 출력 -->
        <c:forEach var="day" items="${days}">
            <c:if test="${cellCount % 7 == 0 && cellCount != 0}">
                <tr></tr>
            </c:if>
            <c:set var="isToday" value="${day == today}" />
            <td class="hover ${isToday ? 'today' : ''}" onclick="onDateClick('${year}-${month}-${day}')"
            	data-date="${year}-${month}-${day}">${day}</td>
            <c:set var="cellCount" value="${cellCount + 1}" />
        </c:forEach>
    </tr>
</table>