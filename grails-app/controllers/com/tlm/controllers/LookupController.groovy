package com.tlm.controllers

import com.tlm.utils.JSON 
import com.tlm.beans.*;
import org.hibernate.FetchMode;

class LookupController {
    def index = {
/*		def wrap = { str ->
			"<p>" + str + "</p>"			
		}
		
		def requestStuff = ""
		
		requestStuff += wrap(request.)
		*/
		render "${request.scheme}://${request.serverName}:${request.serverPort}${request.contextPath}"
		
	}
	
	def jobPositions = {
		render([items: JobPosition.list()] as JSON)
	}
	
	def countries = {
   	    render ([items: Country.list()] as JSON)
	}
	
	def jobFunctions = {
        render ([items: JobFunction.list()] as JSON)
	}
	
	def honorifics = {
		render ([items: LookupHonorific.list()] as JSON)
	}
	
	def publications = {
		render ([items: Publications.list()] as JSON)
	}
	
	def suppliers = {
		JSON.use("deep") {
			render ([items: Supplier.list()] as JSON)
		} 
	}
	
	def manytomanydebugginggarbage = {
		def supplierList = Supplier.createCriteria().list {
		 eq("company", "Corbell")
		 join('publications')
		 }
		
		supplierList.each {
		 println ">"+it.class.canonicalName
		
		 it.publications.each {
		   // println it.pubLongName
		   println ">>"+it.class.canonicalName
		
		   it.suppliers.each {
		     println ">>>"+it.class.canonicalName
		   }
		 }
	   }
		
	}
	
	
}
