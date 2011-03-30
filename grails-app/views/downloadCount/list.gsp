
<%@ page import="com.tlm.beans.DownloadCount" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'downloadCount.label', default: 'DownloadCount')}" />
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
	        </div>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'downloadCount.id.label', default: 'Id')}" />
                        
                            <th><g:message code="downloadCount.issue.label" default="Issue" /></th>                 
                            
                            <th><g:message code="downloadCount.year.label" default="Year" /></th>
                            
                            <th><g:message code="downloadCount.month.label" default="Month" /></th>
                            
                            <th><g:message code="downloadCount.totalCount.label" default="Total Downloads" /></th>
                            
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${downloadCountInstanceList}" status="i" var="downloadCountInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td>${i+1}</td>
                            <td>${downloadCountInstance[0]}</td>
                            <td>${downloadCountInstance[1]}</td>
                            <td>${downloadCountInstance[2]}</td>
                            <td>${downloadCountInstance[3]}</td>
                            
                        
                                            
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>          
        </div>
    </body>
</html>
