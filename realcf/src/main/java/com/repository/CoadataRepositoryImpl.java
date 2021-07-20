package com.repository;

import com.entity.Role;
import com.entity.coadata;
import com.entity.coadata;
import com.entity.member;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import org.springframework.stereotype.Component;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Component
public class CoadataRepositoryImpl implements CustomCoadataRepository {


    @PersistenceContext
    EntityManager em;
    
	@Transactional
	public List<coadata> getprocessquery(String name1, String name2, String para1, String para2){
        
		List<coadata> process = new ArrayList<coadata>();
		
		StringBuilder jpql = new StringBuilder("select m from coadata m where ");
		List<String> criteria = new ArrayList<String>();
        		
		criteria.add("m." + name1 + " = :name1 and ");
		criteria.add("m." + name2 + " = :name2");
		jpql.append(criteria.get(0));
		jpql.append(criteria.get(1));
		
		process = em.createQuery(jpql.toString(), coadata.class)
		        .setParameter("name1", para1)
		        .setParameter("name2", para2)
		        .getResultList();
        
		System.out.println("success");
		
		
		return process;
	}
	
	
	@Transactional
	public List<coadata> getprocessquery(ArrayList<String> names, ArrayList<String> paras){
        
		List<coadata> process = new ArrayList<coadata>();
		
		StringBuilder jpql = new StringBuilder("select m from coadata m where ");
		List<String> criteria = new ArrayList<String>();
        
		int num = 0;
		for(String i : names) {
			num += 1;
			
			if(num == names.size()) {
				criteria.add("m." + i + " = :name" + num);
			}else {
				criteria.add("m." + i + " = :name" + num + " and ");
			}
			jpql.append(criteria.get(criteria.size() - 1));
		}
		
		TypedQuery<coadata> abc = em.createQuery(jpql.toString(), coadata.class);
		
		num = 0;
		for(String i : paras) {
			num += 1;
			abc = abc.setParameter("name" + num, i);
		}
        
		System.out.println("success");
		
		return abc.getResultList();
	}	    
	
} // The End...
