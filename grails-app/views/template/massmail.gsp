
<%@ page import="com.tlm.beans.Template" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'template.label', default: 'Template')}" />
        <title>Send mass e-mail</title>
        <script type="text/javascript" src="${resource(dir:'js/tiny_mce', file:'editor_config.js')}" ></script>
    </head>
    <body>
        <div class="body">
            <h1>Send mass e-mail</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${templateInstance}">
            <div class="errors">
                <g:renderErrors bean="${templateInstance}" as="list" />
            </div>
            </g:hasErrors>
            <div class="nav">
              <span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
              <span class="menuButton"><g:link class="list" action="list">Template List</g:link></span>
            </div>            
            <g:form method="post" >
                <g:hiddenField name="templateInstance.id" value="${templateInstance?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                        	<%-- Show the name only if it is not ad-hoc --%>
                        	<g:if test="${ templateInstance?.name != null}">
                            	<tr class="prop">
                                	<td  class="name">
                                  		<label for="name"><g:message code="template.name.label" default="Name" /></label>
                                	</td>
                                	<td  class="value">
                                    	${templateInstance?.name}
                                	</td>
                            	</tr>
                            </g:if>
                        
                            <tr class="prop">
                                <td  class="name">
                                  <label for="fileName"><g:message code="template.subject.label" default="Subject" /></label>
                                </td>
                                <td  class="value">
                                   <g:textField name="subject" value="${templateInstance?.subject}" size="100" maxlength="255"/>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td  class="name">
                                  <label for="data"><g:message code="template.data.label" default="Data" /></label>
                                </td>
                                <td  class="value ${hasErrors(bean: templateInstance, field: 'data', 'errors')}">
                                    <g:textArea name="data" value="${templateInstance?.data}" />
                                </td>
                            </tr>
                            
                            <tr class="header">
                              <td colspan="2">Send mass mail to users of the following categories: </td>
                            </tr>
                            
                            <g:if test="${templateInstance?.service != null}">
                              <tr class="prop">
                                <td  class="name">
                                  <g:checkBox name="massmail.service" value="true" checked="true" /> Subscribed to the following service: </label>
                                </td>
                                <td  class="value">
                                  ${templateInstance?.service?.name}
                                  <g:hiddenField name="service.id" value="${templateInstance?.service?.id}" />
                                </td>
                              </tr>
                            </g:if>

                            <tr class="prop">
                              <td class="name">Role</td>
                              <td class="value">
                                <g:select name="role.id" 
                                          from="${com.tlm.beans.Role.list()}" optionKey="id" value="${role?.id}" noSelection="['': 'Any']" />
                              </td>
                            </tr>
                            
                            <tr class="prop">
                              <td class="name">Job Function</td>
                              <td class="value">
                                <g:select name="jobFunction.id" 
                                          from="${com.tlm.beans.JobFunction.list()}" optionKey="id" value="${jobFunction?.id}" noSelection="['': 'Any']" />
                              </td>
                            </tr>
                            
                            <tr class="prop">
                              <td class="name">Job Position</td>
                              <td class="value">
                                <g:select name="jobPosition.id" 
                                          from="${com.tlm.beans.JobPosition.list()}" optionKey="id" value="${jobPosition?.id}" noSelection="['': 'Any']" />
                              </td>
                            </tr>
                            
                            <tr class="prop">
                              <td class="name">Country</td>
                              <td class="value">
                                <g:select name="country.id" 
                                          from="${com.tlm.beans.Country.list()}" optionKey="id" value="${country?.id}" noSelection="['': 'Any']" />
                              </td>
                            </tr>
                            
                            <tr class="prop">
                              <td class="name">Publication</td>
                              <td class="value">
                                <ul>
                              	<g:collect in="${com.tlm.beans.Publication.list()}" expr="it">
                              		<li><g:checkBox name="publication.id" value="${it.id}" /> ${it.pubLongName}</li>
                              	</g:collect>
                              	</ul>
                                <%--g:select name="publication.id" 
                                          from="${com.tlm.beans.Publication.list()}" optionKey="id" value="${publication?.id}" noSelection="['': 'Any']" / --%>
                              </td>
                            </tr>

                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="email" action="sendmassmail" value="Send mass e-mail" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
