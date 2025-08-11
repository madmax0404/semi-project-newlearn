package com.newlearn.playground.classroom.model.dao;

import java.util.List;
import java.util.Map;

import com.newlearn.playground.classroom.model.vo.Attendance;
import com.newlearn.playground.classroom.model.vo.ClassJoin;
import com.newlearn.playground.classroom.model.vo.Classroom;

public interface ClassroomDao {

	Attendance getAttendance(Attendance a);

	Classroom getClassroom(int classNo);

	int addAttendance(Attendance a);

	List<Classroom> getClasslist(int mypageNo);

	int exitClass(Map<String, String> paramMap);

	int joinClass(Map<String, String> paramMap);

	Classroom getClassByClasscode(String classCode);

	ClassJoin getClassJoin(Map<String, Object> paramMap);

	List<Integer> getClassJoins(int userNo);

	List<Integer> getTeacherClassJoins(int userNo);

	ClassJoin getClassJoinByUserNo(Map<String, Object> map);

}
