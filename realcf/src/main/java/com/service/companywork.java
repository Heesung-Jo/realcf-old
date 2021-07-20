package com.service; 

 import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity; 

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.json.simple.JSONObject;
import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.stereotype.*;
import org.springframework.transaction.annotation.Transactional;


import com.entity.processdata;
import com.entity.teamdata;
import com.entity.nodedata;
import com.entity.parentnodedata;
import com.entity.childnodedata;
import com.entity.coadata;
import com.entity.financialstatements;


import com.repository.processrepository;
import com.repository.teamrepository;
import com.repository.RoleRepository;
import com.repository.memberrepository;
import com.repository.CoadataRepository;
import com.repository.CoadataRepositoryImpl;
import com.repository.financialstatementsRepository;
import com.entity.Role;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import javax.inject.Inject;

import java.util.*;
// jsp에서 지금 바로는 원하는데로 안받아지므로, submit를 바꿔서, ajax 형태로 입력되도록 수정할 것

@Service
public class companywork { 


    @Autowired
    private CoadataRepository CoadataRepository;
	
    @Autowired
    private financialstatementsRepository financialstatementsRepository;
    
    
    
    @Autowired
    private xlmake xlmake;

    
    @Autowired
    public void companywork() { 
           setting();
           
    } 
	
    
    public void setting() {
      /*
    	// invoke 대신에 익명클래스를 활용해봄
    	System.out.println(123123123);
    	coadata coa = CoadataRepository.getprocessquery("company", "name", "3S", "현금및현금성자산").get(0);
        System.out.println(coa.getyear());
        System.out.println(coa.getbspl());
      */
    	
//    	HSSFRow row;
  //  	row.getCell(0).getNumericCellValue()
    	// datafordb라는 파일을 db에 저장하기 
    	xlsubwork sub = new xlsubwork() {
    		public void work(HSSFRow row) {
    			coadata coa = new coadata();
    			
    			String company = row.getCell(0).toString();
    			String bspl  = row.getCell(1).toString();
    			System.out.println(company);
    			String name = row.getCell(2).toString();
    			String reportname = row.getCell(3).toString();
    			double number = row.getCell(5).getNumericCellValue();
    			
    			
    			try {
        			double cash = row.getCell(4).getNumericCellValue();
        			coa.setval(cash);
    				
    			}catch(Exception e) {
    				      				
    			}
    		
    			// coa data db에 저장하기
    			coa.setcompany(company);
    			coa.setbspl(bspl);
    			coa.setname(name);
    			coa.setreportname(reportname);
    			coa.setnumber(number);
    		    coa.setyear(2020);	
    			
    			CoadataRepository.save(coa);
    			
    			// financialstatements에 저장하기
    			financialstatements statement;
    			
    			try {
    				statement = financialstatementsRepository.findByname(company);
        			statement.addcoadata(coa);
        			financialstatementsRepository.save(statement);

    			}catch(NullPointerException e) {
    					
    				System.out.println("come in");
    				statement = new financialstatements();
    				statement.setname(company);
    				statement.setyear(2020);
    				financialstatementsRepository.save(statement);
    				
        			statement.addcoadata(coa);
        			financialstatementsRepository.save(statement);
    				
    			}catch(Exception e) {
    				
    				// 향후 쿼리 이상 throw를 던지는 문구로 바꿀것
    				System.out.println(e);
    				
    			}
    			
    			
    			
    		}
    	};
    	
    	try {
        	xlmake.listmake("data", "datafordb.xls", 1, 100, sub);
    		
    	}catch(Exception e) {
            // 결국 이것은 파일이 없는 에러이므로 나중에
    		// 다 throw fileexception으로 처리할 것
    		System.out.println(e);
    	}
    	
    }
    
 
	      
}      
    
    
    
    
    
  