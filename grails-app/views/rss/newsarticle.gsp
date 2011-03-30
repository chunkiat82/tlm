
<%@ page import="com.tlm.beans.User"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />
<g:set var="entityName"
	value="${message(code: 'news.label', default: 'News')}" />
<title><g:message code="default.show.label" args="[entityName]" /></title>
<script type="text/javascript" src="${resource(dir:'js/tiny_mce', file:'view_config.js')}" ></script>
</head>
<body>

<div class="body">
<h1><g:message code="default.show.label" args="[entityName]" /></h1>
<g:if test="${flash.message}">
	<div class="message">
	${flash.message}
	</div>
</g:if>
<div class="dialog">
<table>
	<tbody>

		<tr>
			<td colspan="2" class="sectionheader">News Article</td>
		</tr>

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="news.title" default="Title" /></td>
			<td valign="top" class="value">
			${fieldValue(bean: newsInstance, field: "title")}
			</td>
		</tr>
		
		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="news.publicationDate" default="Published Date" /></td>
			<td valign="top" class="value">
			${fieldValue(bean: newsInstance, field: "publicationDate")}
			</td>
		</tr>
		

		<tr class="prop">
			<td valign="top" class="name"><g:message
				code="news.html" default="Content" /></td>
			<td valign="top" class="value">
			<g:textArea style="width:100%" name="html" value="${newsInstance?.html}" />
			</td>
		</tr>

	</tbody>
</table>
</div>
</div>
</body>
</html>
