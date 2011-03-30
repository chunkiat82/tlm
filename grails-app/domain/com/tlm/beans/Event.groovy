package com.tlm.beans

class Event {
	static searchable = true
	static constraints = {
		
//		startDate(nullable:true,
//		validator: {
//			if (it?.compareTo(new Date()) < 0 ) {
//				return false
//			}
//			return true
//		})
	}
    static belongsTo = Publication
    static hasMany = [publications:Publication]
    
    String eventName
    String eventLink
    Date startDate
    Date endDate
    String location
    String orgName
    String orgLink
	
    static mapping = { sort startDate:"asc", eventName:"asc"  }

}
