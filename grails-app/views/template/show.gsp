
<%@ page import="com.tlm.beans.Template" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'template.label', default: 'Template')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        <script type="text/javascript" src="${resource(dir:'js/tiny_mce', file:'view_config.js')}" ></script>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="nav">
            	<span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
            	<span class="menuButton"><g:link class="list" action="list">Template List</g:link></span>
      		</div>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" width="200px" class="name"><g:message code="template.id.label" default="Id" /></td>
                            <td valign="top" class="value">${fieldValue(bean: templateInstance, field: "id")}</td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="template.service.label" default="Service" /></td>
                            <td valign="top" class="value"><g:link controller="service" action="show" id="${templateInstance?.service?.id}">${templateInstance?.service?.encodeAsHTML()}</g:link></td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="template.name.label" default="Name" /></td>
                            <td valign="top" class="value">${fieldValue(bean: templateInstance, field: "name")}</td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="template.subject.label" default="Subject" /></td>
                            <td valign="top" class="value">${fieldValue(bean: templateInstance, field: "subject")}</td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="template.data.label" default="Data" /></td>                            
                            <td valign="top" class="value"><g:textArea style="width:400px; height:500px;" name="data" value="${templateInstance.data}" /></td>                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${templateInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                    <span class="button"><g:actionSubmit class="email" action="massmail" value="Prepare Mass E-mail" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
