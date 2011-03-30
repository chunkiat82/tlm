package com.tlm.controllers
import com.tlm.beans.*;
class JobFunctionController {

    static allowedMethods = [save: "POST", update: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [jobFunctionInstanceList: JobFunction.list(params), jobFunctionInstanceTotal: JobFunction.count()]
    }

    def create = {
        def jobFunctionInstance = new JobFunction()
        jobFunctionInstance.properties = params
        return [jobFunctionInstance: jobFunctionInstance]
    }

    def save = {
        def jobFunctionInstance = new JobFunction(params)
        if (jobFunctionInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'jobFunction.label', default: 'JobFunction'), jobFunctionInstance.id])}"
            redirect(action: "show", id: jobFunctionInstance.id)
        }
        else {
            render(view: "create", model: [jobFunctionInstance: jobFunctionInstance])
        }
    }

    def show = {
        def jobFunctionInstance = JobFunction.get(params.id)
        if (!jobFunctionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'jobFunction.label', default: 'JobFunction'), params.id])}"
            redirect(action: "list")
        }
        else {
            [jobFunctionInstance: jobFunctionInstance]
        }
    }

    def edit = {
        def jobFunctionInstance = JobFunction.get(params.id)
        if (!jobFunctionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'jobFunction.label', default: 'JobFunction'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [jobFunctionInstance: jobFunctionInstance]
        }
    }

    def update = {
        def jobFunctionInstance = JobFunction.get(params.id)
        if (jobFunctionInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (jobFunctionInstance.version > version) {
                    
                    jobFunctionInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'jobFunction.label', default: 'JobFunction')] as Object[], "Another user has updated this JobFunction while you were editing")
                    render(view: "edit", model: [jobFunctionInstance: jobFunctionInstance])
                    return
                }
            }
            jobFunctionInstance.properties = params
            if (!jobFunctionInstance.hasErrors() && jobFunctionInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'jobFunction.label', default: 'JobFunction'), jobFunctionInstance.id])}"
                redirect(action: "show", id: jobFunctionInstance.id)
            }
            else {
                render(view: "edit", model: [jobFunctionInstance: jobFunctionInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'jobFunction.label', default: 'JobFunction'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def jobFunctionInstance = JobFunction.get(params.id)
        if (jobFunctionInstance) {
            try {
                jobFunctionInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'jobFunction.label', default: 'JobFunction'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'jobFunction.label', default: 'JobFunction'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'jobFunction.label', default: 'JobFunction'), params.id])}"
            redirect(action: "list")
        }
    }
}
