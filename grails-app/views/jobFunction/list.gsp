
<%@ page import="com.tlm.beans.JobFunction" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'jobFunction.label', default: 'JobFunction')}" />
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
                       
                        
                            <g:sortableColumn property="title" title="${message(code: 'jobFunction.title.label', default: 'Title')}" />
                        	<th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${jobFunctionInstanceList}" status="i" var="jobFunctionInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
           
                        
                            <td>${fieldValue(bean: jobFunctionInstance, field: "title")}</td>
                        	<td nowrap>
                              <g:link action="show" id="${jobFunctionInstance.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View ${jobFunctionInstance.title}" /></g:link>
                              <g:link action="edit" id="${jobFunctionInstance.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit ${jobFunctionInstance.title}" /></g:link>
                              <g:link action="delete" id="${jobFunctionInstance.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete ${jobFunctionInstance.title}" /></g:link>                              
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${jobFunctionInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
