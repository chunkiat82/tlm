package com.tlm.controllers
import java.util.Calendar
import org.codehaus.groovy.grails.commons.ConfigurationHolder

import grails.converters.*
import com.tlm.beans.*
import com.tlm.utils.*

class ResponseController {
	
	def authenticateService
	def exportService
	def mailService
    
	def index = { }
	
	def adsImage = {
		if (params.id)
		{
			Ads ads = Ads.get(params.id)			
			ResponseUtil.renderImageBlob(response, ads.getFileData(), "ads${ads.id}${ads.releaseDate}")
		}
	}
	
	def adsRandom = {
		Random rgen = new Random()		
		def ads = Ads.createCriteria().list{
			like ('mimeType', 'image%')				
		}
		def totalAds = ads.size()
		if (totalAds>0)	{
			Ads ad = ads.getAt(rgen.nextInt(totalAds))
			ResponseUtil.renderImageBlob(response, ad.getFileData(), "ads${ads.id}${ads.releaseDate}")	
		}			
	}
	
	void updateCount(documentInstance, params) {
		
		synchronized(this.getClass()) {
		
			documentInstance.downloadCount = documentInstance.downloadCount + 1
			
			if (documentInstance.part == 1) {
				// add to the issue download count
				
				def _downloadCount = null
				def day = new Date().getAt(Calendar.DAY_OF_MONTH)
				def month = (new Date().getAt(Calendar.MONTH))+1
				def year = new Date().getAt(Calendar.YEAR)
				
				def _issue = documentInstance.issue
				
				def _user = null
				if (params.userid) {
					_user = User.get(params.userid)
				} else if (authenticateService.principal()) {
					_user = authenticateService.userDomain()
				}
	
				if (_user) {
					// user specific download
					//println "Specific user download - user $_user.id downloaded issue $_issue.id"
					
					_downloadCount = DownloadCount.createCriteria().get {
						eq("user", _user)
						eq("issue", _issue)
						eq("day", day)
						eq("month", month)
						eq("year", year)
					}
					
					if (!_downloadCount) {
						_downloadCount = new DownloadCount(user: _user, issue: _issue)
					}
					
					_downloadCount.downloadCount++
					
				} // end if user download
				else
				{
					// public download
					//println "Anonymous download for issue $_issue.id"
					
					_downloadCount = DownloadCount.createCriteria().get {
						isNull("user")
						eq("issue", _issue)
						eq("day", day)
						eq("month", month)
						eq("year", year)
					}
					
					if (!_downloadCount) {
						_downloadCount = new DownloadCount(user: null, issue: _issue)
					}
					
					_downloadCount.downloadCount++
					
				} // end if anonymous download
				
				_downloadCount.save()
			} // end if document is 1st part

		}
	}
	
	def download = {
		def documentInstance = Document.read(params.id)
		
		if (documentInstance) {
			FileUtil.renderFilePDF(response, documentInstance.name, documentInstance.fileData)
			updateCount(documentInstance, params)
		} else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'document.label', default: 'Document'), params.id])}"
			redirect(action: "list")
		}
	}
	
	def issueThumbnail = {
		Issue issue = Issue.get(params.id)
		
		if (issue) {
			ResponseUtil.renderImageBlob(response, issue.thumbnail, "issue${issue.id}${issue.lastUpdated}")
		} else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'document.label', default: 'Document'), params.id])}"
			redirect(action: "list")
		}
	}
	def mediaKit = {
		if (params.id)
		{
			Publication pub = Publication.findByPubId(params.id)
			//ResponseUtil.renderPDF(response, pub.mediaKit, "mediaKit_for_"+pub.pubShortName)
			FileUtil.renderFilePDF(response, "mediaKit_for_"+pub.pubShortName,pub.mediaKit)
		}
	}
	def issueThumbnailByPubId = {
		if (params.id)
		{
			def pubIssues = Issue.createCriteria().list {
				publication { eq("pubId", Integer.parseInt( params.id)) }
				order('releaseDate', 'desc')
				order('number', 'desc')
			}
			if (pubIssues)
			{
				ResponseUtil.renderImageBlob(response, pubIssues[0].thumbnail, "issue${pubIssues[0].id}${pubIssues[0].lastUpdated}")
			}
		}
	}
	
	def pubMastHead = {
		if (params.id)
		{
			Publication pub = Publication.findByPubId(params.id)
			ResponseUtil.renderImageBlob(response, pub.mastHead, "masthead${pub.id}")
		}
	}
	
	def latestZip = {
		if (params.id)
		{
			def results = Issue.createCriteria().list() {
				  eq("publication.id", Long.parseLong(params.id))
				  le("releaseDate", new Date())
				  maxResults(1)
				  order("releaseDate", "desc")
			}
			
			def latest = null
			if (results.size() == 1) {
				latest = results[0]
			}
			
			if (latest) {
				// create zip file entries
				def entries = []
				for (document in latest.documents) {
					entries << new ZipFileEntry(document.fileName, document.fileData.binaryStream)
				}
				
				def downloadfilename = "${latest.name}.zip"
				
				// make the zip file
				response.contentType = "application/zip"
				response.setHeader("Content-disposition", "attachment; filename=\"${downloadfilename}\"")
				ZipUtil.writeZipStream(response.outputStream, entries)
			}
			
		}
			
	}
	def contact ={
		if (params.emailAddress){
			
		
			mailService.sendMail {
				from "info@tradelinkmedia.biz"
	    		cc params.emailAddress
	    		to 	"info@tradelinkmedia.biz"	
	    		
	    		subject params.subject
	    		html "<html><body>" +
	    			 "Name: ${params.yourName}<br/>"+
	    			 "Company Name: ${params.companyName}<br/>"+
	    			 "Message: ${params.message}<br/>"+
	    			 "</body></html>"
	    	}
			render(contentType: "application/json", text: "{success:true}")	
		}		
	}
	
	
}
