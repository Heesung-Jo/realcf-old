package com.repository;

import com.entity.processdata;
import com.entity.coadata;
import com.entity.teamdata;


import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import java.util.ArrayList;
import java.util.List;

/**
 * User: HolyEyE
 * Date: 2013. 12. 3. Time: 오전 1:08
 */
@Repository
public class teamrepository {

    @PersistenceContext
    EntityManager em;


    @Transactional
    public List<teamdata> findByName(String name) {
        return em.createQuery("select m from teamdata m where m.name = :name", teamdata.class)
                .setParameter("name", name)
                .getResultList();
    }
    

 
    
    
}
