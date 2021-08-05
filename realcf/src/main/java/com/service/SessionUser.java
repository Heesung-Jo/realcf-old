package com.service;


import java.io.Serializable;
import com.entity.member;

public class SessionUser implements Serializable {
   private String name;
   private String email;

   public SessionUser(member member) {
       this.name = member.getName();
       this.email = member.getEmail();
  
   }
   
   public String getEmail() {
       return email;
   }
   public void setEmail(String email) {
       this.email = email;
   }
   public String getName() {
       return name;
   }
   public void setName(String name) {
       this.name = name;
   }

   
   
}
