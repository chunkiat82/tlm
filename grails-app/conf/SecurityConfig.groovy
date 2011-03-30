// Ctrl-Shift-R and open DefaultSecurityConfig.groovy for more
// settings that can be overridden

security {
	
	// enable security
	active = true
	
	/** login user class fields */
	loginUserDomainClass = 'com.tlm.beans.User'
	userName = 'userName'
	password = 'hashPassword'
	enabled = 'enabled' // always set to true in User.groovy (for now)
	relationalAuthorities = 'roles'
	
	/**
	 * Authority domain class and field name
	 */
	authorityDomainClass = 'com.tlm.beans.Role'
	authorityField = 'roleName'
	
	/** passwordEncoder */
	algorithm = 'MD5' // Ex. MD5 SHA
	encodeHashAsBase64 = false
	
	/** use RequestMap from DomainClass */
	useRequestMapDomainClass = true
	
	/** Requestmap domain class (if useRequestMapDomainClass = true) */
	requestMapClass = 'com.tlm.beans.RequestMap'
	requestMapPathField = 'url'
	requestMapConfigAttributeField = 'configAttribute'
	
	// port mappings
	httpPort = 8080
	httpsPort = 8443
	
	/** authenticationProcessingFilter */
	authenticationFailureUrl = '/login/authfail?login_error=1'
	ajaxAuthenticationFailureUrl = '/login/authfail?ajax=true'
	defaultTargetUrl = '/admin'
	alwaysUseDefaultTargetUrl = false
	filterProcessesUrl = '/j_spring_security_check'
	
	/** anonymousProcessingFilter */
	key = 'foo'
	userAttribute = 'anonymousUser,ROLE_ANONYMOUS'
	
	/** authenticationEntryPoint */
	loginFormUrl = '/login/auth'
	forceHttps = 'false'
	ajaxLoginFormUrl = '/login/authAjax'
	
	/** accessDeniedHandler
	 *  set errorPage to null, if you want to get error code 403 (FORBIDDEN).
	 */
	errorPage = '/login/denied'
	ajaxErrorPage = '/login/deniedAjax'
	ajaxHeader = 'X-Requested-With'
	
	/** logoutFilter */
	afterLogoutUrl = '/admin'
	
}