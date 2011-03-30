
<%@ page import="com.tlm.beans.EmailJob" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'emailJob.label', default: 'EmailJob')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${emailJobInstance}">
            <div class="errors">
                <g:renderErrors bean="${emailJobInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${emailJobInstance?.id}" />
                <g:hiddenField name="version" value="${emailJobInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="template"><g:message code="emailJob.template.label" default="Template" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: emailJobInstance, field: 'template', 'errors')}">
                                    <g:select name="template.id" from="${com.tlm.beans.Template.list()}" optionKey="id" value="${emailJobInstance?.template?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="description"><g:message code="emailJob.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: emailJobInstance, field: 'description', 'errors')}">
                                    <g:textField name="description" value="${emailJobInstance?.description}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="html"><g:message code="emailJob.html.label" default="Html" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: emailJobInstance, field: 'html', 'errors')}">
                                    <g:textField name="html" value="${emailJobInstance?.html}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="status"><g:message code="emailJob.status.label" default="Status" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: emailJobInstance, field: 'status', 'errors')}">
                                    <g:textField name="status" value="${emailJobInstance?.status}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="dateCompleted"><g:message code="emailJob.dateCompleted.label" default="Date Completed" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: emailJobInstance, field: 'dateCompleted', 'errors')}">
                                    <g:datePicker name="dateCompleted" precision="day" value="${emailJobInstance?.dateCompleted}" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="emailJobItems"><g:message code="emailJob.emailJobItems.label" default="Email Job Items" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: emailJobInstance, field: 'emailJobItems', 'errors')}">
                                    
<ul>
<g:each in="${emailJobInstance?.emailJobItems?}" var="e">
    <li><g:link controller="emailJobItem" action="show" id="${e.id}">${e?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="emailJobItem" action="create" params="['emailJob.id': emailJobInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'emailJobItem.label', default: 'EmailJobItem')])}</g:link>

                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="lastUpdated"><g:message code="emailJob.lastUpdated.label" default="Last Updated" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: emailJobInstance, field: 'lastUpdated', 'errors')}">
                                    <g:datePicker name="lastUpdated" precision="day" value="${emailJobInstance?.lastUpdated}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="dateCreated"><g:message code="emailJob.dateCreated.label" default="Date Created" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: emailJobInstance, field: 'dateCreated', 'errors')}">
                                    <g:datePicker name="dateCreated" precision="day" value="${emailJobInstance?.dateCreated}"  />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
