package com.newlearn.playground.classroom.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.classroom.model.vo.Attendance;
import com.newlearn.playground.classroom.model.vo.ClassJoin;
import com.newlearn.playground.classroom.model.vo.Classroom;

@Repository
public class ClassroomDaoImpl implements ClassroomDao {
	@Autowired
	private SqlSessionTemplate session;
	
	@Override
	public Attendance getAttendance(Attendance a) {
		return session.selectOne("class.getAttendance", a);
	}

	@Override
	public Classroom getClassroom(int classNo) {
		return session.selectOne("class.getClassroom", classNo);
	}

	@Override
	public int addAttendance(Attendance a) {
		return session.insert("class.addAttendance", a);
	}

	@Override
	public List<Classroom> getClasslist(int mypageNo) {
		return session.selectList("class.getClasslist", mypageNo);
	}

	@Override
	public int exitClass(Map<String, String> paramMap) {
		return session.delete("class.exitClass", paramMap);
	}

	@Override
	public int joinClass(Map<String, String> paramMap) {
		return session.insert("class.joinClass", paramMap);
	}

	@Override
	public Classroom getClassByClasscode(String classCode) {
		return session.selectOne("class.getClassByClasscode", classCode);
	}

	@Override
	public ClassJoin getClassJoin(Map<String, Object> paramMap) {
		return session.selectOne("class.getClassJoin", paramMap);
	}

	@Override
	public List<Integer> getClassJoins(int userNo) {
		return session.selectList("class.getClassJoins", userNo);
	}

	@Override
	public List<Integer> getTeacherClassJoins(int userNo) {
		return session.selectList("class.getTeacherClassJoins", userNo);
	}
	
	@Override
	public ClassJoin getClassJoinByUserNo(Map<String, Object> map) {
		return session.selectOne("class.getClassJoinByUserNo", map);
	}

}
