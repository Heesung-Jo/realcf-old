package com.model;


import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * @author Rob Winch
 * @author Mick Knutson
 * @since chapter 03.00
 */
public class SignupForm {

    @NotEmpty(message="First Name is required")
    private String name;
    @Email(message="Please provide a valid email address")
    @NotEmpty(message="Email is required")
    private String email;
    @NotEmpty(message="Password is required")
    private String password;

    /**
     * Gets the email address for this user.
     *
     * @return
     */
    public String getEmail() {
        return email;
    }

    /**
     * Gets the first name of the user.
     *
     * @return
     */
    public String getname() {
        return name;
    }

    /**
     * Gets the last name of the user.
     *
     * @return
     */

    /**
     * Gets the password for this user.
     *
     * @return
     */
    public String getPassword() {
        return password;
    }

    public void setEmail(String email) {
        this.email = email;
    }
    public void setname(String name) {
        this.name = name;
    }
    public void setPassword(String password) {
        this.password = password;
    }

 

}
