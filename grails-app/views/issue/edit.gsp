
<%@ page import="com.tlm.beans.Issue" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'issue.label', default: 'Issue')}" />
        <script type="text/javascript" src="${resource(dir:'js/swfupload', file:'swfupload.js')}"></script>
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        
        <script type="text/javascript">
        
        function createFileInput(name, data, code) {
            // create a container to hold everything
            var container = document.createElement("DIV");
            
            // create a hidden input that is submitted
            var input = document.createElement("INPUT");
            input.type = "hidden";
            input.name = name;
            input.style.cssFloat = "left";
            if (data) {
                input.value = data;
            }
            container.appendChild(input);

            // create another hidden input representing the code for the file
            var codeInput = document.createElement("INPUT");
            codeInput.type = "hidden";
            codeInput.name = name + ".code";
            codeInput.style.cssFloat = "left";
            if (code) {
                codeInput.value = code; 
            }
            container.appendChild(codeInput);

            // create a container for the upload button
            var button = document.createElement("SPAN");                          
            container.appendChild(button);

            // create a (initially hidden) label that shows the file uploaded
            var fileLabel = document.createElement("LABEL");
            if (data) {
                fileLabel.innerHTML = data;
            } else {
          	  fileLabel.style.display = "none";
            }
            fileLabel.style.cssFloat = "left";
            container.appendChild(fileLabel);

            // create a container for the progress bar
            var progressSpan = document.createElement("SPAN");
            progressSpan.style.width = "100px";
            progressSpan.style.cssFloat = "left";
            container.appendChild(progressSpan);

            // attach an ExtJs progress bar to the container
            var uploadProgress = new Ext.ProgressBar({
                text:'Ready'
            });

            // create the swfbutton that will do some magic
            var swfUploadSettings = {
                upload_url : "/tlm/fileUpload/swfupload",
                flash_url : "${resource(dir:'swf', file:'swfupload.swf')}",
                file_size_limit : "20 MB",
                button_placeholder : button,
                button_image_url: "${resource(dir:'images/webicons', file:'Upload.png')}",
                button_width: 24,
                button_height: 24,
                upload_progress_handler : function(file, bytesComplete, bytesTotal) {
                    if (!uploadProgress.rendered) {
                        uploadProgress.render(progressSpan);
                    } else {
                        uploadProgress.show();
                    };
                    var percentage = bytesComplete / bytesTotal;
                    uploadProgress.updateProgress(percentage, (percentage * 100).toFixed(2) + "%");  
                },
                upload_start_handler : function (file) {
                    return true;
                },
                upload_success_handler: function(file, serverData, receivedResponse) {
                    uploadProgress.hide();
                    fileLabel.style.display = "";
                    fileLabel.innerHTML = file.name;
                    input.value = file.name;
                    codeInput.value = serverData;
                    this.setButtonDisabled(false);                                          
                },
                file_dialog_complete_handler: function(selected, queued, total) {
                    if (queued > 0) {
                    	fileLabel.style.display = "none";
                    	this.setButtonDisabled(true);
                    	this.startUpload();
                    }
                },
                upload_error_handler: function(file, code, message) {
                    alert(message);
                    this.setButtonDisabled(false);
                },
                file_queue_error_handler: function(file, code, message) {
                    alert(message);
                    this.setButtonDisabled(false);
                }
            };

            // return a function that will append to specified holder
            return function(holder) {
                holder.style.width = "150px";
                holder.appendChild(container);
                return new SWFUpload(swfUploadSettings);
            }

        }
        </script>
        
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${issueInstance}">
            <div class="errors">
                <g:renderErrors bean="${issueInstance}" as="list" />
            </div>
            </g:hasErrors>
            
        	<div class="nav">
    	        <span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
        	    <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        	</div>
            <g:form method="post" >
            
                <g:hiddenField name="id" value="${issueInstance?.id}" />
                <g:hiddenField name="version" value="${issueInstance?.version}" />
                
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">Thumbnail</td>
                                <td valign="top" class="value ${hasErrors(bean: issueInstance, field: 'publication', 'errors')}">
                                    <img src="/tlm/response/issueThumbnail/${issueInstance.id}" /> 
                                </td>
                            </tr>
                            
                            <tr class="prop">
                            	<td valign="top" class="name">Replace thumbnail</td>
                            	<td valign="top" class="value" id="thumbnail_input"></td>
                            </tr>
                            
                            <script type="text/javascript">
                            	var inserter = null;
                            	<g:if test="${filecode}">
                            		inserter = createFileInput('replace_thumbnail', '${filename}', '${filecode}'); 
                            	</g:if>                            		
                            	<g:else>
                            		inserter = createFileInput('replace_thumbnail');
                            	</g:else>

                            	inserter(thumbnail_input);
                            </script>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="publication"><g:message code="issue.publication.label" default="Publication" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: issueInstance, field: 'publication', 'errors')}">
                                    <g:select name="publication.id" from="${com.tlm.beans.Publication.list()}" optionKey="id" value="${issueInstance?.publication?.id}"  />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="number"><g:message code="issue.number.label" default="Number" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: issueInstance, field: 'number', 'errors')}">
                                    <g:textField name="number" value="${fieldValue(bean: issueInstance, field: 'number')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="issue.name.label" default="Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: issueInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${issueInstance?.name}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><g:message code="issue.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: issueInstance, field: 'description', 'errors')}">
                                    <g:textField name="description" value="${issueInstance?.description}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="releaseDate"><g:message code="issue.releaseDate.label" default="Release Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: issueInstance, field: 'releaseDate', 'errors')}">
                                    <g:datePicker name="releaseDate" precision="day" value="${issueInstance?.releaseDate}" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                        	<%-- strictly read-only --%>
                        	<tr class="prop">
                            	<td valign="top" class="name"><g:message code="issue.documents.label" default="Documents" /></td>
                            
                            	<td valign="top" style="text-align: left;" class="value">
                                	<ul>
                                	<g:each in="${issueInstance.documents.sort {it.part}}" var="d">
                                    	<li><g:link controller="response" action="download" id="${d.id}">Part ${d.part} (${d.fileName})</g:link></li>
                                	</g:each>
                                	</ul>
                            	</td>
                            
                        	</tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
