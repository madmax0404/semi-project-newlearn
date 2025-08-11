package com.newlearn.playground.teacher.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.newlearn.playground.teacher.model.vo.TeacherAttendance;
import com.newlearn.playground.teacher.model.vo.TeacherClass;
import com.newlearn.playground.teacher.model.vo.TeacherReport;
import com.newlearn.playground.teacher.model.vo.TeacherUploadFile;
import com.newlearn.playground.teacher.model.vo.Student;
import com.newlearn.playground.teacher.model.vo.TeacherAssignment;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class TeacherDaoImpl implements TeacherDao {
	private final SqlSessionTemplate session;
	
	@Override
	public List<Student> getStudentList(int classNo) {
		return session.selectList("teacher.getStudentList", classNo);
	}
	
	@Override
	public List<TeacherAttendance> getAttList(Map<String, Object> attMap) {
		return session.selectList("teacher.getAttList", attMap);
	}

	@Override
	public int attendanceUpdate(Map<String, Object> map) {
		return session.update("teacher.attendanceUpdate", map);
	}

	@Override
	public int studentKick(Map<String, Object> map) {
		return session.delete("teacher.studentKick", map);
	}

	@Override
	public List<TeacherAssignment> getAssignmentList(int classNo) {
		return session.selectList("teacher.getAssignmentList", classNo);
	}

	@Override
	public int insertAssignment(TeacherAssignment ta) {
		return session.insert("teacher.insertAssignment", ta);
	}

	@Override
	public int uploadFile(TeacherUploadFile tuf) {
		return session.insert("teacher.uploadFile", tuf);
	}

	@Override
	public int updateAssignment(TeacherAssignment ta) {
		return session.update("teacher.updateAssignment", ta);
	}

	@Override
	public TeacherAssignment getAssignment(TeacherAssignment ta) {
		return session.selectOne("teacher.getAssignment", ta);
	}

	@Override
	public int updateEntryCode(Map<String, Object> map) {
		return session.update("teacher.updateEntryCode", map);
	}

	@Override
	public int updateClassName(Map<String, Object> map) {
		return session.update("teacher.updateClassName", map);
	}

	@Override
	public TeacherClass getTeacherClass(int classNo) {
		return session.selectOne("teacher.getTeacherClass", classNo);
	}

	@Override
	public int updateClassCode(Map<String, Object> map) {
		return session.update("teacher.updateClassCode", map);
	}

	@Override
	public List<TeacherReport> getReportList(int classNo) {
		return session.selectList("teacher.getReportList", classNo);
	}

	@Override
	public int updateReportStatus(Map<String, Object> map) {
		return session.update("teacher.updateReportStatus", map);
	}

	@Override
	public int deleteAssignment(int assignmentNo) {
		return session.delete("teacher.deleteAssignment", assignmentNo);
	}

	@Override
	public TeacherUploadFile getTeacherUploadFile(int fileNo) {
		return session.selectOne("teacher.getTeacherUploadFile", fileNo);
	}

	@Override
	public int attendanceNoteUpdate(Map<String, Object> map) {
		return session.update("teacher.attendanceNoteUpdate", map);
	}

}
