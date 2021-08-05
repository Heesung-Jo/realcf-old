package com.auth;

import com.entity.member;

/**
 * Manages the current {@link member}. This demonstrates how in larger applications it is good to abstract out
 * accessing the current user to return the application specific user rather than interacting with Spring Security
 * classes directly.
 *
 * @author Rob Winch
 *
 */

public interface UserContext {

 
    member getCurrentUser();

 
   // void setCurrentUser(member user);
}
