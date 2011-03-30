
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
            <h1>Search <g:message code="default.list.label" args="[entityName]" /> Total:${userInstanceTotal}</h1>
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
            <g:form action="searchList" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                        	<tr><td colspan="2" class="sectionheader">Member details</td></tr>
                        	<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="userName"><g:message code="user.userName.label" default="User Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'userName', 'errors')}">
                                    <g:radioGroup name="accountStatus" values="[0,1,-1]" labels="['Active', 'Pending','Disabled']" value="${userInstance?.accountStatus}" >
										<span>${it.label} ${it.radio}</span>
									</g:radioGroup>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="userName"><g:message code="user.userName.label" default="User Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'userName', 'errors')}">
                                    <g:textField name="userName" value="${userInstance?.userName}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="firstName"><g:message code="user.firstName.label" default="First Name" /></label>
                                </td>
                                <td valign="top" class="value">
                                    <g:textField name="firstName" value="" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="userName"><g:message code="user.lastName.label" default="Last Name" /></label>
                                </td>
                                <td valign="top" class="value">
                                    <g:textField name="lastName" value="" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="jobFunction"><g:message code="user.jobFunction.label" default="Job Function" /></label>
                                </td>
                                <td valign="top" class="value">
                                    <g:select name="jobFunction" from="${com.tlm.beans.JobFunction.list()}" optionKey="id" value="" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="jobPosition"><g:message code="user.jobPosition.label" default="Job Position" /></label>
                                </td>
                                <td valign="top" class="value">
                                    <g:select name="jobPosition" from="${com.tlm.beans.JobPosition.list()}" optionKey="id" value="" noSelection="['null': '']" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="publication"><g:message code="user.publication.label" default="Publication" /></label>
                                </td>
                                <td valign="top" class="value">
                                    <g:select name="publication" from="${com.tlm.beans.Publication.list()}" optionKey="id" value="" noSelection="['null': '']" />
                                </td>
                            </tr>
                             <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="country"><g:message code="user.country.label" default="Country" /></label>
                                </td>
                                <td valign="top" class="value">
                                    <g:select name="country" from="${com.tlm.beans.Country.list()}" optionKey="id" value="" noSelection="['null': '']" />
                                </td>
                            </tr>
                             <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="country"><g:message code="user.role.label" default="Role" /></label>
                                </td>
                                <td valign="top" class="value">
                                    <g:select name="role" from="${com.tlm.beans.Role.list()}" optionKey="id" value="" noSelection="['null': '']" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="searchList" class="info" value="${message(code: 'default.button.search.label', default: 'Search')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
