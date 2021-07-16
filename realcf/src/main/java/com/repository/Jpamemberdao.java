package com.repository;

import com.entity.member;
import com.entity.Role;
import com.repository.memberrepository;
import com.repository.RoleRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.repository.memberdao;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * A jdbc implementation of {@link memberdao}.
 *
 * @author Rob Winch
 * @author Mick Knutson
 *
 */
@Repository
public class Jpamemberdao implements memberdao {

    private static final Logger logger = LoggerFactory
            .getLogger(Jpamemberdao.class);

    // --- members ---
    @Autowired
    private memberrepository userRepository;
    @Autowired
    private RoleRepository roleRepository;

    // --- constructors ---

    @Autowired
    public Jpamemberdao(final memberrepository repository,
                              final RoleRepository roleRepository) {
        if (repository == null) {
            throw new IllegalArgumentException("repository cannot be null");
        }
        if (roleRepository == null) {
            throw new IllegalArgumentException("roleRepository cannot be null");
        }

        this.userRepository = repository;
        this.roleRepository = roleRepository;
    }

    // --- CalendarUserDao methods ---

   // @Override
    @Transactional(readOnly = true)
    public member getUser(final int id) {
    	
        return userRepository.getOne(id);
    }

    
  //  @Override
    @Transactional(readOnly = true)
    public member findUserByEmail(final String email) {
        if (email == null) {
            throw new IllegalArgumentException("email cannot be null");
        }
        try {
        	
            return userRepository.findByEmail(email);
        } catch (EmptyResultDataAccessException notFound) {
            return null;
        }
    }

    // TODO FIXME Need to add a LIKE clause
   // @Override
    @Transactional(readOnly = true)
    public List<member> findUsersByEmail(final String email) {
        if (email == null) {
            throw new IllegalArgumentException("email cannot be null");
        }
        if ("".equals(email)) {
            throw new IllegalArgumentException("email cannot be empty string");
        }
        return userRepository.findAll();
    }

    // @Override
    public int createUser(final member userToAdd) {
        if (userToAdd == null) {
            throw new IllegalArgumentException("userToAdd cannot be null");
        }
        if (userToAdd.getId() != null) {
            throw new IllegalArgumentException("userToAdd.getId() must be null when creating a "+member.class.getName());
        }

        Set<Role> roles = new HashSet<>();
        Role role = roleRepository.getOne(1);
        System.out.println(role.getName());
        roles.add(role);
        userToAdd.setRoles(roles);

        member result = userRepository.save(userToAdd);
        

        return result.getId();
    }

} // The End...
