package com.tlm.controllers
import grails.converters.*
import com.tlm.beans.*
import com.tlm.utils.*
import java.util.Calendar
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class PublicationController {
	
	static allowedMethods = [save: "POST", update: "POST"]
    def exportService
	def index = {
		redirect(action: "list", params: params)
	}
	
	def list = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		[publicationInstanceList: Publication.list(params), publicationInstanceTotal: Publication.count()]
	}
	
	def create = {
		def publicationInstance = new Publication()
		publicationInstance.properties = params
		
		return [publicationInstance: publicationInstance]
	}
	
	def save = {
		def publicationInstance = new Publication(params)
		
		def fileName = "Mast Head"
		def fileNameMK = "Media Kit"
		def code = params["upload.fileName.code"]
		def codeMK = params["uploadMK.fileName.code"]
		
		if (code) {
			// user must have opted to change the file			
			publicationInstance.mastHead = FileUtil.getFileBlob(code)			
		}
		if (codeMK) {
			// user must have opted to change the file			
			publicationInstance.mediaKit = FileUtil.getFileBlob(codeMK)			
		}
		
		if (publicationInstance.save(flush: true)) {
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'publication.label', default: 'Publication'), publicationInstance.id])}"
			redirect(action: "show", id: publicationInstance.id)
		}
		else {
			render(view: "create", model: [publicationInstance: publicationInstance,upload: [fileName : fileName, fileCode: code],uploadMK: [fileName : fileNameMK, fileCode: codeMK]])
		}
	}
	
	def show = {
		def publicationInstance = Publication.get(params.id)
		
		if (!publicationInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'publication.label', default: 'Publication'), params.id])}"
			redirect(action: "list")
		}
		else {
			//additional logic for getting the correct number of subscription
			Integer totalcount = Subscription.getSubscriptionPdfCount(Long.parseLong(params.id))
			return [publicationInstance: publicationInstance,subTotalCount:totalcount]
		}
	}
	
	def edit = {
		def publicationInstance = Publication.get(params.id)
		if (!publicationInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'publication.label', default: 'Publication'), params.id])}"
			redirect(action: "list")
		}
		else {			
			return [publicationInstance: publicationInstance]
		}
	}
	
	def update = {
		def publicationInstance = Publication.get(params.id)

		def fileName = "Mast Head"
		def fileNameMK = "Media Kit"
		def code = params["upload.fileName.code"]
		def codeMK = params["uploadMK.fileName.code"]
		
		
		if (publicationInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (publicationInstance.version > version) {
					
					publicationInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'publication.label', default: 'Publication')] as Object[], "Another user has updated this Publication while you were editing")
					render(view: "edit", model: [publicationInstance: publicationInstance, upload: [fileName: fileName, fileCode: code],uploadMK: [fileName : fileNameMK, fileCode: codeMK]])
					return
				}
			}
			if (code) {
				// user must have opted to change the file			
				publicationInstance.mastHead = FileUtil.getFileBlob(code)			
			}
			if (codeMK) {
				// user must have opted to change the file			
				publicationInstance.mediaKit = FileUtil.getFileBlob(codeMK)			
			}
			publicationInstance.properties = params
			if (!publicationInstance.hasErrors() && publicationInstance.save(flush: true)) {
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'publication.label', default: 'Publication'), publicationInstance.id])}"
				redirect(action: "show", id: publicationInstance.id)
			}
			else {
				render(view: "edit", model: [publicationInstance: publicationInstance, upload: [fileName: fileName, fileCode: code],uploadMK: [fileName : fileName, fileCode: code]])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'publication.label', default: 'Publication'), params.id])}"
			redirect(action: "list")
		}
	}
	
	def delete = {
		def publicationInstance = Publication.get(params.id)
		if (publicationInstance) {
			try {
				publicationInstance.delete(flush: true)
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'publication.label', default: 'Publication'), params.id])}"
				redirect(action: "list")
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'publication.label', default: 'Publication'), params.id])}"
				redirect(action: "show", id: params.id)
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'publication.label', default: 'Publication'), params.id])}"
			redirect(action: "list")
		}
	}
	
	def subscriptionList ={
		long pubId=1
		if (session.pubId)
		{
			pubId=Long.parseLong(session.pubId)
		}
		if (params.id){
			session.pubId=params.id
			pubId=Long.parseLong(session.pubId)
		}
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		
		
		if(params?.format && params.format != "html"){
			def pub = Publication.get(pubId);
			response.contentType = ConfigurationHolder.config.grails.mime.types[params.format]
			response.setHeader("Content-disposition", "attachment; filename="+pub.pubShortName+".${params.extension}")
			
			List fields =  new ArrayList<String>(User.getDisplayColumns().keySet())
			Map labels = User.getDisplayColumns()
			
			// Formatter closure def upperCase = { value -> return value.toUpperCase() }
			
			//Map formatters = [author: upperCase] 
			Map parameters = [title: pub.pubLongName]
			def userList = User.executeQuery("select distinct u from User u inner join u.subscriptions as subs inner join subs.service as sv inner join subs.publication as p where sv.id = 1 and p.id = :pid and u.accountStatus = 'A'",[pid:pubId])
			exportService.export(params.format, response.outputStream , userList, fields, labels, [:], parameters) 
		}
		else
		{		
			def userList = User.createCriteria().list(params) {
				subscriptions { 				
					service 	{	idEq(Long.parseLong("1"))	}
					publication { 	idEq(pubId)}								
				}				
				eq ("accountStatus",User.ACTIVE)
			}
			Integer totalcount = Subscription.getSubscriptionPdfCount(pubId)
			[userInstanceList: userList, userInstanceTotal: totalcount]
		}	
	}
}
