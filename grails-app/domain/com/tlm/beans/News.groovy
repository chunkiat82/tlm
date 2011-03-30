package com.tlm.beans

class News {
	static searchable = true
    static constraints = {
		title(nullable: false, blank: false)
		html(nullable: false, blank: false)
		publicationDate(nullable: false)
    }

    static belongsTo = [publication: Publication]

    static mapping = {
    	html type: 'text'
    	sort publicationDate:"desc"
    }

    Publication publication
	String title
	String html
	Date publicationDate
	
	String toString() {
		title
	}
	
}
