package com.entity; 

 import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import java.util.*;

import javax.inject.Inject;
import java.time.LocalDateTime;

@Entity
public class financialstatements { 

	
	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	
	
	 private String name; // 회사이름을 의미
	 private int year;    // 사업보고서 연도

	 @OneToMany(mappedBy = "financialstatements", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	 private Set<coadata> coadata = new HashSet<>();
	 
	 
	 public financialstatements() {
		 
	 }

	 
	 public void setyear(int val) {
		 this.year = val;
	 }
	 
	 public int getyear() {
		 return this.year;
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

     public void setcoadata(HashSet<coadata> act) {
    	 this.coadata = act;
     }

     public void addcoadata(coadata act) {
    	 this.coadata.add(act);
    	 act.setfinancialstatements(this);
     }

     public Set<coadata> getcoadata() {
    	 return coadata;
     }

}