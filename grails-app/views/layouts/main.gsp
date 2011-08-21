<html>
    <head>
        <title><g:layoutTitle default="TLM" /></title>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'style', file:'ext-all.css')}" />        
        <link rel="stylesheet" href="${resource(dir:'style',file:'admin2.css')}" />
        <link rel="shortcut icon" href="${resource(dir:'',file:'favicon.ico')}" type="image/x-icon" />
        
        
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
        
        <script type="text/javascript" src="${resource(dir:'js', file:'ext-base.js')}"></script>
        <script type="text/javascript" src="${resource(dir:'js', file:'ext-all-debug.js')}"></script>
        <script type="text/javascript" src="${resource(dir:'js/tiny_mce', file:'tiny_mce.js')}"></script>
        
        <g:layoutHead />
        
    </head>
    <body>
        <div id="spinner" class="spinner" style="display:none;">
            <img src="${resource(dir:'images',file:'spinner.gif')}" alt="Spinner" />
        </div>
        <div class="body">
            <div class="nav">
            	<g:isLoggedIn>
            		<span>Hello <b><g:loggedInUserInfo field="userName"/></b>!</span>
            		<span class="menuButton"><a class="logout" href="${createLink(controller: 'logout')}">Logout</a></span>
            	</g:isLoggedIn>
				<g:isNotLoggedIn>
					<span>
					You are not logged in. 
					<span class="menuButton"><a class="login" href="${createLink(controller: 'login')}">Login</a></span>
					</span>
				</g:isNotLoggedIn>
				<span class="menuButton"><a class="public" href="${createLink(uri: '/')}" target="tlm_public">Public Portal</a>
            </div>
        </div>
        
        <g:layoutBody />
    </body>
</html>