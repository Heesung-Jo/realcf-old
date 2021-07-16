package com.userdetail;

import com.userdetail.memberAuthorityUtils;
import com.repository.memberdao;
import com.entity.member;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import java.util.Collection;

/**
 * Integrates with Spring Security using our existing {@link memberdao} by looking up a {@link member} and
 * converting it into a {@link UserDetails} so that Spring Security can do the username/password comparison for us.
 *
 * @author Rob Winch
 * @ see CalendarUserAuthenticationProvider
 */
@Component
public class memberDetailsService implements UserDetailsService {

    private final memberdao memberdao;

    @Autowired
    public memberDetailsService(memberdao memberdao) {
        if (memberdao == null) {
            throw new IllegalArgumentException("memberdao cannot be null");
        }
        this.memberdao = memberdao;
    }

    /**
     * Lookup a {@link member} by the username representing the email address. Then, convert the
     * {@link member} into a {@link UserDetails} to conform to the {@link UserDetails} interface.
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        member user = memberdao.findUserByEmail(username);
        if (user == null) {
            throw new UsernameNotFoundException("Invalid username/password.");
        }
        return new memberrUserDetails(user);
    }

    /**
     * There are advantages to creating a class that extends {@link member}, our domain notion of a user, and
     * implements {@link UserDetails}, Spring Security's notion of a user.
     * <ul>
     * <li>First we can obtain all the custom information in the {@link member}</li>
     * <li>Second, we can use this service to integrate with Spring Security in other ways (i.e. when implementing
     * Spring Security's <a
     * href="http://static.springsource.org/spring-security/site/docs/current/reference/remember-me.html">Remember-Me
     * Authentication</a></li>
     * </ul>
     *
     * @author Rob Winch
     *
     */
    private final class memberrUserDetails extends member implements UserDetails {
        memberrUserDetails(member user) {
            setId(user.getId());
            setEmail(user.getEmail());
            setname(user.getname());
            setPassword(user.getPassword());
        }

        @Override
        public Collection<? extends GrantedAuthority> getAuthorities() {
            return memberAuthorityUtils.createAuthorities(this);
        }

        @Override
        public String getUsername() {
            return getEmail();
        }

        @Override
        public boolean isAccountNonExpired() {
            return true;
        }

        @Override
        public boolean isAccountNonLocked() {
            return true;
        }

        @Override
        public boolean isCredentialsNonExpired() {
            return true;
        }

        @Override
        public boolean isEnabled() {
            return true;
        }

        private static final long serialVersionUID = 3384436451564509032L;
    }
}
