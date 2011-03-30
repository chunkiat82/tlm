package com.tlm.beans

class JobFunction {

    static constraints = {
    }
    static hasMany = [users: User]
	static mapping = {
		sort "title"
	}

    String title;
	
	String toString() {
		title
	}
	
	void setUsers(users){
		this.users=users	
	}
}
