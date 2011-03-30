<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />
<title>Trade Link Media Portal Administration</title>
</head>
<body>
<div class="body"><g:if test="${flash.message}">
	<div class="message">
	${flash.message}
	</div>
</g:if>
<style>
div.adminPageMainDiv{
padding-left:15px;
border-style:dotted;
margin-right:15px;
border-width:1px;
width:255px;
float:left;
}
div.adminPageMainDiv div.title{
font:italic bold 12px/30px Georgia, serif;
width:255px;
float:left;
clear:right;
margin-bottom:20px;
text-align:center;
}
div.adminPageMainDiv a div.first
{
margin-bottom:15px;
margin-right:3px;
width:115px;
float:left;
}
div.adminPageMainDiv a div.last
{
margin-bottom:15px;
margin-right:3px;
width:115px;
float:left;
clear:right;
}
div.adminPageMainDiv a div div:first-child
{
width:35px;
float:left;
}
div.adminPageMainDiv a div div
{
width:80px;
float:left;
clear:right;
}
</style>
<h1>Trade Link Media Portal Administration</h1>

<div style="width:900px;display:block;height:400px;">
<!-- 1st Section -->
<div class="adminPageMainDiv" style="background-color:#D6FFF3;">
	<div class="title">About Subscribers</div>
	<g:link controller="dataEntry" action="index">
	<div class="first" >
		<div>
			<img src="images/icons/btn_clients_bg.gif"></img>
		</div>
		<div>
			New Subscriber
		</div>
	</div>
	</g:link>

</div>

</div>
</body>
</html>
