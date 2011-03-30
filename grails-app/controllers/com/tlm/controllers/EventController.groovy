package com.tlm.controllers;

import grails.converters.JSON
import com.tlm.beans.*
import com.tlm.utils.*
import java.util.Map

class EventController {
	

	
	static allowedMethods = [save: "POST", update: "POST"]
	
	def index = {
		redirect(action: "list", params: params)
	}
	
	def list = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		[eventInstanceList: Event.list(params), eventInstanceTotal: Event.count()]
	}
	
	def create = {
		def eventInstance = new Event()
		eventInstance.properties = params
		return [eventInstance: eventInstance,pubList: Publication.list()]
	}
	
	def save = {
		def eventInstance = new Event(params)
		if (eventInstance.save(flush: true)) {
			addPublications(eventInstance)
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'event.label', default: 'Event'), eventInstance.id])}"
			redirect(action: "show", id: eventInstance.id)
		}
		else {
			render(view: "create", model: [eventInstance: eventInstance,pubList: Publication.list()])
		}
		
		
	}
	
	def show = {
		def eventInstance = Event.get(params.id)
		if (!eventInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'event.label', default: 'Event'), params.id])}"
			redirect(action: "list")
		}
		else {
			[eventInstance: eventInstance]
		}
	}
	
	def edit = {
		def eventInstance = Event.get(params.id)
		if (!eventInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'event.label', default: 'Event'), params.id])}"
			redirect(action: "list")
		}
		else {
			return buildEventModel(eventInstance)
		}
	}
	
	def update = {
		def eventInstance = Event.get(params.id)
		if (eventInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (eventInstance.version > version) {
					
					eventInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'event.label', default: 'Event')] as Object[], "Another user has updated this Event while you were editing")
					render(view: "edit", model: [eventInstance: eventInstance])
					return
				}
			}
			eventInstance.properties = params
			if (!eventInstance.hasErrors() && eventInstance.save(flush: true)) {
				Publication.findAll().each { it.removeFromEvents(eventInstance) }
				addPublications(eventInstance)
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'event.label', default: 'Event'), eventInstance.id])}"
				redirect(action: "show", id: eventInstance.id)
			}
			else {
				render(view: "edit", model: buildUserModel(eventInstance))
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'event.label', default: 'Event'), params.id])}"
			redirect(action: "list")
		}
	}
	
	def delete = {
		def eventInstance = Event.get(params.id)
		if (eventInstance) {
			try {
				eventInstance.delete(flush: true)
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'event.label', default: 'Event'), params.id])}"
				redirect(action: "list")
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'event.label', default: 'Event'), params.id])}"
				redirect(action: "show", id: params.id)
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'event.label', default: 'Event'), params.id])}"
			redirect(action: "list")
		}
	}
	private void addPublications(event) {
		for (String key in params.keySet()) {
			if (key.startsWith('PUB_') && 'on' == params.get(key)) {
				Publication.findByPubId(Integer.parseInt(key.substring(4))).addToEvents(event)
			}
		}
	}
	
	private Map buildEventModel(event) {
		
		// get a list of all roles
		List publications = Publication.list()

		
		// get a set of all role names the user has
		Set publicationNames = []
		for (pub in event.publications) {
			publicationNames << pub.pubId
		}
		
		// set whether a user has a role by checking userRoleNames if it contains
		// a role in the set of all roles
		LinkedHashMap<Publication, Boolean> pubMap = [:]
		for (pub in publications) {
			pubMap[(pub)] = publicationNames.contains(pub.pubId)
		}

		return [eventInstance: event, pubMap: pubMap]
	}
}
