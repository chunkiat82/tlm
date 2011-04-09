
<%@ page import="com.tlm.beans.User" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        <style>
        	ul.horizontal li
			{
				display: inline;
				list-style-type: none;
				padding-right: 20px;
			}
        </style>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${userInstance}">
            <div class="errors">
                <g:renderErrors bean="${userInstance}" as="list" />
            </div>
            </g:hasErrors>
        	<div class="nav">
	            <span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
    	        <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        	    <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        	</div>
            
            <g:form method="post" >
                <g:hiddenField name="id" value="${userInstance?.id}" />
                <g:hiddenField name="version" value="${userInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                        	<tr><td colspan="2" class="sectionheader">User account details</td></tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="userName"><g:message code="user.userName.label" default="User Name" />*</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'userName', 'errors')}">
                                    <g:textField name="userName" value="${userInstance?.userName}" />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="password"><g:message code="user.password.label" default="Password" />*</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'password', 'errors')}">
                                    <g:passwordField name="password" value="${userInstance?.password}" />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="confirmPassword"><g:message code="user.confirmPassword.label" default="Confirm Password" />*</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'confirmPassword', 'errors')}">
                                    <g:passwordField name="confirmPassword" value="${userInstance?.confirmPassword}" />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="accountStatus"><g:message code="user.accountStatus.label" default="Account Status" />*</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'accountStatus', 'errors')}">
                                	<g:radioGroup name="accountStatus" values="[0,1,-1]" labels="['Active', 'Pending','Disabled']" value="${userInstance?.accountStatus}" >
										<span>${it.label} ${it.radio}</span>
									</g:radioGroup>
                                </td>
                            </tr>
                        
                          
                            
					<tr class="prop">
						<td valign="top" class="name"><label for="authorities">Roles:</label></td>
						<td valign="top" class="value ${hasErrors(bean:userInstance,field:'roles','errors')}">
							<ul>
							<g:each var="entry" in="${roleMap}">
								<li>${entry.key.roleName.encodeAsHTML()}
									<g:checkBox name="${entry.key.roleName}" value="${entry.value}"/>
								</li>
							</g:each>
							</ul>
						</td>
					</tr>							
                            
                        	<tr><td colspan="2" class="sectionheader">User particulars</td></tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="honorific"><g:message code="user.honorific.label" default="Honorific" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'honorific', 'errors')}">
                                    <g:select name="honorific.id" from="${com.tlm.beans.LookupHonorific.list()}" optionKey="id" value="${userInstance?.honorific?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="firstName"><g:message code="user.firstName.label" default="First Name" />*</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'firstName', 'errors')}">
                                    <g:textField name="firstName" value="${userInstance?.firstName}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="lastName"><g:message code="user.lastName.label" default="Last Name" />*</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'lastName', 'errors')}">
                                    <g:textField name="lastName" value="${userInstance?.lastName}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="email"><g:message code="user.email.label" default="Email" />*</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'email', 'errors')}">
                                    <g:textField name="email" value="${userInstance?.email}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="gender"><g:message code="user.gender.label" default="Gender" />*</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'gender', 'errors')}">
                                	<g:radioGroup name="gender" values="['M','F']" value="${userInstance?.gender}" >
										<span>${it.label} ${it.radio}</span>
									</g:radioGroup>                                	
                                </td>
                            </tr>
                            
                            <tr><td colspan="2" class="sectionheader">Employment particulars</td></tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="company"><g:message code="user.company.label" default="Company" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'company', 'errors')}">
                                    <g:textField name="company" value="${userInstance?.company}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="jobFunction"><g:message code="user.jobFunction.label" default="Job Function" />*</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'jobFunction', 'errors')}">
                                    <g:select name="jobFunction.id" from="${com.tlm.beans.JobFunction.list()}" optionKey="id" value="${userInstance?.jobFunction?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="jobPosition"><g:message code="user.jobPosition.label" default="Job Position" />*</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'jobPosition', 'errors')}">
                                    <g:select name="jobPosition.id" from="${com.tlm.beans.JobPosition.list()}" optionKey="id" value="${userInstance?.jobPosition?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                            
                            <tr><td colspan="2" class="sectionheader">Contact Information</td></tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="address"><g:message code="user.address.label" default="Address" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'address', 'errors')}">
                                    <g:textField name="address" value="${userInstance?.address}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="postal"><g:message code="user.postal.label" default="Postal" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'postal', 'errors')}">
                                    <g:textField name="postal" value="${userInstance?.postal}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="city"><g:message code="user.city.label" default="City" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'city', 'errors')}">
                                    <g:textField name="city" value="${userInstance?.city}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="state"><g:message code="user.state.label" default="State" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'state', 'errors')}">
                                    <g:textField name="state" value="${userInstance?.state}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="country"><g:message code="user.country.label" default="Country" />*</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'country', 'errors')}">
                                    <g:select name="country.id" from="${com.tlm.beans.Country.list()}" optionKey="id" value="${userInstance?.country?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="telephone"><g:message code="user.telephone.label" default="Telephone" />*</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'telephone', 'errors')}">
                                    <g:textField name="telephone" value="${userInstance?.telephone}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="fax"><g:message code="user.fax.label" default="Fax" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'fax', 'errors')}">
                                    <g:textField name="fax" value="${userInstance?.fax}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="mobile"><g:message code="user.mobile.label" default="Mobile" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'mobile', 'errors')}">
                                    <g:textField name="mobile" value="${userInstance?.mobile}" />
                                </td>
                            </tr>   
                            <tr><td colspan="2" class="sectionheader">Subscription Information</td></tr>
                            <g:each in="${publicationList}" var="pubItem">
                            	<tr>
								 	<td valign="top" class="name">
								 		${pubItem.pubLongName} 
								 	</td>
								 	<td valign="top" class="value">
								 	<ul class="horizontal" >
								 		<g:each in="${serviceList}" var="serItem">
								 			<g:set var="cbValue">false</g:set>
								 			<g:each in="${userInstance?.subscriptions}" var="subItem">
								 				<g:if test="${subItem.subscriptionStatus == 'A'}">								 				
									 				<g:if test="${subItem.publication.pubId == pubItem.pubId}">
													     <g:if test="${subItem.service.id == serItem.id}">
													     	<g:set var="cbValue">true</g:set>													     
													     </g:if>
													</g:if>
												</g:if>
								 			</g:each>
							 			<li>${serItem.name}<g:checkBox name="SERV_${serItem.id}_${pubItem.pubId}" checked="${cbValue}" value="${true}"/></li>							 											 			
								 		</g:each>
								 		</ul>
								 		
								 	</td>
								 
								 </tr>  
                            </g:each>                            
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
