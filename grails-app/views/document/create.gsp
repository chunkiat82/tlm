
<%@ page import="com.tlm.beans.Document" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'document.label', default: 'Document')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${documentInstance}">
            <div class="errors">
                <g:renderErrors bean="${documentInstance}" as="list" />
            </div>
            </g:hasErrors>
        	<div class="nav">
            	<span class="menuButton"><a class="home" href="${createLink(uri: '/')}">Home</a></span>
            	<span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        	</div>            
            <g:form action="save" method="post" enctype="multipart/form-data" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="document.name.label" default="Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: documentInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${documentInstance?.name}" />
                                </td>
                            </tr>                            
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><g:message code="document.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: documentInstance, field: 'description', 'errors')}">
                                    <g:textField name="description" value="${documentInstance?.description}" />
                                </td>
                            </tr>                        
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="releaseDate"><g:message code="document.releaseDate.label" default="Release Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: documentInstance, field: 'releaseDate', 'errors')}">
                                    <g:datePicker name="releaseDate" precision="day" value="${documentInstance?.releaseDate}"  />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="expireDate"><g:message code="document.expireDate.label" default="Expire Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: documentInstance, field: 'expireDate', 'errors')}">
                                    <g:datePicker name="expireDate" precision="day" value="${documentInstance?.expireDate}"  />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="approved"><g:message code="document.approved.label" default="Approved" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: documentInstance, field: 'approved', 'errors')}">
                                    <g:checkBox name="approved" value="${documentInstance?.approved}" />
                                </td>
                            </tr>                                                        
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="fileData"><g:message code="document.fileData.label" default="File Data" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: documentInstance, field: 'fileData', 'errors')}">
                                    <input type="file" name="document.fileData" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="publication"><g:message code="document.publication.label" default="Publication" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: documentInstance, field: 'publication', 'errors')}">
                                    <g:select name="publication.id" from="${com.tlm.beans.Publication.list()}" optionKey="id" value="${documentInstance?.publication?.id}"  />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
