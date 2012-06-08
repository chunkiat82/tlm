package com.tlm.controllers
import java.util.Date

import com.tlm.beans.*
import com.tlm.utils.*

class JsonController {
	def jsonService;
	def index = {
		redirect(action: "publicationList", params: params)
	}
	
	def publicationList = {
		response.setHeader("Cache-Control", "no-store")		
		JSON.use("deep"){
			render(contentType: "application/json", text:Publication.list() as JSON)			
		}
	}
	def publication = {
		
		def pubList  = Publication.createCriteria().get{
			if (params.id){
				eq ("pubId",Integer.parseInt( params.id))
				news{
					order("publicationDate","DESC")
				}
			}						
			order('pubId', 'desc')
		}
		response.setHeader("Cache-Control", "no-store")		
		JSON.use("deep"){
			render(contentType: "application/json", text:pubList as JSON)			
		}

	}
	def issueListByPubId = {
		if (params.id){
			def pubIssues = Issue.createCriteria().list(){
				publication { eq("pubId", Integer.parseInt( params.id))}
				order('releaseDate', 'desc')
					
			}
			for (p in pubIssues){
				p.documents=null;
				def docs = Document.executeQuery("select name, part ,id from Document where issue.id=?",[p.id])
				SortedSet set2 = new TreeSet();
				for (d in docs){
					Document ne =  new Document();
					ne.name=d[0]
					ne.part=d[1]
					ne.id=d[2]
					set2.add(ne)
				}
				p.documents=set2
				
			}		
			JSON.use("deep") {
				render(contentType: "application/json", text:[success: "true", items: pubIssues] as JSON)
			}
		}
		
	}
	
	def eventListPage = {
		def pagingConfig = [
		max: params.limit ?: 25,
		offset: params.start ?: 0,
		sort: params.sort ?: 'id',
		order: params.dir ?: 'asc'
		]
		def results = Event.createCriteria().list(pagingConfig) {
			5.times {index ->
				def field = params["filter[${index}][field]"]
				def type = params["filter[${index}][data][type]"]
				def value = params["filter[${index}][data][value]"]
				if (field && value) {
					like(field, "%${value}%").ignoreCase()
				}
			}
			ge("endDate", DateUtil.today())			
		}
		def json = [
		totalCount: results.totalCount,
		items: results.list
		]
		response.setHeader("Cache-Control", "no-store")
		JSON.use("deep"){			
			render(contentType: "application/json", text: json as JSON)			
		}
	}
	def eventList = {
			def results = Event.createCriteria().list() {		
				ge("endDate", DateUtil.today())			
			}
			response.setHeader("Cache-Control", "no-store")
			JSON.use("deep"){			
			
				render(contentType: "application/json", text:[success: "true", items:results, totalCount:results.size ] as JSON)
			}
	}
	def supplierListPage = {
		def pagingConfig = [
		max: params.limit ?: 25,
		offset: params.start ?: 0,
		sort: params.sort ?: 'id',
		order: params.dir ?: 'asc'
		]
		session.searchParams=params.company
		def results = Supplier.createCriteria().list(pagingConfig) {
			5.times {index ->
				def field = params["filter[${index}][field]"]
				def type = params["filter[${index}][data][type]"]
				def value = params["filter[${index}][data][value]"]
				if (field && value) {
					like(field, "%${value}%").ignoreCase()
				}
			}
		}
		if  (session.searchParams) {
			session.searchParams=params.company
			results = Supplier.createCriteria().list(pagingConfig){
				like("company", session.searchParams+"%")					
			}
		}
		def json = [
		totalCount: results.totalCount,
		items: results.list
		]
		response.setHeader("Cache-Control", "no-store")
		JSON.use("deep"){
			render(contentType: "application/json", text: json as JSON)
			
		}
		//			render json as JSON.
	}
	def supplierList = {
		response.setHeader("Cache-Control", "no-store")
		def json = [			
		items: Supplier.list()
		]
		JSON.use("deep"){
			render(contentType: "application/json", text: json as JSON)			
		}
	}
	
	def downloadList = { 
		response.setHeader("Cache-Control", "no-store")
		def json = [			
		items: Supplier.list()
		]
		JSON.use("deep"){
			render(contentType: "application/json", text: json as JSON)			
		}
	}
	
	//2 = all 1 = events 2= sponsors
	def adsList = {
		int maxResult=20
		if (params.size)
			maxResult=Integer.parseInt(params.size)
		
		response.setHeader("Cache-Control", "no-store")
		def objList = Ads.createCriteria().list{
			if (params.pubid){
				publications { eq("pubId", Integer.parseInt( params.id))}
			}			
			if (params.rank){
				if (Integer.parseInt(params.rank) >1)
					//events
					le("rank", 2)
				else
				{
					//sponsors
					order("name","asc")
					ge("rank", 2)
				}
			}
			ge ( "expireDate", new Date() )
			order("expireDate", "asc")
		}
		if (params.rank=="1")
			objList=  shuffleArrayList(objList)[1..maxResult]
		
		JSON.use("deep"){
			render([success: "true", items:objList ] as JSON)			
		}
	}	
	
	def newsList = {
			int maxResult=20
			if (params.size)
				maxResult=Integer.parseInt(params.size)
			
			response.setHeader("Cache-Control", "no-store")
			def objList = News.createCriteria().list{
				if (params.pubid){
					publication { eq("pubId", Integer.parseInt( params.id))}
				}			
				maxResults(maxResult)
				order("publicationDate", "desc")
			}
			JSON.use("deep"){
				render([success: "true", items:objList ] as JSON)			
			}
		}
	def userIdCheck ={
			if (params.userId){
				def user = User.findByUserName(params.userId)
				if (user!=null){
					JSON.use("deep"){
						render([success: "true"] as JSON)			
					}
				}
			}

			JSON.use("deep"){
				render([success: "false" ] as JSON)			
			}

	}
	def industrialLinkList = {
		response.setHeader("Cache-Control", "no-store")
		def json = [
			items: IndustrialLink.list()
		]
		JSON.use("deep"){
			render(contentType: "application/json", text: json as JSON)
		}
	}
	
	def shuffleArrayList = { source ->
		ArrayList sortedList = new ArrayList();
		Random generator = new Random();
		while (source.size() > 0)
		{
			int position = generator.nextInt(source.size());
			sortedList.add(source[position]);
			source.remove(position);
		}
	
		return sortedList;
	}
	
}


//example
//			def tasks = c2.list{
//				eq("assignee.id", task.assignee.id)
//				maxResults(new Integer(params.max))
//				firstResult(new Integer(params.offset))
//				fetchMode('assignee', FM.EAGER)
//				fetchMode('project', FM.EAGER)
//				order('priority', 'asc')
//			}
