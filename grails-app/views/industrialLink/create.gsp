
<%@ page import="com.tlm.beans.IndustrialLink" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'industrialLink.label', default: 'IndustrialLink')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="nav">
	            <span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Home</a></span>
	            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>	           
            </div>
            <g:hasErrors bean="${industrialLinkInstance}">
            <div class="errors">
                <g:renderErrors bean="${industrialLinkInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="organization"><g:message code="industrialLink.organization.label" default="Organization" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: industrialLinkInstance, field: 'organization', 'errors')}">
                                    <g:textField name="organization" value="${industrialLinkInstance?.organization}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="abbreviation"><g:message code="industrialLink.abbreviation.label" default="Abbreviation" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: industrialLinkInstance, field: 'abbreviation', 'errors')}">
                                    <g:textField name="abbreviation" value="${industrialLinkInstance?.abbreviation}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="website"><g:message code="industrialLink.website.label" default="Website" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: industrialLinkInstance, field: 'website', 'errors')}">
                                    <g:textField name="website" value="${industrialLinkInstance?.website}" />
                                </td>
                            </tr>
                        	<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="website"><g:message code="industrialLink.publications.label" default="Publications"  /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: industrialLinkInstance, field: 'publications', 'errors')}">
                                    <g:select name="publications" from="${com.tlm.beans.Publication.list()}" multiple="yes" optionKey="id" size="5" value="${industrialLinkInstance?.publications}" />
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
