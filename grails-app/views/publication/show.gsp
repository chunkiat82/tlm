
<%@ page import="com.tlm.beans.Publication" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'publication.label', default: 'Publication')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
       
        <div class="body">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="nav">
	            <span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Home</a></span>
	            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
	            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        	</div>
            
            <div class="dialog">
                <table>
                    <tbody>
                    	<tr class="prop">
                            <td valign="top" class="name"><g:message code="publication.pubLongName.label" default="Publication Fixed ID" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: publicationInstance, field: "pubId")}</td>
                            
                        </tr>
                       <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="mastHead"><g:message code="publication.mastHead.label" default="Mast Head" /></label>
                                </td>
                                <td valign="top" id="fileUpload">
                                    <img  style="float:left;margin-right:3px;vertical-align:bottom;" src="/tlm/response/pubMastHead/${fieldValue(bean: publicationInstance, field: "pubId")}"/>
                                </td>
                            </tr>                
                        
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="publication.pubLongName.label" default="Pub Long Name" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: publicationInstance, field: "pubLongName")}</td>
                            
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="publication.pubShortName.label" default="Pub Short Name" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: publicationInstance, field: "pubShortName")}</td>
                            
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="publication.editor.label" default="Editor" /></td>
                            
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${publicationInstance?.editor?.id}">${publicationInstance?.editor?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="publication.advertiser.label" default="Advertiser" /></td>
                            
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${publicationInstance?.advertiser?.id}">${publicationInstance?.advertiser?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                        
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="publication.subscriptions.label" default="Subscriptions" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                               <a href="/tlm/publication/subscriptionList?id=${publicationInstance.id}">${subTotalCount}</a> <i>Click to download list in CSV</i>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="publication.events.label" default="Events" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                              ${publicationInstance.events.size()}                              
                            </td>
                            
                        </tr>
                    
                        
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="publication.news.label" default="News" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                            	${publicationInstance.news.size()}                               
                            </td>
                            
                        </tr>
                    
             
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="publication.issues.label" default="Issues" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                ${publicationInstance.issues.size()}   
                            </td>
                            
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="publication.suppliers.label" default="Suppliers" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                ${publicationInstance.suppliers.size()}   
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="publication.ads.label" default="Ads" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                ${publicationInstance.ads.size()}   
                            </td>
                            
                        </tr>
                                        
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${publicationInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
