package com.tlm.beans

import java.util.Calendar

class DownloadCount {

    static constraints = {
		issue(nullable: false)
		user(nullable: true)
		downloadCount(nullable: false)
		day(nullable: false)
		month(nullable: false)
		year(nullable: false)
    }
	static belongsTo = [issue: Issue, user: User]
	
	Issue issue
	User user
	Integer year = new Date().getAt(Calendar.YEAR)
	Integer month = new Date().getAt(Calendar.MONTH)+1
	Integer day = new Date().getAt(Calendar.DAY_OF_MONTH)
	Integer downloadCount = 0
	
}
