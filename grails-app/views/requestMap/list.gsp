<head>
	<meta name="layout" content="main" />
	<title>RequestMap List</title>
</head>

<body>

	<div class="body">
		<h1>Permissions</h1>
		<g:if test="${flash.message}">
		<div class="message">${flash.message}</div>
		</g:if>
		<div class="nav">
			<span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
			<span class="menuButton"><g:link class="create" action="create">New Permission</g:link></span>
		</div>
		
		<div class="list">
			<table>
			<thead>
				<tr>					
					<g:sortableColumn property="url" title="URL Pattern" />
					<g:sortableColumn property="configAttribute" title="Roles" />
					<th>Action</th>
				</tr>
			</thead>
			<tbody>
			<g:each in="${requestmapList}" status="i" var="requestmap">
				<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">					
					<td>${requestmap.url?.encodeAsHTML()}</td>
					<td>${requestmap.configAttribute}</td>
                    <td nowrap>
                    	<g:link action="show" id="${requestmap.id}"><img src="${resource(dir:'images/webicons',file:'Search.png')}" title="View ${requestmap.url}" /></g:link>
                        <g:link action="edit" id="${requestmap.id}"><img src="${resource(dir:'images/webicons',file:'Modify.png')}" title="Edit ${requestmap.url}" /></g:link>
                        <g:link action="delete" id="${requestmap.id}"><img src="${resource(dir:'images/webicons',file:'Delete.png')}" title="Delete ${requestmap.url}" /></g:link>                              
                    </td>

				</tr>
				</g:each>
			</tbody>
			</table>
		</div>

		<div class="paginateButtons">
			<g:paginate total="${com.tlm.beans.RequestMap.count()}" />
		</div>

	</div>
</body>
