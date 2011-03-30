
<%@ page import="com.tlm.beans.Issue" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'issue.label', default: 'Issue')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
        	<div class="nav">
            	<span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
            	<span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            	<span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        	</div>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <%--tr class="prop">
                            <td valign="top" class="name"><g:message code="issue.id.label" default="Id" /></td>
                            <td valign="top" class="value">${fieldValue(bean: issueInstance, field: "id")}</td>
                        </tr --%>
                        
                        <tr class="prop">
                            <td valign="top" class="name">Thumbnail</td>
                            <td valign="top" class="value"><img src="/tlm/response/issueThumbnail/${issueInstance.id}" /></td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="issue.name.label" default="Name" /></td>
                            <td valign="top" class="value">${fieldValue(bean: issueInstance, field: "name")}</td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="issue.description.label" default="Description" /></td>
                            <td valign="top" class="value">${fieldValue(bean: issueInstance, field: "description")}</td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="issue.number.label" default="Number" /></td>
                            <td valign="top" class="value">${fieldValue(bean: issueInstance, field: "number")}</td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="issue.releaseDate.label" default="Release Date" /></td>
                            <td valign="top" class="value"><g:formatDate date="${issueInstance?.releaseDate}" /></td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="issue.documents.label" default="Documents" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${issueInstance.documents.sort {it.part}}" var="d">
                                    <li><g:link controller="response" action="download" id="${d.id}">Part ${d.part} (${d.fileName})</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="issue.lastUpdated.label" default="Last Updated" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${issueInstance?.lastUpdated}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="issue.dateCreated.label" default="Date Created" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${issueInstance?.dateCreated}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="issue.publication.label" default="Publication" /></td>
                            
                            <td valign="top" class="value">${issueInstance?.publication?.encodeAsHTML()}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${issueInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
