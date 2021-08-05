package com.repository;


import com.entity.processdata;
import com.entity.coadata;
import com.entity.financialstatements;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.repository.query.Param;

public interface financialstatementsRepository extends JpaRepository<financialstatements, Integer> {

	
	@Query("select m from financialstatements m left join fetch m.coagroupdata where m.name = :name")
	//@EntityGraph(attributePaths = {"coadata, coagroupdata"}, type = EntityGraph.EntityGraphType.LOAD)
	financialstatements findByname(@Param("name") String name);  //@Param("name") 

} // The End...
