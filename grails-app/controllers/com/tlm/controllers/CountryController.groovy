package com.tlm.controllers
import grails.converters.*
import com.tlm.beans.*

class CountryController {

	def list = {
		render Country.list() as JSON      
	}
	
	def showImage = {
		Country country = Country.get(params.id)
		response.contentType = "image"		
        response.outputStream << country?.image?.getBinaryStream()
		response.outputStream.flush()
	}
	def populate = {
		def listObjects = Country.list();		
		println listObjects.size() 		
		listObjects.each {println "http://www.bannersoftheworld.com/flag-pictures/"+it.title.toLowerCase()+"-flag.gif"} // 0123456789
		   
	}
}
