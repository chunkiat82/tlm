
<%@ page import="com.tlm.beans.User" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="body">
            <h1>Search <g:message code="default.list.label" args="[entityName]" /> Result Total:${userInstanceTotal}</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
        	<div class="nav">
				<span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
            	<span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
            	<span class="menuButton"><g:link class="info" action="search">Search Member</g:link></span>
        	</div>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        	<g:sortableColumn property="userName" title="User Name" />
                        	<g:sortableColumn property="accountStatus" title="Account Status" />
                        	<g:sortableColumn property="enabled" title="Enabled" />
                        	<th>Roles</th>
                        	<th>Full Name</th>                        	
                        	<g:sortableColumn property="mobile" title="Mobile no." />
                            <th>Action</th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${userInstanceList}" status="i" var="userInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        	
                        	<td>${userInstance.userName}</td>
                        	<td>${userInstance.accountStatusLabel}</td>
                        	<td>${userInstance.enabled}</td>
                        	<td>${userInstance.roles}</td>
                        	<td>${userInstance.fullName}</td>
                        	<td>${userInstance.mobile}</td>
                            <td nowrap>
                              <g:link action="show" id="${userInstance.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View ${userInstance.userName}" /></g:link>
                              <g:link action="edit" id="${userInstance.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit ${userInstance.userName}" /></g:link>
                              <g:link action="delete" id="${userInstance.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete ${userInstance.userName}" /></g:link>                              
                            </td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate controller="user" action="searchList" params="[role:params?.role,firstName:params?.firstName,lastName:params?.lastName,userName:params?.userName,jobFunction:params?.jobFunction,jobPosition:params?.jobPosition,publication:params?.publication,country:params?.country,accountStatus:params?.accountStatus]" total="${userInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
