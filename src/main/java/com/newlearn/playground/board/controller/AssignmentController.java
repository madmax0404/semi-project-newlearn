package com.newlearn.playground.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.newlearn.playground.board.model.service.AssignmentService;
import com.newlearn.playground.board.model.vo.Assignment;

@Controller
public class AssignmentController {

	@Autowired
	private AssignmentService assignmentService;
	
	
}