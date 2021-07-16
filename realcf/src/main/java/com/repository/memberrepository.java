package com.repository;

import com.entity.member;
import com.entity.member;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public class memberrepository  {

    @PersistenceContext
    EntityManager em;

    @Transactional
    public member save(member pro) {
    	
    	if (pro.getId() == null) {
	    	em.persist(pro);
	    } else {
	    	em.merge(pro);
	    }
    	em.flush();
    	return pro;
    }
    
    public member findByEmail(String name) {
        return em.createQuery("select m from member m where m.email = :name", member.class)
                .setParameter("name", name)
                .getResultList().get(0);
    }

    public member getOne(int id) {
    	return em.find(member.class, id);
    }
    
    
    public List<member> findAll() {
        return em.createQuery("select m from member m", member.class)
                             .getResultList();
    }
    
} // The End...
