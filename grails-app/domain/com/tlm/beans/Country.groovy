package com.tlm.beans
import java.sql.Blob

class Country {

    static constraints = {
      image(nullable: true)
    }    
    static hasMany = [users: User]

    // data fields
    String code
    String title
    String image
	
    static mapping = { sort "title" }
	
	String toString() {
		title
	}
	void setUsers(users){
		this.users=users	
	}
}
