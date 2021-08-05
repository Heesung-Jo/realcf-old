package com.config;



import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;



import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.*;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.beans.factory.annotation.Autowired; 
import org.springframework.beans.factory.annotation.Value; 
import org.springframework.boot.autoconfigure.security.oauth2.client.OAuth2ClientProperties; 
import org.springframework.boot.autoconfigure.security.oauth2.client.*;
import org.springframework.context.annotation.Bean; 
import org.springframework.context.annotation.Configuration; 
import org.springframework.security.config.annotation.web.builders.HttpSecurity; 
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity; 
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter; 
import org.springframework.security.config.oauth2.client.CommonOAuth2Provider;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserRequest;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserService;
import org.springframework.security.oauth2.client.registration.ClientRegistration; 
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository; 
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;

import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.oauth2.core.OAuth2AccessToken;

import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;
import org.springframework.security.crypto.password.PasswordEncoder;
import java.util.*;
//import com.packtpub.springsecurity.configuration.BCryptPasswordEncoder;
//import com.packtpub.springsecurity.configuration.PasswordEncoder;


import java.util.Collections;
import java.util.Map;

import org.springframework.security.config.annotation.web.builders.WebSecurity;

//import service.CalendarUserDetailsService;

import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.method.configuration.GlobalMethodSecurityConfiguration;

import com.service.memberService;

import com.entity.Role;
import com.entity.member;
import com.repository.memberdao;
import com.service.CustomOAuth2UserService;
import javax.servlet.http.HttpSession;
/**
 * Spring Security Config Class
 * @see WebSecurityConfigurerAdapter
 */
@Configuration
@EnableWebSecurity//(debug = true) //@EnableGlobalMethodSecurity(securedEnabled=true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    private static final Logger logger = LoggerFactory
            .getLogger(SecurityConfig.class);

    @Autowired
    private HttpSession httpSession;
    /**
     * Configure AuthenticationManager with inMemory credentials.
     *
     * @param auth       AuthenticationManagerBuilder
     * @throws Exception Authentication exception
     */
    
  //  @Autowired
  //  private memberDetailsService memberDetailsService;
    
    @Autowired
    private CustomOAuth2UserService customOAuth2UserService;
    
 //   @Override
  //  @Autowired
  //  public void configure(final AuthenticationManagerBuilder auth) throws Exception {

    /*
    	auth.inMemoryAuthentication()
        .withUser("user").password("{noop}user").roles("USER")
        .and().withUser("admin").password("{noop}admin").roles("ADMIN")
        .and().withUser("user1@example.com").password("{noop}user1").roles("USER")
        .and().withUser("admin1@example.com").password("{noop}admin1").roles("USER", "ADMIN")
     ;
    */
    	/*
        logger.info("***** Password for user 'user1@example.com' is 'user1'");
        auth
        .userDetailsService(memberDetailsService);
       // .passwordEncoder(passwordEncoder());
*/
    
    
   // }

/*    
    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder(4);
    }
*/
 
    @Override
    protected void configure(final HttpSecurity http) throws Exception {

    /*	
        http.authorizeRequests().anyRequest().authenticated()
            .and().formLogin().and()
            .httpBasic();
      */  
                // CSRF is enabled by default, with Java Config
       //         .and().csrf().disable();
        	
        System.out.println(90090);
        System.out.println(90090);
        System.out.println(90090);
   /*
        http
        .authorizeRequests()
            .antMatchers("/oauth-login").permitAll() // login URL에는 누구나 접근 가능하게 합니다.
        .anyRequest().authenticated() // 그 이외에는 인증된 사용자만 접근 가능하게 합니다.
    .and()
    .oauth2Login(oauth2 -> oauth2
            .userInfoEndpoint(userInfo -> userInfo
                .oidcUserService(this.oidcUserService())));     
 */
       
        http
        .csrf().disable()
        .headers().frameOptions().disable() 
        .and()
        
        .authorizeRequests()
      
       .antMatchers("/thymeleaf/*").permitAll()
       .antMatchers("/**").hasRole("USER")
     //  .antMatchers("/google").hasAuthority(GOOGLE.getRoleType())
       .anyRequest().authenticated()
       .and()
       .logout()
       .logoutSuccessUrl("/")
       .and()
       .oauth2Login(oauth2 -> oauth2
                .userInfoEndpoint(userInfo -> userInfo
                    .oidcUserService(this.oidcUserService())
                .and().defaultSuccessUrl("/view/loginSuccess", true)));

        http.exceptionHandling() 
        .authenticationEntryPoint(new LoginUrlAuthenticationEntryPoint("/thymeleaf/login"));
        
//        http.defaultSuccessUrl("/view/loginSuccess", true);    
       
        /*
       http.oauth2Login().defaultSuccessUrl("/view/loginSuccess", true);
             .userInfoEndpoint()
       .userService(customOAuth2UserService);


    
                
     //   .permitAll()
     .and().httpBasic()
     .and().csrf().disable();

     */
        
        /*
      .formLogin()
       .loginPage("/thymeleaf/login")
       .loginProcessingUrl("/thymeleaf/login")
        //    .failureUrl("/login/form?error")
         //   .usernameParameter("username")
          //  .passwordParameter("password")
            .defaultSuccessUrl("/view/loginSuccess", true)
            .permitAll()
         .and().httpBasic()
         .and().csrf().disable();
       */
        System.out.println(90090);
        
       
        
        
    }

	@Autowired
	private memberdao memberdao;	

    
    private OAuth2UserService<OidcUserRequest, OidcUser> oidcUserService() {
        final OidcUserService delegate = new OidcUserService();

        return (userRequest) -> {
            // Delegate to the default implementation for loading a user
            OidcUser oidcUser = delegate.loadUser(userRequest);

            OAuth2AccessToken accessToken = userRequest.getAccessToken();
            Set<GrantedAuthority> mappedAuthorities = new HashSet<>();
            
            mappedAuthorities.add(new SimpleGrantedAuthority("ROLE_USER"));

            System.out.println("success");
            Map<String, Object> attributes = oidcUser.getAttributes();
            member member = new member();
            member.setEmail((String) attributes.get("email"));
            member.setname((String) attributes.get("name"));
            member.setRole(Role.USER);
            int mem = memberdao.createUser(member);
            System.out.println("success4");
            // TODO
            // 1) Fetch the authority information from the protected resource using accessToken
            // 2) Map the authority information to one or more GrantedAuthority's and add it to mappedAuthorities

            // 3) Create a copy of oidcUser but use the mappedAuthorities instead
            oidcUser = new DefaultOidcUser(mappedAuthorities, oidcUser.getIdToken(), oidcUser.getUserInfo());

            return oidcUser;
        };
    }
    
    /*
    @Override
    public void configure(final WebSecurity web) throws Exception {
    
    	//이렇게 해 놓아도 상관없이 돌아가는 것 보면, 현재까지는 큰 의미는 없는듯
    	// 차차 고민해볼 것
    	//    web.ignoring()
       //           .antMatchers("/resources/**")
        //          .antMatchers("/css/**")
                
        ;
    }
    
    
    /*
	@Bean
	public SpittleService SpittleService() {
		return new SecuredSpittleService();
	}
*/
} // The End...
