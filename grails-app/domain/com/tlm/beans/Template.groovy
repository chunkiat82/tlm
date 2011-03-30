package com.tlm.beans

class Template {

    static constraints = {
		service(nullable: true)
		name(nullable: false, blank: false)
		subject(nullable:true, blank: true)
		data(nullable: false, blank: false)
	}
    
    static belongsTo = [service: Service]

    static mapping = {
		data type: 'text'
    }

    // owning entities
	Service service
	
	// data fields
	String name
    String subject
    String data
	
	String toString() {
		return "${name} belonging to ${service.name}"
	}

}