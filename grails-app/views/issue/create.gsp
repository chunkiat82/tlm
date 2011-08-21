<%@page import="com.tlm.beans.Issue"%>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="layout" content="main" />
  <g:set var="entityName" value="${message(code: 'issue.label', default: 'Issue')}" />
  <script type="text/javascript" src="${resource(dir:'js/swfupload', file:'swfupload.js')}"></script>
  <title>
    <g:message code="default.create.label" args="[entityName]" />
  </title>
  <style type="text/css">
    .swfupload {
	  float: left ;
    } 
  </style>
</head>
<body>
	<div class="body">
		<h1>
			<g:message code="default.create.label" args="[entityName]" />
		</h1>
		<g:if test="${flash.message}">
			<div class="message">
				${flash.message}
			</div>
		</g:if>
		<g:hasErrors bean="${issueInstance}">
			<div class="errors">
				<g:renderErrors bean="${issueInstance}" as="list" />
			</div>
		</g:hasErrors>
		<div class="nav">
			<span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a>
			</span> <span class="menuButton"><g:link class="list" action="list">
					<g:message code="default.list.label" args="[entityName]" />
				</g:link>
			</span>
		</div>
		<g:form action="save" method="post" enctype="multipart/form-data">
			<div class="dialog">
				<table>
					<tbody>

						<tr class="prop">
							<td valign="top" class="name"><label for="publication"><g:message code="issue.publication.label" default="Publication" />
							</label></td>
							<td valign="top" class="value ${hasErrors(bean: issueInstance, field: 'publication', 'errors')}"><g:select name="publication.id" from="${com.tlm.beans.Publication.list()}" optionKey="id"
									value="${issueInstance?.publication?.id}" /></td>
						</tr>

						<tr class="prop">
							<td valign="top" class="name"><label for="number"><g:message code="issue.number.label" default="Number" />
							</label></td>
							<td valign="top" class="value ${hasErrors(bean: issueInstance, field: 'number', 'errors')}"><g:textField name="number" value="${fieldValue(bean: issueInstance, field: 'number')}" /></td>
						</tr>

						<tr class="prop">
							<td valign="top" class="name"><label for="name"><g:message code="issue.name.label" default="Name" />
							</label></td>
							<td valign="top" class="value ${hasErrors(bean: issueInstance, field: 'name', 'errors')}"><g:textField name="name" value="${issueInstance?.name}" /></td>
						</tr>

						<tr class="prop">
							<td valign="top" class="name"><label for="description"><g:message code="issue.description.label" default="Description" />
							</label></td>
							<td valign="top" class="value ${hasErrors(bean: issueInstance, field: 'description', 'errors')}"><g:textField name="description" value="${issueInstance?.description}" /></td>
						</tr>

						<tr class="prop">
							<td valign="top" class="name"><label for="releaseDate"><g:message code="issue.releaseDate.label" default="Release Date" />
							</label></td>
							<td valign="top" class="value ${hasErrors(bean: issueInstance, field: 'releaseDate', 'errors')}"><g:datePicker name="releaseDate" precision="day" value="${issueInstance?.releaseDate}"
									noSelection="['': '']" /></td>
						</tr>

					</tbody>
				</table>

				<table id="fileUploadTable" border="0">
					<tr>
						<th class="name">Part #</th>
						<th class="name">Name</th>
						<th class="name">Description</th>
						<th class="name">PDF File</th>
						<th class="name">&nbsp;</th>
					</tr>
				</table>

				<script type="text/javascript">

                      String.prototype.trim = function() {
                        try {
                            return this.replace(/^\s+|\s+$/g, "");
                        } catch(e) {
                            return this;
                        }
                      }
                                        

                      function getTable() {
                          return document.getElementById("fileUploadTable");
                      }

                      function createActionAnchor(href, onclickFunction) {
                          var anchor = document.createElement("A");
                          anchor.style.padding = "4px";
                          anchor.href = href;
                          anchor.onclick = onclickFunction;
                          return anchor; 
                      }

                      function createImg(src) {
                          var img = document.createElement("IMG");
                          img.src = src;
                          return img;
                      }

                      function createInput(type, name, data) {
                          var input = document.createElement("INPUT");
                          input.type = type;
                          input.name = name;
                          if (data) {
                              input.value = data;
                          }
                          input.className = "value";

                          return input;
                      }

                      var pineapple;

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

                      function getDeleteRowFunction(row) {
                          return function() {
                              deleteRow(row);
                              return false;
                          }
                      }

                      function getMoveUpFunction(row) {
                          return function() {                              
                              swapRows(row, row-1);
                              return false;
                          }
                      }

                      function getMoveDownFunction(row) {
                          return function() {                        	  
                              swapRows(row, row+1);
                              return false;
                          }
                      }

                      function getName(rowIdx) {
                          return getTable().rows[rowIdx].cells[1].children[0].value;                          
                      }

                      function getDescription(rowIdx) {
                          return getTable().rows[rowIdx].cells[2].children[0].value;                          
                      }
                      
                      function getFile(rowIdx) {
                          return getTable().rows[rowIdx].cells[3].children[0].children[0].value;                          
                      }

                      function validate() {
                          var table = getTable();

                          var errMsgs = "";

                          for (var row = 1; row < table.rows.length; row++)
                          {
                              if (getName(row).trim() == "") {
                                  errMsgs += "Part " + row + " : Name is required\n";
                              }

                              if (getDescription(row).trim() == "") {
                                  errMsgs += "Part " + row + " : Description is required\n";
                              }

                              if (getFile(row).trim() == "") {
                                  errMsgs += "Part " + row + " : File is required\n";
                              }
                          }

                          if (errMsgs != "") {
                              alert (errMsgs);
                          }                              

                          return errMsgs == "";
                          
                      }                                             

                      function setParts() {
                          var table = getTable();
                          for (var row = 1; row < table.rows.length; row++)
                          {
                              table.rows[row].cells[0].innerHTML = row;
                              table.rows[row].cells[4].innerHTML = "";

                              // up link if it is not the first row in the table
                              if (row != 1) {
                                  var upAnchor = createActionAnchor("#", getMoveUpFunction(row));
                                  var upImg = createImg("${resource(dir:'images/webicons', file:'Up.png')}");
                                  upAnchor.appendChild(upImg);
                                  table.rows[row].cells[0].appendChild(upAnchor);
                              }

                              // down link if it is not the last row in the table
                              if (row != table.rows.length - 1) {
                                  var downAnchor = createActionAnchor("#", getMoveDownFunction(row));
                                  var downImg = createImg("${resource(dir:'images/webicons', file:'Down.png')}");
                                  downAnchor.appendChild(downImg);
                                  table.rows[row].cells[0].appendChild(downAnchor);
                              }                              

                              // delete link if it is not the only row in the table
                              if (!(row == 1 && table.rows.length == 2)) {
                            	  var deleteAnchor = createActionAnchor("#", getDeleteRowFunction(row));
                            	  var deleteImg = createImg("${resource(dir:'images/webicons', file:'Delete.png')}");                            	  
                            	  deleteAnchor.appendChild(deleteImg);
                            	  table.rows[row].cells[4].appendChild(deleteAnchor);
                              }

                              // add link for the last row in the table
                              if (row == table.rows.length - 1) {
                                  var appendAnchor = createActionAnchor("#", function() { appendRow(); return false; });
                                  var appendImg = createImg("${resource(dir:'images/webicons', file:'Add.png')}");
                                  appendAnchor.appendChild(appendImg);
                                  table.rows[row].cells[4].appendChild(appendAnchor);
                              }


                              
                          }
                      }

                      function deleteRow(rowIdx) {
                          var table = getTable();
                          table.deleteRow(rowIdx);
                          setParts();
                      }

                      function swapRows(Idx1, Idx2) {

                    	  // Idx1 must be less than Idx2 (using this algorithm)
                          if (Idx1 > Idx2) {
                              var tmp = Idx1;
                              Idx1 = Idx2;
                              Idx2 = tmp;
                          }
                          
                          var table = getTable();
                          var tbody = table.tBodies[0];
                          var row1 = table.rows[Idx1];
                          var row2 = table.rows[Idx2];

                          var tmpNode = tbody.replaceChild(row1, row2);
                          if (typeof(row1) != "undefined") {
                              tbody.insertBefore(tmpNode, row1);
                          } else {
                              tbody.appendChild(tmpNode);
                          }
                          setParts();
                      }                      

                      function appendRow(name, description, filename, filecode) {

                          if (!validate()) return;

                          var table = getTable();
                          var row = table.insertRow(-1);
                          row.className = "prop";

                          row.insertCell(-1).style.width="70px";
                          row.insertCell(-1).appendChild(createInput("text", "documents.name", name));
                          row.insertCell(-1).appendChild(createInput("text", "documents.description", description));
                          // row.insertCell(-1).appendChild(createInput("file", "document.file"));
                          var fileUploadInserter = createFileInput("documents.fileName", filename, filecode);
                          fileUploadInserter(row.insertCell(-1));//.appendChild(createFileInput("document.file"));
                          row.insertCell(-1).style.width="70px";

                          setParts();
                          
                      }

                      function validateIssue() {
                          return validate();
                      }

                      <g:if test="${documents}">
                        <g:each in="${documents}">
                          appendRow("${it.name?.encodeAsHTML()}","${it.description?.encodeAsHTML()}","${it.fileName?.encodeAsHTML()}","${it.code?.encodeAsHTML()}");
                        </g:each>
                      </g:if>
                      <g:else>
                        appendRow();
                      </g:else>

                    </script>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" onclick="return validateIssue()" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
