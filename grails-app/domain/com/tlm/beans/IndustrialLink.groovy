package com.tlm.beans

class IndustrialLink {
	String organization
	String abbreviation
	String website
	
	static constraints = {
		organization(nullable: false)
		abbreviation(nullable: true)
		website(nullable: false)
	}
	static hasMany = [publications: Publication]
	static mapping = {
		sort organization:"asc"
	}
	
}
