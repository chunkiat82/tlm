package com.tlm.beans

class JobPosition {

    static constraints = {
    }
    static hasMany = [users: User]
           
	static mapping = {
		sort "title"
	}

    String title
	
	String toString() {
		title
	}
	void setUsers(users){
		this.users=users	
	}
}
