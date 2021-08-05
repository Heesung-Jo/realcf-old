package com.entity;


import javax.persistence.*;
import java.io.Serializable;
import java.util.Set;

/**
 *
 * @author Mick Knutson
 */
/*
@Entity
@Table(name = "role")
public class Role3  implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
    private String name;

    @ManyToMany(fetch = FetchType.EAGER, mappedBy = "roles")
    private Set<member> users;

    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public Set<member> getUsers() {
        return users;
    }
    public void setUsers(Set<member> users) {
        this.users = users;
    }


  

} // The End...*/