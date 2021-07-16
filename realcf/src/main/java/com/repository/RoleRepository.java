package com.repository;

import com.entity.Role;
import com.entity.processdata;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public class RoleRepository {

    @PersistenceContext
    EntityManager em;

    @Transactional
    public void save(Role pro) {
    	
    	if (pro.getId() == null) {
	    	em.persist(pro);
	    } else {
	    	em.merge(pro);
	    }
    }
    
    public Role findByEmail(String name) {
        return em.createQuery("select m from Role m where m.email = :name", Role.class)
                .setParameter("name", name)
                .getResultList().get(0);
    }

    public Role getOne(int id) {
    	return em.find(Role.class, id);
    }
	
	
} // The End...
