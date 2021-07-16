package com.service; 

 import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity; 
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
import org.json.simple.JSONArray;

import org.springframework.stereotype.*;


import javax.inject.Inject;


public class wordmake { 

	
	 private String name; 
	 private String val;

	 private String realword;
	 private HashMap<String, Integer> word_dict = new HashMap<>();
	 private ArrayList<ArrayList<String>> reallist = new ArrayList<>();
	 private ArrayList<String> remainlist = new ArrayList<>();
	 private int realprob = 0;


	 
	 public wordmake(String word) {
		 this.realword = word;
		 
         make_list();
	     next_loop(0, 1, new ArrayList<String>());

	 }
           
	 public void make_list() {
	        for(int i = 0; i < this.realword.length();i++) {
	        	
	            find_word(this.realword.substring(i));
	        }
	 }
	        
	 public void find_word(String word) {
		    ArrayList<String> arr =  new ArrayList<>();
	        for(int i = 0; i< word.length() + 1; i++) {
	        	
	            if(word_dict.containsKey(word.substring(0, i)) == true) {
	                arr.add(word.substring(0, i));
	            }    
	        }   
	        
	        this.reallist.add(arr);
	        
	 }
	 
	 
	 public void next_loop(int num, int prob, ArrayList<String> templist) {
	        for(int i = 0; i < this.reallist.get(num).size(); i++) {
	            next_find(this.reallist.get(num).get(i), num, prob, templist);
	        }    
	 }
	 
	 
	 public void next_find(String word, int num, int prob, ArrayList<String> templist) {
	        
		 prob = prob * word_dict.get(word)/word_dict.get("^^total^^");
	        num += word.length();
	        ArrayList<String> temp = new ArrayList<>();
	        Collections.copy(templist, temp);
	        temp.add(word);
	        
	        if(num < realword.length()) {
	            next_loop(num, prob, temp);
	        }else{
	            if(prob > this.realprob) {
	                System.out.println(temp);
	                this.remainlist = temp;
	            }
	        }
	 }

}