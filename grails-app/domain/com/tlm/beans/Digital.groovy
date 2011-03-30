package com.tlm.beans
import java.sql.Blob

class Digital {

    static constraints = {
    }
    static belongsTo = Publication

    // relations
    Publication pub
	
	// data
	String title
	String description		
    Blob file
    String fileName
    Date createdDate
    Integer height
    Integer width

}
