package com.tlm.controllers

import com.tlm.beans.*

class ServiceController {

    static allowedMethods = [save: "POST", update: "POST"]
    def sessionFactory 
    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [serviceInstanceList: Service.list(params), serviceInstanceTotal: Service.count()]
    }

    def create = {
        def serviceInstance = new Service()
        serviceInstance.properties = params
        return [serviceInstance: serviceInstance]
    }

    def save = {
        def serviceInstance = new Service(params)
		def connection = sessionFactory.currentSession.connection() 
		def batchInsert = connection.prepareStatement("INSERT INTO subscription (version, subscription_status,service_id,user_id,publication_id, signup_date) SELECT '0', 'A',?,id,?,now() FROM user")
		
		
        if (serviceInstance.save(flush: true)) {
			for (pub in Publication.list())
			{					
				batchInsert.setInt(1, serviceInstance.ident().toInteger())
				batchInsert.setInt(2, pub.id.toInteger())
				batchInsert.addBatch()
			}
			batchInsert.executeBatch()
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'service.label', default: 'Service'), serviceInstance.id])}"
            redirect(action: "show", id: serviceInstance.id)
        }
        else {
            render(view: "create", model: [serviceInstance: serviceInstance])
        }
    }

    def show = {
        def serviceInstance = Service.get(params.id)
        if (!serviceInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'service.label', default: 'Service'), params.id])}"
            redirect(action: "list")
        }
        else {
            [serviceInstance: serviceInstance]
        }
    }

    def edit = {
        def serviceInstance = Service.get(params.id)
        if (!serviceInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'service.label', default: 'Service'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [serviceInstance: serviceInstance]
        }
    }

    def update = {
        def serviceInstance = Service.get(params.id)
        if (serviceInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (serviceInstance.version > version) {
                    
                    serviceInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'service.label', default: 'Service')] as Object[], "Another user has updated this Service while you were editing")
                    render(view: "edit", model: [serviceInstance: serviceInstance])
                    return
                }
            }
            serviceInstance.properties = params
            if (!serviceInstance.hasErrors() && serviceInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'service.label', default: 'Service'), serviceInstance.id])}"
                redirect(action: "show", id: serviceInstance.id)
            }
            else {
                render(view: "edit", model: [serviceInstance: serviceInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'service.label', default: 'Service'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def serviceInstance = Service.get(params.id)
        //You cannot delete the first two services
        if (serviceInstance.id<3)
        	serviceInstance=null;
        if (serviceInstance) {
            try {
				serviceInstance.delete(flush: true)
				def connection = sessionFactory.currentSession.connection() 
				def deteletStatement = connection.prepareStatement("delete from subscription where service_id = ?")
				deteletStatement.setInt(1,Integer.parseInt(params.id))
				deteletStatement.execute()
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'service.label', default: 'Service'), params.id])}"
				redirect(action: "list")
				                
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'service.label', default: 'Service'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'service.label', default: 'Service'), params.id])}"
            redirect(action: "list")
        }
    }
}
