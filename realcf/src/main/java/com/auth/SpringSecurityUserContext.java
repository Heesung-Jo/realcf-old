package com.auth;

import com.entity.member;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;
import com.service.memberService;
import org.springframework.security.oauth2.core.user.OAuth2User;

/**
 * An implementation of {@link UserContext} that looks up the {@link member} using the Spring Security's
 * {@link Authentication} by principal name.
 *
 * TODO: How and when does this get called?
 *
 * @author Rob Winch
 *
 */

@Component
public class SpringSecurityUserContext implements UserContext {

    private static final Logger logger = LoggerFactory
            .getLogger(SpringSecurityUserContext.class);

    private final memberService memberService;
 

    @Autowired
    public SpringSecurityUserContext(final memberService memberService
                                  ) {
        if (memberService == null) {
            throw new IllegalArgumentException("calendarService cannot be null");
        }
   
        this.memberService = memberService;
     
    }

     @Override
    public member getCurrentUser() {
        SecurityContext context = SecurityContextHolder.getContext();
        Authentication authentication = context.getAuthentication();
        if (authentication == null) {
            return null;
        }

        OAuth2User user = (OAuth2User)authentication.getPrincipal();
        String email = (String) user.getAttributes().get("email");
        if (email == null) {
            return null;
        }
        
        member result = memberService.findUserByEmail(email);
        if (result == null) {
            throw new IllegalStateException(
                    "Spring Security is not in synch with members. Could not find user with email " + email);
        }

        logger.info("member: {}", result);
        return result;
    }
/*
    @Override
    public void setCurrentUser(member user) {
        if (user == null) {
            throw new IllegalArgumentException("user cannot be null");
        }
        UserDetails userDetails = userDetailsService.loadUserByUsername(user.getEmail());
        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(userDetails,
                user.getPassword(), userDetails.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(authentication);
    }
*/
     
} // The End...
