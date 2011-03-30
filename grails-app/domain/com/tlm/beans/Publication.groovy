package com.tlm.beans

import java.sql.Blob


class Publication {
  static searchable = true
  static constraints = {        
        mastHead(nullable: true)
        htmlWriteUp(nullable: true)
        editor(nullable: true)
        advertiser(nullable: true)
        mastHead(nullable: true)
        mediaKit(nullable: true)
        pubId(nullable: false,unique: true)
  }
  static hasMany = [events:Event, ads:Ads, suppliers:Supplier, issues:Issue, subscriptions:Subscription, news: News]
  static mapping = { 
	sort pubLongName : "asc"
	htmlWriteUp type: 'text'
  }
  static fetchMode = [subscriptions : 'lazy']  

  Integer pubId // special domain-specific id, do not remove
  String pubLongName
  String pubShortName

  // "owning" users
  User editor
  User advertiser

  // data fields
  String htmlWriteUp
  Blob mastHead
  Blob mediaKit

  String toString() {
	pubLongName
  }
  void setSubscriptions(input){
	this.subscriptions=input	
  }
  void setSuppliers(input){
	this.suppliers=input	
  }
  
  void setAds(input){
	  this.ads=input;
  }
	
//  List<News> getNews(){
//	return News.createCriteria().list{
//		if (this.id){
//			publication{
//				eq("id",this.id)
//			}
//		}
//		order ("publicationDate" , "DESC")
//	}
//  }
	void setNews(input){
		this.news=input	
	}
	
	void setIssues(input){
		this.issues=input	
	}
	void setEvents(input){
		this.events=input;
	}
	
	void setAdvertiser(input){
		this.advertiser=input;
	}
}