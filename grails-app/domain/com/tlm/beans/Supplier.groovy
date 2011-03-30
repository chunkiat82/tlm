package com.tlm.beans

class Supplier {
	static searchable = true
    static constraints = {
    }
    static belongsTo = Publication    
    static hasMany = [publications:Publication]
    

    String company
    Country country
    String email
    String website
    String address
    String telephone
    String fax
    String mobile
    String description
	
    static fetchMode = [ country: "eager", publications:"eager" ]
	static mapping = {
		sort company:"asc"
	}
   
}
