
<%@ page import="com.tlm.beans.News" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'news.label', default: 'News')}" />
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
                            <g:sortableColumn property="publicationDate" title="${message(code: 'news.publicationDate.label', default: 'Publication Date')}" />
                            <th><g:message code="news.publication.label" default="Publication" /></th>
                            <g:sortableColumn property="title" title="${message(code: 'news.title.label', default: 'Title')}" />
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${newsInstanceList}" status="i" var="newsInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                            <td><g:formatDate date="${newsInstance.publicationDate}" format="dd/MM/yyy" /></td>
                            <td>${fieldValue(bean: newsInstance, field: "publication")}</td>
                            <td>${fieldValue(bean: newsInstance, field: "title")}</td>
                            <td nowrap>
                              <g:link action="show" id="${newsInstance.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View ${newsInstance.title}" /></g:link>
                              <g:link action="edit" id="${newsInstance.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit ${newsInstance.title}" /></g:link>
                              <g:link action="delete" id="${newsInstance.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete ${newsInstance.title}" /></g:link>                              
                            </td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${newsInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
