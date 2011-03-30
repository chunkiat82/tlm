package com.tlm.controllers

import com.tlm.beans.*
import com.tlm.utils.FileUtil
import com.tlm.utils.ThumbnailUtil
import com.tlm.utils.ResponseUtil

class IssueController {

    static allowedMethods = [save: "POST", update: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [issueInstanceList: Issue.list(params), issueInstanceTotal: Issue.count()]
    }

    def create = {
        def issueInstance = new Issue()
        issueInstance.properties = params
        return [issueInstance: issueInstance]
    }


    def save = { 
		
		def issueInstance = new Issue(params)
		
		def fileNames = request.getParameterValues ("documents.fileName")
		def names = request.getParameterValues("documents.name")
		def descriptions = request.getParameterValues("documents.description")
		def codes = request.getParameterValues("documents.fileName.code")

        def documents = []
		
		fileNames.eachWithIndex { fileName, idx ->
		    Document doc = new Document(part: idx+1, fileName: fileNames[idx], name: names[idx], description: descriptions[idx], code: codes[idx], fileData: FileUtil.getFileBlob(codes[idx]))
			documents << doc
		}
		
		def saveSuccessful = true
		
		if (issueInstance.save(flush: true)) {	
			
			documents.each { document ->
				document.issue = issueInstance
				if (!document.save(flush: true)) {
					saveSuccessful = false
					println "Failed to save ${document}"
				}
			}
			
			if (saveSuccessful) {
				// generate a thumbnail for the issue
				documents.each { document ->
					if (document.part==1)
					{
						File file = FileUtil.getFile(document.code)
						issueInstance.thumbnail = ThumbnailUtil.generateThumbnailBlob(file)
						flash.message = "${message(code: 'default.created.message', args: [message(code: 'issue.label', default: 'Issue'), issueInstance.id])}"
						redirect(action: "show", id: issueInstance.id)
					}
				}			
			}
			
		} else {
			saveSuccessful = false
		}
		
		if (!saveSuccessful) {
			documents.each { document ->
				document.delete()
			}			
			render(view: "create", model: [issueInstance: issueInstance, documents: documents])	
		} else {
			// purge temporary files
		    fileNames.each {
				FileUtil.removeFile(it)
		    }
		}
    }
    
    // legacy code kept for reference
    def oldsave = {
		
        def issueInstance = new Issue(params)
		
		def fileArray = request.getFiles("document.file")
		def docList = []
		
		// transfer individual file objects into the docList array
        fileArray.eachWithIndex { file, idx ->
			
			def document = new Document()
			document.part = idx + 1
			document.name = params["document.name"][idx]
			document.description = params["document.desc"][idx]
			
			FileUtil.putFile(file) { fileName, fileData ->
				document.fileName = fileName
				document.fileData = fileData
			}
			
			docList << document
		}
		
		def saveSuccessful = true

        if (issueInstance.save(flush: true)) {	
			
			docList.each { document ->
				document.issue = issueInstance
				if (!document.save(flush: true)) {
					saveSuccessful = false
					println "Failed to save ${document}"
				}
			}
			
			if (saveSuccessful) {
				flash.message = "${message(code: 'default.created.message', args: [message(code: 'issue.label', default: 'Issue'), issueInstance.id])}"
					redirect(action: "show", id: issueInstance.id)
			}
			
        } else {
        	saveSuccessful = false
        }
		
		if (!saveSuccessful) {
			render(view: "create", model: [issueInstance: issueInstance, docList: docList])	
		}
		
        
    }

    def show = {
        def issueInstance = Issue.get(params.id)
        if (!issueInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'issue.label', default: 'Issue'), params.id])}"
            redirect(action: "list")
        }
        else {
            [issueInstance: issueInstance]
        }
    }

    def edit = {
        def issueInstance = Issue.get(params.id)
        if (!issueInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'issue.label', default: 'Issue'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [issueInstance: issueInstance]
        }
    }

    def update = {
        def issueInstance = Issue.get(params.id)
        
        // stuff for file upload
        def filename = params['replace_thumbnail']
        def filecode = params['replace_thumbnail.code']
        
        if (issueInstance) {
        	// [040510] Ben: I'm just going to ignore remembering the filename if there is a versioning issue.
            if (params.version) {
                def version = params.version.toLong()
                if (issueInstance.version > version) {
                    
                    issueInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'issue.label', default: 'Issue')] as Object[], "Another user has updated this Issue while you were editing")
                    render(view: "edit", model: [issueInstance: issueInstance])
                    return
                }
            }
            
            // attempt to make the save
            issueInstance.properties = params
            
            // [040510] Ben: upload any new thumbnails as needed
            println "filecode = [$filecode]"
            if (filecode) {
            	issueInstance.thumbnail = FileUtil.getFileBlob(filecode)
            }
            
            if (!issueInstance.hasErrors() && issueInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'issue.label', default: 'Issue'), issueInstance.id])}"
                redirect(action: "show", id: issueInstance.id)
            }
            else {
            	// [040510] Ben: Render different nonsense depending on whether the user opted to upload a replacement thumbnail
            	if (filecode) {
            		render(view: "edit", model: [issueInstance : issueInstance, filename: filename, filecode: filecode])
            	} else {
            		render(view: "edit", model: [issueInstance: issueInstance])
            	}
                
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'issue.label', default: 'Issue'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def issueInstance = Issue.get(params.id)
        if (issueInstance) {
            try {
                issueInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'issue.label', default: 'Issue'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'issue.label', default: 'Issue'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'issue.label', default: 'Issue'), params.id])}"
            redirect(action: "list")
        }
    }
	
	
    
}
