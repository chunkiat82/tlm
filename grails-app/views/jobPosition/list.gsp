
<%@ page import="com.tlm.beans.JobPosition" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'jobPosition.label', default: 'JobPosition')}" />
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

                        
                            <g:sortableColumn property="title" title="${message(code: 'jobPosition.title.label', default: 'Title')}" />
                        	<th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${jobPositionInstanceList}" status="i" var="jobPositionInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                        
                        
                            <td>${fieldValue(bean: jobPositionInstance, field: "title")}</td>
                        	<td nowrap>
                              <g:link action="show" id="${jobPositionInstance.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View ${jobPositionInstance.title}" /></g:link>
                              <g:link action="edit" id="${jobPositionInstance.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit ${jobPositionInstance.title}" /></g:link>
                              <g:link action="delete" id="${jobPositionInstance.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete ${jobPositionInstance.title}" /></g:link>                              
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${jobPositionInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
