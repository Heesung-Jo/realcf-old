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
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;


import com.entity.processdata;
import com.entity.teamdata;
import com.entity.nodedata;
import com.entity.parentnodedata;
import com.entity.childnodedata;
import com.entity.coadata;
import com.entity.coagroupdata;
import com.entity.financialstatements;


import com.repository.processrepository;
import com.repository.teamrepository;

import com.repository.CoagroupdataRepository;
import com.repository.memberrepository;
import com.repository.CoadataRepository;
import com.repository.CoadataRepositoryImpl;
import com.repository.financialstatementsRepository;
import com.repository.CoagroupdataRepository;



import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import javax.inject.Inject;

import java.util.*;
// jsp?????? ?????? ????????? ??????????????? ??????????????????, submit??? ?????????, ajax ????????? ??????????????? ????????? ???

@Service
public class companywork { 


    @Autowired
    private CoadataRepository CoadataRepository;
	
    @Autowired
    private financialstatementsRepository financialstatementsRepository;
    
    @Autowired
    private CoagroupdataRepository coagroupdataRepository;
    
    
    @Autowired
    private xlmake xlmake;

    private ArrayList<String> coaturnarr = new ArrayList<>();
    private HashSet<String> companyarr = new HashSet<>();
    
    @Autowired
    public void companywork() { 
           //setting();
           // ????????? ??? ????????? ???????????? // ???????????? ???
           setting2();
           
    } 
	
    public financialstatements findbyname(String name) {
    	return financialstatementsRepository.findByname(name);
    }
    
    
    
    public void setting() {
      /*
    	// invoke ????????? ?????????????????? ????????????
    	System.out.println(123123123);
    	coadata coa = CoadataRepository.getprocessquery("company", "name", "3S", "????????????????????????").get(0);
        System.out.println(coa.getyear());
        System.out.println(coa.getbspl());
      */
    	
//    	HSSFRow row;
  //  	row.getCell(0).getNumericCellValue()
    	
    	// datafordb?????? ????????? db??? ????????????
    	
    	// coaturnobj ?????? ????????????
    	// coaturnarr ?????????
  
    	
    	xlsubwork coms = new xlsubwork() {
    		public void work(HSSFRow row) {
    			String company = row.getCell(0).toString();
    			financialstatements statement;
     			statement = new financialstatements();
    			statement.setname(company);
    			statement.setyear(2020);
    			financialstatementsRepository.save(statement);
   			
    		};
    	};
    	
    	// main data sheet ????????????
    	xlsubwork sub = new xlsubwork() {
    		public void work(HSSFRow row) {
 
    			
     			
    			coadata coa = new coadata();
    			
    			
    			String bspl  = row.getCell(1).toString();
    			String name = row.getCell(2).toString();
    			String reportname = row.getCell(3).toString();
    			double number = row.getCell(5).getNumericCellValue();
    			double level = row.getCell(6).getNumericCellValue();
    			String company = row.getCell(0).toString();
    			
    			
    			
    			try {
    				// null?????? ?????????
        			double cash = row.getCell(4).getNumericCellValue();
        			coa.setval(cash);
        			String parent = row.getCell(7).toString();
        			coa.setparent(parent);	
    			}catch(Exception e) {
    				      				
    			}
    		    
    		
    			// coa data db??? ????????????
    			coa.setcompany(company);
    			coa.setbspl(bspl);
    			coa.setname(name);
    			coa.setreportname(reportname);
    			coa.setnumber(number);
    		    coa.setyear(2020);	
    		    coa.setlevel(level);
    		    
    			
    			//statement.addcoadata(coa);
    			CoadataRepository.save(coa);
    			
    			
    			// coagroupdata??? ????????????
   			
    			coagroupdata coagroupdata;
    			
    			try {
    				coagroupdata = coagroupdataRepository.findByCompanyAndLevelAndName(company, level, name);
    				double cash = row.getCell(4).getNumericCellValue();
    				coagroupdata.setval(cash + coagroupdata.getval());
    				coagroupdata.addcoadata(coa);
    				coagroupdataRepository.save(coagroupdata);
    			}catch(NullPointerException e) {
    				coagroupdata = new coagroupdata();
    				System.out.println("come in");
    				coagroupdata.setcompany(company);
    				double cash = row.getCell(4).getNumericCellValue();
    				coagroupdata.setval(cash + coagroupdata.getval());

    				coagroupdata.setbspl(bspl);
    				coagroupdata.setname(name);
    				coagroupdata.setyear(2020);	
    				coagroupdata.setlevel(level);
    				coagroupdataRepository.save(coagroupdata);
        		    
        		    coagroupdata.addcoadata(coa);
        		    coagroupdataRepository.save(coagroupdata);

    			}catch(Exception e) {
    				
    				// ?????? ?????? ?????? throw??? ????????? ????????? ?????????
    				System.out.println(e);
    				
    			}
    			
    			
     		}
    	};
    	
    	try {
    		xlmake.listmake("company", "datafordb_BS.xls", 0, 256, coms);
        	xlmake.listmake("data", "datafordb_BS.xls", 0, 200, sub); // 15619
    		
    	}catch(Exception e) {
            // ?????? ????????? ????????? ?????? ??????????????? ?????????
    		// ??? throw fileexception?????? ????????? ???
    		System.out.println(e);
    	}
    	
    	
    	// company??? ????????? ????????????
    	for(coagroupdata tempcoa : coagroupdataRepository.findAll()) {
    		System.out.println(tempcoa.getcompany());
    		financialstatements statements = financialstatementsRepository.findByname(tempcoa.getcompany());
    		System.out.println(statements.getname());
    		statements.addcoagroupdata(tempcoa);   	
    		financialstatementsRepository.save(statements);
    	}
    	
    	
    	
    }
 
    
    public void setting2() {
    	// companyarr??? ?????????
       	xlsubwork coa = new xlsubwork() {
    		public void work(HSSFRow row) {
    			coaturnarr.add(row.getCell(0).toString());
    		}
    	};

    	try {
    		xlmake.listmake("coaturn", "datafordb_BS.xls", 0, 90, coa);
     		
    	}catch(Exception e) {
            // ?????? ????????? ????????? ?????? ??????????????? ?????????
    		// ??? throw fileexception?????? ????????? ???
    		System.out.println(e);
    	}
    	
    	for(financialstatements com : financialstatementsRepository.findAll()) {
    		companyarr.add(com.getname());
    	};
    	
    	
    }
    
    
    public HashMap<String, JSONObject> toresponse(Set<coagroupdata> coas){
    	
    	
    	HashMap<String, JSONObject> temp = new HashMap<>();
    	for(coagroupdata coa : coas) {
    		
    		// ????????? ????????? ???????????? json??? ????????????
    		JSONObject json = new JSONObject();
    		json.put("name", coa.getname());
    		json.put("bspl", coa.getbspl());
    		
    		json.put("val", coa.getval());
    		temp.put(coa.getname(), json);
    	}
    	
    	return temp;
    }
	     
    
   public ArrayList<String> getcoaturnarr(){
	   return coaturnarr;
	   
   }

   public HashSet<String> getcompanyarr(){
	   return companyarr;
   }
   
   public  List<Object[]> findmaxval(String name){
	   return coagroupdataRepository.findmaxval(name);

   }
   public  List<Object[]> findmaxval(List<String> name){
	   return coagroupdataRepository.findmaxval(name);

   }
   
}      
    
    
    
    
    
  