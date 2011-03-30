package com.tlm.controllers
import com.tlm.beans.*

class RssController {

    def index = { 
    		redirect(action: "news")
    }
    def news ={
	    render(feedType:"rss", feedVersion:"2.0") {
	        title = "Trade Link Feed"
	        link = grailsApplication.config.grails.serverURL+"/rss/"

	        description = "Trade Link Media RSS News"
	
	        	News.list().each() { article -> 
		        	entry(article.title) { 
	        			link = grailsApplication.config.grails.serverURL+"/rss/newsarticle/${article.id}"
	        			publishedDate = article.publicationDate
	        			article.html // return the content  
	        		}
	        	}
	    }
    }
    def newsarticle ={
		def newsInstance = News.get(params.id)
        if (!newsInstance) {
           return null
        }
        else {
			return [newsInstance:newsInstance]
        }
    }
}
