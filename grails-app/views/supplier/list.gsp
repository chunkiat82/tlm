
<%@ page import="com.tlm.beans.Supplier" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'supplier.label', default: 'Supplier')}" />
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
                        
                            <!--<g:sortableColumn property="id" title="${message(code: 'supplier.id.label', default: 'Id')}" />
                        
                            -->
                            <g:sortableColumn property="company" title="${message(code: 'supplier.company.label', default: 'Company')}" />
                            
                            <g:sortableColumn property="telephone" title="${message(code: 'supplier.telephone.label', default: 'Telephone')}" />                          
                        
                            <g:sortableColumn property="fax" title="${message(code: 'supplier.fax.label', default: 'Fax')}" />
                        
                            
                        	<th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${supplierInstanceList}" status="i" var="supplierInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <!--<td><g:link action="show" id="${supplierInstance.id}">${fieldValue(bean: supplierInstance, field: "id")}</g:link></td>
                        
                            -->
                            <td>${fieldValue(bean: supplierInstance, field: "company")}</td>
                        
                            <td>${fieldValue(bean: supplierInstance, field: "telephone")}</td>
                        
                            <td>${fieldValue(bean: supplierInstance, field: "fax")}</td>
                        
                            
                        
                        	<td nowrap>
                              <g:link action="show" id="${supplierInstance.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View ${supplierInstance.company}" /></g:link>
                              <g:link action="edit" id="${supplierInstance.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit ${supplierInstance.company}" /></g:link>
                              <g:link action="delete" id="${supplierInstance.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete ${supplierInstance.company}" /></g:link>                              
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${supplierInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
