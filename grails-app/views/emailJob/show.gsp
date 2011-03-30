<%@ page import="com.tlm.beans.EmailJob" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'emailJob.label', default: 'EmailJob')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        <script type="text/javascript" src="${resource(dir:'js/tiny_mce', file:'view_config.js')}" ></script>
    </head>
    <body>
        <style type="text/css">
        	.shortvalue { width: 100px }
        </style>
        <div class="body">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
        	<div class="nav">
            	<span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
            	<span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            	<span class="menuButton"><a class="create" href="${createLink(controller: 'template', action: 'massmail')}">Create ad-hoc job</a></span>
        	</div>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <%--tr class="prop">
                            <td valign="top" class="name"><g:message code="emailJob.template.label" default="Template" /></td>
                            <td valign="top" class="value"><g:link controller="template" action="show" id="${emailJobInstance?.template?.id}">${emailJobInstance?.template?.encodeAsHTML()}</g:link></td>
                        </tr --%>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="emailJob.description.label" default="Description" /></td>
                            <td valign="top" class="value">${emailJobInstance.description}</td>
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="emailJob.subject.label" default="Subject" /></td>
                            <td valign="top" class="value">${emailJobInstance.subject}</td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="emailJob.html.label" default="Html" /></td>
                            <td valign="top" class="value"><g:textArea name="data" value="${emailJobInstance.html}" /></td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="emailJob.status.label" default="Status" /></td>
                            <td valign="top" class="value"><div id="jobProgress" style="width:300px"></div></td>
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="emailJob.report.label" default="Report" /></td>
                            <td valign="top" class="value"><a href="${request.contextPath}/emailJob/report/${emailJobInstance.id}">Click</a></td>                        
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="emailJob.dateCompleted.label" default="Date Completed" /></td>
                            <td valign="top" class="value"><g:formatDate date="${emailJobInstance?.dateCompleted}" /></td>
                        </tr>
                    
                        <%-- tr class="prop">
                            <td valign="top" class="name"><g:message code="emailJob.emailJobItems.label" default="Email Job Items" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                
                                 <table>
                                    <thead>
                                      <tr>
                                        <th>Email</th>
                                        <th>User</th>
                                        <th>Status</th>
                                      </tr>
                                    </thead>
                                    
                                    <tbody>
                                      <g:each in="${emailJobInstance.emailJobItems}" var="e">
                                        <tr>
                                          <td class="shortvalue">${e.email}</td>
                                          <td class="shortvalue">${e.user}</td>
                                          <td class="shortvalue ${e.status}">${e.statusLabel}</td>
                                        </tr>
                                      </g:each>
                                    </tbody>
                                  </table>

                            </td>
                            
                        </tr --%>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="emailJob.lastUpdated.label" default="Last Updated" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${emailJobInstance?.lastUpdated}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="emailJob.dateCreated.label" default="Date Created" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${emailJobInstance?.dateCreated}" /></td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                    <g:hiddenField name="id" value="${emailJobInstance?.id}" />
                    <g:if test="${emailJobInstance.status == 'R'}">
                    	<span class="button"><input type="submit" class="pause" onclick="pause()" value="Pause Job" /> </span> 
                    </g:if>
                    <g:elseif test="${emailJobInstance.status == 'P'}">
                    	<span class="button"><input type="submit" class="resume" onclick="resume()" value="Resume Job" /> </span>
                    </g:elseif>
                    <g:else>
                    	<span class="button"><input type="submit" disabled="disabled" value="No actions"/></span>
                    </g:else>
                    
                    <%-- span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span--%>
                    <%-- span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span--%>
            </div>
        </div>
        
    <script type="text/javascript">
      var jobProgress = new Ext.ProgressBar({
        text:'Ready',
        id:'progressBar',
        cls:'left-align',
        renderTo:'jobProgress'
      });

      function pause() {
          Ext.Ajax.request({
              url: '/tlm/emailJob/pause/${emailJobInstance?.id}',
              success: function(response, opts)
              {
                  window.location.reload();
              },
              failure: function(response, opts)
              {
                  alert('Unable to pause this job!');
              }
          });    
      }

      function resume() {
          Ext.Ajax.request({
              url: '/tlm/emailJob/resume/${emailJobInstance?.id}',
              success: function(response, opts)
              {
                  window.location.reload();
              },
              failure: function(response, opts)
              {
                  alert('Unable to resume this job!');
              }
          });
      }

      function pollProgress() {
		Ext.Ajax.request({
			url: '/tlm/emailJob/detailedProgress/${emailJobInstance?.id}',
			success: function(response, opts) 
			{
        	    var obj = Ext.decode(response.responseText);
				var progress = parseFloat(obj.progress)
				var failure = parseInt(obj.failure)
				var success = parseInt(obj.success)
				var total = parseInt(obj.total)
				
				var details = "F="+failure+", S="+success+", T="+total
				
				if (progress >= 1) 
				{
					jobProgress.updateProgress(1.0, obj.status);
				}
				else 
				{
					
					jobProgress.updateProgress(progress, obj.status + " ("+(Math.floor(progress * 10000)/100)+"%) "+details);
					setTimeout("pollProgress()", 1000);
				}
			},
			failure: function(response, opts) {
				jobProgress.updateProgress(0.0, 'Communications error, retrying...');
				setTimeout("pollProgress()", 1000);
			}
		}); // end request
          
      }

      pollProgress();
      
    </script>        
    </body>
    

</html>
