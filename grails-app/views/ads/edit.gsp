
<%@ page import="com.tlm.beans.Ads" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'ads.label', default: 'Ads')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
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
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${adsInstance}">
            <div class="errors">
                <g:renderErrors bean="${adsInstance}" as="list" />
            </div>
            </g:hasErrors>
	        <div class="nav">
    	        <span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
        	    <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            	<span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        	</div>
            <g:form method="post" >
                <g:hiddenField name="id" value="${adsInstance?.id}" />
                <g:hiddenField name="version" value="${adsInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="ads.name.label" default="Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: adsInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${adsInstance?.name}" />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="url"><g:message code="ads.url.label" default="Url" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: adsInstance, field: 'url', 'errors')}">
                                    <g:textField name="url" value="${adsInstance?.url}" />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="rank"><g:message code="ads.rank.label" default="Rank" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: adsInstance, field: 'rank', 'errors')}">
                                   <g:radioGroup name="rank" values="[2,1,3]" labels="['All', 'Events','Sponsors']" value="${adsInstance?.rank}" >
										<span>${it.label} ${it.radio}</span>
									</g:radioGroup> 
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="releaseDate"><g:message code="ads.releaseDate.label" default="Release Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: adsInstance, field: 'releaseDate', 'errors')}">
                                    <g:datePicker name="releaseDate" precision="day" value="${adsInstance?.releaseDate}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="expireDate"><g:message code="ads.expireDate.label" default="Expire Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: adsInstance, field: 'expireDate', 'errors')}">
                                    <g:datePicker name="expireDate" precision="day" value="${adsInstance?.expireDate}"  />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    File
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: adsInstance, field: 'fileName', 'errors')}" id="fileUpload" >
                                    
                                </td>
                            </tr>    
                            
                            <script type="text/javascript">
                              var fileUpload = document.getElementById('fileUpload');

                              <g:if test="${upload}">
                                var inserter = createFileInput("upload.fileName", "${upload.fileName}", "${upload.fileCode}");
                              </g:if>
                              <g:elseif test="${adsInstance?.fileName}">
                                var inserter = createFileInput("upload.fileName", "${adsInstance.fileName}", "");
                              </g:elseif>
                              <g:else>
                                var inserter = createFileInput("upload.fileName");
                              </g:else>
            
            				  inserter(fileUpload);
                            </script>
                            
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
