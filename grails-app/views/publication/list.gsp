<%@ page import="com.tlm.beans.Publication" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'publication.label', default: 'Publication')}" />
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
                      
                        
                            <g:sortableColumn property="mastHead" title="${message(code: 'publication.mastHead.label', default: 'Mast Head')}" />
                                                   
                        
                            <th><g:message code="publication.editor.label" default="Editor" /></th>
                   	    
                            <th><g:message code="publication.advertiser.label" default="Advertiser" /></th>
                   	    
                            <g:sortableColumn property="pubLongName" title="${message(code: 'publication.pubLongName.label', default: 'Pub Long Name')}" />
                        	 <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${publicationInstanceList}" status="i" var="publicationInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">                       
                        
                            <td><img width="120px" src="/tlm/response/pubMastHead/${fieldValue(bean: publicationInstance, field: "pubId")}"></img></td>
                                        
                        
                            <td>${fieldValue(bean: publicationInstance, field: "editor")}</td>
                        
                            <td>${fieldValue(bean: publicationInstance, field: "advertiser")}</td>
                        
                            <td>${fieldValue(bean: publicationInstance, field: "pubLongName")}</td>
                        
                        	 <td nowrap>
                              <g:link action="show" id="${publicationInstance.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View ${publicationInstance.pubShortName}" /></g:link>
                              <g:link action="edit" id="${publicationInstance.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit ${publicationInstance.pubShortName}" /></g:link>
                              <g:link action="delete" id="${publicationInstance.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete ${publicationInstance.pubShortName}" /></g:link>                              
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${publicationInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
