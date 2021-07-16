package com.service;

import java.util.List;

import org.springframework.dao.EmptyResultDataAccessException;

import com.entity.member;

public interface memberService {

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
     * @return a List of {@link member}s that have an email that starts with given partialEmail. The returned
     *         value will never be null. If no results are found an empty List will be returned.
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

    /**
     * Given an id gets an {@link Event}.
     *
     * @param eventId
     *            the {@link Event#getId()}
     * @return the {@link Event}. Cannot be null.
     * @throws RuntimeException
     *             if the {@link Event} cannot be found.
     */
  //  Event getEvent(int eventId);

    /**
     * Creates a {@link Event} and returns the new id for that {@link Event}.
     *
     * @param event
     *            the {@link Event} to create. Note that the {@link Event#getId()} should be null.
     * @return the new id for the {@link Event}
     * @throws RuntimeException
     *             if {@link Event#getId()} is non-null.
     */
  //  int createEvent(Event event);

    /**
     * Finds the {@link Event}'s that are intended for the {@link CalendarUser}.
     *
     * @param userId
     *            the {@link CalendarUser#getId()} to obtain {@link Event}'s for.
     * @return a non-null {@link List} of {@link Event}'s intended for the specified {@link CalendarUser}. If the
     *         {@link CalendarUser} does not exist an empty List will be returned.
     */
  //  List<Event> findForUser(int userId);

    /**
     * Gets all the available {@link Event}'s.
     *
     * @return a non-null {@link List} of {@link Event}'s
     */
   // List<Event> getEvents();
}
