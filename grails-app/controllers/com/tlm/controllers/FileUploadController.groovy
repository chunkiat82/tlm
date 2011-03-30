package com.tlm.controllers;

import org.hibernate.Hibernate;
import com.tlm.beans.*;
import com.tlm.utils.FileUtil

class FileUploadController {
	
	def swfuploadtest = { }
	
    def swfupload = {
		def name = FileUtil.saveFile(request.getFile("Filedata"))
		render name
	}
}
