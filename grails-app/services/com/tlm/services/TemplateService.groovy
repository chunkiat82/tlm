package com.tlm.services

import com.tlm.beans.Template

class TemplateService {

    boolean transactional = true

    def saveTemplate(Template template) {
		template.save()
		
		if (template.hasErrors()) {
			return template.errors
		}
		
		return true
    }
	
	def emailTemplate() {
		
	}
}
