package com.tlm.beans

import java.sql.Blob;

class Issue {
    static constraints = {
		name(nullable: false, blank: false)
		description(nullable: true, blank: true)
		number(nullable: false)
		releaseDate(nullable:false)
		thumbnail(nullable: true)
		downloadCount(nullable: false)
    }
	
	static belongsTo = [publication: Publication]
	static hasMany = [documents: Document, downloadCounts: DownloadCount]
    static mapping = { 
		sort releaseDate:"desc",number:"asc"
	}
	
	static fetchMode = [downloadCounts : 'lazy',documents:'lazy']
	
	// parent object
	Publication publication
	
	// force sorted set for documents
    SortedSet documents
	
	// details
	String name // required
	String description
	Integer number // required
	Blob thumbnail
	Integer downloadCount = 0 // contrast with document.downloadCount
	
	Date releaseDate	
	Date dateCreated
	Date lastUpdated
	
	String toString() {
		"${publication} ${number} / ${name}"
	}

	void setDownloadCounts(input){
		this.downloadCounts=input
	}
}
