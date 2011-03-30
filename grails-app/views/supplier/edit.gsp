
<%@ page import="com.tlm.beans.Supplier" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'supplier.label', default: 'Supplier')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${supplierInstance}">
            <div class="errors">
                <g:renderErrors bean="${supplierInstance}" as="list" />
            </div>
            </g:hasErrors>
        	<div class="nav">
            	<span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
            	<span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            	<span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        	</div>
            <g:form method="post" >
                <g:hiddenField name="id" value="${supplierInstance?.id}" />
                <g:hiddenField name="version" value="${supplierInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="mobile"><g:message code="supplier.mobile.label" default="Mobile" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: supplierInstance, field: 'mobile', 'errors')}">
                                    <g:textField name="mobile" value="${supplierInstance?.mobile}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="address"><g:message code="supplier.address.label" default="Address" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: supplierInstance, field: 'address', 'errors')}">
                                    <g:textField name="address" value="${supplierInstance?.address}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="telephone"><g:message code="supplier.telephone.label" default="Telephone" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: supplierInstance, field: 'telephone', 'errors')}">
                                    <g:textField name="telephone" value="${supplierInstance?.telephone}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="fax"><g:message code="supplier.fax.label" default="Fax" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: supplierInstance, field: 'fax', 'errors')}">
                                    <g:textField name="fax" value="${supplierInstance?.fax}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="publications"><g:message code="supplier.publications.label" default="Publications" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: supplierInstance, field: 'publications', 'errors')}">
                                    <ul>
										<g:each var="entry" in="${pubMap}">
										<li>${entry.key.pubLongName.encodeAsHTML()}
											<g:checkBox name="PUB_${entry.key.pubId}" value="${entry.value}"/>
										</li>
									</g:each>
									</ul>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="company"><g:message code="supplier.company.label" default="Company" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: supplierInstance, field: 'company', 'errors')}">
                                    <g:textField name="company" value="${supplierInstance?.company}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="country"><g:message code="supplier.country.label" default="Country" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: supplierInstance, field: 'country', 'errors')}">
                                    <g:select name="country.id" from="${com.tlm.beans.Country.list()}" optionKey="id" value="${supplierInstance?.country?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="description"><g:message code="supplier.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: supplierInstance, field: 'description', 'errors')}">
                                    <g:textField name="description" value="${supplierInstance?.description}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="email"><g:message code="supplier.email.label" default="Email" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: supplierInstance, field: 'email', 'errors')}">
                                    <g:textField name="email" value="${supplierInstance?.email}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="website"><g:message code="supplier.website.label" default="Website" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: supplierInstance, field: 'website', 'errors')}">
                                    <g:textField name="website" value="${supplierInstance?.website}" />
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
