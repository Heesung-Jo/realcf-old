package com.repository;

import com.entity.Role;
import com.entity.processdata;
import com.entity.coadata;
import com.entity.financialstatements;
import com.entity.coagroupdata;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


public interface CoagroupdataRepository extends JpaRepository<coagroupdata, Integer>, CoagroupdataRepositoryCustom {
	coagroupdata findByname(String name);
	coagroupdata findByCompanyAndLevelAndName(String company, double level, String name);
} // The End...
