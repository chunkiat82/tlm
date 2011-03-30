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