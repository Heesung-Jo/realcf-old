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


public class xlmake { 

	
	 private String name; 
	 private String val;

	 private String realword;
	 private HashMap<String, Integer> word_dict = new HashMap<>();
	 private ArrayList<ArrayList<String>> reallist = new ArrayList<>();
	 private ArrayList<String> remainlist = new ArrayList<>();
	 private int realprob = 0;


	 
	 public xlmake(String word) {
		 this.realword = word;
		 

	 }
           

	    // xl 사용하기 위해서 테스트
	    public void listmake(String sheetname, String name, int row1, int row2, String para)
	   		 throws ClassNotFoundException, IllegalAccessException, InstantiationException
	         ,NoSuchMethodException, InvocationTargetException 
	    {
	      // 각 배열에 앞뒤로 집어넣기, pos는 엑셀 열의 위치를 부여하기
	      	
	      try {
	      	FileInputStream fis = new FileInputStream("C:\\java\\gob\\프로토타입\\계정\\" + name); ///usr/local/gob/"
	      	HSSFWorkbook book = new HSSFWorkbook(fis);
	      	HSSFSheet sheet = book.getSheet(sheetname);
	      	
	      	
	      	//조금이라도 null이면 null이 떠 버리니 조심할 것
	      	//그리고 열과행은 0부터 시작한다는 것 주의할 것
	      	//https://blog.naver.com/wlgh325/221391234592
	      	int rowexisting = 1;

	      	for(int num = row1; num <= row2; num++) {
	      		
	      		HSSFRow row = sheet.getRow(num);
	         
	  	        ArrayList<JSONObject> sentences = new ArrayList<>();
	  	        JSONObject obj = new JSONObject();
	  	        String activitystring = "";
	  	    
	      	    int existing = 1;
	      	    if(row != null) {
	      	      //subwork(row, pro);
	      	      	
	      	      // 아래쪽에 서브클래스에 subwork 함수를 만들고 익명클래스로 subwork를 오버라이드해서 그것으로 즉시 인스턴스화해서 사용할까도 고려했으나, 
	      	      // 예시 위쪽에서 함수 실행시키기 전에 new subclass(){@override
	      	      //	                                  subwork(){ ~~~~ 할일을 불라불라 기재 ~~~ } 
	      	      // 이것을 매개변수로 넘기기. 이렇게하면 위에가 너무 지저분해지므로       	    	
	      	      // 일단은 invoke를 사용함	
	      	    	System.out.println(Integer.valueOf(row.getCell(1).toString()));
	      	    	word_dict.put(row.getCell(0).toString(), Integer.valueOf(row.getCell(1).toString()));
	              
	      	    }
	      	
	      	}
	      }catch(FileNotFoundException e) {
	    	  System.out.println(e);
	      }catch(IOException e) {
	    	  System.out.println(e);
	      }
	      
	      
	    }   
	 
	 
	 

}