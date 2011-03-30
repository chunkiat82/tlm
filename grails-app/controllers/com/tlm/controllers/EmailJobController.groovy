package com.tlm.controllers

import java.math.RoundingMode;
import grails.converters.JSON 
import com.tlm.beans.*
import java.text.DecimalFormat;

public class EmailJobController {

    static allowedMethods = [save: "POST", update: "POST"]

    def emailJobService
    
    def progress = {
		def percentage = 1.0
		def statusLabel = ""
		
		if (params.id) {
			EmailJob emailJob = EmailJob.get(params.id)
			
			if (emailJob) {
				percentage = emailJob.progress
				statusLabel = emailJob.statusLabel
			} else {
				percentage = 0.0
				statusLabel = "Job doesn't exist?!?"				
			}
				
		}
		
		render([success: "true", progress: percentage, status: statusLabel ] as JSON)
	}
    
    def detailedProgress = {
		def percentage = 1.0
		def statusLabel = ""
		def success = 0
		def failure = 0
		def total = 0
		
		if (params.id) {
			EmailJob emailJob = EmailJob.get(params.id)
			
			if (emailJob) {
				percentage = emailJob.progress
				statusLabel = emailJob.statusLabel
				success = emailJob.success
				failure = emailJob.failure
				total = emailJob.total
			} else {
				percentage = 0.0
				statusLabel = "Job doesn't exist?!?"				
			}
				
		}
		
		render([success: "true", success: success, failure: failure, total: total, progress: percentage, status: statusLabel ] as JSON)
    }

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
    	// as a precaution, check all e-mail jobs against the mailer service.
    	emailJobService.validate()
    	
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        if (!params.sort) {
        	params.sort = 'dateCreated'
        	params.order = 'desc'
        }
        [emailJobInstanceList: EmailJob.list(params), emailJobInstanceTotal: EmailJob.count()]
    }

    def create = {
        def emailJobInstance = new EmailJob()
        emailJobInstance.properties = params
        return [emailJobInstance: emailJobInstance]
    }

    def save = {
        def emailJobInstance = new EmailJob(params)
        if (emailJobInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'emailJob.label', default: 'EmailJob'), emailJobInstance.id])}"
            redirect(action: "show", id: emailJobInstance.id)
        }
        else {
            render(view: "create", model: [emailJobInstance: emailJobInstance])
        }
    }

    def show = {
        def emailJobInstance = EmailJob.get(params.id)
        if (!emailJobInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'emailJob.label', default: 'EmailJob'), params.id])}"
            redirect(action: "list")
        }
        else {
            [emailJobInstance: emailJobInstance]
        }
    }

    def edit = {
        def emailJobInstance = EmailJob.get(params.id)
        if (!emailJobInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'emailJob.label', default: 'EmailJob'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [emailJobInstance: emailJobInstance]
        }
    }

    def update = {
        def emailJobInstance = EmailJob.get(params.id)
        if (emailJobInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (emailJobInstance.version > version) {
                    
                    emailJobInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'emailJob.label', default: 'EmailJob')] as Object[], "Another user has updated this EmailJob while you were editing")
                    render(view: "edit", model: [emailJobInstance: emailJobInstance])
                    return
                }
            }
            emailJobInstance.properties = params
            if (!emailJobInstance.hasErrors() && emailJobInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'emailJob.label', default: 'EmailJob'), emailJobInstance.id])}"
                redirect(action: "show", id: emailJobInstance.id)
            }
            else {
                render(view: "edit", model: [emailJobInstance: emailJobInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'emailJob.label', default: 'EmailJob'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def emailJobInstance = EmailJob.get(params.id)
        if (emailJobInstance) {
            try {
                emailJobInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'emailJob.label', default: 'EmailJob'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'emailJob.label', default: 'EmailJob'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'emailJob.label', default: 'EmailJob'), params.id])}"
            redirect(action: "list")
        }
    }
    
    def resume = {
    	
    	def job = EmailJob.get(params.id)
    	
    	if (job && job.status == EmailJob.STOPPED) {
    		emailJobService.startSendingFor(job, "${request.scheme}://${request.serverName}:${request.serverPort}${request.contextPath}")
    		flash.message = "Job #${job.id} has been resumed"
    	} else {
    		flash.message ="Job #${job.id} does not exist or is not STOPPED (invalid target for RESUMing)"    		
    	}
    	
    	render([success: "true"] as JSON)
    	
    	// redirect(action: "list")
    	
    }
    
    def pause = {
    	
    	def job = EmailJob.get(params.id)
    	
    	if (job && job.status == EmailJob.RUNNING) {
    		emailJobService.pause(job)
    		flash.message = "Job #${job.id} has been paused"
    	} else {
    		flash.message ="Job #${job.id} does not exist or is not RUNNING (invalid target for STOPPing)"    		
    	}
    	
    	render([success: "true"] as JSON)
    	
    	//redirect(action: "list")
    }
    
    def report = {
    	def jobId = Long.parseLong(params.id)
    	def groupBy = params.groupBy
    	
    	def hql = "select '-', sum(case eji.status when 'E' then 1 else 0 end), sum(case eji.status when 'F' then 1 else 0 end), sum(case eji.status when null then 0 else 1 end) from EmailJobItem eji where eji.emailJob.id = :id"
    	switch (groupBy) {
    		case "country":
    			hql = "select c.title, sum(case when eji.status = 'E' then 1 else 0 end), sum(case when eji.status='F' then 1 else 0 end), sum(case when eji.status is null then 0 else 1 end) from EmailJobItem eji join eji.emailJob ej with ej.id = :id join eji.user u join u.country c group by c.title";
    			break;
    		case "jobFunction":
    			hql = "select jf.title, sum(case when eji.status = 'E' then 1 else 0 end), sum(case when eji.status='F' then 1 else 0 end), sum(case when eji.status is null then 0 else 1 end) from EmailJobItem eji join eji.emailJob ej with ej.id = :id right outer join eji.user u right outer join u.jobFunction jf group by jf.title";
    			break;
    		case "jobPosition":
    			hql = "select jp.title, sum(case when eji.status = 'E' then 1 else 0 end), sum(case when eji.status='F' then 1 else 0 end), sum(case when eji.status is null then 0 else 1 end) from EmailJobItem eji join eji.emailJob ej with ej.id = :id right outer join eji.user u right outer join u.jobPosition jp group by jp.title";
    			break;
    		// TODO: Publication, Service
    	}
    	
    	println hql
    	def hqlResult = EmailJobItem.executeQuery(hql, ["id":jobId])
    	def report = []
    	              
    	println "HQL REsult is ${hqlResult}"
    	
    	for (item in hqlResult) {
   
    		def resultItem = [:]
    		resultItem.category = item[0]
    		resultItem.sent = item[1]
            resultItem.failed = item[2]
            resultItem.total = item[3]   
            report << resultItem
    
        }
    	
    	['jobId': jobId, 'groupBy': groupBy, 'report': report, 'emailJob': EmailJob.get(params.id)]
    	
    }
}
