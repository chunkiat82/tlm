package com.tlm.controllers

import com.tlm.beans.*

public class TemplateController {

    static allowedMethods = [save: "POST", update: "POST", sendmassmail: "POST"]
    def emailJobService
    def sessionFactory

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [templateInstanceList: Template.list(params), templateInstanceTotal: Template.count()]
    }

    def create = {
        def templateInstance = new Template()
        templateInstance.subject = "TLM Publications"
        templateInstance.properties = params
        return [templateInstance: templateInstance]
    }

    def save = {
        def templateInstance = new Template(params)
        if (templateInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'template.label', default: 'Template'), templateInstance.id])}"
            redirect(action: "show", id: templateInstance.id)
        }
        else {
            render(view: "create", model: [templateInstance: templateInstance])
        }
    }

    def show = {
        def templateInstance = Template.get(params.id)
        if (!templateInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'template.label', default: 'Template'), params.id])}"
            redirect(action: "list")
        }
        else {
            [templateInstance: templateInstance]
        }
    }

    def edit = {
        def templateInstance = Template.get(params.id)
        if (!templateInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'template.label', default: 'Template'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [templateInstance: templateInstance]
        }
    }

    def update = {
        def templateInstance = Template.get(params.id)
        if (templateInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (templateInstance.version > version) {
                    
                    templateInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'template.label', default: 'Template')] as Object[], "Another user has updated this Template while you were editing")
                    render(view: "edit", model: [templateInstance: templateInstance])
                    return
                }
            }
            templateInstance.properties = params
            if (!templateInstance.hasErrors() && templateInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'template.label', default: 'Template'), templateInstance.id])}"
                redirect(action: "show", id: templateInstance.id)
            }
            else {
                render(view: "edit", model: [templateInstance: templateInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'template.label', default: 'Template'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def templateInstance = Template.get(params.id)
        if (templateInstance) {
            try {
                templateInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'template.label', default: 'Template'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'template.label', default: 'Template'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'template.label', default: 'Template'), params.id])}"
            redirect(action: "list")
        }
    }
	
	def massmail = {
		def template = new Template()
		
		if (params.id != null) {
			template = Template.get(params.id)
		} else {
		    template.properties = params 
		    template.subject = "TLM Publications"
	    }
		
		[templateInstance: template]
	}
	
	def sendmassmail = {
		// fetch all e-mails that fall under the selected categories
		
		def template = params['templateInstance.id'] ? Template.get(params['templateInstance.id']) : null
		def jobFunction = params['jobFunction.id'] ? JobFunction.get(params['jobFunction.id']) : null
		def jobPosition = params['jobPosition.id'] ? JobPosition.get(params['jobPosition.id']) : null
		def country = params['country.id'] ? Country.get(params['country.id']) : null
		def service = params['service.id'] && params['massmail.service'] ? Service.get(params['service.id']) : null
		def role = params['role.id'] ? Role.get(params['role.id']) : null;		
		// def publication = params['publication.id'] ? Publication.get(params['publication.id']) : null
		
		// e-mail across multiple publications
		def pubIds = request.getParameterValues("publication.id")		
		def publications = []
		pubIds.each {
			publications << Publication.get(it)
		}
		
		println "templateInstance.id = [${params['templateInstance.id']}], template = [${template}]"
		println "jobFunction.id = [${params['jobFunction.id']}], jobFunction = [${jobFunction}]"
		println "jobPosition.id = [${params['jobPosition.id']}], jobPosition = [${jobPosition}]"
		println "country.id = [${params['country.id']}], country = [${country}]" 
		println "service.id = [${params['service.id']}] and massmail.service = ${params['massmail.service']}, service = [${service}]"
		println "role.id = [${params['role.id']}"
		
		// println "publication.id = [${params['publication.id']}], publication = [${publication}]"
		publications.each {
			println it.pubLongName
		}
		
		def users = User.createCriteria().listDistinct {
			// deep associations
			if (service != null) {
				subscriptions {
					eq('service', service)
					eq('subscriptionStatus', Subscription.ACTIVE)
				}
			}
			if (publications.size() == 0) {
				// select nothing
				eq('id', (long) -1)
			} else {
				subscriptions {
					'in'('publication', publications)
				}		
			}
			if (role != null) {
				roles {
					eq('id', role.id)
				}
			}
			
			// simple associations
			if (jobFunction != null) eq('jobFunction', jobFunction)
			if (jobPosition != null) eq('jobPosition', jobPosition)
			if (country != null) eq('country', country)
			eq('accountStatus', User.ACTIVE)
			
		}
		
		println "Going to show users queries: ${users.size}"
		users.each {
			println it
		}		
		
		// create a job
		def emailJob = new EmailJob()
		emailJob.template = template
		emailJob.description = "Mass email job on \"${template == null ? 'adhoc' : template.name}\" template "
		emailJob.description += "for all users ${role == null ? 'with any role' : 'with the '+role+' role'} and ${jobFunction == null ? 'with any job function': 'who are a '+jobFunction} "
		emailJob.description += " and ${jobPosition == null ? 'with any job position' : 'are working as a '+jobPosition} "
		emailJob.description += " from ${country == null ? 'any country' : 'the country of ' + country} "
		emailJob.description += " and subscribed to ${publications == null ? 'any' : 'the '+ publications} publication(s) "
		emailJob.description += " and ${service == null ? 'any' : 'the ' + service } service"
		emailJob.html = params['data']
		emailJob.status = EmailJob.RUNNING
		
		// copy the subject, or put a default if it is blank
		if (params['subject']) {
			emailJob.subject = params['subject']
		} else {
			emailJob.subject = "TLM Publications"
		}
		
		
		emailJob.save()
		
		println "Going to create massive amounts of emailJobItem(s)";
		// create all the EmailJobItems associated with the job
		User.withTransaction {
			users.each {
				def emailJobItem = new EmailJobItem()
				emailJobItem.emailJob = emailJob
				emailJobItem.user = it
				emailJobItem.email = it.email			
				emailJobItem.status = EmailJobItem.PENDING
				emailJobItem.save(flush: true) // force flushing
				if (emailJobItem.hasErrors()) {
					println "Could not save email job item: ${emailJobItem.errors}"
				}
				
				// [28-Jan-2012] Ben: Too long since I touched gorm / hibernate.  I'm not sure
				// if this will work
				sessionFactory.currentSession.evict(emailJobItem)
				
			}
		}
		
		flash.message = "[STARTED] ${emailJob.description}"
		emailJobService.startSendingFor(emailJob, "${request.scheme}://${request.serverName}:${request.serverPort}${request.contextPath}")
		
		redirect(controller: 'emailJob', action: 'show', params:['id':emailJob.id])
		
	}
}
