package com.tlm.utils

import org.hibernate.Hibernate
import org.apache.log4j.Logger
import org.codehaus.groovy.grails.commons.ApplicationAttributes
import com.tlm.beans.*

class BootstrapUtil {
	static final Logger log = Logger.getLogger(BootstrapUtil)
	private static final ms = 1000 * 15 * 60

	public static tune = {servletContext ->
	    def ctx = servletContext.getAttribute(ApplicationAttributes.APPLICATION_CONTEXT)
	    ctx.dataSource.with {d ->
	      d.setMinEvictableIdleTimeMillis(ms)
	      d.setTimeBetweenEvictionRunsMillis(ms)
	      d.setNumTestsPerEvictionRun(3)
	      d.setTestOnBorrow(true)
	      d.setTestWhileIdle(true)
	      d.setTestOnReturn(true)
	      d.setValidationQuery('select 1')
	      d.setMinIdle(1)
	      d.setMaxActive(16)
	      d.setInitialSize(8)
	    }
	
	    if (log.infoEnabled) {
	      log.info "Configured Datasource properties:"
	      ctx.dataSource.properties.findAll {k, v -> !k.contains('password') }.each {p ->
	        log.info "  $p"
	      }
	    }
	  }
	
	static def addFileToAd(Ads ad, String filename, String mimeType) {
		
		def File file = new File(filename)
		def FileInputStream fis = new FileInputStream(file)
		
		def int length = file.length()
		
		byte[] fileData = new byte[length];
		fis.read(fileData);
		
		ad.fileName = filename
		ad.fileData = Hibernate.createBlob(fileData)
		ad.mimeType = mimeType
		
		
	}
	
	static def addImageToPubMastHead(Publication pub, String filename) {
		
		def File file = new File(filename)
		def FileInputStream fis = new FileInputStream(file)
		
		def int length = file.length()
		
		byte[] fileData = new byte[length];
		fis.read(fileData);
		
		pub.mastHead = Hibernate.createBlob(fileData)
				
	}
	
	static def addImageToIssue(Issue issue, String filename) {
		
		def File file = new File(filename)
		def FileInputStream fis = new FileInputStream(file)
		
		def int length = file.length()
		
		byte[] fileData = new byte[length];
		fis.read(fileData);
		
		issue.thumbnail = Hibernate.createBlob(fileData)
		
	}
	
	static def addPdfToIssue(Issue issue, String filename) {
		
		def File file = new File(filename)
		def FileInputStream fis = new FileInputStream(file)
		
		def int length = file.length()
		
		byte[] fileData = new byte[length];
		fis.read(fileData);
		
		def document= new Document(name:'Test Document',description:'Test Document',number:'1',fileName:filename,dateCreated:new Date().parse('yyyy/MM/dd', '2010/03/01'))
		document.fileData = Hibernate.createBlob(fileData)
		issue.addToDocuments(document)
		
	}
	
	static def readAsBlob(String filename) {
		File file = new File(filename)
		FileInputStream fis = new FileInputStream(file)
		int length = file.length()
		byte[] fileData = new byte[length]
		fis.read(fileData)
		
		return Hibernate.createBlob(fileData)
	}
	
	static def addPartsToIssue(Issue issue, List<Document> parts) {
		// just number the parts in order
		parts.eachWithIndex { part, idx ->
			part.part = idx + 1
			if (idx == 0) {
				issue.thumbnail = ThumbnailUtil.generateThumbnailBlob(new File(part.fileName))
			}
			
			issue.addToDocuments(part)
		
		}
	}
	
	static def pubText(String str) {
		
		return "<center><img height='150px' src='response/pubMastHead/"+str+"'/></center><br/><br/><p>Displays News and Publication Writeup.. Flashing Button to display News... Single Line Supplier Ads Scrolling Bottom 1 line</p>";
		
	}
	
	static def sampleUsers(services, publications, jobFunctions, jobPositions, countries, subRole) {
		
		def index = 1
		
		services.each { service ->
			publications.each { publication ->
				jobFunctions.each { jobFunction ->
					jobPositions.each { jobPosition ->
						countries.each { country ->
							
							// first, find and delete any existing user
							def oldUser = User.findByUserName("USER${index}")
							if (oldUser != null) {
								println "Delete old user [USER${index}]"
								oldUser.delete(flush: true)
							}
							
							// now, create the new user
							def usr = new User();
							usr.accountStatus = User.ACTIVE
							usr.address = "Address in ${country}"
							usr.city = "City in ${country}"
							usr.company = "Company in ${country}"
							usr.confirmPassword = "password"
							usr.country = country
							usr.email = "test@soho.sg"
							usr.fax = "FAX"
							usr.firstName = "[${service}] service, [${publication}] publication"
							usr.lastName = "[${jobFunction}] function [${jobPosition}] position, from [${country}]"
							usr.gender = "M"
							usr.honorific = LookupHonorific.findByType("mr")
							usr.jobFunction = jobFunction
							usr.jobPosition = jobPosition
							usr.mobile = "MOBILE"
							usr.password = "password"
							usr.postal = "123456"
							usr.state = "State in ${country}"
							usr.telephone = "TELEPHONE"
							usr.userName = "USER${index}"
							
							// define service and publication subscribed for
							def subscription = new Subscription()
							subscription.user = usr
							subscription.publication = publication
							subscription.service = service
							subscription.signupDate = new Date()
							subscription.subscriptionStatus = "A"
							
							usr.addToSubscriptions(subscription)
							usr.addToRoles(subRole)
							usr.save()

							if (usr.hasErrors()) {
								println usr.errors								
							}
							
							subscription.save()

							if (subscription.hasErrors()) {
								println subscription.errors
							}
							
							index++
						} // end of subscriptions loop
					} // end of job positions loop
				} // end of job functions loop
			} // end of publications loop 
		} // end of services loop (also, end of mock user generation)		
	}

}
