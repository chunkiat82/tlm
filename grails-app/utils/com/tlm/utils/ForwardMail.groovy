package com.tlm.utils

/**
 * This is a POJO.
 * 
 * @author masotime
 */
class ForwardMail {
	
	static constraints = {
		subject(nullable: false)
		userId(nullable: false)
		jobId(nullable: false)
		
		senderName(nullable: false, blank: false)
		senderEmail(nullable: false, blank: false)
		
		friend1Email(email: true, validator: {val, obj ->
			if (obj.friend1Name && !val) {
				return "Please specify ${obj.friend1Name}'s e-mail address";
			}
			
			return true;
		})
		
		friend2Email(email: true, validator: {val, obj ->
			if (obj.friend2Name && !val) {
				return "Please specify ${obj.friend2Name}'s e-mail address";
			}
			
			return true;
		})
		
		friend3Email(email: true, validator: {val, obj ->
			if (obj.friend3Name && !val) {
				return "Please specify ${obj.friend3Name}'s e-mail address";
			}
			
			return true;
		})
		
		friend4Email(email: true, validator: {val, obj ->
			if (obj.friend4Name && !val) {
				return "Please specify ${obj.friend4Name}'s e-mail address";
			}
			
			return true;
		})
		
		friend5Email(email: true, validator: {val, obj ->
			if (obj.friend5Name && !val) {
				return "Please specify ${obj.friend5Name}'s e-mail address";
			}
			
			return true;
		})
	}
	
	String subject
	String userId
	String jobId
	
	String senderName
	String senderEmail
	
	String friend1Name
	String friend1Email
	
	String friend2Name
	String friend2Email
	
	String friend3Name
	String friend3Email
	
	String friend4Name
	String friend4Email
	
	String friend5Name
	String friend5Email

}
