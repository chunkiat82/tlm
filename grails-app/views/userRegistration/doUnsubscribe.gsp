
<%@ page import="com.tlm.beans.User" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
    </head>
    <body>
    	<script type="text/javascript">
    		// lazy way to hide nav bar
    		document.getElementsByTagName('div')[2].style.display='none'
    	</script>
    	
        <div class="body">
            <g:if test="${flash.message}">
            	<div class="message">${flash.message}</div>
            </g:if>
            
            <g:form method="post" >
            	<g:hiddenField name="encodedId" value="${encodedId}" />
                <g:hiddenField name="userId" value="${userId}" />
                <div class="dialog">
                    <table>
                        <tbody>
                            <tr><td colspan="2" class="sectionheader">You are now only subscribed to the following newsletters:</td></tr>
                            
                            <g:set var="pubId" value="" />                            
                            <g:each in="${subscriptions}" var="sub">
                            	<g:if test="${pubId != sub.publication.id}">
	                            	<tr>
									 	<td valign="top" class="name" colspan="2">
									 		<b>${sub.publication.pubLongName}</b> 
									 	</td>
									 </tr>
									 <g:set var="pubId" value="${sub.publication.id}" />                         	
                            	</g:if>
                            	
                            	<tr>
                            		<td />
                            		<td class="value">${sub.service.name}</td>
                            	</tr>
                            </g:each>
                                                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="home" action="Home" value="Return to Home Page" onclick="window.location = '/tlm'; return false;" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
