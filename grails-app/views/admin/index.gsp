<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />
<title>Trade Link Media Portal Administration</title>

<link rel="stylesheet" type="text/css" href="<g:resource dir="style" file="ext-all.css" />" />
<link rel="stylesheet" type="text/css" href="<g:resource dir="style" file="bubble.css" />" />
<link rel="stylesheet" type="text/css" href="<g:resource dir="style" file="desktop.css"/>"/>
<link rel="stylesheet" type="text/css" href="<g:resource dir="style" file="main.css" />"/>

<script type="text/javascript" src="<g:resource dir="js" file="ext-base.css" />js/ext-base.js"></script>
<!-- ENDLIBS -->

<script type="text/javascript" src="<g:resource dir="js" file="ext-all.js" />"></script>
<script type="text/javascript" src="<g:resource dir="js" file="ext-basex.js" />"></script>
<script type="text/javascript" src="<g:resource dir="js" file="ext-all.css" />"></script>
<link rel="stylesheet" type="text/css" href="<g:resource dir="style" file="admin2.css" />"/>
</head>
<body>
<div class="body"><g:if test="${flash.message}">
	<div class="message">
	${flash.message}
	</div>
</g:if>
<style type="text/css">
div.first
{
margin-bottom:15px;
margin-right:3px;
width:115px;
float:left;
}
div.last
{
margin-bottom:15px;
margin-right:3px;
width:115px;
float:left;
clear:right;
}
a:hover {
	text-decoration: underline !important;
}
ul {
	/*list-style-type: circle !important;*/
}
ul img{
	vertical-align:middle;
}
li {
	margin-bottom:5px;
}
h2 {
	font-size: 20pt;
}
</style>
<h1>Trade Link Media Portal Administration</h1>
<div id="mainDiv"></div>
<div id="fistAdminDivHidden" class="adminPageMainDiv" style="display:none;">
	<ul >
		<li>
			
			<g:link controller="user" action="list">
				<img src="images/icons/btn_clients_bg.gif"></img>
				Subscribers List
			</g:link>
		</li>
		<li>
			
			<g:link controller="dataEntry" action="dataEntry">
				<img src="images/icons/btn_clients_bg.gif"></img>
				Add new subscribers
			</g:link>
		</li>
		<li>
			
			<g:link controller="user" action="unapproveList">
				<img src="images/icons/btn_clients_bg.gif"></img>
				Unapproved Members
			</g:link>			
		</li>
		<li>
			<g:link controller="jobFunction" action="list">
				<img src="images/icons/btn_user-job_bg.gif"></img>
				Job Functions
			</g:link>
		</li>
		<li>
			<g:link controller="jobPosition" action="list">
				<img src="images/icons/btn_user-job_bg.gif"></img>
				Job Positions
			</g:link>
		</li>
		<li>
			<g:link controller="role" action="list">
				<img src="images/icons/btn_user-role_bg.gif"></img>
				Roles
			</g:link>
		</li>
		<li>
			<g:link controller="requestMap" action="list">
				<img src="images/icons/btn_permission_bg.gif"></img>
				URL Permissions
			</g:link>
		</li>
		<!--<li>
			<g:link controller="searchable" >
				<img width="32" height="32" src="images/webicons/Search.png"></img>
				Power Search
			</g:link>
		</li>
		--><li>
			<g:link controller="downloadCount" action="list">
				<img src="images/icons/btn_report_bg.gif"></img>
				Download Statistics
				
			</g:link>
		</li>
	</ul>	
</div>
<!-- 2nd Section -->
<div id="secondAdminDivHidden" style="display:none;">
	<ul>
		<li>
			<g:link controller="publication" action="list"><img src="images/icons/btn_publications_bg.gif"></img>Publications</g:link>
		</li>
		<li>
			<g:link controller="issue" action="list"><img src="images/icons/btn_publications_bg.gif"></img>Issues</g:link>
		</li>
		<li>
			<g:link controller="news" action="list"><img src="images/icons/btn_whatsnew_bg.gif"></img>News</g:link>
		</li>
		<li>
			<g:link controller="event" action="list"><img src="images/icons/btn_eventmgr_bg.gif"></img>Events</g:link>
		</li>
		<li>
			<g:link controller="supplier" action="list"><img src="images/icons/btn_reseller-account_bg.gif"></img>Suppliers</g:link>
		</li>
		<li>
			<g:link controller="ads" action="list"><img src="images/icons/btn_ads_bg.gif"></img>Advertisements</g:link>
		</li>
		<li>
			<g:link controller="industrialLink" action="list"><img src="images/icons/btn_whatsnew_bg.gif"></img>Industrial Links</g:link>
		</li>
	</ul>	
</div>
<!-- 3rd Section -->
<div id="thirdAdminDivHidden" style="display:none;" >
	<ul>
		<li>
			<g:link controller="service" action="list"><img src="images/icons/btn_tts-mail-gate_bg.gif"></img>Email Services</g:link>
		</li>
		<li>
			<g:link controller="template" action="list"><img src="images/icons/btn_email-templates_bg.gif"></img>Email Templates</g:link>
		</li>
		<li>
			<g:link controller="emailJob" action="list"><img src="images/icons/btn_crontab-win_bg.gif"></img>Email Job</g:link>
		</li>		
	</ul>	
</div>
<script type="text/javascript">
Ext.onReady(function(){

    var htmlText1 = Ext.get('fistAdminDivHidden').dom.innerHTML;
    var htmlText2 = Ext.get('secondAdminDivHidden').dom.innerHTML;
    var htmlText3 = Ext.get('thirdAdminDivHidden').dom.innerHTML;
    
	var p1 = new Ext.Panel({
        title: 'About Subscribers',
        columnWidth: .33,
        html:htmlText1
    });
	var p2 = new Ext.Panel({
        title: 'Portal Administration',
        columnWidth: .33,
        html:htmlText2
    });
	var p3 = new Ext.Panel({
        title: 'Email Administration',      
        columnWidth: .34,
        html:htmlText3
    });

	var main = new Ext.Panel({        
        renderTo: 'mainDiv',
        width:800,
        defaults: {     
			width:300,          // defaults are applied to items, not the container
		 	height:'100%',
		 	bodyStyle:'padding-top:10px;'
        },                
        border:false,
        height:350,
        layout:'column',        
        items:[p1,p2,p3]
    }); 
    p1.setHeight(main.getHeight());
    p2.setHeight(main.getHeight());
    p3.setHeight(main.getHeight());

});
</script>
</body>
</html>
