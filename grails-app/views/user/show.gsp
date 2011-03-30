
<%@ page import="com.tlm.beans.User"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />
<g:set var="entityName"
	value="${message(code: 'user.label', default: 'User')}" />
<title><g:message code="default.show.label" args="[entityName]" /></title>
</head>
<body>

<div class="body">
<h1><g:message code="default.show.label" args="[entityName]" /></h1>
<g:if test="${flash.message}">
	<div class="message">
	${flash.message}
	</div>
</g:if>
<div class="nav"><span class="menuButton"><a class="home"
	href="${createLink(uri: '/admin')}">Admin Menu</a></span> <span
	class="menuButton"><g:link class="list" action="list">
	<g:message code="default.list.label" args="[entityName]" />
</g:link></span> <span class="menuButton"><g:link class="create" action="create">
	<g:message code="default.new.label" args="[entityName]" />
</g:link></span></div>
<div class="dialog">
<table>
	<tbody>

		<tr>
			<td colspan="2" class="sectionheader">Account details</td>
		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.userName.label" default="User Name" /></td>
			<td valign="top" class="value">
			${fieldValue(bean: userInstance, field: "userName")}
			</td>
		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.fullName.label" default="Full Name" /></td>
			<td valign="top" class="value">
			${fieldValue(bean: userInstance, field: "fullName")}
			</td>
		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.accountStatus.label" default="Account Status" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: userInstance, field: "accountStatus")}
			</td>

		</tr>

		<!--<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.enabled.label" default="Enabled" /></td>

			<td valign="top" class="value"><g:formatBoolean
				boolean="${userInstance?.enabled}" /></td>

		</tr>

		--><tr class="prop">
			<td valign="top" class="name"><g:message code="user.roles.label"
				default="Roles" /></td>

			<td valign="top" style="text-align: left;" class="value">
			<ul>
				<g:each in="${userInstance.roles}" var="r">
					<li>
					${r?.encodeAsHTML()}
					</li>
				</g:each>
			</ul>
			</td>

		</tr>


		<tr class="prop">
			<td valign="top" class="name"><g:message code="user.email.label"
				default="Email" /></td>
			<td valign="top" class="value">
			${fieldValue(bean: userInstance, field: "email")}
			</td>
		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.gender.label" default="Gender" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: userInstance, field: "gender")}
			</td>

		</tr>

		<tr>
			<td class="sectionheader" colspan="2">Employment Particulars</td>
		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.company.label" default="Company" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: userInstance, field: "company")}
			</td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.jobFunction.label" default="Job Function" /></td>

			<td valign="top" class="value">
			${userInstance?.jobFunction?.encodeAsHTML()}
			</td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.jobPosition.label" default="Job Position" /></td>

			<td valign="top" class="value">
			${userInstance?.jobPosition?.encodeAsHTML()}
			</td>

		</tr>

		<tr>
			<td class="sectionheader" colspan="2">Contact Information</td>
		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.address.label" default="Address" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: userInstance, field: "address")}
			</td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.postal.label" default="Postal" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: userInstance, field: "postal")}
			</td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message code="user.city.label"
				default="City" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: userInstance, field: "city")}
			</td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message code="user.state.label"
				default="State" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: userInstance, field: "state")}
			</td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.country.label" default="Country" /></td>

			<td valign="top" class="value">
			${userInstance?.country?.encodeAsHTML()}
			</td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.telephone.label" default="Telephone" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: userInstance, field: "telephone")}
			</td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message code="user.fax.label"
				default="Fax" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: userInstance, field: "fax")}
			</td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.mobile.label" default="Mobile" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: userInstance, field: "mobile")}
			</td>

		</tr>
		
		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.lastUpdated.label" default="Last Updated" /></td>

			<td valign="top" class="value"><g:formatDate
				date="${userInstance?.lastUpdated}" /></td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="user.dateCreated.label" default="Date Created" /></td>

			<td valign="top" class="value"><g:formatDate
				date="${userInstance?.dateCreated}" /></td>

		</tr>
		<tr>
			<td colspan="2" class="sectionheader">Subscription Information</td>
		</tr>
		<g:each in="${publicationList}" var="pubItem">
			<tr>
				<td valign="top" class="name">
				${pubItem.pubLongName}
				</td>
				<td valign="top" class="value">
				<ul class="horizontal">
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
						<li>
						${serItem.name} -> 
						<g:if test="${cbValue == 'true'}">
						SUBSCRIBED
						</g:if>
						<g:if test="${cbValue != 'true'}">
						NOT SUBSCRIBED
						</g:if>
						</li>
					</g:each>
				</ul>

				</td>

			</tr>
		</g:each>
		<tr>
			<td class="sectionheader" colspan="2">Download Information</td>
		</tr>
		<tr class="prop">
			<td colspan="2" class="name">
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
                    <g:each in="${userDownloadStatList}" status="i" var="downloadCountInstance">
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
			</td>
		</tr>
	</tbody>
</table>
</div>
<div class="buttons"><g:form>
	<g:hiddenField name="id" value="${userInstance?.id}" />
	<span class="button"><g:actionSubmit class="edit" action="edit"
		value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
	<span class="button"><g:actionSubmit class="delete"
		action="delete"
		value="${message(code: 'default.button.delete.label', default: 'Delete')}"
		onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
</g:form></div>
</div>
</body>
</html>
