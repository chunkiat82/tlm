
<%@ page import="com.tlm.beans.Ads" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'ads.label', default: 'Ads')}" />
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
                            <g:sortableColumn property="name" title="${message(code: 'ads.name.label', default: 'Name')}" />
                            <g:sortableColumn property="mimeType" title="${message(code: 'ads.mimeType.label', default: 'Mime Type')}" />
                            <g:sortableColumn property="rank" title="${message(code: 'ads.rank.label', default: 'Rank')}" />
                            <g:sortableColumn property="releaseDate" title="${message(code: 'ads.releaseDate.label', default: 'Release Date')}" />
                            <g:sortableColumn property="expireDate" title="${message(code: 'ads.expireDate.label', default: 'Expire Date')}" />
                            <th>Action</th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${adsInstanceList}" status="i" var="adsInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td><a href="${adsInstance.url}">${fieldValue(bean: adsInstance, field: "name")}</a></td>
                            <td>
                            	<g:if test="${adsInstance.mimeType.contains('image')}">
 				                	<img src="/tlm/response/adsImage/${adsInstance.id}" class="thumb-img" />
                            	</g:if>
                            	<g:else>
                            		<object width="150" height="150" id="advertise3"
										codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"
										classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
										<param value="/tlm/response/adsImage/${adsInstance.id}" name="movie">
										<param value="High" name="quality">
										<param value="#ffffff" name="bgcolor">
										<embed width="150" height="150" align=""
										pluginspage="http://www.macromedia.com/go/getflashplayer"
										type="application/x-shockwave-flash" name="advertise1"
										bgcolor="#ffffff" quality="High"
										src="/tlm/response/adsImage/${adsInstance.id}">
									</object>
                            	</g:else>
                            </td>
                            <td>
	                            <g:if test="${adsInstance.rank == 2}">
											All
								</g:if>
								<g:if test="${adsInstance.rank == 1}">
											Events
								</g:if>
								<g:if test="${adsInstance.rank == 3}">
											Sponsors
								</g:if>
							</td>
                            <td><g:formatDate format="dd/MM/yyyy" date="${adsInstance.releaseDate}" /></td>
                            <td><g:formatDate format="dd/MM/yyyy" date="${adsInstance.expireDate}" /></td>
                            <td nowrap>
                              <g:link action="show" id="${adsInstance.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View ${adsInstance.name}" /></g:link>
                              <g:link action="edit" id="${adsInstance.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit ${adsInstance.name}" /></g:link>
                              <g:link action="delete" id="${adsInstance.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete ${adsInstance.name}" /></g:link>                              
                            </td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${adsInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
