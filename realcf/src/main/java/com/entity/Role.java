package com.entity;


import javax.persistence.*;
import java.io.Serializable;
import java.util.Set;

/**
 *
 * @author Mick Knutson
 */
public enum Role {

	   GUSET("ROLE_GUEST", "손님"),
	   USER("ROLE_USER", "일반 사용자");

	   private final String key;
	   private final String title;
	   
	   Role(String key, String title) {
	        this.key = key;
	        this.title = title;
	    }

	    public String getKey() {
	        return this.key;
	    }


	    public String gettitle() {
	        return this.title;
	    }	   
	   
	} // The End...