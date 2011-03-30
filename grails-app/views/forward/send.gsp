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
			<h1>Successfully forwarded!</h1>
			<h2>The e-mail on "${forwardMail.subject}" has been successfully forwarded to your friends:</h2>
			<ul>
				<g:if test="${forwardMail.friend1Email}">
					<li>${forwardMail.friend1Email} (${forwardMail.friend1Name})</li>
				</g:if>
				<g:if test="${forwardMail.friend2Email}">
					<li>${forwardMail.friend2Email} (${forwardMail.friend2Name})</li>
				</g:if>
				<g:if test="${forwardMail.friend3Email}">
					<li>${forwardMail.friend3Email} (${forwardMail.friend3Name})</li>
				</g:if>
				<g:if test="${forwardMail.friend4Email}">
					<li>${forwardMail.friend4Email} (${forwardMail.friend4Name})</li>
				</g:if>
				<g:if test="${forwardMail.friend5Email}">
					<li>${forwardMail.friend5Email} (${forwardMail.friend5Name})</li>
				</g:if>				
			</ul>
			Click <a href="/tlm">here</a> to go back to the Trade Link Media website, or if you wish to, you can <a href="/tlm/forward/user/${forwardMail.userId}/job/${forwardMail.jobId}/">forward</a> to more of your friends.
			
		</div>
	</body>
</html>