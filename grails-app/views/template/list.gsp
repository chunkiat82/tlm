<%@ page import="com.tlm.beans.Template" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'template.label', default: 'Template')}" />
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
              <span class="menuButton"><g:link class="create" action="create">Create Template</g:link></span>
            </div>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <%--g:sortableColumn property="id" title="${message(code: 'template.id.label', default: 'Id')}" /--%>
                        
                            <g:sortableColumn property="name" title="${message(code: 'template.name.label', default: 'Name')}" />
                            <g:sortableColumn property="service" title="${message(code: 'template.service.label', default: 'Service')}" />
                        
                            <%--g:sortableColumn property="subject" title="${message(code: 'template.subject.label', default: 'Subject')}" /--%>
                            <%--g:sortableColumn property="data" title="${message(code: 'template.data.label', default: 'Data')}" /--%>
                            <th width="1%"><g:message code="action.label" default="Action" /></th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${templateInstanceList}" status="i" var="templateInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <%-- td><g:link action="show" id="${templateInstance.id}">${fieldValue(bean: templateInstance, field: "id")}</g:link></td--%>
                            <td>${fieldValue(bean: templateInstance, field: "name")}</td>
                            <td>${fieldValue(bean: templateInstance, field: "service")}</td>
                            <%-- td>${fieldValue(bean: templateInstance, field: "subect")}</td--%>
                            <%-- td>${fieldValue(bean: templateInstance, field: "data")}</td--%>
                            <td nowrap>
                              <g:link action="show" id="${templateInstance.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View ${templateInstance.name}" /></g:link>
                              <g:link action="edit" id="${templateInstance.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit ${templateInstance.name}" /></g:link>
                              <g:link action="delete" id="${templateInstance.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete ${templateInstance.name}" /></g:link>
                              <g:link action="massmail" id="${templateInstance.id}"><img src="${resource(dir:'images/webicons',file:'Email.png')}" title="Send mass mail using ${templateInstance.name}" /></g:link>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${templateInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
