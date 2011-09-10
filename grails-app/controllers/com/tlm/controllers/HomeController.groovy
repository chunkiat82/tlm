package com.tlm.controllers

import com.tlm.beans.User
import grails.converters.JSON 

class HomeController {

    def index = { 
		def activateId = params['activateId']
		def pubId = params['id']
		println pubId
		if (activateId != null) {
			render(view:'/index', model:[activatedUser: User.get(activateId),pubId:pubId])
		} else {
		    render(view:'/index',model:[pubId:pubId])
		}
	}
	
	def login = {
		def username = params['username']
		def password = params['password']
		
		def user = User.findByUserName(username)
		def result = false
		if (user != null) {			
			if (user.checkPassword(password)) {
				session['loginId'] = user.id				
				result = true
			}
		}
		
		if (result == true) {
			render ([success: true] as JSON)
		} else {
			render ([success: false, errors: [ reason: 'The user name does not exist or the password is wrong.' ]] as JSON)
		}
		
	}
}
