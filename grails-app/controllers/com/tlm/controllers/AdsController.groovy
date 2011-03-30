package com.tlm.controllers
import java.util.Map;
import com.tlm.beans.*
import com.tlm.utils.FileUtil
import com.tlm.utils.ThumbnailUtil
import com.tlm.utils.ResponseUtil
import grails.converters.*

class AdsController {
	
	static allowedMethods = [save: "POST", update: "POST"]
	
	def index = {
		redirect(action: "list", params: params)
	}
	
	def list = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		[adsInstanceList: Ads.list(params), adsInstanceTotal: Ads.count()]
	}
	
	def create = {
		def adsInstance = new Ads()
		adsInstance.properties = params
		return [adsInstance: adsInstance,pubList: Publication.list()]
	}
	
	def save = {
		def adsInstance = new Ads(params)
		def fileName = params["upload.fileName"]
		def code = params["upload.fileName.code"]
		
		if (fileName && code) {
			adsInstance.fileName = fileName
			adsInstance.fileData = FileUtil.getFileBlob(code)
			adsInstance.mimeType = FileUtil.getFileMimeType(fileName)
		}
		addPublications(adsInstance)
		if (adsInstance.save(flush: true)) {
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'ads.label', default: 'Ads'), adsInstance.id])}"
			redirect(action: "show", id: adsInstance.id)
		}
		else {
			render(view: "create", model: [adsInstance: adsInstance, pubList: Publication.list(),upload: [fileName : fileName, fileCode: code]])
		}
	}
	
	def show = {
		def adsInstance = Ads.get(params.id)
		if (!adsInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ads.label', default: 'Ads'), params.id])}"
			redirect(action: "list")
		}
		else {
			[adsInstance: adsInstance]
		}
	}
	
	def edit = {
		def adsInstance = Ads.get(params.id)
		if (!adsInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ads.label', default: 'Ads'), params.id])}"
			redirect(action: "list")
		}
		else {
			return buildEventModel(adsInstance)
		}
	}
	
	def update = {
		def adsInstance = Ads.get(params.id)

		def fileName = params["upload.fileName"]
		def code = params["upload.fileName.code"]
		

		if (code) {
			// user must have opted to change the file			
			adsInstance.fileName = fileName
			adsInstance.fileData = FileUtil.getFileBlob(code)
			adsInstance.mimeType = FileUtil.getFileMimeType(fileName)
		}
		
		if (adsInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (adsInstance.version > version) {
					
					adsInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'ads.label', default: 'Ads')] as Object[], "Another user has updated this Ads while you were editing")
					render(view: "edit", model: [adsInstance: adsInstance, upload: [fileName: adsInstance.fileName, fileCode: code]])
					return
				}
			}
			adsInstance.properties = params
			if (!adsInstance.hasErrors() && adsInstance.save(flush: true)) {
				Publication.findAll().each { it.removeFromAds(adsInstance) }
				addPublications(adsInstance)
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'ads.label', default: 'Ads'), adsInstance.id])}"
				redirect(action: "show", id: adsInstance.id)
			}
			else {
				def modelTemp = buildUserModel(adsInstance)				
				modelTemp.add( upload: [fileName: adsInstance.fileName, fileCode: code])
				render(view: "edit", model: modelTemp)
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ads.label', default: 'Ads'), params.id])}"
			redirect(action: "list")
		}
	}
	
	def delete = {
		def adsInstance = Ads.get(params.id)
		if (adsInstance) {
			try {
				adsInstance.delete(flush: true)
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'ads.label', default: 'Ads'), params.id])}"
				redirect(action: "list")
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'ads.label', default: 'Ads'), params.id])}"
				redirect(action: "show", id: params.id)
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ads.label', default: 'Ads'), params.id])}"
			redirect(action: "list")
		}
	}


	private void addPublications(ads) {
		for (String key in params.keySet()) {
			if (key.startsWith('PUB_') && 'on' == params.get(key)) {
				Publication.findByPubId(Integer.parseInt(key.substring(4))).addToAds(ads)
			}
		}
	}
	private Map buildEventModel(ads) {
		
		// get a list of all roles
		List publications = Publication.list()

		
		// get a set of all role names the user has
		Set publicationNames = []
		for (pub in ads.publications) {
			publicationNames << pub.pubId
		}
		
		// set whether a user has a role by checking userRoleNames if it contains
		// a role in the set of all roles
		LinkedHashMap<Publication, Boolean> pubMap = [:]
		for (pub in publications) {
			pubMap[(pub)] = publicationNames.contains(pub.pubId)
		}

		return [adsInstance: ads, pubMap: pubMap]
	}
	
		
	
}
