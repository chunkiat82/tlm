package com.tlm.beans

class EmailJobItem {
	
	static String PENDING = "P"
	static String SENT = "E"
	static String FAILED = "F"

    static transients = ['statusLabel']

	static belongsTo = [emailJob : EmailJob ]

	static constraints = {
		emailJob(nullable: false)
		email(nullable: false)
		status(nullable: false, blank: false)
    }

    EmailJob emailJob
	User user // optional
	String email
	String status
	
	
	String toString() {
		"${email} ${user == null ? '' : '[' + user.fullName + ']'}"
	}
	
	String getStatusLabel() {
		switch(status){
			case PENDING: return "Pending"; break;
			case SENT: return "Sent"; break;
			case FAILED: return "FAILED"; break;
		}
	}
}
