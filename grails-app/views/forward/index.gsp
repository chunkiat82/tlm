<html>
	<head>
		<style type="text/css">
			body {
				font-family: Helvetica, Arial;
				font-size: 12px;
				background-color: white;
			}
			
			div.form {
				margin: auto;
				width: 700px;
			}
			
			h1 {
				font-size: 24pt;
				font-weight: bold;
				margin-bottom: 20px;
			}
			
			h2 {
				font-size: 16pt;				
			}
			
			form label {
				width: 100px;
				display: inline-block;
				text-align: right;
				margin-right: 20px;
			}
			
			form label.readonly {
				width: 200px;
				display: inline-block;
				font-weight: bold;
				text-align: left;				
			}
			
			form input[type='text'] {
				width: 200px;
				display: inline-block;
				text-align: left;
			}
			
			form fieldset {
				width: 700px;
				display: block;
				margin-bottom: 20px;				
			}
			
			form legend {
				font-weight: bold;
				display: block;
			}
			
			form div.row {
				display: block;
				margin-bottom: 10px;
				margin-top: 10px;
			}
			
			form div.row ul {
				list-style: none;
			}
			
			form div.row ul li {
				font-weight: bold;
				color: red;
			}
		</style>
	</head>
	<body>
		<div class="form">
			<h1>Forward to a friend</h1>
			<h2>Subject: ${forwardMail.subject}</h2>
			<g:form method="post">
				<g:hiddenField name="forwardMail.userId" value="${forwardMail?.userId}" />
				<g:hiddenField name="forwardMail.jobId" value="${forwardMail?.jobId}" />
				<g:hiddenField name="forwardMail.subject" value="${forwardMail?.subject}" />
				<g:hiddenField name="forwardMail.senderEmail" value="${forwardMail?.senderEmail}" />
				<fieldset>
					<legend>My details:</legend>
					<div class="row">
						<g:renderErrors bean="${forwardMail}" as="list" field="senderName"/>					
						<label for="forwardMail.senderName">Name:</label><g:textField name="forwardMail.senderName" value="${forwardMail?.senderName}" />
						<label for="forwardMail.senderEmail">Email:</label><label id="forwardMail.senderEmail" class="readonly">${forwardMail?.senderEmail}</label>
					</div>
				</fieldset>
				<fieldset>
					<legend>I want to forward this email to:</legend>
					<div class="row">
						<g:renderErrors bean="${forwardMail}" as="list" field="friend1Email"/>	
						<label for="forwardMail.friend1Name">Name:</label><g:textField name="forwardMail.friend1Name" value="${forwardMail?.friend1Name}" />
						<label for="forwardMail.friend1Email">Email:</label><g:textField name="forwardMail.friend1Email" value="${forwardMail?.friend1Email}" />
					</div>
					<div class="row">
						<g:renderErrors bean="${forwardMail}" as="list" field="friend2Email"/>
						<label for="forwardMail.friend2Name">Name:</label><g:textField name="forwardMail.friend2Name" value="${forwardMail?.friend2Name}" />
						<label for="forwardMail.friend2Email">Email:</label><g:textField name="forwardMail.friend2Email" value="${forwardMail?.friend2Email}" />
					</div>
					<div class="row">
						<g:renderErrors bean="${forwardMail}" as="list" field="friend3Email"/>
						<label for="forwardMail.friend3Name">Name:</label><g:textField name="forwardMail.friend3Name" value="${forwardMail?.friend3Name}" />
						<label for="forwardMail.friend3Email">Email:</label><g:textField name="forwardMail.friend3Email" value="${forwardMail?.friend3Email}" />
					</div>
					<div class="row">
						<g:renderErrors bean="${forwardMail}" as="list" field="friend4Email"/>
						<label for="forwardMail.friend4Name">Name:</label><g:textField name="forwardMail.friend4Name" value="${forwardMail?.friend4Name}" />
						<label for="forwardMail.friend4Email">Email:</label><g:textField name="forwardMail.friend4Email" value="${forwardMail?.friend4Email}" />
					</div>
					<div class="row">
						<g:renderErrors bean="${forwardMail}" as="list" field="friend5Email"/>
						<label for="forwardMail.friend5Name">Name:</label><g:textField name="forwardMail.friend5Name" value="${forwardMail?.friend5Name}" />
						<label for="forwardMail.friend5Email">Email:</label><g:textField name="forwardMail.friend5Email" value="${forwardMail?.friend5Email}" />
					</div>
				</fieldset>
				<g:actionSubmit action="send" value="Send Email" onclick="return confirm('Are you sure you want to forward to the specified e-mail addreses?');" />
			</g:form>
			<hr/>
			<p><b>Privacy Notice:</b> Your friends' e-mail address will only be used to forward this e-mail to them, and will <i>never</i> be available to anyone else.</p>			
		</div>
	</body>
</html>