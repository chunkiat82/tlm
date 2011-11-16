package com.tlm.controllers

import com.tlm.utils.EncodingUtil
import java.util.Map;

import com.tlm.beans.*
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class UserController {
	
	def authenticateService
	def exportService
	def mailService
	
    static allowedMethods = [save: "POST", update: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        if(params?.format && params.format != "html"){
        	response.contentType = ConfigurationHolder.config.grails.mime.types[params.format]
        	response.setHeader("Content-disposition", "attachment; filename=users.${params.format}")
			List fields =  new ArrayList<String>(User.getDisplayColumns().keySet())
			Map labels = User.getDisplayColumns()
			Map parameters = [title: 'All Users List']
			
			exportService.export(params.format, response.outputStream , User.list(), fields, labels, [:], parameters) 
		}
		else
		{
			return [userInstanceList: User.list(params), userInstanceTotal: User.count()]
		}
    }

	def searchList = {
		if(!params.format){
			params.max = Math.min(params.max ? params.int('max') : 10, 100)
		}
		def userList = User.createCriteria().list(params){
			if(params.userName)
			{
				like ('userName','%'+params.userName+'%')
			}
			if(params.lastName)
			{
				like ('lastName','%'+params.lastName+'%')
			}
			if(params.firstName)
			{
				like ('firstName','%'+params.firstName+'%')
			}
			if(params.jobFunction  && params.jobFunction != "null")
			{
				eq ('jobFunction.id',Long.parseLong(params.jobFunction))
			}
			if(params.jobPosition && params.jobPosition != "null")
			{
				eq ('jobPosition.id',Long.parseLong(params.jobPosition))
			}
			if(params.publication && params.publication != "null")
			{
				subscriptions{
					eq ('publication.id',Long.parseLong(params.publication))
				}
			}
			if(params.country && params.country != "null")
			{
				eq ('country.id',Long.parseLong(params.country))
			}
			if(params.accountStatus)
			{
				eq ('accountStatus',Integer.parseInt(params.accountStatus))
			}
			if(params.role && params.role != "null")
			{
				roles {
					eq ('id',Long.parseLong(params.role))
				}
			}			
		}
		
		
		if(params?.format && params.format != "html"){
			response.contentType = ConfigurationHolder.config.grails.mime.types[params.format]
			response.setHeader("Content-disposition", "attachment; filename=users.${params.format}")
			List fields =  new ArrayList<String>(User.getDisplayColumns().keySet())
			Map labels = User.getDisplayColumns()
			
			Map parameters = [title: 'Filtered Users List']
			
			exportService.export(params.format, response.outputStream , userList, fields, labels, [:], parameters)
		}
		else
		{
			def userInstanceTotal = User.createCriteria().get{
				projections {
					rowCount()
				}
				if(params.userName)
				{
					like ('userName','%'+params.userName+'%')
				}
				if(params.lastName)
				{
					like ('lastName','%'+params.lastName+'%')
				}
				if(params.firstName)
				{
					like ('firstName','%'+params.firstName+'%')
				}
				if(params.jobFunction != "null")
				{
					eq ('jobFunction.id',Long.parseLong(params.jobFunction))
				}
				if(params.jobPosition != "null")
				{
					eq ('jobPosition.id',Long.parseLong(params.jobPosition))
				}
				if(params.publication != "null")
				{
					subscriptions{
						eq ('publication.id',Long.parseLong(params.publication))
					}
				}
				if(params.country != "null")
				{
					eq ('country.id',Long.parseLong(params.country))
				}
				if(params.accountStatus)
				{
					eq ('accountStatus',Integer.parseInt(params.accountStatus))
				}
				if(params.role != "null")
				{
					roles {
						eq ('id',Long.parseLong(params.role))
					}
				}
				
			}
			return [userInstanceList: userList, userInstanceTotal: userInstanceTotal,params:params]
		}
    }

	def search = {
		def userInstance = new User()
		userInstance.properties = params
		return [userInstance: userInstance, roleList: Role.list(), serviceList:Service.list(),publicationList:Publication.list()]
    }

    def create = {
        def userInstance = new User()
        userInstance.properties = params
        return [userInstance: userInstance, roleList: Role.list(), serviceList:Service.list(),publicationList:Publication.list()]
    }

    def save = {
        def userInstance = new User(params)
		
        if (userInstance.save(flush: true)) {
			addRoles(userInstance)
			createSubscription(userInstance)
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'user.label', default: 'User'), userInstance.id])}"
            redirect(action: "show", id: userInstance.id)
        }
        else {
            render(view: "create", model: [userInstance: userInstance, roleList: Role.list()])
        }
    }

    def show = {
        def userInstance = User.get(params.id)
        if (!userInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
            redirect(action: "list")
        }
        else {
			return buildUserModel(userInstance)
        }
    }

    def edit = {
        def userInstance = User.get(params.id)
        if (!userInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
            redirect(action: "list")
        }
        else {
            return buildUserModel(userInstance)
        }
    }

    def update = {
        def userInstance = User.get(params.id)
		def userPreviousStatus = 1
        if (userInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (userInstance.version > version) {
                    
                    userInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'user.label', default: 'User')] as Object[], "Another user has updated this User while you were editing")
                    render(view: "edit", model: buildUserModel(userInstance))
                    return
                }
            }
			
			userPreviousStatus = userInstance.accountStatus
			bindData(userInstance, params, [exclude:['password', 'confirmPassword']])
			if (params.confirmPassword) {
				userInstance.password = params.password
				userInstance.confirmPassword = params.confirmPassword
			}
            
            if (!userInstance.hasErrors() && userInstance.save(flush: true)) {
				Role.findAll().each { it.removeFromUsers(userInstance) }
				addRoles(userInstance)		
				updateSubscription(userInstance)
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'user.label', default: 'User'), userInstance.id])}"
				if (params.accountStatus){
					if (params.accountStatus!=1 && userPreviousStatus==1) {
						redirect(action: "unapproveList")
					}
					else
						redirect(action: "show", id: userInstance.id)
				}
				else{
					/*
					 * safety net
					 */
                	redirect(action: "show", id: userInstance.id)
				}
				
            }
            else {
                render(view: "edit", model: buildUserModel(userInstance))
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
		def user = User.get(params.id)
		if (user) {
			def authPrincipal = authenticateService.principal()
			//avoid self-delete if the logged-in user is an admin
			if (!(authPrincipal instanceof String) && authPrincipal.username == user.userName) {
				flash.message = "You can not delete yourself, please login as another admin and try again"
			}
			else {
				//first, delete this person from People_Authorities table.
				Role.findAll().each { it.removeFromUsers(user) }
				user.delete(flush: true)
				flash.message = "$user deleted."
			}
		}
		else {
			flash.message = "User not found with id $params.id"
		}
		
		redirect action: list
    }
	
	
	
	def subscribe = {
		// KIV
		/*
		def user = User.get(params.userId)
		def service = Service.get(params.serviceId)
		
		def subscriptionsForUser = Subscription.findAllByUserAndService(user, service)
		
		if (subscriptionsForUser.size() == 0) {
			
		}
			
		
		for (subscription : subscriptionsForUser) {
			// there really should only be one at the most
			subscription.subscriptionStatus = Subscription.ACTIVE
			subscription.save()
			
			// inform the user that the unsubscription is successful
			mailService.sendMail {
			  	from "info@tradelinkmedia.biz"
			   	to user.email			
			   	subject "Subscription to $subscription.service successful"
			   	html "<html><body><h3>Dear ${item.user?.fullName},</h3>You have successfully subscribed to the $subscription.service service.  To re-subscribe, click <a href='#'>here</a>.</body></html>"
			}
		}
		*/
	}
	
	private void addRoles(user) {
		for (String key in params.keySet()) {
			if (key.startsWith('ROLE_') && 'on' == params.get(key)) {
				Role.findByRoleName(key).addToUsers(user)
			}
		}
	}

	private void createSubscription(user) {
		def publications = Publication.list()
		def services = Service.list()
		publications.each { publication ->
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
	private void updateSubscription(user) {
		
		def subscriptionList = Subscription.findAllByUser(user);
		params.findAll {k,v -> k.startsWith("_SERV_")}.each { k,v ->
			def str =  k.split("_");
			def currentParam =  params.get("SERV_"+str[2]+"_"+str[3])	
			long serviceId = Long.parseLong(str[2]);
			int pubId = Integer.parseInt(str[3]);
			boolean found= false
			for (sub in subscriptionList)
			{
				if ( sub.service.id == serviceId && sub.publication.pubId==pubId)
				{
					sub.subscriptionStatus = currentParam ? Subscription.ACTIVE :Subscription.NOT_ACTIVE
					sub.save()
					found=true					
				}								
			}
			if (!found){
				if (currentParam){
					def subscription = new Subscription()
					subscription.user = user
					subscription.publication = Publication.findByPubId(pubId)
					subscription.service = Service.get(serviceId)
					subscription.signupDate = new Date()
					subscription.subscriptionStatus = "A"
					user.addToSubscriptions(subscription)
				}
			}
		}
		user.save(flush:true)
	}

	private Map buildUserModel(user) {
		
		// get a list of all roles
		List roles = Role.list()
		roles.sort { r1, r2 ->
			r1.roleName <=> r2.roleName
		}
		
		// get a set of all role names the user has
		Set userRoleNames = []
		for (role in user.roles) {
			userRoleNames << role.roleName
		}
		
		// set whether a user has a role by checking userRoleNames if it contains
		// a role in the set of all roles
		LinkedHashMap<Role, Boolean> roleMap = [:]
		for (role in roles) {
			roleMap[(role)] = userRoleNames.contains(role.roleName)
		}

		return [userInstance: user, roleMap: roleMap, serviceList:Service.list(),publicationList:Publication.list(), userDownloadStatList:user.getUserDownloadStatics()]
	}	
	
	def unapproveList ={
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def userList = User.createCriteria().list(params){
			eq ('accountStatus',User.PENDING)
		}
		def userInstanceTotal =User.createCriteria().get{
			projections {
				rowCount()
			}
			eq ('accountStatus',User.PENDING)
		}
		return [userInstanceList: userList,userInstanceTotal: userInstanceTotal, params:params]
	}
	
	def approve ={
		def userInstance = User.get(params.id)
		if (userInstance) {
			userInstance.accountStatus=User.ACTIVE
			flash.message = "${message(code: 'default.updated.message', args: [message(code: 'user.label', default: 'User'), userInstance.id])}"
		}
		else{
			flash.message = "UserId $userInstance.id not found"
		}
		redirect(action: "unapproveList", params: params)
	}
	
}
