<head>
	<meta name="layout" content="main" />
	<title>Show Permission</title>
</head>

<body>

	<div class="body">
		<h1>Show Permission</h1>
		<g:if test="${flash.message}">
		<div class="message">${flash.message}</div>
		</g:if>
		<div class="nav">
			<span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
			<span class="menuButton"><g:link class="list" action="list">Permissions</g:link></span>
			<span class="menuButton"><g:link class="create" action="create">New Permission</g:link></span>
		</div>
		<div class="dialog">
			<table>
			<tbody>

				<tr class="prop">
					<td valign="top" class="name">URL:</td>
					<td valign="top" class="value">${requestmap.url}</td>
				</tr>

				<tr class="prop">
					<td valign="top" class="name">Roles:</td>
					<td valign="top" class="value">${requestmap.configAttribute}</td>
				</tr>

			</tbody>
			</table>
		</div>

		<div class="buttons">
			<g:form>
				<input type="hidden" name="id" value="${requestmap.id}" />
				<span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
				<span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
			</g:form>
		</div>

	</div>
</body>
