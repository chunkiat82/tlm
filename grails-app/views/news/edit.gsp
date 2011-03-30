
<%@ page import="com.tlm.beans.News" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'news.label', default: 'News')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        <script type="text/javascript" src="${resource(dir:'js/tiny_mce', file:'editor_config.js')}" ></script>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${newsInstance}">
            <div class="errors">
                <g:renderErrors bean="${newsInstance}" as="list" />
            </div>
            </g:hasErrors>
	        <div class="nav">
    	        <span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
        	    <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            	<span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        	</div>
            <g:form method="post" >
                <g:hiddenField name="id" value="${newsInstance?.id}" />
                <g:hiddenField name="version" value="${newsInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="title"><g:message code="news.title.label" default="Title" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: newsInstance, field: 'title', 'errors')}">
                                    <g:textField name="title" value="${newsInstance?.title}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="html"><g:message code="news.html.label" default="Html" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: newsInstance, field: 'html', 'errors')}">
                                    <g:textArea name="html" value="${newsInstance?.html}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="publicationDate"><g:message code="news.publicationDate.label" default="Publication Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: newsInstance, field: 'publicationDate', 'errors')}">
                                    <g:datePicker name="publicationDate" precision="day" value="${newsInstance?.publicationDate}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="publication"><g:message code="news.publication.label" default="Publication" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: newsInstance, field: 'publication', 'errors')}">
                                    <g:select name="publication.id" from="${com.tlm.beans.Publication.list()}" optionKey="id" value="${newsInstance?.publication?.id}"  />
                                </td>
                            </tr>
                        
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
