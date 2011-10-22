/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
var numberOfPubPerRow= 4;
var urlPath = "/tlm/";
var urls={
	pubList:urlPath+'json/publicationList/',
	pubGet:urlPath+'json/publication/',
	issueListByPubId:urlPath+'json/issueListByPubId',
	eventListPage:urlPath+'json/eventListPage',
	eventList:urlPath+'json/eventList',
	supplierListPage:urlPath+'json/supplierListPage',
	supplierList:urlPath+'json/supplierList',
	issueDownload:urlPath+'response/download/',
	adsList:urlPath+'json/adsList',
	adsEventsList:urlPath+'json/adsList?rank=2&size=30',
	adsSponsorsList:urlPath+'json/adsList?rank=1&size=3',
	newsList:urlPath+'json/newsList?size=15',
	industrialLinkList:urlPath+'json/industrialLinkList'
};
var documentWindow = window;
var pageSize=10;
var windowName='';
var adsLoaded=false;  //keep track of ads loaded?
var adsWin;
var adsCount;
var ScriptLoader;
var loggedIn=false;
var PublicationsPers;
Ext.onReady(function()
{
	
    Ext.get('rightMenuDiv').setHeight(Ext.getBody().getHeight());
   // Ext.get('leftMenuDiv').setHeight(Ext.getBody().getHeight());
   // Ext.select('#leftMenuDiv div.leftMenuItem').on('mouseover',menuFadeIn);
    
    
});

function menuFadeIn(e,t,o)
{
	Ext.get(t).move('right',80,true);
	Ext.get(t).purgeAllListeners();
	new Ext.util.DelayedTask(function(){
		Ext.get(t).move('left',80,true);
	    new Ext.util.DelayedTask(function(){
	    	Ext.get(t).on('mouseover',menuFadeIn);
	    }).delay(500);

	}).delay(5000);
}
function openWindowLocation(input){
	window.location.href=input;
}
function frameworkCalls(jsonObj)
{
	_gaq.push(['_trackPageview', jsonObj.windowId]);
	//this will close all the windows instead of just hiding it
	if (jsonObj.hideAll!=false){
		//it is not a publication panel load
		//don't close the two buttons
		closeAllWindows(jsonObj.windowId=='pub-win');
	}

	//openAds (only called once) (status variable is adsLoaded)
	if ((jsonObj.ads)&&(!adsLoaded)&&!(loggedIn)){	
		openAds(jsonObj);
	}
	else
	{
		loadActualWindow(jsonObj);
	}
//	Please remember to put the below 2 lines in ajax call if you are not using Ext.ux.JsonStore
//	Ext.MessageBox.hide();
}
function closeAllWindows(itIsPubPanel)
{
	globalApp.getDesktop().getManager().each(function(){this.close()});	
	if (itIsPubPanel)
		Ext.get('publicationLinksDiv').hide(true);
}

function loadActualWindow(jsonObj){
	//global loading screen
	Ext.MessageBox.wait("Loading");
		
	windowName=jsonObj.windowId;		
	MyDesktop.getModule(windowName).createWindow(jsonObj.pubId);
}

function openAds(jsonObj)
{
	adsCount=0;
	adsWin =  new Ext.Window({
        layout:'fit',
        width:500,
        height:300,
        closeAction:'close',
        modal: true,       
        resizable:false,
        baseCls:'x-plain',
        shadow:false,
        closable:false,
        html:'<center><img src="'+urlPath+'response/adsRandom?'+new Date()+'"/></center>',
        listeners:
        {
			close:function(){
				if (jsonObj.windowId)
				{
					loadActualWindow(jsonObj);
				}
				else if (jsonObj.documentId)
				{			
					window.open(urls.issueDownload+jsonObj.documentId);
				}
			}
        }
    });
	//adsLoaded=true;
	adsWin.show();
	adsWin.center();
	adsCount=3;
	Ext.TaskMgr.start({
	    run: updateAd,
	    interval: 1000
	});
}
function home(){
	closeAllWindows(true);
	
	Ext.get('twoDivsOnly').scrollTo('top',0,true);
	Ext.get('basic-slider').setWidth(300);
    Ext.get('basic-slider').center(Ext.get('sliderOutDiv'));
	var returnDiv = Ext.get('returnDiv');
	if (returnDiv){
		returnDiv.hide();
	}
	var taskInner = new Ext.util.DelayedTask(function(){
		Ext.get('mainDiv').update('');
		
	});
	taskInner.delay(500);
}
function updateAd()
{	
	if (adsCount==0)
	{
		//need to find a better way to stop tasks
		//Ext.TaskMgr.stopAll();
		adsWin.close();
	}
	var adText="<center><span style='color:#FFF'>This advertisement closes in "+(adsCount--)+"</span></center>";
	adsWin.setTitle(adText);

}

function openEvents()
{		
	frameworkCalls({windowId:"event-win"});
}
function openSuppliers()
{	
	frameworkCalls({windowId:"supplier-win"});
}
function openPublications(publicationId)
{
	frameworkCalls({"windowId":"pub-win","pubId":publicationId});		
}

function openDownloads(publicationId)
{
	frameworkCalls({"windowId":"download-win","pubId":publicationId});		
}

function openPdfs(documentId)
{
	frameworkCalls({"documentId":documentId,hideAll:false, ads:[{random:true}]});		
}

function openAboutUs()
{
	frameworkCalls({"windowId":"about-win"});		
}

function openIndustrialLink()
{
	frameworkCalls({"windowId":"industrialLink-win"});		
}
function openLogin()
{
	frameworkCalls({"windowId":"login-win"});		
}

function loadjscssfile(filename, filetype){
	 if (filetype=="js"){ //if filename is a external JavaScript file
	  var fileref=document.createElement('script')
	  fileref.setAttribute("type","text/javascript")
	  fileref.setAttribute("src", filename)
	 }
	 else if (filetype=="css"){ //if filename is an external CSS file
	  var fileref=document.createElement("link")
	  fileref.setAttribute("rel", "stylesheet")
	  fileref.setAttribute("type", "text/css")
	  fileref.setAttribute("href", filename)
	 }
	 if (typeof fileref!="undefined")
	  document.getElementsByTagName("head")[0].appendChild(fileref)
}

function jqueryInitialization(){
	
	$('.thumb-link').click(function(e){
		e.preventDefault();
		var url = $(this).attr('title');
		var name = $(this).attr('name');
		_gaq.push(['_trackPageview', name]);
		setTimeout('openWindow("'+url+'")', 500);

	});
}

function openWindow(url){
	window.open(url, '_blank');
}

var documentFields = ['id', 'name', 'description', 'fileName', 'dateCreated', 'releaseDate', 'expireDate' ];
var adsFields = ['id', 'name', 'mimeType', 'fileName', 'url', 'releaseDate', 'expireDate' ];
var issueFields = ['id', 'name', 'description', 'number', 'downloadCount', 'releaseDate', 'documents']
var industrialLinkFields=['id','organization','abbreviation','website','publications']
