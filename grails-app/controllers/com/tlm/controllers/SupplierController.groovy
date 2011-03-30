package com.tlm.controllers

import java.util.Map;
import grails.converters.JSON
import com.tlm.beans.*

class SupplierController {
	
	static allowedMethods = [save: "POST", update: "POST"]
	
	def index = {
		redirect(action: "list", params: params)
	}
	
	def list = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		[supplierInstanceList: Supplier.list(params), supplierInstanceTotal: Supplier.count()]
	}
	
	def create = {
		def supplierInstance = new Supplier()
		supplierInstance.properties = params
		return [supplierInstance: supplierInstance,pubList: Publication.list()]
	}
	
	def save = {
		def supplierInstance = new Supplier(params)
		if (supplierInstance.save(flush: true)) {
			addPublications(supplierInstance)
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'supplier.label', default: 'Supplier'), supplierInstance.id])}"
			redirect(action: "show", id: supplierInstance.id)
		}
		else {
			render(view: "create", model: [supplierInstance: supplierInstance])
		}
	}
	
	def show = {
		def supplierInstance = Supplier.get(params.id)
		if (!supplierInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'supplier.label', default: 'Supplier'), params.id])}"
			redirect(action: "list")
		}
		else {
			[supplierInstance: supplierInstance]
		}
	}
	
	def edit = {
		def supplierInstance = Supplier.get(params.id)
		if (!supplierInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'supplier.label', default: 'Supplier'), params.id])}"
			redirect(action: "list")
		}
		else {
			return buildSupplierModel(supplierInstance)
		}
	}
	
	def update = {
		def supplierInstance = Supplier.get(params.id)
		if (supplierInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (supplierInstance.version > version) {
					
					supplierInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'supplier.label', default: 'Supplier')] as Object[], "Another user has updated this Supplier while you were editing")
					render(view: "edit", model: [supplierInstance: supplierInstance])
					return
				}
			}
			supplierInstance.properties = params
			if (!supplierInstance.hasErrors() && supplierInstance.save(flush: true)) {
				Publication.findAll().each { it.removeFromSuppliers(supplierInstance) }
				addPublications(supplierInstance)
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'supplier.label', default: 'Supplier'), supplierInstance.id])}"
				redirect(action: "show", id: supplierInstance.id)
			}
			else {
				render(view: "edit", model: buildSupplierModel(supplierInstance))
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'supplier.label', default: 'Supplier'), params.id])}"
			redirect(action: "list")
		}
	}
	
	def delete = {
		def supplierInstance = Supplier.get(params.id)
		if (supplierInstance) {
			try {
				supplierInstance.delete(flush: true)
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'supplier.label', default: 'Supplier'), params.id])}"
				redirect(action: "list")
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'supplier.label', default: 'Supplier'), params.id])}"
				redirect(action: "show", id: params.id)
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'supplier.label', default: 'Supplier'), params.id])}"
			redirect(action: "list")
		}
	}
	private void addPublications(supplier) {
		for (String key in params.keySet()) {
			if (key.startsWith('PUB_') && 'on' == params.get(key)) {
				Publication.findByPubId(Integer.parseInt(key.substring(4))).addToSuppliers(supplier)
			}
		}
	}
	
	private Map buildSupplierModel(supplier) {
		
		// get a list of all roles
		List publications = Publication.list()

		
		// get a set of all role names the user has
		Set publicationNames = []
		for (pub in supplier.publications) {
			publicationNames << pub.pubId
		}
		
		// set whether a user has a role by checking userRoleNames if it contains
		// a role in the set of all roles
		LinkedHashMap<Publication, Boolean> pubMap = [:]
		for (pub in publications) {
			pubMap[(pub)] = publicationNames.contains(pub.pubId)
		}

		return [supplierInstance: supplier, pubMap: pubMap]
	}
}
