package com.tlm.controllers
import com.tlm.beans.*

class DownloadCountController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
		//
		def groupCount = DownloadCount.createCriteria().list(){	
			projections {
				property("issue")
				groupProperty("year")
				groupProperty("month")
				sum("downloadCount")
				groupProperty("issue.id")											
				order("year","desc")
				order("month","desc")
			}				
			gt("year",(Calendar.getInstance().get(Calendar.YEAR)-5))
		}		
			
		return [downloadCountInstanceList: groupCount]
    }

    def create = {
        def downloadCountInstance = new DownloadCount()
        downloadCountInstance.properties = params
        return [downloadCountInstance: downloadCountInstance]
    }

    def save = {
        def downloadCountInstance = new DownloadCount(params)
        if (downloadCountInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'downloadCount.label', default: 'DownloadCount'), downloadCountInstance.id])}"
            redirect(action: "show", id: downloadCountInstance.id)
        }
        else {
            render(view: "create", model: [downloadCountInstance: downloadCountInstance])
        }
    }

    def show = {
        def downloadCountInstance = DownloadCount.get(params.id)
        if (!downloadCountInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'downloadCount.label', default: 'DownloadCount'), params.id])}"
            redirect(action: "list")
        }
        else {
            [downloadCountInstance: downloadCountInstance]
        }
    }

    def edit = {
        def downloadCountInstance = DownloadCount.get(params.id)
        if (!downloadCountInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'downloadCount.label', default: 'DownloadCount'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [downloadCountInstance: downloadCountInstance]
        }
    }

    def update = {
        def downloadCountInstance = DownloadCount.get(params.id)
        if (downloadCountInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (downloadCountInstance.version > version) {
                    
                    downloadCountInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'downloadCount.label', default: 'DownloadCount')] as Object[], "Another user has updated this DownloadCount while you were editing")
                    render(view: "edit", model: [downloadCountInstance: downloadCountInstance])
                    return
                }
            }
            downloadCountInstance.properties = params
            if (!downloadCountInstance.hasErrors() && downloadCountInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'downloadCount.label', default: 'DownloadCount'), downloadCountInstance.id])}"
                redirect(action: "show", id: downloadCountInstance.id)
            }
            else {
                render(view: "edit", model: [downloadCountInstance: downloadCountInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'downloadCount.label', default: 'DownloadCount'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def downloadCountInstance = DownloadCount.get(params.id)
        if (downloadCountInstance) {
            try {
                downloadCountInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'downloadCount.label', default: 'DownloadCount'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'downloadCount.label', default: 'DownloadCount'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'downloadCount.label', default: 'DownloadCount'), params.id])}"
            redirect(action: "list")
        }
    }
}
