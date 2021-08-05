package com.service;


import com.repository.memberdao;
import com.repository.memberrepository;
import com.entity.Role;
import com.entity.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import java.util.Collection;
import java.util.Collections;
import java.util.Map;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;

import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import javax.servlet.http.HttpSession;



/**
 * Integrates with Spring Security using our existing {@link memberdao} by looking up a {@link member} and
 * converting it into a {@link UserDetails} so that Spring Security can do the username/password comparison for us.
 *
 * @author Rob Winch
 * @ see CalendarUserAuthenticationProvider
 */

@Service
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User>  {
    
	@Autowired
	private memberrepository userRepository;

	//@Autowired
	//private final HttpSession httpSession; 
	
	@Autowired
	private memberdao memberdao;	

/*	
    @Autowired
    public CustomOAuth2UserService(memberrepository userRepository
    		, memberdao memberdao) {
    	System.out.println("이거 만들어지는거니");
    	this.userRepository = userRepository;
    	//this.httpSession = httpSession;
    	this.memberdao = memberdao;
    }
 */
	
	
    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2UserService delegate = new DefaultOAuth2UserService();
        OAuth2User oAuth2User = delegate.loadUser(userRequest);

        String registrationId = userRequest.getClientRegistration().getRegistrationId();
        String userNameAttributeName = userRequest.getClientRegistration()
                .getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName();

        
        Map<String, Object> attributes = oAuth2User.getAttributes();

        member member = new member();
        member.setEmail((String) attributes.get("email"));
        member.setname((String) attributes.get("name"));
        member.setRole(Role.USER);
        
        System.out.println(member.getname());
        System.out.println(member.getEmail());
        
        int mem = memberdao.createUser(member);
        
       // httpSession.setAttribute("member", userRepository.getOne(mem));
        
        
        return new DefaultOAuth2User(
                Collections.singleton(new SimpleGrantedAuthority("ROLE_USER")),
                attributes, userNameAttributeName);
    }


 
}
