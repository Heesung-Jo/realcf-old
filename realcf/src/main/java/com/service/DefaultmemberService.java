package com.service;

import java.util.List;

import com.repository.memberrepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Repository;

import com.repository.memberdao;
import com.repository.RoleRepository;

import com.entity.member;
import com.entity.Role;

/**
 * A default implementation of {@link memberService} that delegates to {@link EventDao} and {@link memberdao}.
 *
 * @author Rob Winch
 * @author Mick Knutson
 *
 */
@Repository
public class DefaultmemberService implements memberService {

    private static final Logger logger = LoggerFactory
            .getLogger(DefaultmemberService.class);

    @Autowired
    private memberdao userDao;
  //  private final PasswordEncoder passwordEncoder;
    @Autowired
    private memberrepository userRepository;

    @Autowired
    private RoleRepository rolerepository;

    
    @Autowired
    public DefaultmemberService(
                                  memberdao userDao,
                                  memberrepository userRepository,
                                  RoleRepository rolerepository
                                  //final PasswordEncoder passwordEncoder
                                  ) {
        if (userDao == null) {
            throw new IllegalArgumentException("userDao cannot be null");
        }
        if (userRepository == null) {
            throw new IllegalArgumentException("userRepository cannot be null");
        }
        /*
        if (passwordEncoder == null) {
            throw new IllegalArgumentException("passwordEncoder cannot be null");
        }
        */
        
        this.userDao = userDao;
        this.rolerepository = rolerepository;

		// role 세팅
		Role role = new Role();
		role.setName("ROLE_USER");
		rolerepository.save(role);
		
		// 기본 아이디 세팅
		
        member user = new member();
        user.setEmail("gochoking@naver.com");
        user.setname("jo hee sung");
        user.setPassword("{noop}1234");

     //   logger.info("CalendarUser: {}", user);

        System.out.println("여기가 문제니");
        int member = createUser(user);
		

        
       // this.passwordEncoder = passwordEncoder;
    }


    @Override
    public member getUser(int id) {
        return userDao.getUser(id);
    }

    @Override
    public member findUserByEmail(String email) {
        return userDao.findUserByEmail(email);
    }

    @Override
    public List<member> findUsersByEmail(String partialEmail) {
        return userDao.findUsersByEmail(partialEmail);
    }

    /**
     * Create a new Signup User
     * @param user
     *            the new {@link member} to create. The {@link member#getId()} must be null.
     * @return
     */
    @Override
    public int createUser(member user) {
        String encodedPassword = user.getPassword(); // passwordEncoder.encode(user.getPassword());
        user.setPassword(encodedPassword);
        int id = userDao.createUser(user);
        
        return id;
    }

    
    
    
    

} // The End...
