package com.tlm.controllers
import com.tlm.beans.*;
class JobPositionController {

    static allowedMethods = [save: "POST", update: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [jobPositionInstanceList: JobPosition.list(params), jobPositionInstanceTotal: JobPosition.count()]
    }

    def create = {
        def jobPositionInstance = new JobPosition()
        jobPositionInstance.properties = params
        return [jobPositionInstance: jobPositionInstance]
    }

    def save = {
        def jobPositionInstance = new JobPosition(params)
        if (jobPositionInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'jobPosition.label', default: 'JobPosition'), jobPositionInstance.id])}"
            redirect(action: "show", id: jobPositionInstance.id)
        }
        else {
            render(view: "create", model: [jobPositionInstance: jobPositionInstance])
        }
    }

    def show = {
        def jobPositionInstance = JobPosition.get(params.id)
        if (!jobPositionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'jobPosition.label', default: 'JobPosition'), params.id])}"
            redirect(action: "list")
        }
        else {
            [jobPositionInstance: jobPositionInstance]
        }
    }

    def edit = {
        def jobPositionInstance = JobPosition.get(params.id)
        if (!jobPositionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'jobPosition.label', default: 'JobPosition'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [jobPositionInstance: jobPositionInstance]
        }
    }

    def update = {
        def jobPositionInstance = JobPosition.get(params.id)
        if (jobPositionInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (jobPositionInstance.version > version) {
                    
                    jobPositionInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'jobPosition.label', default: 'JobPosition')] as Object[], "Another user has updated this JobPosition while you were editing")
                    render(view: "edit", model: [jobPositionInstance: jobPositionInstance])
                    return
                }
            }
            jobPositionInstance.properties = params
            if (!jobPositionInstance.hasErrors() && jobPositionInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'jobPosition.label', default: 'JobPosition'), jobPositionInstance.id])}"
                redirect(action: "show", id: jobPositionInstance.id)
            }
            else {
                render(view: "edit", model: [jobPositionInstance: jobPositionInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'jobPosition.label', default: 'JobPosition'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def jobPositionInstance = JobPosition.get(params.id)
        if (jobPositionInstance) {
            try {
                jobPositionInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'jobPosition.label', default: 'JobPosition'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'jobPosition.label', default: 'JobPosition'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'jobPosition.label', default: 'JobPosition'), params.id])}"
            redirect(action: "list")
        }
    }
}
