package com.repository;


import com.entity.processdata;
import com.entity.coadata;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


public interface CoadataRepository extends JpaRepository<coadata, Integer>, CoadataRepositoryCustom {


	coadata findByname(String name);
	coadata findByreportname(String reportname);
	
} // The End...
