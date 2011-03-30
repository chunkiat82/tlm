package com.tlm.controllers

import com.tlm.beans.*

class IndustrialLinkController {

    static allowedMethods = [save: "POST", update: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [industrialLinkInstanceList: IndustrialLink.list(params), industrialLinkInstanceTotal: IndustrialLink.count()]
    }

    def create = {
        def industrialLinkInstance = new IndustrialLink()
        industrialLinkInstance.properties = params
        return [industrialLinkInstance: industrialLinkInstance]
    }

    def save = {
        def industrialLinkInstance = new IndustrialLink(params)
        if (industrialLinkInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'industrialLink.label', default: 'IndustrialLink'), industrialLinkInstance.id])}"
            redirect(action: "show", id: industrialLinkInstance.id)
        }
        else {
            render(view: "create", model: [industrialLinkInstance: industrialLinkInstance])
        }
    }

    def show = {
        def industrialLinkInstance = IndustrialLink.get(params.id)
        if (!industrialLinkInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'industrialLink.label', default: 'IndustrialLink'), params.id])}"
            redirect(action: "list")
        }
        else {
            [industrialLinkInstance: industrialLinkInstance]
        }
    }

    def edit = {
        def industrialLinkInstance = IndustrialLink.get(params.id)
        if (!industrialLinkInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'industrialLink.label', default: 'IndustrialLink'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [industrialLinkInstance: industrialLinkInstance]
        }
    }

    def update = {
        def industrialLinkInstance = IndustrialLink.get(params.id)
        if (industrialLinkInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (industrialLinkInstance.version > version) {
                    
                    industrialLinkInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'industrialLink.label', default: 'IndustrialLink')] as Object[], "Another user has updated this IndustrialLink while you were editing")
                    render(view: "edit", model: [industrialLinkInstance: industrialLinkInstance])
                    return
                }
            }
            industrialLinkInstance.properties = params
            if (!industrialLinkInstance.hasErrors() && industrialLinkInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'industrialLink.label', default: 'IndustrialLink'), industrialLinkInstance.id])}"
                redirect(action: "show", id: industrialLinkInstance.id)
            }
            else {
                render(view: "edit", model: [industrialLinkInstance: industrialLinkInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'industrialLink.label', default: 'IndustrialLink'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def industrialLinkInstance = IndustrialLink.get(params.id)
        if (industrialLinkInstance) {
            try {
                industrialLinkInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'industrialLink.label', default: 'IndustrialLink'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'industrialLink.label', default: 'IndustrialLink'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'industrialLink.label', default: 'IndustrialLink'), params.id])}"
            redirect(action: "list")
        }
    }
}
