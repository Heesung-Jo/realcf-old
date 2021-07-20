package com.service; 

 import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.*;

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
import org.springframework.stereotype.*;

import com.entity.processdata;

import javax.inject.Inject;

@Service
public class xlmake { 

	 public xlmake() {
		 //this.realword = word;
	 }
           

	    // xl 사용하기 위해서 테스트
	    public void listmake(String sheetname, String filename, int row1, int row2, xlsubwork sub)
	   		 throws ClassNotFoundException, IllegalAccessException, InstantiationException
	         ,NoSuchMethodException, InvocationTargetException 
	    {
	      // 각 배열에 앞뒤로 집어넣기, pos는 엑셀 열의 위치를 부여하기
	      	
	      try {
	      	FileInputStream fis = new FileInputStream("C:\\java\\gob\\프로토타입\\계정\\" + filename); ///usr/local/gob/"
	      	HSSFWorkbook book = new HSSFWorkbook(fis);
	      	HSSFSheet sheet = book.getSheet(sheetname);
	      	
	      	
	      	//조금이라도 null이면 null이 떠 버리니 조심할 것
	      	//그리고 열과행은 0부터 시작한다는 것 주의할 것
	      	//https://blog.naver.com/wlgh325/221391234592
	      	int rowexisting = 1;

	      	for(int num = row1; num <= row2; num++) {
	      		
	      		HSSFRow row = sheet.getRow(num);
	         
	  	    
	      	    int existing = 1;
	      	    if(row != null) {
	      	      sub.work(row);   // 주작업을 할 내용
	      	    }
	      	
	      	}
	      }catch(FileNotFoundException e) {
	    	  System.out.println(e);
	      }catch(IOException e) {
	    	  System.out.println(e);
	      }
	      
	      
	    }   
	 
	 public void work() {
		 
	 }
	 

}