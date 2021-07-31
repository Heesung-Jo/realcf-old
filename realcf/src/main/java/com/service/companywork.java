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
import com.entity.coagroupdata;
import com.entity.financialstatements;


import com.repository.processrepository;
import com.repository.teamrepository;
import com.repository.RoleRepository;
import com.repository.coagroupdataRepository;
import com.repository.memberrepository;
import com.repository.CoadataRepository;
import com.repository.CoadataRepositoryImpl;
import com.repository.financialstatementsRepository;
import com.repository.coagroupdataRepository;
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
    private coagroupdataRepository coagroupdataRepository;
    
    
    @Autowired
    private xlmake xlmake;

    private ArrayList<String> coaturnarr = new ArrayList<>();
    private HashSet<String> companyarr = new HashSet<>();
    
    @Autowired
    public void companywork() { 
           setting();
           
    } 
	
    public financialstatements findbyname(String name) {
    	return financialstatementsRepository.findByname(name);
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
    	
    	// coaturnobj 시트 저장하기
    	// coaturnarr 만들기
    	xlsubwork coa = new xlsubwork() {
    		public void work(HSSFRow row) {
    			coaturnarr.add(row.getCell(0).toString());
    		}
    	};
 
    	
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
    	
    	// main data sheet 저장하기
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
    				// null값을 허용함
        			double cash = row.getCell(4).getNumericCellValue();
        			coa.setval(cash);
        			String parent = row.getCell(7).toString();
        			coa.setparent(parent);	
    			}catch(Exception e) {
    				      				
    			}
    		    
    		
    			// coa data db에 저장하기
    			coa.setcompany(company);
    			coa.setbspl(bspl);
    			coa.setname(name);
    			coa.setreportname(reportname);
    			coa.setnumber(number);
    		    coa.setyear(2020);	
    		    coa.setlevel(level);
    		    
    			
    			//statement.addcoadata(coa);
    			CoadataRepository.save(coa);
    			
    			
    			// coagroupdata에 저장하기
   			
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
    				
    				// 향후 쿼리 이상 throw를 던지는 문구로 바꿀것
    				System.out.println(e);
    				
    			}
    			
    			
     		}
    	};
    	
    	try {
    		xlmake.listmake("company", "datafordb_BS.xls", 0, 256, coms);
    	
    		xlmake.listmake("coaturn", "datafordb_BS.xls", 0, 90, coa);
        	xlmake.listmake("data", "datafordb_BS.xls", 0, 100, sub); // 15619
    		
    	}catch(Exception e) {
            // 결국 이것은 파일이 없는 에러이므로 나중에
    		// 다 throw fileexception으로 처리할 것
    		System.out.println(e);
    	}
    	
    	
    	
    	// companyarr이 만들기
    	for(financialstatements com : financialstatementsRepository.findAll()) {
    		companyarr.add(com.getname());
    	};
    	
    	System.out.println(companyarr.size());
    	
    }
    
    public HashMap<String, JSONObject> toresponse(Set<coadata> coas){
    	
    	
    	HashMap<String, JSONObject> temp = new HashMap<>();
    	for(coadata coa : coas) {
    		
    		// 필요한 데이터 추출하여 json에 집어넣기
    		JSONObject json = new JSONObject();
    		json.put("name", coa.getname());
    		json.put("bspl", coa.getbspl());
    		json.put("number", coa.getnumber());
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

   
}      
    
    
    
    
    
  