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

import com.repository.processrepository;
import com.repository.teamrepository;
import com.repository.RoleRepository;
import com.entity.Role;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import javax.inject.Inject;


// jsp에서 지금 바로는 원하는데로 안받아지므로, submit를 바꿔서, ajax 형태로 입력되도록 수정할 것

@Service
public class mywork { 


	

	private HashMap<String, String> processteammap = new LinkedHashMap<>();

	private HashMap<String, coaarray> coahash = new LinkedHashMap<>();
	
	private JSONObject sortobj = new JSONObject();

	private HashMap<String, HashMap<String, String>> middlecoa = new LinkedHashMap();
    
    @Autowired
    public void mywork() { 
    	setting();
    } 
	
	public class  subclass{
  	   public void work(HSSFRow row) {
  		 System.out.println(123123);
  	   }; 
    }


    
    public void setting() {

    	// invoke 대신에 익명클래스를 활용해봄

    	System.out.println("why not");
    	
    	subclass sub1 = new subclass() {
    	  @Override
    	  public void work(HSSFRow row) {
    		  int num = (int) Math.round(Double.valueOf(row.getCell(1).toString()));
    		  
      	      coaarray coa = new coaarray(row.getCell(0).toString(), num, row.getCell(2).toString(), 
      	    		  row.getCell(3).toString(), row.getCell(4).toString());
              coahash.put(coa.getname(), coa);
              sortobj.put(coa.getname(), row.getCell(3).toString());
              
    	  }
    	};

    	
    	subclass sub2 = new subclass() {
    	  @Override
      	  public void work(HSSFRow row) {
                coahash.get(row.getCell(0).toString()).addlist(row.getCell(3).toString());
      	  }
      	};

      	// 약간 중분류 성격임
    	subclass sub3 = new subclass() {
      	      @Override
        	  public void work(HSSFRow row) {
      		      HashMap<String, String> tem1 = new HashMap<>();
      		      tem1.put("분류1", row.getCell(1).toString());
      		      tem1.put("분류2", row.getCell(2).toString());
      		      tem1.put("분류3", row.getCell(3).toString());
      		      middlecoa.put(row.getCell(0).toString(), tem1);
        	  }
       	};
    	
      	
      	
      	
      	
    	try{
        	listmake("계정과목_전체.xls", "분류", 0, 355, sub1);
        	listmake("계정과목_전체.xls", "세부분류", 0, 432, sub2);
        	listmake("계정과목_전체.xls", "중분류", 0, 120, sub3);


    	}catch(Exception e) {
            System.out.println(e);    		
    	}

    }
    
    public coaarray getcoaarray(String str){
    	return coahash.get(str);
    }
    
    public HashMap<String, String> getsortobj(){
    	return this.sortobj;
    }
    
    public HashMap<String, HashMap<String, String>> getmiddlecoa(){
    	return this.middlecoa;
    }
    
    
    
	 public JSONObject coatest(String str) {
         
		 // coa마다 정규식 매칭을 시켜서, 포함되는 coa를 포함시킬 것
		 HashSet<String> array = new HashSet<String>();
		 
		 for(coaarray coa : coahash.values()) {
			 
			  for(String sort : coa.getlist_sort()) {
				  Pattern p = Pattern.compile(sort);
			      Matcher m = p.matcher((String) str);
				  if(m.find()) {
					  
					 array.add(coa.getname());
				  }
				  
				  break;
				  
			  }
		 }

		 System.out.println(array);
		 // 포함여부 검증(손상차손, 손상차손누계액)일 때 무조건 손상차손누계액이 이겨야 함
		 ArrayList<String> tem = new ArrayList<>();
         for(String word1 : array) {
        	 for(String word2 : array) {
        		 if(word2.contains(word1) == true && word2.equals(word1) == false) {
        			 tem.add(word1);
        			 break;
        		 }
        	 }
         }
		 
		 for(String word : tem) {
			 array.remove(word);
		 }
         
         
		 // 위에서 제거하고 남은 집합(array)이 넘어올텐데, 우선순위 0인것과 나머지 것으로 
     	JSONObject data = new JSONObject();
     	HashMap<Integer, Integer> nums = new HashMap<>();
     	for(String wo : array) {
     		int num = coahash.get(wo).getorder();
     		data.put(num, wo);
     		if(nums.containsKey(num)) {
         		nums.put(num, nums.get(num) + 1);
     			
     		}else {
         		nums.put(num, 1);
     		}
     	}
		 
        // nums에 각 항목별로 num이 1보다 크면 실패이면 비어있는 jsonobject를 넘기고 
     	// 그렇지 않을때는 data를 넘길 것
     	for(int num : nums.keySet()) {
     		if(nums.get(num) > 1) {
     			return new JSONObject();
     		}
     	}
     	
     	return data;
		 
    }
    
	    // xl 사용하기 위해서 테스트
	    public void listmake(String name, String sheetname, int row1, int row2, subclass sub)
	   		 throws ClassNotFoundException, IllegalAccessException, InstantiationException
	         ,NoSuchMethodException, InvocationTargetException 
	    {
	      // 각 배열에 앞뒤로 집어넣기, pos는 엑셀 열의 위치를 부여하기
	      	
	      try {
	      	FileInputStream fis = new FileInputStream("C:\\java\\cf\\기타\\" + name); ///usr/local/gob/"
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
	      	      sub.work(row);	
                  
	      	      // 아래쪽에 서브클래스에 subwork 함수를 만들고 익명클래스로 subwork를 오버라이드해서 그것으로 즉시 인스턴스화해서 사용할까도 고려했으나, 
	      	      // 예시 위쪽에서 함수 실행시키기 전에 new subclass(){@override
	      	      //	                                  subwork(){ ~~~~ 할일을 불라불라 기재 ~~~ } 
	      	      // 이것을 매개변수로 넘기기. 이렇게하면 위에가 너무 지저분해지므로       	    	
	      	      // 일단은 invoke를 사용함	
	              
	      	    }
	      	
	      	}
	      }catch(FileNotFoundException e) {
	    	  System.out.println(e);
	      }catch(IOException e) {
	    	  System.out.println(e);
	      }
	      
	      
	    }      
    
    
    
    
    
    
    ///
    ///  이 아래는
    ////   gob임
    /////
    //////
    

    
    
}