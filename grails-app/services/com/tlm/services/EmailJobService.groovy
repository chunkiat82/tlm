package com.tlm.services

import com.tlm.beans.EmailJob 
import com.tlm.utils.Mailer

class EmailJobService {
	
	boolean transactional = false
	def sessionFactory
	def mailService
	static def jobMap = [:] 
	
	def startSendingFor(EmailJob job, String fullContextPath) {
		
		// send only if the job is not complete, and there isn't an existing job in the job map
		def jobAlreadyStarted = jobMap.containsKey(job.id)
		def jobAlreadyComplete = EmailJob.COMPLETED.equals(job.status)

        if (!jobAlreadyStarted && !jobAlreadyComplete) {
        	
		  Thread thread = new Thread(new Mailer(mailService, job, fullContextPath))
		  thread.start() // the thread will update the job status to running automatically		  

		  jobMap.put(job.id, thread)
		}
		
	}
	
	def pause(EmailJob job) {
		// pause only if the job is RUNNING, and there is an existing job in the job map
		def jobAlreadyStarted = jobMap.containsKey(job.id)
		def jobStopped = EmailJob.STOPPED.equals(job.status)
		
		if (jobAlreadyStarted && !jobStopped) {
			
			Thread thread = jobMap.get(job.id)
			thread.interrupt() // the thread will update the job status to STOPPED automatically
		}
		
	}
	
	def validate() {
		// checks all jobs in the database against the current job pool.  if the job is "RUNNING"
		// but the id is not in the jobMap, then we need to set it to "STOPPED", allowing the user
		// to resume the job		
		
		def runningJobs = EmailJob.createCriteria().list {
			eq('status', 'R')
		}
		
		runningJobs.each { job ->
			if (job.status == EmailJob.RUNNING && !jobMap.containsKey(job.id)) {
				println "Corrected ${job.id} from RUNNING to STOPPED status"
				job.status = EmailJob.STOPPED
				job.save()
			}
		}
	}
	
	
	
}
