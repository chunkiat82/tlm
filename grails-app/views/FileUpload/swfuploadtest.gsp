<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <style type="text/css">
          div.console {
           border: 1px solid black;
           height: 100px;
            overflow: scroll;
            font-family: Courier;
           font-size: 8pt;      
           }
        </style>
        <script type="text/javascript" src="${resource(dir:'js/swfupload', file:'swfupload.js')}"></script>
        <script type="text/javascript">
          var swfu;

          window.onload = function () {

              var uploadProgress = new Ext.ProgressBar({
                  text:'Ready',
                  id:'progressBar',
                  cls:'left-align',
                  renderTo:'uploadProgress'
                });              
              
              var settings = {
                      upload_url : "/tlm/fileUpload/swfupload",
                      flash_url : "${resource(dir:'swf', file:'swfupload.swf')}",
                      file_size_limit : "200 MB",
                      button_placeholder_id : "button",
                      button_image_url: "${resource(dir:'images/webicons', file:'Upload.png')}",
                      button_width: 24,
                      button_height: 24,
                      upload_progress_handler : function(file, bytesComplete, bytesTotal) {
                          var progressSpan = document.getElementById("progress");
                          progressSpan.innerHTML = bytesComplete + " of " + bytesTotal + " uploaded!";
                          var percentage = bytesComplete / bytesTotal;
                          uploadProgress.updateProgress(percentage, (percentage * 100) + "%");  
                      },
                      upload_start_handler : function (file) {
                          var progressSpan = document.getElementById("progress");
                          progressSpan.innerHTML = "File Upload started.";
                          uploadProgress.updateProgress(0,"File upload started.");
                          return true;
                      },
                      upload_success_handler: function(file, serverData, receivedResponse) {
                          var progressSpan = document.getElementById("progress");
                          progressSpan.innerHTML = "Upload complete.  Server data = " + serverData + ", received response = " + receivedResponse;
                          uploadProgress.updateProgress(1.0, "Upload complete!");
                      },
                      file_dialog_complete_handler: function(selected, queued, total) {
                          var progressSpan = document.getElementById("progress");
                          progressSpan.innerHTML = "Selected " + selected +", queued "+queued+", total "+total;
                          this.startUpload();
                      },
                      upload_error_handler: function(file, code, message) {
                          progressSpan.innerHTML = "Error occurred with message " + message;
                      },
                      file_queue_error_handler: function(file, code, message) {
                          alert(message);
                          progressSpan.innerHTML = "Error occurred with message " + message;
                      },
                      debug: true,
                      debug_handler: function(message) {
                          var debugPanel = document.getElementById("debugPanel");
                          debugPanel.innerHTML += "<p>"+message+"</p>";
                      }
              
              };

              swfu = new SWFUpload(settings);
         
          }
        </script>
        <title>SWFUpload test page</title>
        <p>Upload progress = <div style="width: 200px" id="uploadProgress"></div></p>
        <p><div class="console" id="progress"></div></p>
        <p>Debug = <div id="debugPanel" class="console"></div></p>
        
        <p>Download button below:<div id="button"></div></p>
        <p></p>
    </head>
    <body>    
    </body>
</html>
   