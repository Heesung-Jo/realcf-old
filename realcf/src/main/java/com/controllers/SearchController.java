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


@RestController
@SessionAttributes("process")
public class SearchController {

    
	@Autowired
	private companywork companywork;


	@PostMapping("/view/searchrequest")
	public ResponseEntity<Object> searchrequest(HttpSession session, HttpServletRequest request,
			@RequestParam(value="business[]") @Nullable List<String> business,
			@RequestParam(value="coa[]") @Nullable List<String> coa,
			@RequestParam(value="company[]") @Nullable List<String> company) {
	
		System.out.println(123123);
		HashMap<String, Object> realdata = new HashMap<>();
		// 로직: company가 있을때는 무조건 company로 조회
		// 그렇지 않을때는 나머지 두개로 조회
		
		if(company != null) {
			for(String com : company) {
				financialstatements financial = companywork.findbyname(com);
				Set<coadata> coastemp = financial.getcoadata();
				HashMap<String, JSONObject> coas = companywork.toresponse(coastemp);
				
                int coatest = 0;				
                System.out.println(com);
                if(coa != null) {
                
					// 일부 계정만 조회함
					HashMap<String, JSONObject> temp = new HashMap<>();
					for(String text : coa) {
						if(coas.containsKey(text)) {
							temp.put(text, coas.get(text));
						}
						
					}
					realdata.put(com, temp);
					coatest = 1;
				}

                if(coatest == 0) {
					// 전 계정을 조회함
					
					realdata.put(com, coas);
				}
			}
			
		}else if(1 == 1) {
			
			// 그렇지 않을때 조회하는 코드
			
			
		}
		
		
		
		
		return ResponseEntity.status(HttpStatus.OK).body(realdata);
	       
	}    
	
	
	

	
}
