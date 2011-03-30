
<%@ page import="com.tlm.beans.Issue" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'issue.label', default: 'Issue')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
        	<div class="nav">
            	<span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
            	<span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        	</div>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <!-- g:sortableColumn property="id" title="${message(code: 'issue.id.label', default: 'Id')}" / -->
                            <g:sortableColumn property="publication" title="Publication" />
                            <g:sortableColumn property="number" title="Number" />
                            <g:sortableColumn property="name" title="Name" />
                            <g:sortableColumn property="description" title="Description" />
                            <g:sortableColumn property="releaseDate" title="Release Date" />
                            <th>Action</th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${issueInstanceList}" status="i" var="issueInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <%-- td><g:link action="show" id="${issueInstance.id}">${fieldValue(bean: issueInstance, field: "id")}</g:link></td  --%>
                            <td>${issueInstance.publication?.pubLongName}</td>
                            <td>${issueInstance.number}</td>
                            <td>${issueInstance.name}</td>
                            <td>${issueInstance.description}</td>
                            <td><g:formatDate format="dd/MM/yyyy" date="${issueInstance.releaseDate}" /></td>
                            <td nowrap>
                              <g:link action="show" id="${issueInstance.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View ${issueInstance.name}" /></g:link>
                              <g:link action="edit" id="${issueInstance.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit ${issueInstance.name}" /></g:link>
                              <g:link action="delete" id="${issueInstance.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete ${issueInstance.name}" /></g:link>                              
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${issueInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
