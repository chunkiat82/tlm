package com.tlm.beans

class Subscription {
	
	static String ACTIVE="A"
	static String NOT_ACTIVE="N"
	
    static constraints = {
		user(nullable: false)
		publication(nullable: false)
		service(nullable: false)
		
		signupDate(nullable: false)
		cancelDate(nullable: true)
		subscriptionStatus(nullable: true)
	
	}
    static transients = ["subscriptionPdf"]
    static belongsTo = [user: User, publication: Publication, service: Service]
    
	// owning entities
	User user
	Publication publication
	Service service
	
	// subscription details
	Date signupDate
	Date cancelDate
	String subscriptionStatus
	
	public static Integer getSubscriptionPdfCount(paramsId)
	{
		Integer totalcount = Subscription.createCriteria().get{
			projections {
				rowCount()
			}			
			service {idEq(Long.parseLong("1"))}
			publication {eq ("id",paramsId)}
			user { eq ("accountStatus",User.ACTIVE)} 
		}
		return totalcount
	}
}
