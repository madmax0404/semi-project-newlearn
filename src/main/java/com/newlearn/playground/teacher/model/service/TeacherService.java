package com.newlearn.playground.teacher.model.service;

import java.util.List;
import java.util.Map;

import com.newlearn.playground.teacher.model.vo.TeacherAttendance;
import com.newlearn.playground.teacher.model.vo.TeacherClass;
import com.newlearn.playground.teacher.model.vo.TeacherReport;
import com.newlearn.playground.teacher.model.vo.TeacherUploadFile;
import com.newlearn.playground.teacher.model.vo.Student;
import com.newlearn.playground.teacher.model.vo.TeacherAssignment;

public interface TeacherService {

	List<Student> getStudentList(int classNo);
	
	List<TeacherAttendance> getAttList(Map<String, Object> attMap);

	int attendanceUpdate(Map<String, Object> map);

	int studentKick(Map<String, Object> map);

	List<TeacherAssignment> getAssignmentList(int classNo);

	int insertAssignment(TeacherAssignment ta);

	int uploadFile(TeacherUploadFile tuf);

	int updateAssignment(TeacherAssignment ta);

	TeacherAssignment getAssignment(TeacherAssignment ta);

	int updateEntryCode(Map<String, Object> map);

	int updateClassName(Map<String, Object> map);

	TeacherClass getTeacherClass(int classNo);

	int updateClassCode(Map<String, Object> map);

	List<TeacherReport> getReportList(int classNo);

	int updateReportStatus(Map<String, Object> map);

	int deleteAssignment(int assignmentNo);

	TeacherUploadFile getTeacherUploadFile(int fileNo);

	int attendanceNoteUpdate(Map<String, Object> map);

}
