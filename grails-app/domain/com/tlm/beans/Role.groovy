package com.tlm.beans

class Role {
	
	static transients = ['SUBSCRIBER']
    static constraints = {
		roleName(blank: false, nullable: false, validator: { return it.startsWith("ROLE_")})
		description()
    }

    static hasMany = [users: User]
	
	String roleName
	String description
	
	static String SUBSCRIBER="ROLE_SUBSCRIBER" 
		
	String toString() {
		roleName
	}
	void setUsers(users){
		this.users=users	
	}
}
