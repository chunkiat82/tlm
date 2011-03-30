package com.tlm.beans

class EmailJob {
	
	static String RUNNING = "R"
	static String STOPPED = "P"
	static String COMPLETED = "C"

	static transients = ['statusLabel', 'progress', 'total', 'success', 'attempted', 'failure']

    static constraints = {
		template(nullable: true)
		description(nullable: false, blank: true)
		html(nullable: false, blank: false)
		status(nullable: false, blank: false)
		dateCompleted(nullable: true)
    }

    static mapping = {
		description type: 'text'
		html type: 'text'
    }

    static hasMany = [ emailJobItems : EmailJobItem ]

    Template template
	String description
	String subject
	String html
	String status
	Date dateCreated // auto-set by Grails
	Date lastUpdated // auto-set by Grails
	Date dateCompleted
	
	String getStatusLabel() {
		switch(status){
			case RUNNING: return "Running"; break;
			case STOPPED: return "Stopped"; break;
			case COMPLETED: return "Completed"; break;
		}
	}
	
	float getProgress() {
		if (status.equals(COMPLETED)) {
			return 1.0
		}
		
		// use a query to get the data
		def attempted = getAttempted()
        def total = getTotal()
		
		return total == 0 ? 1.0 : (attempted * 1.0 / total)
	}
	
	// total number of child records
	float getTotal() {
		return EmailJob.executeQuery("select count(*) from EmailJobItem eji where eji.emailJob.id = :emailJobId", ["emailJobId": id]).get(0) 
	}
	
	// child records with status SENT
	float getSuccess() {
		return EmailJob.executeQuery("select count(*) from EmailJobItem eji where eji.emailJob.id = :emailJobId and eji.status = :status", ["emailJobId":id, "status": EmailJobItem.SENT]).get(0)
	}
	
	// child records with status SENT or FAILED
	float getAttempted() {
		return EmailJob.executeQuery("select count(*) from EmailJobItem eji where eji.emailJob.id = :emailJobId and eji.status != :status", ["emailJobId":id, "status": EmailJobItem.PENDING]).get(0)
	}
	
	// child records with status FAILED
	float getFailure() {
		EmailJob.executeQuery("select count(*) from EmailJobItem eji where eji.emailJob.id = :emailJobId and eji.status = :status", ["emailJobId":id, "status": EmailJobItem.FAILED]).get(0)
	}
	
	
}
