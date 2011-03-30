
<%@ page import="com.tlm.beans.Publication" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'publication.label', default: 'Publication')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        <script type="text/javascript" src="${resource(dir:'js/swfupload', file:'swfupload.js')}"></script>
        <style type="text/css">
          .swfupload { float: left }
        </style>
    </head>
    <body>
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
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="nav">
	            <span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Home</a></span>
	            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        	</div>
            <g:hasErrors bean="${publicationInstance}">
            <div class="errors">
                <g:renderErrors bean="${publicationInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="pubId"><g:message code="publication.pubId.label" default="Publication Fixed Id" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: publicationInstance, field: 'pubId', 'errors')}">
                                    <g:textField name="pubId" value="${fieldValue(bean: publicationInstance, field: 'pubId')}" />
                                </td>
                            </tr>
                     
                        
	                        <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="mastHead"><g:message code="publication.mastHead.label" default="Mast Head" /></label>
                                </td>
                                <td valign="top" id="fileUpload">
                                  
                                </td>
                            </tr>
                            
                           
                            <script type="text/javascript">
                              var fileUpload = document.getElementById('fileUpload');

                              <g:if test="${upload}">
                                var inserter = createFileInput("upload.fileName", "${upload.fileName}", "${upload.fileCode}");
                              </g:if>
                              <g:elseif test="${publicationInstance?.mastHead}">
                                var inserter = createFileInput("upload.fileName", "", "");
                              </g:elseif>
                              <g:else>
                                var inserter = createFileInput("upload.fileName");
                              </g:else>
            
            				  inserter(fileUpload);
                            </script>
                            
                             <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="mediaKit"><g:message code="publication.mediaKit.label" default="Media Kit" /></label>
                                </td>
                                <td valign="top" id="fileUploadMK">
                                  
                                </td>
                            </tr>
                            <script type="text/javascript">
                              var fileUploadMK = document.getElementById('fileUploadMK');

                              <g:if test="${uploadMK}">
                                var inserterMK = createFileInput("uploadMK.fileName", "${uploadMK.fileName}", "${uploadMK.fileCode}");
                              </g:if>
                              <g:elseif test="${publicationInstance?.mediaKit}">
                                var inserterMK = createFileInput("uploadMK.fileName", "", "");
                              </g:elseif>
                              <g:else>
                                var inserterMK = createFileInput("uploadMK.fileName");
                              </g:else>
            
            				  inserterMK(fileUploadMK);
                            </script>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="htmlWriteUp"><g:message code="publication.htmlWriteUp.label" default="Html Write Up" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: publicationInstance, field: 'htmlWriteUp', 'errors')}">
                                    <g:textArea name="htmlWriteUp" value="${publicationInstance?.htmlWriteUp}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="editor"><g:message code="publication.editor.label" default="Editor" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: publicationInstance, field: 'editor', 'errors')}">
                                    <g:select name="editor.id" from="${com.tlm.beans.User.getNonSubscribers()}" optionKey="id" value="${publicationInstance?.editor?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="advertiser"><g:message code="publication.advertiser.label" default="Advertiser" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: publicationInstance, field: 'advertiser', 'errors')}">
                                    <g:select name="advertiser.id" from="${com.tlm.beans.User.getNonSubscribers()}" optionKey="id" value="${publicationInstance?.advertiser?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="pubLongName"><g:message code="publication.pubLongName.label" default="Pub Long Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: publicationInstance, field: 'pubLongName', 'errors')}">
                                    <g:textField name="pubLongName" value="${publicationInstance?.pubLongName}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="pubShortName"><g:message code="publication.pubShortName.label" default="Pub Short Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: publicationInstance, field: 'pubShortName', 'errors')}">
                                    <g:textField name="pubShortName" value="${publicationInstance?.pubShortName}" />
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
