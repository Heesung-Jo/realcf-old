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

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

@Entity
@Table
public class processdata { 
	
	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	
	
	 private String name; 

	 @OneToMany(mappedBy = "processdata", cascade = CascadeType.ALL)
	 private List<teamdata> teamdata = new ArrayList<>();

	 /* 나중에 부모 및 자식 노드 추가를 위한 것음
	 @OneToMany(mappedBy = "processdata", cascade = CascadeType.ALL)
	 private List<nodedata> nodedata = new ArrayList<>();
     
     */
	 
	 @OneToMany(mappedBy = "processdata", cascade = CascadeType.ALL)
	 private List<childnodedata> childnodedata = new ArrayList<>();

	 @OneToMany(mappedBy = "processdata", cascade = CascadeType.ALL)
	 private List<parentnodedata> parentnodedata = new ArrayList<>();
	 

	 
	 // childnode 관련
     public void setchildnodedata(List<childnodedata> act) {
    	 this.childnodedata = act;
     }

     public void addchildnodedata(childnodedata act) {
    	 this.childnodedata.add(act);
    	 act.setprocessdata(this);
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
    	 act.setprocessdata(this);
     }

     public List<parentnodedata> getparentnodedata() {
    	 return parentnodedata;
     }	 
	 
	 //210419 추가함 나중에 항목을 더 늘려야함
	 private String businesscode;
	 private String companyname;
	 private String processcode;
	 private String processname;
	 private String subprocesscode;
	 private String subprocess;
	 private String riskcode;
	 private String risk;
	 private String riskgrade;
	 private String detailprocess;
	 private String detailprocessname;
	 private String processexplain;
	 private String controlcode;
	 private String controlname;
	 private String controlexplain;

	 public void setbusinesscode(String x){
	        this.businesscode = x;
	}
	public String getbusinesscode(){
	        return businesscode;
	}
	public void setcompanyname(String x){
	        this.companyname = x;
	}
	public String getcompanyname(){
	        return companyname;
	}
	public void setprocesscode(String x){
	        this.processcode = x;
	}
	public String getprocesscode(){
	        return processcode;
	}
	public void setprocessname(String x){
	        this.processname = x;
	}
	public String getprocessname(){
	        return processname;
	}
	public void setsubprocesscode(String x){
	        this.subprocesscode = x;
	}
	public String getsubprocesscode(){
	        return subprocesscode;
	}
	public void setsubprocess(String x){
	        this.subprocess = x;
	}
	public String getsubprocess(){
	        return subprocess;
	}
	public void setriskcode(String x){
	        this.riskcode = x;
	}
	public String getriskcode(){
	        return riskcode;
	}
	public void setrisk(String x){
	        this.risk = x;
	}
	public String getrisk(){
	        return risk;
	}
	public void setriskgrade(String x){
	        this.riskgrade = x;
	}
	public String getriskgrade(){
	        return riskgrade;
	}
	public void setdetailprocess(String x){
	        this.detailprocess = x;
	}
	public String getdetailprocess(){
	        return detailprocess;
	}
	public void setdetailprocessname(String x){
	        this.detailprocessname = x;
	}
	public String getdetailprocessname(){
	        return detailprocessname;
	}
	public void setprocessexplain(String x){
	        this.processexplain = x;
	}
	public String getprocessexplain(){
	        return processexplain;
	}
	public void setcontrolcode(String x){
	        this.controlcode = x;
	}
	public String getcontrolcode(){
	        return controlcode;
	}
	public void setcontrolname(String x){
	        this.controlname = x;
	}
	public String getcontrolname(){
	        return controlname;
	}
	public void setcontrolexplain(String x){
	        this.controlexplain = x;
	}
	public String getcontrolexplain(){
	        return controlexplain;
	}

	 // 210419 여기까지 추가됨
	 
	 
	 
	 public processdata() {
		 
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

     public void setteamdata(List<teamdata> act) {
    	 this.teamdata = act;
     }

     public void addteamdata(teamdata act) {
    	 this.teamdata.add(act);
    	 act.setprocessdata(this);
     }

     public List<teamdata> getteamdata() {
    	 return teamdata;
     }

     /* 나중을 위한 것임 위 참고할 것
     public void setnodedata(List<nodedata> act) {
    	 this.nodedata = act;
     }

     public void addnodedata(nodedata act) {
    	 this.nodedata.add(act);
    	 act.setprocessdata(this);
     }

     public List<nodedata> getnodedata() {
    	 return nodedata;
     }
     */
     
     
     

}