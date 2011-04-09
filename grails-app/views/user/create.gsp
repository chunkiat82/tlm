
<%@ page import="com.tlm.beans.User" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
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
        	</div>
            <g:form action="save" method="post" >
           		<g:hiddenField name="password" value="password" />
                <g:hiddenField name="confirmPassword" value="password" />
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
                                    <label for="accountStatus"><g:message code="user.accountStatus.label" default="Account Status" />*</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'accountStatus', 'errors')}">
                                	<g:radioGroup name="accountStatus" values="[0,1]" labels="['Active', 'Pending']" value="${userInstance?.accountStatus}" >
										<span>${it.label} ${it.radio}</span>
									</g:radioGroup>
                                </td>
                            </tr><tr class="prop">
								<td valign="top" class="name" align="left">Roles</td>
								<td align="left">
									<g:each in="${roleList}">
										${it.roleName.encodeAsHTML()} <g:checkBox name="${it.roleName}"/>
									</g:each>
								</td>
							</tr>
							                                                        
                            
                        	<tr><td colspan="2" class="sectionheader">User particulars</td></tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="honorific"><g:message code="user.honorific.label" default="Honorific" />*</label>
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
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
