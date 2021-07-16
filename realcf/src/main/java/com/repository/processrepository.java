package com.repository;

import com.entity.processdata;
import com.entity.coadata;
import com.entity.teamdata;
import com.entity.childnodedata;
import com.entity.parentnodedata;

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
public class processrepository {

    @PersistenceContext
    EntityManager em;

    @Transactional
    public void save(processdata pro) {

    	
    	// 프로세스의 내용이 이미 있는 거라면 덮어쓰도록 해야해서
    	String name = pro.getname();
    	List<processdata> list = em.createQuery("select m from processdata m where m.name = :name", processdata.class)
    	.setParameter("name", name).getResultList();
    	
    	if(list.isEmpty() == false) {
    		processdata pro_old = list.get(0);
    		pro.setid(pro_old.getid());
    		// 하부 클래스도 모두 id 갈아끼어주기
    		// 추가되는 클래스도 있으면 모두 수정하기
    		// 혹시 한번에 되는게 있는지 jpa 책 찾아볼 것
    	    pro.getcoadata().setid(pro_old.getcoadata().getid());
    	}

    	
    	if (pro.getid() == null) {
	    	em.persist(pro);
	    } else {
	    	em.merge(pro);
	    }
    }
    
    @Transactional
    public void test() {
    	processdata pro = new processdata();
    	pro.setname("조희성");
    	save(pro);
    }
   /*
    public Member findOne(Long id) {
        return em.find(Member.class, id);
    }
*/
    @Transactional
    public List<processdata> findAll() {
        return em.createQuery("select m from processdata m", processdata.class)
                .getResultList();
    }

    
    public List<processdata> findByName(String name) {
        return em.createQuery("select m from processdata m where m.processname = :name", processdata.class)
                .setParameter("name", name)
                .getResultList();
    }
    

    
	@Transactional
	public void savedata(processdata pro) {
		
		// 저장되었다는 의미의 컬럼
       // 본데이터 저장	    
		for(teamdata str :  pro.getteamdata()) {
			str.setprocessdata(pro);
		}

		for(childnodedata str :  pro.getchildnodedata()) {
			str.setprocessdata(pro);
		}

		for(parentnodedata str :  pro.getparentnodedata()) {
			str.setprocessdata(pro);
		}
		
		
		System.out.println(123);
		
	    if (pro.getid() == null) {
	    	em.persist(pro);
	    } else {
	         em.merge(pro);
	    }
	    
	}   
	
	
	// 조회 관련
	@Transactional
	public List<processdata> getprocessquery(String name, String para){
        
		List<processdata> process = new ArrayList<processdata>();
		
		StringBuilder jpql = new StringBuilder("select m from processdata m where ");
		List<String> criteria = new ArrayList<String>();
        		
		criteria.add("m." + name + " = :name");
		jpql.append(criteria.get(0));
		
		process = em.createQuery(jpql.toString(), processdata.class)
		        .setParameter("name", para)
		        .getResultList();
        
		System.out.println("success");
		
		
		return process;
	}
	
	
	
	@Transactional
	public List<processdata> getprocessquery(String name1, String name2, String para1, String para2){
        
		List<processdata> process = new ArrayList<processdata>();
		
		StringBuilder jpql = new StringBuilder("select m from processdata m where ");
		List<String> criteria = new ArrayList<String>();
        		
		criteria.add("m." + name1 + " = :name1 and ");
		criteria.add("m." + name2 + " = :name2");
		jpql.append(criteria.get(0));
		jpql.append(criteria.get(1));
		
		process = em.createQuery(jpql.toString(), processdata.class)
		        .setParameter("name1", para1)
		        .setParameter("name2", para2)
		        .getResultList();
        
		System.out.println("success");
		
		
		return process;
	}
	
	
	@Transactional
	public List<processdata> getprocessquery(ArrayList<String> names, ArrayList<String> paras){
        
		List<processdata> process = new ArrayList<processdata>();
		
		StringBuilder jpql = new StringBuilder("select m from processdata m where ");
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
		
		TypedQuery<processdata> abc = em.createQuery(jpql.toString(), processdata.class);
		
		num = 0;
		for(String i : paras) {
			num += 1;
			abc = abc.setParameter("name" + num, i);
		}
        
		System.out.println("success");
		
		return abc.getResultList();
	}	
	

	
	// 작업관련
	   @Transactional
	    public void setparentnodetotal() {
	    	List<processdata> pros = findAll();
	    	
	    	for(processdata pro : pros) {
	    		List<childnodedata> childs = pro.getchildnodedata();
	    		
	    		// 부모찾기
	    		for(childnodedata ch : childs) {
	    			String name = ch.getname();
	    			if(name.equals("start") == false) {
	    				processdata pro_ch = getprocessquery("detailprocessname", name).get(0);
	    				
	    				// 부모에 자식노드 만들기
	    				parentnodedata act = new parentnodedata();
	    				act.setname(pro.getdetailprocessname());
	    				act.setsubprocess(pro.getsubprocess());
	    				pro_ch.addparentnodedata(act);
	    			}
	    		}
	    		
	    	}
	    	
	    }	
	
    
}
