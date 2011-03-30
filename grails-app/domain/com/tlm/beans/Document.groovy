package com.tlm.beans;

import java.sql.Blob;

class Document implements Comparable {
	static belongsTo = [issue:Issue]

    static constraints = {
		name(nullable: false, blank: false)
		description(nullable: false, blank: false)
		fileName(nullable: false, blank: false)
		fileData(nullable: false)
		part(nullable: true)		
		downloadCount(nullable: false)
	}

	static mapping = {
		columns{
			fileData cache:true
			fileData lazy :true
		}
		
	}
  
	static transients = ["code"]
	static fetchMode = [fileData : 'lazy']
    // owning entities
    // Publication publication
	Issue issue
	
	// optional part no.
	Integer part

	// data fields
	String name
	String description
	Date dateCreated
	//Date releaseDate
	//Date expireDate
	//Boolean approved
	String fileName
	Blob fileData
	Integer downloadCount = 0
	
	// transient field used to identify a physical file on the server
	String code
	
	String toString() {
		"Document: ${name} [${description}] (${fileName})"
	}
	
	// define sort strategy
	int compareTo(obj) {
	   part.compareTo(obj.part)
	}
	
	Blob getFileData(){
		return fileData;
	}
	void setFileData(Blob input){
		fileData=input;
	}
}
