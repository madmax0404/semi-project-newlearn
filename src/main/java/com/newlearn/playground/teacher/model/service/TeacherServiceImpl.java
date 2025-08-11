package com.newlearn.playground.teacher.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.newlearn.playground.teacher.model.dao.TeacherDao;
import com.newlearn.playground.teacher.model.vo.TeacherAttendance;
import com.newlearn.playground.teacher.model.vo.TeacherClass;
import com.newlearn.playground.teacher.model.vo.TeacherReport;
import com.newlearn.playground.teacher.model.vo.TeacherUploadFile;
import com.newlearn.playground.teacher.model.vo.Student;
import com.newlearn.playground.teacher.model.vo.TeacherAssignment;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TeacherServiceImpl implements TeacherService {
	private final TeacherDao dao;
	
	@Override
	public List<Student> getStudentList(int classNo) {
		return dao.getStudentList(classNo);
	}
	
	@Override
	public List<TeacherAttendance> getAttList(Map<String, Object> attMap) {
		return dao.getAttList(attMap);
	}

	@Override
	public int attendanceUpdate(Map<String, Object> map) {
		return dao.attendanceUpdate(map);
	}

	@Override
	public int studentKick(Map<String, Object> map) {
		return dao.studentKick(map);
	}

	@Override
	public List<TeacherAssignment> getAssignmentList(int classNo) {
		return dao.getAssignmentList(classNo);
	}

	@Override
	public int insertAssignment(TeacherAssignment ta) {
		return dao.insertAssignment(ta);
	}

	@Override
	public int uploadFile(TeacherUploadFile tuf) {
		return dao.uploadFile(tuf);
	}

	@Override
	public int updateAssignment(TeacherAssignment ta) {
		return dao.updateAssignment(ta);
	}

	@Override
	public TeacherAssignment getAssignment(TeacherAssignment ta) {
		return dao.getAssignment(ta);
	}

	@Override
	public int updateEntryCode(Map<String, Object> map) {
		return dao.updateEntryCode(map);
	}

	@Override
	public int updateClassName(Map<String, Object> map) {
		return dao.updateClassName(map);
	}

	@Override
	public TeacherClass getTeacherClass(int classNo) {
		return dao.getTeacherClass(classNo);
	}

	@Override
	public int updateClassCode(Map<String, Object> map) {
		return dao.updateClassCode(map);
	}

	@Override
	public List<TeacherReport> getReportList(int classNo) {
		return dao.getReportList(classNo);
	}

	@Override
	public int updateReportStatus(Map<String, Object> map) {
		return dao.updateReportStatus(map);
	}

	@Override
	public int deleteAssignment(int assignmentNo) {
		return dao.deleteAssignment(assignmentNo);
	}

	@Override
	public TeacherUploadFile getTeacherUploadFile(int fileNo) {
		return dao.getTeacherUploadFile(fileNo);
	}

	@Override
	public int attendanceNoteUpdate(Map<String, Object> map) {
		return dao.attendanceNoteUpdate(map);
	}

}
