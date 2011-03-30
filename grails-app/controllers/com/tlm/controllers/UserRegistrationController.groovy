package com.tlm.controllers

import grails.converters.JSON
import com.tlm.beans.*
import com.tlm.services.RegistrationService
import com.tlm.utils.EncodingUtil;

class UserRegistrationController {
	
	def registrationService
	
	def save = {
		println '=============='
		println 'action [save]'
		def user = new User(params)
		user.save()

        // check if save was successful
        if (!user.hasErrors()) {			
			println "Validation succeeded"
			flash.message = "User ${user} successfully registered";
			redirect(action: 'index')
		} else {
		    flash.message = "Validation failed";		    
		    println user.errors		
			render(view: 'index', model: [user: user])
		}
		
	}
	
	def ajaxSave = {
		def user = new User(params['user'])
		def publicationIds = request.getParameterValues('publication.ids')
		def fullContextPath = "${request.scheme}://${request.serverName}:${request.serverPort}${request.contextPath}"
		
		// [090410] Ben: During registration, the user's e-mail is the user's userName
		user.userName = user.email
		user.password = 'password'
		user.confirmPassword='password'
		def saveResult = registrationService.addUserAndSubscriptions(user, publicationIds, fullContextPath)
		
		if (saveResult == true) {
			JSON.use("deep") {
				render(contentType: "application/json", text: ["success" : true] as JSON)
			}
		} else {
		    println saveResult
		    JSON.use("deep") {
			    render(contentType: "application/json", text: saveResult as JSON)
		    }
		}
		
	}
	
    def index = {
		println 'Executing index'
	    [ honorifics : LookupHonorific.list(),
		  countries : Country.list(),
		  jobFunctions : JobFunction.list(),
		  jobPositions : JobPosition.list()
		]
	}
	
	def activate = {
		def user = User.findByActivationCode(params['id'])
		
		if (user != null) {
			user.accountStatus = User.ACTIVE
			redirect(controller: 'home', action: 'index', params: ['activateId': user.id])
			// render "Hi ${user.honorific.type} ${user.lastName}, your account has been successfully activated.  Click <a href='/tlm/index.html'>here</a> to login and change your user profile."
		} else {
			render "Unauthorized access detected.  Please hold, Interpol will be contacting you shortly." 
		}
	}
	
	def unsubscribe = {
			
			// validate that the id and encodedId match
			def doesItMatch = EncodingUtil.validateObfuscatedId(params.userId, params.encodedId)		
			def user = User.get(params.userId)
			
			// if no such user or invalid match, go back to index page
			if (!user || !doesItMatch) redirect(controller: 'home', action: 'index')
			
			// blah
			def subscriptionsForUser = Subscription.createCriteria().listDistinct {
				eq('user', user)
				eq('subscriptionStatus', Subscription.ACTIVE)
				publication {}
				service {}
				order('publication.id', 'asc')
				order('service.id', 'asc')
			}
			
			render(view: 'unsubscribe', model: [doesItMatch: doesItMatch, userId: params.userId, encodedId: params.encodedId, subscriptions: subscriptionsForUser, user: user])
			
			
			/*
			def service = Service.get(params.serviceId)
			def publication = Publication.get(params.publicationId)
			
			def subscriptionsForUser = Subscription.createCriteria().listDistinct {
				eq('user', user)
				eq('service', service)
				eq('publication', publication)
			}
			
			for (subscription in subscriptionsForUser) {
				// there really should only be one at the most
				subscription.subscriptionStatus = Subscription.NOT_ACTIVE
				subscription.save()
				
				// inform the user that the unsubscription is successful
				mailService.sendMail {
				  	from "info@tradelinkmedia.biz"
				   	to user.email			
				   	subject "Unsubscription from $subscription.service successful"
				   	html "<html><body><h3>Dear ${user?.fullName},</h3>You have successfully unsubscribed from the ${subscription.service} service under the publication ${subscription.publication}.</body></html>"
				}
			}
			*/
			
		}
		
		def doUnsubscribe = {
			// validate that the id and encodedId match
			def doesItMatch = EncodingUtil.validateObfuscatedId(params.userId, params.encodedId)		
			def user = User.get(params.userId)
			
			// if no such user or invalid match, go back to index page
			if (!user || !doesItMatch) redirect(controller: 'home', action: 'index')
			
			// iterate through the list of subscriptionIds and extract the objects from the database
			// the should be grouped by publication from the subscribe action
			def subscriptionIds = request.getParameterValues("subscriptionId")
			def subscriptions = []
			
			/*
			 * since the logic is reversed, and checkbox do not return a value 
			 * if they are not checked, i have unsubsribe all of them first
			 * then subscribe them back using the ids returned in the form submission
			 */
			                     
			for (subscriptionId in subscriptionIds) {
				subscriptions << Subscription.get(subscriptionId)
			}
			for (currentUserSubscriptions in user.subscriptions){
				currentUserSubscriptions.subscriptionStatus = Subscription.NOT_ACTIVE
			}
			// mark them all as unsubscribed, then put them in the model for the user to view.
			for (subscription in subscriptions) {
				//println "Unsubscribing $subscription"
				subscription.subscriptionStatus = Subscription.ACTIVE
			}
			
			render(view: "doUnsubscribe", model: [subscriptions: subscriptions])
			
		}
}
