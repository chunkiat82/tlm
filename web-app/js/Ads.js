Ext.onReady(function() {
	//generateAdsForEvents();
	generateAdsForSponsors();
});

function generateAdsForEvents(){
 
 
	var view =new Ext.DataView({
		applyTo:'bottomDiv',
        itemSelector: 'div.thumb-wrap',
        style:'overflow:auto',
        multiSelect: false,       
        store: 
        new Ext.data.JsonStore({
        	url: urls.adsSponsorsList,
            autoLoad: true,
            root: 'items',
            id:'id',
            fields: adsFields
        }),
        tpl: new Ext.XTemplate(
            '<tpl for=".">',
            '<div class="thumb-wrap" id="{name}">',
            '<div class="thumb"><tpl if="this.isImage(mimeType)">',
            '<a target="_blank" href="{url}" border="0"><img src="/tlm/response/adsImage/{id}" class="thumb-img" /></a>',
            '</tpl><tpl if="this.isImage(mimeType) == false">',
            '<object width="150" height="150" id="advertise3"',
			'codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"',
			'classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">',
			'<param value="/tlm/response/adsImage/{id}" name="movie">',
			'<param value="High" name="quality">',
			'<param value="#ffffff" name="bgcolor">',
			'<param value="transparent" name="wmode">',
			'<embed width="150" height="150" align=""',
			'pluginspage="http://www.macromedia.com/go/getflashplayer"',
			'type="application/x-shockwave-flash" wmode="transparent" name="advertise1"',
			'bgcolor="#ffffff" quality="High"',
			'src="/tlm/response/adsImage/{id}">',
			'</object>',
            '</tpl></div>',
            '<span>&nbsp;</span></div>',
            '</tpl>',
            {
                isImage: function(mimeType){
                	if (mimeType.indexOf("image")>=0)
                    	return true;
                    else
                    	return false;                        	
                }                
            }
        )
    });
	var topSponsor=0;
	Ext.TaskMgr.start({
	    run: function(){
			var adsEventPanel =Ext.get('bottomDiv');
			var tempTopSponsor= adsEventPanel.getScroll().left;
        	if (tempTopSponsor+100<topSponsor){
        		adsEventPanel.scrollTo('left',0,true);
        		topSponsor=0;
        	}
        	else{
	        	topSponsor+=100;
	        	adsEventPanel.scroll('right',100,true);
        	}
    	},
	    interval: 2000
	});
}

function generateAdsForSponsors(){
	   
	var view =new Ext.DataView({
		applyTo:'rightMenuDiv',
        itemSelector: 'div.thumb-wrap',
        style:'overflow:auto',
        multiSelect: false,       
        store: 
        new Ext.data.JsonStore({
        	url: urls.adsSponsorsList,
            autoLoad: true,
            root: 'items',
            id:'id',
            fields: adsFields
        }),
        tpl: new Ext.XTemplate(
            '<tpl for=".">',
            '<div class="thumb-wrap" id="{name}">',
            '<div class="thumb"><tpl if="this.isImage(mimeType)">',
            '<a href="{url}" target="_blank" border="0"><img src="/tlm/response/adsImage/{id}" class="thumb-img" /></a>',
            '</tpl><tpl if="this.isImage(mimeType) == false">',
            '<object width="150" height="150" id="advertise3"',
			'codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"',
			'classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">',
			'<param value="/tlm/response/adsImage/{id}" name="movie">',
			'<param value="High" name="quality">',
			'<param value="#ffffff" name="bgcolor">',
			'<param value="transparent" name="wmode">',
			'<embed width="150" height="150" align=""',
			'pluginspage="http://www.macromedia.com/go/getflashplayer"',
			'type="application/x-shockwave-flash" wmode="transparent" name="advertise1"',
			'bgcolor="#ffffff" quality="High"',
			'src="/tlm/response/adsImage/{id}">',
			'</object>',
            '</tpl></div>',
            '<span>&nbsp;</span></div>',
            '</tpl>',
            {
                isImage: function(mimeType){
                	if (mimeType.indexOf("image")>=0)
                    	return true;
                    else
                    	return false;                        	
                }                
            }
        )
    });
	var topSponsor=0;
	Ext.TaskMgr.start({
	    run: function(){
			var adsEventPanel =Ext.get('rightMenuDiv');
        	//var tempTopSponsor= sponsorsPanel.body.getScroll().top;
			var tempTopSponsor= adsEventPanel.getScroll().top;
        	if (tempTopSponsor+100<topSponsor){
        		adsEventPanel.scrollTo('top',0,true);
        		topSponsor=0;
        	}
        	else{
	        	topSponsor+=100;
	        	adsEventPanel.scroll('b',100,true);
        	}
    	},
	    interval: 2000
	});
}