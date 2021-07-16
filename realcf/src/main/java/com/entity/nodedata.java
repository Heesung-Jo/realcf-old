package com.entity; 

 import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity;
import javax.persistence.CascadeType;
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
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.springframework.stereotype.*;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

@Entity
public class nodedata { 

	 // 210506 현재는 쓰지 않고 있으며, 나중에 자식과 부모 노드가 여러개가 발생하는 것을 대비하기 위해서 만들었음
	
	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	
	
	 private String name; 
	 private String val;
	 private String subprocess;

	 
	 public nodedata() {
		 
	 }
	 
	 /*
	 
	 @ManyToOne
     @JoinColumn(name = "processdata_id")
     private processdata processdata;

	 
	 @OneToMany(mappedBy = "nodedata", cascade = CascadeType.ALL)
	 private List<childnodedata> childnodedata = new ArrayList<>();

	 @OneToMany(mappedBy = "nodedata", cascade = CascadeType.ALL)
	 private List<parentnodedata> parentnodedata = new ArrayList<>();
	 
	 

           
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

	 public void setsubprocess(String val) {
		 this.subprocess = val;
	 }
	 
	 public String getsubprocess() {
		 return subprocess;
	 }

	 // childnode 관련
     public void setchildnodedata(List<childnodedata> act) {
    	 this.childnodedata = act;
     }

     public void addchildnodedata(childnodedata act) {
    	 this.childnodedata.add(act);
    	 act.setnodedata(this);
     }

     public List<childnodedata> getchildnodedata() {
    	 return childnodedata;
     }

     // parentnode 관련
     public void setparentnodedata(List<parentnodedata> act) {
    	 this.parentnodedata = act;
     }

     public void addparentnodedata(parentnodedata act) {
    	 this.parentnodedata.add(act);
    	 act.setnodedata(this);
     }

     public List<parentnodedata> getparentnodedata() {
    	 return parentnodedata;
     }	 
	 
     */
}