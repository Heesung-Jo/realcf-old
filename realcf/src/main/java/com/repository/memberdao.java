package com.repository;

import java.util.List;

import org.springframework.dao.EmptyResultDataAccessException;

import com.entity.member;

/**
 * An interface for managing {@link member} instances.
 *
 * @author Rob Winch
 *
 */
public interface memberdao {

    /**
     * Gets a {@link member} for a specific {@link member#getId()}.
     *
     * @param id
     *            the {@link member#getId()} of the {@link member} to find.
     * @return a {@link member} for the given id. Cannot be null.
     * @throws EmptyResultDataAccessException
     *             if the {@link member} cannot be found
     */
    member getUser(int id);

    /**
     * Finds a given {@link member} by email address.
     *
     * @param email
     *            the email address to use to find a {@link member}. Cannot be null.
     * @return a {@link member} for the given email or null if one could not be found.
     * @throws IllegalArgumentException
     *             if email is null.
     */
    member findUserByEmail(String email);


    /**
     * Finds any {@link member} that has an email that starts with {@code partialEmail}.
     *
     * @param partialEmail
     *            the email address to use to find {@link member}s. Cannot be null or empty String.
     * @return a List of {@link member}s that have an email that starts with given partialEmail. The returned value
     *         will never be null. If no results are found an empty List will be returned.
     * @throws IllegalArgumentException
     *             if email is null or empty String.
     */
    List<member> findUsersByEmail(String partialEmail);

    /**
     * Creates a new {@link member}.
     *
     * @param user
     *            the new {@link member} to create. The {@link member#getId()} must be null.
     * @return the new {@link member#getId()}.
     * @throws IllegalArgumentException
     *             if {@link member#getId()} is non-null.
     */
    int createUser(member user);
}
