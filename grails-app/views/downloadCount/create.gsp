
<%@ page import="com.tlm.beans.DownloadCount" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'downloadCount.label', default: 'DownloadCount')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${downloadCountInstance}">
            <div class="errors">
                <g:renderErrors bean="${downloadCountInstance}" as="list" />
            </div>
            </g:hasErrors>
    	    <div class="nav">
	            <span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
        	    <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        	</div>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="issue"><g:message code="downloadCount.issue.label" default="Issue" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: downloadCountInstance, field: 'issue', 'errors')}">
                                    <g:select name="issue.id" from="${com.tlm.beans.Issue.list()}" optionKey="id" value="${downloadCountInstance?.issue?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="user"><g:message code="downloadCount.user.label" default="User" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: downloadCountInstance, field: 'user', 'errors')}">
                                    <g:select name="user.id" from="${com.tlm.beans.User.list()}" optionKey="id" value="${downloadCountInstance?.user?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="downloadCount"><g:message code="downloadCount.downloadCount.label" default="Download Count" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: downloadCountInstance, field: 'downloadCount', 'errors')}">
                                    <g:textField name="downloadCount" value="${fieldValue(bean: downloadCountInstance, field: 'downloadCount')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="day"><g:message code="downloadCount.day.label" default="Day" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: downloadCountInstance, field: 'day', 'errors')}">
                                    <g:textField name="day" value="${fieldValue(bean: downloadCountInstance, field: 'day')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="month"><g:message code="downloadCount.month.label" default="Month" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: downloadCountInstance, field: 'month', 'errors')}">
                                    <g:textField name="month" value="${fieldValue(bean: downloadCountInstance, field: 'month')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="year"><g:message code="downloadCount.year.label" default="Year" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: downloadCountInstance, field: 'year', 'errors')}">
                                    <g:textField name="year" value="${fieldValue(bean: downloadCountInstance, field: 'year')}" />
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
