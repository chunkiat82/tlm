
<%@ page import="com.tlm.beans.Template" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'template.label', default: 'Template')}" />
        <script type="text/javascript" src="${resource(dir:'js/tiny_mce', file:'editor_config.js')}" ></script>
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${templateInstance}">
            <div class="errors">
                <g:renderErrors bean="${templateInstance}" as="list" />
            </div>
            </g:hasErrors>
            <div class="nav">
            	<span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
        	    <span class="menuButton"><g:link class="list" action="list">Template List</g:link></span>
        	</div>
            <g:form method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="service"><g:message code="template.service.label" default="Service" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: templateInstance, field: 'service', 'errors')}">
                                    <g:select name="service.id" from="${com.tlm.beans.Service.list()}" optionKey="id" value="${templateInstance?.service?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="template.name.label" default="Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: templateInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${templateInstance?.name}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="subject"><g:message code="template.subject.label" default="Subject" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: templateInstance, field: 'subject', 'errors')}">
                                    <g:textField name="subject" value="${templateInstance?.subject}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="data"><g:message code="template.data.label" default="Data" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: templateInstance, field: 'data', 'errors')}">
                                    <g:textArea name="data" value="${templateInstance?.data}" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit name="create" class="save" action="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
                    <span class="button"><g:actionSubmit name="email" class="email" action="massmail" value="Send without saving" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
