package com.tlm.controllers

import com.tlm.beans.EmailJob 
import com.tlm.beans.User 
import com.tlm.utils.ForwardMail 
import com.tlm.utils.TemplateUtil 

class ForwardController {
	
	def mailService
	
	def index = {
		// load the user and job
		def userObj = User.get(params.userId)
		def jobObj = EmailJob.get(params.jobId)
		
		// create a forwardMail object that will be the model for the form
		def forwardMail = new ForwardMail()
		forwardMail.subject = jobObj.subject
		forwardMail.userId = userObj.id
		forwardMail.jobId = jobObj.id
		forwardMail.senderName = userObj.fullName
		forwardMail.senderEmail = userObj.email
		
		// make sure both the user object and the job object are available on the page
		[forwardMail: forwardMail]
	}
	
	def view = {
		def job = EmailJob.get(params.id)
		def fullContextPath = "${request.serverName}:${request.serverPort}${request.contextPath}"
		
		Map<String, String> dynamicData = [:]
		// dynamicData[TemplateUtil.UNSUBSCRIBE_LINK] = ""
		// dynamicData[TemplateUtil.USER_NAME] = ""
		// dynamicData[TemplateUtil.FORWARD_LINK] = ""
		// dynamicData[TemplateUtil.VIEW_ONLINE_LINK] = ""
		
		def htmlMessage = TemplateUtil.processTemplate(job.html, dynamicData)
		
		render(text: htmlMessage, contentType:"text/html", encoding:"UTF-8")
		
	}
	
	def send = {
		def forwardMail = new ForwardMail(params['forwardMail'])
		def fullContextPath = "${request.serverName}:${request.serverPort}${request.contextPath}"
		
		if (forwardMail.validate()) {
			// do not create an e-mail job, just send it directly since the volume is small
			EmailJob job = EmailJob.get(forwardMail.jobId)
			
			for ( i in 1..5) {
				if (forwardMail["friend${i}Email"]) {
					Map<String, String> dynamicData = [:]
					dynamicData[TemplateUtil.UNSUBSCRIBE_LINK] = ""
					dynamicData[TemplateUtil.USER_NAME] = forwardMail["friend${i}Name"]
					dynamicData[TemplateUtil.FORWARD_LINK] = ""
					dynamicData[TemplateUtil.VIEW_ONLINE_LINK] = "${fullContextPath}/forward/view/${job.id}"
					
					def htmlMessage = TemplateUtil.processTemplate(job.html, dynamicData)
					
					try {
						mailService.sendMail {
							from "info@tradelinkmedia.biz"
							to forwardMail["friend${i}Email"]
							subject forwardMail.subject
							html htmlMessage
						}
					} catch (Exception ex) {
						ex.printStackTrace();
					}
		
				}
			}
			
			[forwardMail: forwardMail]
		} else {
			// display errors
			render(view:'index',model:[forwardMail:forwardMail])
		}
		
	}

}
