
<%@ page import="com.tlm.beans.Document" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'document.label', default: 'Document')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <!-- g:sortableColumn property="id" title="${message(code: 'document.id.label', default: 'Id')}" / -->
                            <g:sortableColumn property="publication.name" title="Publication" />
                            <g:sortableColumn property="name" title="Name" />
                            <g:sortableColumn property="fileName" title="File" />
                            <g:sortableColumn property="dateCreated" title="Created" />
                            <g:sortableColumn property="releaseDate" title="Release" />
                            <g:sortableColumn property="expireDate" title="Expires" />
                            <g:sortableColumn property="approved" title="${message(code: 'document.approved.label', default: 'Approved')}" />
                            <th width="1%"><g:message code="action.label" default="Action" /></th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${documentInstanceList}" status="i" var="documentInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td>${documentInstance.publication.pubLongName}</td>
                            <td>${documentInstance.name}</td>
                            <td><g:link action="download" id="${documentInstance.id}">${documentInstance.fileName}</g:link></td>
                            <td><g:formatDate format="dd/MM/yyyy" date="${documentInstance.dateCreated}" /></td>
                            <td><g:formatDate format="dd/MM/yyyy" date="${documentInstance.releaseDate}" /></td>
                            <td><g:formatDate format="dd/MM/yyyy" date="${documentInstance.expireDate}" /></td>
                            <td><g:formatBoolean boolean="${documentInstance.approved}" /></td>
                            <td nowrap>
                              <g:link action="show" id="${documentInstance.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View ${documentInstance.name}" /></g:link>
                              <g:link action="edit" id="${documentInstance.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit ${documentInstance.name}" /></g:link>
                              <g:link action="delete" id="${documentInstance.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete ${documentInstance.name}" /></g:link>
                            </td>
                        
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${documentInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
