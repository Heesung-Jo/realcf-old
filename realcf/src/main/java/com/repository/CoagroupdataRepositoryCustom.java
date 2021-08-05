package com.repository;


import com.entity.processdata;
import com.entity.coadata;
import com.entity.coagroupdata;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


public interface CoagroupdataRepositoryCustom  {


	List<coagroupdata> getprocessquery(String name1, String name2, String para1, String para2);
	coagroupdata getprocessquery(ArrayList<String> names, ArrayList<String> paras);
	List<coagroupdata> getprocessquery(ArrayList<String> businesses, ArrayList<String> coas, ArrayList<String> companys);
	List<Object[]> findmaxval(String coa);
	List<Object[]> findmaxval(List<String> coa);

} // The End...
