var timerNewsCount=0;
var newsTask;
Ext.onReady(function() 
{
	Ext.get('footerNews').mask();
	ajaxCallNewsTask();
});
function ajaxCallNewsTask(url){
	var currentUrl = urls.newsList;
	
	if (newsTask!=null)
		Ext.TaskMgr.stop(newsTask);	
	if (url!=null)
		currentUrl = url;
	Ext.Ajax.request ({url: currentUrl,
        async : true,
        method: 'POST',
        success: function(responseObject) {
           var inputData= responseObject.responseText;
           var inputObj = eval("(" + inputData + ")");
        
           if (inputObj)
           {
        	   newsTask ={
        	       run: function(){updateNews(inputObj.items)},
        	       interval: 10000
        	   }
        	   Ext.TaskMgr.start(newsTask); 
           }
        },
        failure: function() {
               Ext.Msg.alert('Status', 'Unable to show history at this time. Please try again later.');
       }
    });
}
function updateNews(inputObj){
	
	var tempObj = inputObj;
    if (tempObj.length>0){
       var newsObj = tempObj;
       var newsTitle;
       if (newsObj.length<(timerNewsCount+1))
    	   timerNewsCount=0;
       var html="";           
       html+='<div id="newsBody">';
       html+='<h1 style="font-size: 120%">'+newsObj[timerNewsCount].title+'</h1>';
     //  html+='<h4 style="font-size: 100%">'+defaultDateFormat(newsObj[timerNewsCount].publicationDate)+'</h4>';
       //html+='<h4 style="font-size: 100%">'+newsObj[timerNewsCount].publicationDate+'</h4>';
       html+=newsObj[timerNewsCount].html;
       html+='</div>';
       timerNewsCount+=1;
       newTitle='News ('+(timerNewsCount)+' of '+newsObj.length+')';
       Ext.get('footerNews').fadeOut({
    	    endOpacity: 0, //can be any value between 0 and 1 (e.g. .5)
    	    easing: 'easeOut',
    	    duration: .5,
    	    remove: false,
    	    useDisplay: false,
    	    callback:function(){
		    	   Ext.get('footerNews').update('');
		           
		           new Ext.Container({
		               id:'pubNewsPanel',
		               renderTo:'footerNews',
		               title:newTitle,
		               height:200,
		               width:'100%',                   
		               margins: '5 5 5 5',
		               padding: '5 5 5 5',
		               html:html
		           });
		           Ext.get('footerNews').fadeIn();
       		}
    	});
       
   }
}