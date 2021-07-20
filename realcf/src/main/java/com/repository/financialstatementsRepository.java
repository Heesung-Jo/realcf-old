package com.repository;

import com.entity.Role;
import com.entity.processdata;
import com.entity.coadata;
import com.entity.financialstatements;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


public interface financialstatementsRepository extends JpaRepository<financialstatements, Integer> {

	financialstatements findByname(String name);
	
} // The End...
