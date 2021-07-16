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


public class coaarray { 

	
	 private String name; 
	 private String name_sort;
     private String sortobj;
	 
	 private int order;
	 private ArrayList<String> list_sort = new ArrayList<>();
	 
	 private String bsis;
	 
	 public coaarray(String name, int order, String bsis, String name_sort, String sortobj) {
            this.name = name;
            this.name_sort = name_sort;
            this.order = order;
            this.bsis = bsis;
            this.sortobj = sortobj;
	 }
     
	 public String getname() {
		 return name;
	 }

	 public String getname_sort() {
		 return name_sort;
	 }

	 public String getsortobj() {
		 return sortobj;
	 }

	 
	 public int getorder() {
		 return order;
	 }

	 public ArrayList<String> getlist_sort() {
		 return list_sort;
	 }
	 
	 public void addlist(String e) {
		 list_sort.add(e);
	 }
	 
	 public String getbsis() {
		 return bsis;
	 }

}