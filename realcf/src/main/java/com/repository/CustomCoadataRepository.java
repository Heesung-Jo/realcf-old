package com.repository;

import com.entity.Role;
import com.entity.processdata;
import com.entity.coadata;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


public interface CustomCoadataRepository  {


	List<coadata> getprocessquery(String name1, String name2, String para1, String para2);
	List<coadata> getprocessquery(ArrayList<String> names, ArrayList<String> paras);
} // The End...
