package com.entity; 

 import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity; 

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

import org.springframework.stereotype.*;


import javax.inject.Inject;

@Entity
public class childnodedata { 

	
	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	
	
	 private String name; 
	 private String val;
	 private String subprocess;

	 @ManyToOne
     @JoinColumn(name = "processdata_id")
     private processdata processdata;

	 
	 public childnodedata() {
		 
	 }
	 public void setsubprocess(String val) {
		 this.subprocess = val;
	 }
	 
	 public String getsubprocess() {
		 return subprocess;
	 }
           
	 public void setval(String val) {
		 this.val = val;
	 }
	 
	 public String getval() {
		 return val;
	 }
	 
     public void setid(Long x){ 
         this.id = x; 
     }
     
     public Long getid(){ 
         return id; 
     }
     
     public void setname(String x){ 
         this.name = x; 
     }
     
     public String getname(){ 
         return name; 
     }


     public void setprocessdata(processdata x){ 
         this.processdata = x; 
     }
     
     public processdata getprocessdata(){ 
         return processdata; 
     }

     
}