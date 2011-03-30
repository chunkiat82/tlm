package com.tlm.utils

import com.tlm.beans.EmailJob 
import com.tlm.beans.EmailJobItem
import com.tlm.beans.Subscription
import javax.servlet.http.HttpServletRequest 
import org.grails.mail.MailService 
import com.tlm.services.EmailJobService


class Mailer implements Runnable {
	
	private final MailService mailService
	private final Long emailJobId
	private final String fullContextPath
	private EmailJob emailJob
	
	
	public Mailer(MailService mailService, EmailJob emailJob, String fullContextPath) {
		
		if (mailService == null) {
			throw new IllegalArgumentException("mailService must not be null")
		}
		
		if (emailJob == null) {
			throw new IllegalArgumentException("emailJob must not be null")			
		}
		
		if (emailJob.id == null) {
			throw new IllegalArgumentException("emailJobId must not be null.")
		}		
		
		this.mailService = mailService
		this.emailJobId = emailJob.id
		this.fullContextPath = fullContextPath.startsWith("http://") ? fullContextPath.replace("http://", "") : fullContextPath
	}
	
	private boolean iAmInterrupted()
	{
		boolean result = Thread.currentThread().isInterrupted()

        if (result) {
			EmailJobService.jobMap.remove(emailJobId)
			
			EmailJob.withTransaction() {
				emailJob = EmailJob.get(emailJobId)
				emailJob.status = EmailJob.STOPPED
				emailJob.save()
			}
		}
		
		return result
	}

	@Override
	public void run() {
		
		  // first, obtain the list of email job items that are not pending
		  def emailJobItems
		  def htmlTemplate
		  def theSubject		  
		  
		  // update the job status to running		  
		  EmailJob.withTransaction() {
			  emailJob = EmailJob.get(emailJobId)
			  emailJob.status = EmailJob.RUNNING
			  emailJob.save()
		  }
		  
		  EmailJobItem.withTransaction() {
			
			emailJobItems = EmailJobItem.createCriteria().list() {
				emailJob { eq('id', emailJobId) }
				eq('status', EmailJobItem.PENDING)
			}
			
			emailJob = EmailJob.get(emailJobId)
			htmlTemplate = emailJob.html
			theSubject = emailJob.subject
			
		  }

          if (iAmInterrupted()) return

		  println "Going to send emails"
		
          // for each job item, attempt to e-mail, then set the status after that
		
		  for (EmailJobItem item : emailJobItems) {
			
			EmailJobItem.withTransaction() {
				
				// reload the item (as part of the session)
				item = EmailJobItem.get(item.id)
				
				// construct the html for unsubscribing
				def subscriptions = item?.user?.subscriptions
				def encodedId = EncodingUtil.generateObfuscatedId(item.user?.id)
				
				// [090910] Ben: Construct the dynamic variables
				Map<String, String> dynamicData = [:]
				dynamicData[TemplateUtil.UNSUBSCRIBE_LINK] = "${fullContextPath}/unsubscribe/user/${item.user?.id}/${encodedId}"
				dynamicData[TemplateUtil.USER_NAME] = "${item.user?.fullName}"
				dynamicData[TemplateUtil.FORWARD_LINK] = "${fullContextPath}/forward/user/${item.user?.id}/job/${emailJobId}"
				dynamicData[TemplateUtil.VIEW_ONLINE_LINK] = "${fullContextPath}/forward/view/${emailJobId}"
				
				// [090910] Ben: Parse the dynamic variable strings in the HTML template into real data
				def htmlMessage = TemplateUtil.processTemplate(htmlTemplate, dynamicData) 
				
			    print "Sending one e-mail..."
			    def successful = true
			    
			    try {
			    	mailService.sendMail {
			    		from "info@tradelinkmedia.biz"
			    		to item.email				
			    		subject theSubject
			    		html htmlMessage
			    	}
			    } catch (Exception ex) {
			    	ex.printStackTrace();
			    	successful = false
			    }
			
			    if (successful) {
			    	// update the status of the item
			    	print "sent..."
			    	item.status = EmailJobItem.SENT
			    } else {
			    	print "FAILED..."
			    	item.status = EmailJobItem.FAILED
			    }
				
				item.save()				
				print "status updated!\n"
			}
			
			if (iAmInterrupted()) return
			

		  }
		
		  println "Emails job completed"
		
		  // update the parent job
		  EmailJob.withTransaction() {
			// reload the item
			emailJob = EmailJob.get(emailJob.id)
  		    emailJob.status = EmailJob.COMPLETED
  		    emailJob.dateCompleted = new Date()
			emailJob.save()
		  }
		
		  // tell the emailService to remove the reference
		  EmailJobService.jobMap.remove(emailJobId)
		
	}

}
