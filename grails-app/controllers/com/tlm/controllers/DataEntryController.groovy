package com.tlm.controllers

import com.tlm.beans.*;

class DataEntryController {

    def index = { 
    	redirect(action: "dataEntry")
    }
    
    def dataEntry = {
    	 
    	def selectedIds = []
    	
    	for (pub in Publication.list()) {
    		selectedIds << pub.id
    	}
    	
    	[publicationList:Publication.list(), selectedIds : selectedIds]
    	
    }
    
    def save = {
        def user = new User(params)
        def selectedIds = []        
        
        if (params.selectedIds) {
        	for (id in params.selectedIds) {
        		selectedIds << Long.parseLong(id)
        	}
        }
        
        // copy the email to the username
        user.userName = user.email
        
    	// set password, account status
    	user.accountStatus = User.ACTIVE
    	user.password = "password"
    	user.confirmPassword = "password"
    		
        if (user.save(flush: true)) {
        	// add subscriber role
			user.addToRoles(Role.findByRoleName("ROLE_SUBSCRIBER")).save(flush:true)
        	
        	// add subscriptions
        	def publications = Publication.list()
        	def services = Service.list()
        	
        	// for each publication
        	publications.each { publication ->
        	
        		// if it was selected
        		if (selectedIds.contains(publication.id)) {
        			
        			// subscribe for all services under the publication
    				services.each { service ->
						def subscription = new Subscription()
						subscription.user = user
						subscription.publication = publication
						subscription.service = service
						subscription.signupDate = new Date()
						subscription.subscriptionStatus = "A"
				
						subscription.save()				
    				}        			
        			
        		}

        	}        	

            flash.message = "${message(code: 'default.created.message', args: [message(code: 'user.label', default: 'User'), user.id])}"
            redirect(action: "dataEntry")
        }
        else {
        	println user.errors
        	flash.message = "Saving to Database Error [Some Fields not filled/ User already exist]"
            render(view: "dataEntry", model: [user: user,publicationList:Publication.list(), selectedIds : selectedIds])
        }
    }
}
