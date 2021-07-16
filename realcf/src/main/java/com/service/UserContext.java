package com.service;

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

    /**
     * Gets the currently logged in {@link member} or null if there is no authenticated user.
     *
     * @return
     */
    member getCurrentUser();

    /**
     * Sets the currently logged in {@link member}.
     * @param user the logged in {@link member}. Cannot be null.
     * @throws IllegalArgumentException if the {@link member} is null.
     */
    void setCurrentUser(member user);
}
