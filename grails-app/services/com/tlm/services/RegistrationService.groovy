package com.tlm.services

import com.tlm.beans.User
import com.tlm.beans.Publication
import com.tlm.beans.Service
import com.tlm.beans.Subscription
import com.tlm.beans.Role

class RegistrationService {

    boolean transactional = true
	def static Random generator = new Random();

    def addUserAndSubscriptions(User user, String[] publicationIds, String baseURL) {
		user.accountStatus = User.PENDING
		user.activationCode = Long.toString(Math.abs(generator.nextLong()), 36)
		user.save()
		
		if (user.hasErrors()) {
			return user.errors
		}
		
		// [090410] Ben: Also set the role to ROLE_SUBSCRIBER
		user.addToRoles(Role.findByRoleName(Role.SUBSCRIBER));
				
		for (String id : publicationIds) {
			
			def publication = Publication.get(id)
			def services = Service.list();
			
			services.each{ service->
				def subscription = new Subscription();
				subscription.user = user;
				subscription.service = service;
				subscription.publication = publication;
				subscription.subscriptionStatus = "A"
				
				subscription.signupDate = new Date();
				
				subscription.save();
				if (subscription.hasErrors()) {
					return subscription.errors;
				}
			}
			
			
		}
		
		sendMail {
			to user.email
			from "info@tradelinkmedia.com.sg"
			subject "TLM Subscription Confirmation"
//			html "Hi ${user.honorific.type} ${user.lastName}, <br/>" +
//					"click <a href='${baseURL}/userRegistration/activate/${user.activationCode}'>here</a> to activate your account." +
//					"<br/>Regards<br/>Webmaster"
			html "Hi ${user.honorific.type} ${user.lastName}, <br/>" +
			"Thank you for registering. Your account will be verified soon." +
			"<br/>Regards<br/>Webmaster"
		}
		
		return true;

    }
}
