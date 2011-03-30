
<%@ page import="com.tlm.beans.EmailJob" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'emailJob.label', default: 'EmailJob')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        <script type="text/javascript" src="${resource(dir:'js/tiny_mce', file:'view_config.js')}" ></script>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            
        	<div class="nav">
            	<span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
            	<%-- span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span--%>
            	<span class="menuButton"><a class="create" href="${createLink(controller: 'template', action: 'massmail')}">Create ad-hoc job</a></span>
        	</div>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <%--g:sortableColumn property="id" title="${message(code: 'emailJob.id.label', default: 'Id')}" /--%>
                        
                            <th><g:message code="emailJob.template.label" default="Template" /></th>
                            <g:sortableColumn property="description" title="${message(code: 'emailJob.description.label', default: 'Description')}" />
                            <g:sortableColumn property="status" title="${message(code: 'emailJob.status.label', default: 'Status')}" />
                            <g:sortableColumn property="dateCreated" defaultOrder="desc" title="${message(code: 'emailJob.dateCreated.label', default: 'Date Created')}" />
                            <g:sortableColumn property="dateCompleted" title="${message(code: 'emailJob.dateCompleted.label', default: 'Date Completed')}" />
                            <th>Action</th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${emailJobInstanceList}" status="i" var="emailJobInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td>${fieldValue(bean: emailJobInstance, field: "template")}</td>
                            <td>${fieldValue(bean: emailJobInstance, field: "description")}</td>
                            <td><%--${fieldValue(bean: emailJobInstance, field: "statusLabel")} 
                            	 g:if test="${emailJobInstance.status != 'C'}"><g:formatNumber number="${emailJobInstance.progress * 100}" format="0.000" />%</g:if--%>
                            	<div id="jobProgress${emailJobInstance.id}" style="width:130px"></div>
                            </td>
                            <td><g:formatDate date="${emailJobInstance.dateCreated}" /></td>
                            <td><g:formatDate date="${emailJobInstance.dateCompleted}" /></td>
                            
                            <td nowrap>
                              <g:link action="show" id="${emailJobInstance.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View Job" /></g:link>
                              <g:if test="${emailJobInstance.status == 'R'}">
                              	<a href="#" onclick="Ext.Ajax.request({url: '/tlm/emailJob/pause/${emailJobInstance?.id}', success: function() {window.location.reload()}})"><img src="${resource(dir:'images/webicons',file:'Pause.png')}" title="Pause Job" /></a>
                              </g:if>
                              <g:elseif test="${emailJobInstance.status == 'P'}">
                                <a href="#" onclick="Ext.Ajax.request({url: '/tlm/emailJob/resume/${emailJobInstance?.id}', success: function() {window.location.reload()}})"><img src="${resource(dir:'images/webicons',file:'Play.png')}" title="Resume Job" /></a>
                              </g:elseif>
                              <g:else>
                              	<g:link action="report" id="${emailJobInstance.id}"><img src="${resource(dir:'images/webicons',file:'Pie Chart.png')}" title="View Report" /></g:link>
                              </g:else> 	
                              <%-- g:link action="edit" id="${emailJobInstance.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit Job" /></g:link>
                              <g:link action="delete" id="${emailJobInstance.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete Job" /></g:link --%>
							</td>                            
                        
                        </tr>
                     
    <%-- attach a live updating progress bar for each row --%>                        
    <script type="text/javascript">
      var jobProgress${emailJobInstance.id} = new Ext.ProgressBar({
        text:'Ready',
        id:'progressBar${emailJobInstance.id}',
        cls:'left-align',
        renderTo:'jobProgress${emailJobInstance.id}'
      });

      function pollProgress${emailJobInstance.id}() {
		Ext.Ajax.request({
			url: '/tlm/emailJob/progress/${emailJobInstance.id}',
			success: function(response, opts) 
			{
        	    var obj = Ext.decode(response.responseText);
				var progress = parseFloat(obj.progress)
				if (progress >= 1) 
				{					
					jobProgress${emailJobInstance.id}.updateProgress(1.0, obj.status);
				}
				else 
				{
					jobProgress${emailJobInstance.id}.updateProgress(progress, obj.status + ": "+(Math.floor(progress * 10000) / 100)+"%");					
					setTimeout("pollProgress${emailJobInstance.id}()", 3000);
				}
			},
			failure: function(response, opts) {
				jobProgress${emailJobInstance.id}.updateProgress(0.0, 'Communications error, retrying...');
				setTimeout("pollProgress${emailJobInstance.id}()", 3000);
			}
		}); // end request
          
      }

      pollProgress${emailJobInstance.id}();
      
    </script>        
                        
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${emailJobInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
