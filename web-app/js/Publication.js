var globalObj;
var globalNewsPanel;
function Publications() {
	var pubObj;
	var pubStore;
	var publicationSlider;
	this.init = function(){
		 var timestamp = Number(new Date()); 
		 Ext.Ajax.request ({url: urls.pubList,
	           async : true,
	           method: 'POST',
	           success: function(responseObject) {
		            var pubData= responseObject.responseText;
		            pubObj = eval("(" + pubData + ")");	 
		            pubStore = getJsonStore('lookup/publications', 'items', 'id', publicationFields);
		            pubStore.loadData({items:pubObj});
		           	    
		  		    Ext.get('basic-slider').setWidth(300);
				    Ext.get('basic-slider').center(Ext.get('sliderOutDiv'));
				    imageLoaded();
	           },
	           failure: function() {
	                  window.location.href="/tlm";
	          }
	       });		 				 
	};
	this.getPublicationList = function(){
		return pubObj;	
	};
	this.getPublicationStore = function(){
		return pubStore;
	};
	this.getPublicationSlider =function(){
		return publicationSlider;
	};
	
};

function imageLoaded(){
	Ext.get('nextPageDiv').show();
	Ext.get('loadingDiv').hide();
	Ext.get('nextPageImage').on('click',function (){
		Ext.get('loading').hide();
	    Ext.get('loading-mask').fadeOut({remove:false});
	    Ext.get('nextPageDiv').hide();
	});		  		
}
MyDesktop.PublicationWindow = Ext.extend(Ext.app.Module, {
   id:'pub-win',
   init : function(){
       this.launcher = {
           text: 'Publication',
           iconCls:'icon-grid',
           handler : this.createWindow,
           scope: this
       }
   },

   createWindow : function(pubId){ 
	   var pubObjList = PublicationsPers.getPublicationList();
	   for (i=0;i<pubObjList.length;i++){
              if (pubObjList[i].pubId==pubId)
              {
            	  pubObj=pubObjList[i];
	              globalObj = pubObj;                              
	              var desktop = globalApp.getDesktop();
	              var win = desktop.getWindow('pub-win');	             
	              generatePublicationPanel(pubObj);	              
	              var taskInner =  new Ext.util.DelayedTask(function(){
	            	  Ext.get('twoDivsOnly').scroll('down',350,true);
	            	  generatePublicationLinksHtml(pubId);   
	            	 
	            	  new Ext.util.DelayedTask(function(){
	            		  var returnDiv = Ext.get('returnDiv');
	            		  returnDiv.center();
	            		  returnDiv.setY(27);
	            		  returnDiv.show(true);
	            	  }).delay(700);
	      	      });
	      	      taskInner.delay(500);	      	         
	              Ext.MessageBox.hide();   
              }
	   }
   }
});

function generatePublicationPanel(pubObj)
{
   
 var publicationPanel=new Ext.Container({
	  id:'publicationPanel',
	  renderTo:'mainDiv',
	  height:300,
	  style: 'padding:15px;',		 
	  html:pubObj.htmlWriteUp
  });
 return publicationPanel;
}

function generatePublicationLinksHtml(pubId)
{
     var temp = Ext.get('publicationLinksDiv');
     
     var downloadLatestLink = '<a href="#" onclick="window.location.href=\''+urlPath+'response/latestZip/'+pubId+'\'"><img src="images/buttons/buttons-download-zip.png"></a>'
     var downloadDialogLink = '<a href="#" onclick="openDownloads('+pubId+')"><img src="images/buttons/buttons-download-pdf.png"></a>'
     var downloadMediaKitLink = '<a href="#" onclick="window.location.href=\''+urlPath+'response/mediaKit/'+pubId+'\'"><img src="images/buttons/buttons-download-mk.png"></a>'
     
     temp.update('<div id="publicationLinksInnerDiv">'+downloadLatestLink+downloadDialogLink+downloadMediaKitLink+'</div>');
     temp.show(true);
}
