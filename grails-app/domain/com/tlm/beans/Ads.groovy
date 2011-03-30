package com.tlm.beans
import java.sql.Blob
import java.util.Date;

class Ads {
	static searchable = true
    static constraints = {		
		mimeType(nullable: true)
    }
    static belongsTo = Publication
    static hasMany = [publications: Publication]
    
    String name // (corresponds to banners.title in old system)
    String fileName
    Blob fileData
	Date releaseDate=new Date() // corresponds to banners.startDate in old system
	Date expireDate=new Date()+30 // corresponds to banners.endDate in old system
	String url // corresponds to banners.url in old system
	Integer rank = 2 // corresponds to banners.rank in old system
	String mimeType // (corresponds to banners.extension in old system)
	static transients = ["adType"]
	
	String getAdType()
	{
    	if (mimeType!=null)
		{
    		if (mimeType.contains("image"))
    			return "image"
			else
				return "flash"
		}
		else
			return "image"
	}

}