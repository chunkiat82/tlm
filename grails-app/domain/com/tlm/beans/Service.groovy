package com.tlm.beans;

class Service {
	
	static constraints = {
		name(nullable: false, blank: false)
	}
	static hasMany = [templates : Template, subscriptions : Subscription ]
	
	String name
	
	String toString() {
		return name
	}
	
}
