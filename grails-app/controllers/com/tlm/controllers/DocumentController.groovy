package com.tlm.controllers

import java.nio.ByteBuffer;
import com.sun.pdfview.*
import com.tlm.beans.*
import java.sql.Blob
import java.awt.image.*
import java.awt.*
import com.sun.image.codec.jpeg.JPEGImageEncoder
import com.sun.image.codec.jpeg.JPEGCodec
import com.tlm.utils.*

class DocumentController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [documentInstanceList: Document.list(params), documentInstanceTotal: Document.count()]
    }

    def create = {
        def documentInstance = new Document()
        documentInstance.properties = params
        return [documentInstance: documentInstance]
    }

    def save = {
        def documentInstance = new Document(params)
		
		// must manually handle file upload
		FileUtil.putFile(request.getFile("document.fileData")) { fileName, fileBlob ->
			documentInstance.fileData = fileBlob
			documentInstance.fileName = fileName
		}
		
        if (documentInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'document.label', default: 'Document'), documentInstance.id])}"
            redirect(action: "show", id: documentInstance.id)
        }
        else {
            render(view: "create", model: [documentInstance: documentInstance])
        }
    }

    def show = {
        def documentInstance = Document.get(params.id)
        if (!documentInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'document.label', default: 'Document'), params.id])}"
            redirect(action: "list")
        }
        else {
            [documentInstance: documentInstance]
        }
    }

    def edit = {
        def documentInstance = Document.get(params.id)
        if (!documentInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'document.label', default: 'Document'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [documentInstance: documentInstance]
        }
    }

    def update = {
        def documentInstance = Document.get(params.id)
        if (documentInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (documentInstance.version > version) {
                    
                    documentInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'document.label', default: 'Document')] as Object[], "Another user has updated this Document while you were editing")
                    render(view: "edit", model: [documentInstance: documentInstance])
                    return
                }
            }
            documentInstance.properties = params
            if (!documentInstance.hasErrors() && documentInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'document.label', default: 'Document'), documentInstance.id])}"
                redirect(action: "show", id: documentInstance.id)
            }
            else {
                render(view: "edit", model: [documentInstance: documentInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'document.label', default: 'Document'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def documentInstance = Document.get(params.id)
        if (documentInstance) {
            try {
                documentInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'document.label', default: 'Document'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'document.label', default: 'Document'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'document.label', default: 'Document'), params.id])}"
            redirect(action: "list")
        }
    }
	
	
	
	def thumbnail = {
		println "Hello world"
		Document documentInstance = Document.get(params.id)

		if (documentInstance) {
			
			Blob blob = documentInstance.fileData
			byte[] pdfFile = blob.getBytes(1, (int) blob.length())
			ThumbnailUtil.renderThumbnailResponse pdfFile, response			
			
		} else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'document.label', default: 'Document'), params.id])}"
			redirect(action: "list")
		}
	}
}
