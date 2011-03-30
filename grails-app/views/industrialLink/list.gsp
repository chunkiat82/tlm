
<%@ page import="com.tlm.beans.IndustrialLink" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'industrialLink.label', default: 'IndustrialLink')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Home</a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
            </div>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                        
                            <g:sortableColumn property="organization" title="${message(code: 'industrialLink.organization.label', default: 'Organization')}" />
                        
                            <g:sortableColumn property="abbreviation" title="${message(code: 'industrialLink.abbreviation.label', default: 'Abbreviation')}" />
                        
                            <g:sortableColumn property="website" title="${message(code: 'industrialLink.website.label', default: 'Website')}" />
                        	<th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${industrialLinkInstanceList}" status="i" var="industrialLinkInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            
                        
                            <td>${fieldValue(bean: industrialLinkInstance, field: "organization")}</td>
                        
                            <td>${fieldValue(bean: industrialLinkInstance, field: "abbreviation")}</td>
                        
                            <td>${fieldValue(bean: industrialLinkInstance, field: "website")}</td>
                        	<td nowrap>
                              <g:link action="show" id="${industrialLinkInstance.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View ${industrialLinkInstance.organization}" /></g:link>
                              <g:link action="edit" id="${industrialLinkInstance.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit ${industrialLinkInstance.organization}" /></g:link>
                              <g:link action="delete" id="${industrialLinkInstance.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete ${industrialLinkInstance.organization}" /></g:link>                              
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${industrialLinkInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
