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
import com.service.companywork;
import com.entity.financialstatements;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import javax.annotation.Nullable;
import org.springframework.http.*;

import java.util.*;
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
import com.entity.coadata;
import com.entity.coagroupdata;

@RestControllerAdvice("com")
public class CommonExceptionHandler {

    


	@ExceptionHandler(RuntimeException.class)
	public ResponseEntity<Object> runtimeerror(HttpSession session, HttpServletRequest request) {
	
		System.out.println(123123);
		HashMap<String, Object> realdata = new LinkedHashMap<>();
		realdata.put("error", "통신이 오류없는지 확인해주세요");
		
		return ResponseEntity.status(HttpStatus.OK).body(realdata);
	}    

	
	@ExceptionHandler(NullPointerException.class)
	public ResponseEntity<Object> nullpointerror(HttpSession session, HttpServletRequest request) {
	
		System.out.println(123123);
		HashMap<String, Object> realdata = new LinkedHashMap<>();
		realdata.put("error", "해당하는 데이터가 없습니다.");
		
		return ResponseEntity.status(HttpStatus.OK).body(realdata);
	}    
	

	
}
