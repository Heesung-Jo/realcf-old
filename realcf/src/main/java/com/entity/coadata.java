package com.entity; 

 import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
public class coadata { 

	
	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	
	
	 private String name; // 계정과목 이름을 말함 // 세부분류 계정과목을 뜻함
	 private String reportname; // 사업보고서 상의 계정과목 이름을 말함
	 
	 @Column(nullable = true) 
	 private double val;        // 금액을 의미함 
	 private int year;          // 2020년 등 결산기간을 의미함
	 private String bspl;       // BS/IS/CF를 의미함
	 private String company;    // 사실 아래의 financialstatements이나, 여기서 간단히 string만으로 조회가능토록 구상
	 private double number;        // 나중에 회사의 재무제표를 순서대로 보여줄수있도록 number 계정 설정함

	 private double level;         // 레벨에 관련된 열 
	 private String parent;        // 부모와 관련된 열
	 
	 @ManyToOne
     @JoinColumn(name = "financialstatements_id")
     private financialstatements financialstatements;

	 
	 public coadata() {
		 
	 }

	 public void setparent(String parent) {
		 this.parent = parent;
	 }
	 
	 public String getparent() {
		 return parent;
	 }

	 
	 public void setlevel(double level) {
		 this.level = level;
	 }
	 
	 public double getlevel() {
		 return level;
	 }

	 
	 public void setnumber(double number) {
		 this.number = number;
	 }
	 
	 public double getnumber() {
		 return number;
	 }

	 public void setbspl(String val) {
		 this.bspl = val;
	 }
	 
	 public String getbspl() {
		 return bspl;
	 }
	 
	 public void setcompany(String val) {
		 this.company = val;
	 }
	 
	 public String getcompany() {
		 return company;
	 }

	 
	 
	 
	 public void setreportname(String val) {
		 this.reportname = val;
	 }
	 
	 public String getreportname() {
		 return reportname;
	 }
	 public void setyear(int year) {
		 this.year = year;
	 }
	 
	 public int getyear() {
		 return year;
	 }

	 
	 
	 public void setval(double val) {
		 this.val = val;
	 }
	 
	 public double getval() {
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

     public void setfinancialstatements(financialstatements x){ 
         this.financialstatements = x; 
     }
     
     public financialstatements getfinancialstatements(){ 
         return financialstatements; 
     }

}