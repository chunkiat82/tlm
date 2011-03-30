
<%@ page import="com.tlm.beans.Role" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'role.label', default: 'Role')}" />
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
                            <g:sortableColumn property="roleName" title="${message(code: 'role.roleName.label', default: 'Role Name')}" />
                            <g:sortableColumn property="description" title="${message(code: 'role.description.label', default: 'Description')}" />
                        	<th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${roleInstanceList}" status="i" var="roleInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td>${fieldValue(bean: roleInstance, field: "roleName")}</td>
                            <td>${fieldValue(bean: roleInstance, field: "description")}</td>
                            <td nowrap>
                              <g:link action="show" id="${roleInstance.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View ${roleInstance.roleName}" /></g:link>
                              <g:link action="edit" id="${roleInstance.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit ${roleInstance.roleName}" /></g:link>
                              <g:link action="delete" id="${roleInstance.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete ${roleInstance.roleName}" /></g:link>                              
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${roleInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
