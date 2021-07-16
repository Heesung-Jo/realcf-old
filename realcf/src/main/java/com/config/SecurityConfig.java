package com.config;


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
import org.springframework.security.oauth2.client.registration.ClientRegistration; 
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository; 
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository; 
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;
import org.springframework.security.crypto.password.PasswordEncoder;

//import com.packtpub.springsecurity.configuration.BCryptPasswordEncoder;
//import com.packtpub.springsecurity.configuration.PasswordEncoder;
import static com.auth.SocialType.*;

import org.springframework.security.config.annotation.web.builders.WebSecurity;

//import service.CalendarUserDetailsService;

import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.method.configuration.GlobalMethodSecurityConfiguration;

import com.service.memberService;
import com.userdetail.memberDetailsService;

/**
 * Spring Security Config Class
 * @see WebSecurityConfigurerAdapter
 */
@Configuration
@EnableWebSecurity(debug = true)
@EnableGlobalMethodSecurity(securedEnabled=true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    private static final Logger logger = LoggerFactory
            .getLogger(SecurityConfig.class);

    
    /**
     * Configure AuthenticationManager with inMemory credentials.
     *
     * @param auth       AuthenticationManagerBuilder
     * @throws Exception Authentication exception
     */
    
    @Autowired
    private memberDetailsService memberDetailsService;


    
    @Override
    @Autowired
    public void configure(final AuthenticationManagerBuilder auth) throws Exception {

    /*
    	auth.inMemoryAuthentication()
        .withUser("user").password("{noop}user").roles("USER")
        .and().withUser("admin").password("{noop}admin").roles("ADMIN")
        .and().withUser("user1@example.com").password("{noop}user1").roles("USER")
        .and().withUser("admin1@example.com").password("{noop}admin1").roles("USER", "ADMIN")
     ;
    */
        logger.info("***** Password for user 'user1@example.com' is 'user1'");
        auth
        .userDetailsService(memberDetailsService);
       // .passwordEncoder(passwordEncoder());

    
    
    }

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
        
        
        http.authorizeRequests()
      
       .antMatchers("/thymeleaf/*").permitAll()
       .antMatchers("/**").hasRole("USER")
       .antMatchers("/google").hasAuthority(GOOGLE.getRoleType())
       .anyRequest().authenticated()
       .and()
       .logout()
       .logoutSuccessUrl("/")
       
       .and().oauth2Login()
        .defaultSuccessUrl("/view/loginSuccess", true)
        .and() .exceptionHandling() 
        .authenticationEntryPoint(new LoginUrlAuthenticationEntryPoint("/thymeleaf/login"))

     //   .permitAll()
     .and().httpBasic()
     .and().csrf().disable();

        
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
    
    }


    
    
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
