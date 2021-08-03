package com.controllers;

import org.springframework.stereotype.Controller;

import org.springframework.ui.Model;

import java.io.IOException;
import java.net.URI;
import java.util.stream.Collectors;
import java.util.*;

import org.springframework.http.converter.*;
import org.json.simple.JSONArray;

import org.springframework.web.servlet.*;
import org.springframework.stereotype.Controller;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import com.service.mywork;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;


import javax.servlet.ServletRequest;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;

import org.springframework.web.bind.support.*;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import com.fasterxml.jackson.core.sym.Name;

import com.entity.processdata;



@RestController
@SessionAttributes("process")
public class HelloController {

	@Autowired
	private mywork mywork;

    
	@PostMapping("/view/controlmethod")
	public ResponseEntity<Object> inputtest(HttpSession session,
		@RequestParam(value="realcoa[]") List<String> realcoa,	HttpServletRequest request) {
	
		ArrayList<String> names = new ArrayList<>();
		ArrayList<String> paras = new ArrayList<>();
 
		System.out.println(realcoa);
		JSONArray arr = new JSONArray();
		JSONObject realarr = new JSONObject();
		
		for(String coa : realcoa) {
			realarr.put(coa,mywork.coatest(coa));
		}
		
       /*		
		for(String name : request.getParameterMap().keySet()) {
			names.add(name);
			paras.add(request.getParameter(name));
	        System.out.println(name);
	        System.out.println(paras);

		}
	   */
		return ResponseEntity.status(HttpStatus.OK).body(realarr);
	       
	}    

	@PostMapping("/view/sortobj")
	public ResponseEntity<Object> makesortobj(HttpSession session,
			HttpServletRequest request) {
	
		
		HashMap<String, Object> realdata = new HashMap<>();
		realdata.put("sortobj", mywork.getsortobj());
		realdata.put("middlecoa", mywork.getmiddlecoa());
		return ResponseEntity.status(HttpStatus.OK).body(realdata);
	       
	}    
	
	
	
	
	@PostMapping("/view/poolmake")
	public ResponseEntity<Object> getactiondata(HttpSession session, 
			 Model model //, @PathVariable String name
	) {
		
	//System.out.println(name);
    
    
	try {	
		System.out.println("여기는 통과");
		JSONObject process = new JSONObject();

		System.out.println("여기는 통과");
	    
		return ResponseEntity.status(HttpStatus.OK).body(process);

	} catch(Exception e) {
    	  System.out.println(e);
		  return ResponseEntity.status(HttpStatus.OK).body(1909);
	}
    	  
  }
	
}
