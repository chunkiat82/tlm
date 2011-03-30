
<%@ page import="com.tlm.beans.Ads"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />
<g:set var="entityName"
	value="${message(code: 'ads.label', default: 'Ads')}" />
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

		<tr class="prop">
			<td valign="top" class="name"><g:message code="ads.id.label"
				default="Preview" /></td>

			<td valign="top" class="value">
				<g:if test="${adsInstance?.adType == 'image'}">
					<img src="/tlm/response/adsImage/${adsInstance?.id}" border="0">
				</g:if> 
				<g:else>
				<object width="150" height="150" id="advertise3"
					codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"
					classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
					<param value="/tlm/response/adsImage/${adsInstance?.id}" name="movie">
					<param value="High" name="quality">
					<param value="#ffffff" name="bgcolor">
					<embed width="150" height="150" align=""
						pluginspage="http://www.macromedia.com/go/getflashplayer"
						type="application/x-shockwave-flash" name="advertise1"
						bgcolor="#ffffff" quality="High"
						src="/tlm/response/adsImage/${adsInstance?.id}">
					<p>&nbsp;</p></object>
			</g:else></td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="ads.mimeType.label" default="Mime Type" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: adsInstance, field: "mimeType")}
			</td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message code="ads.rank.label"
				default="Rank" /></td>

			<td valign="top" class="value">
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

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="ads.releaseDate.label" default="Release Date" /></td>

			<td valign="top" class="value"><g:formatDate
				date="${adsInstance?.releaseDate}" /></td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message code="ads.name.label"
				default="Name" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: adsInstance, field: "name")}
			</td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="ads.expireDate.label" default="Expire Date" /></td>

			<td valign="top" class="value"><g:formatDate
				date="${adsInstance?.expireDate}" /></td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="ads.fileName.label" default="File Name" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: adsInstance, field: "fileName")}
			</td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message code="ads.url.label"
				default="Url" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: adsInstance, field: "url")}
			</td>

		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="ads.fileData.label" default="File Data" /></td>

			<td valign="top" class="value">
			${fieldValue(bean: adsInstance, field: "fileData")}
			</td>

		</tr>

	</tbody>
</table>
</div>
<div class="buttons"><g:form>
	<g:hiddenField name="id" value="${adsInstance?.id}" />
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
