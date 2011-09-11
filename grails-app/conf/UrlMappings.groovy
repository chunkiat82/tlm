class UrlMappings {
    static mappings = {
    	
  	  // special mapping for unsubscription
  	  "/unsubscribe/user/$userId?/$encodedId?"(controller:'userRegistration', action:'unsubscribe')
		
	  // special mapping for forward to friend
	  "/forward/user/$userId?/job/$jobId"(controller:'forward', action:'index')
    	
      "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }
      
	  
	  "/$id?"{
		  controller = "home"
		  action = "index"
		  constraints {
			   id(matches:/\d{1}/)
		  }
	 }
	 "/"(controller:'home', action: 'index')
	 "500"(view:'/error')
		
	  // special mapping for publication downloads
	 "/response/download/$id?/user/$userid?"(controller:'response', action:'download')
	  
	}
}
