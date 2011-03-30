package com.tlm.controllers

import javax.activation.MimetypesFileTypeMap;
import com.tlm.beans.*

class MailController {

    def index = {
		flash.message = "Select a publication to mail out."
		
		[publications : Publication.list()]
		
	}
	
	def mail = {
		def publication = Publication.get(params.id)
		
		if (!publication) {
			flash.message = "No publication exists with id [$params.id]"
			redirect(action: 'index')
		}
		
		def mimetype = new MimetypesFileTypeMap().getContentType(publication.fileName)

        println "Mimetype = " + mimetype
		
		sendMail {
			multipart true
			to "test@soho.sg"
			from "test@soho.sg"
			subject publication.pubLongName
			body "Hello Raymond! Your publication is in the attached file."
			attachBytes publication.fileName, mimetype, publication.fileData?.binaryStream.text.bytes
		}
		
		flash.message = "Mail has been sent."
		println "Mail has been sent"
		redirect(action: 'index')
		
	}
}
