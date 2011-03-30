package com.tlm.beans

class LookupHonorific {

    static constraints = {
    }
    static hasMany = [users: User]

    String type
	
	String toString() {
		type
	}
	void setUsers(users){
		this.users=users	
	}
}
