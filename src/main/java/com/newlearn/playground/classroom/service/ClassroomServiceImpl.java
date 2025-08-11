package com.newlearn.playground.classroom.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.newlearn.playground.classroom.model.dao.ClassroomDao;
import com.newlearn.playground.classroom.model.vo.Attendance;
import com.newlearn.playground.classroom.model.vo.ClassJoin;
import com.newlearn.playground.classroom.model.vo.Classroom;

@Service
public class ClassroomServiceImpl implements ClassroomService {
	@Autowired
	private ClassroomDao classroomDao;
	
	@Override
	public Attendance getAttendance(Attendance a) {
		return classroomDao.getAttendance(a);
	}

	@Override
	public Classroom getClassroom(int classNo) {
		return classroomDao.getClassroom(classNo);
	}

	@Override
	public int addAttendance(Attendance a) {
		return classroomDao.addAttendance(a);
	}

	@Override
	public List<Classroom> getClasslist(int mypageNo) {
		return classroomDao.getClasslist(mypageNo);
	}

	@Override
	public int exitClass(Map<String, String> paramMap) {
		return classroomDao.exitClass(paramMap);
	}

	@Override
	public int joinClass(Map<String, String> paramMap) {
		return classroomDao.joinClass(paramMap);
	}

	@Override
	public Classroom getClassByClasscode(String classCode) {
		return classroomDao.getClassByClasscode(classCode);
	}

	@Override
	public ClassJoin getClassJoin(Map<String, Object> paramMap) {
		return classroomDao.getClassJoin(paramMap);
	}

	@Override
	public List<Integer> getClassJoins(int userNo) {
		return classroomDao.getClassJoins(userNo);
	}

	@Override
	public List<Integer> getTeacherClassJoins(int userNo) {
		return classroomDao.getTeacherClassJoins(userNo);
	}
	
	@Override
	public ClassJoin getClassJoinByUserNo(int userNo, int classNo) {
		Map<String, Object> map = new HashMap<>();
        map.put("userNo", userNo);
        map.put("classNo", classNo);
		return classroomDao.getClassJoinByUserNo(map);
	}

}
