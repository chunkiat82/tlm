dataSource {
	pooled = true
	driverClassName = "com.mysql.jdbc.Driver"
	username = "root"
	password = "password"
	dialect = "com.soho.hibernate.CustomMySQLDialect" // [20101212] Ben: sian...
	
	// [261010] Ben: I swear I will give Graeme Rocher one tight slap
	// if I meet him for not making pooling configuration a default in
	// Grails projects.  Who the f*** creates a web / database application
	// without using connection pooling???
	//
	// ref: http://www.grails.org/doc/latest/guide/3.%20Configuration.html#3.3 The DataSource
	// under "Advanced Properties"
	properties {
		/* why are these not here by default? */
		testOnBorrow = true
		testOnReturn = true
		testWhileIdle = true
		validationQuery = "SELECT 1"
	
		// These really should have defaults based on
		// http://people.apache.org/~fhanik/tomcat/jdbc-pool.html
		// but I'm putting them here anyway.
		minEvictableIdleTimeMillis = 60000
		timeBetweenEvictionRunsMillis = 60000
		maxWait = 10000
		
		/* WARNING: The below might cause super-long SQL statements to fail */
		removeAbandoned = true
		removeAbandonedTimeout = 60 // 60 seconds for longest running statement
		logAbandoned = true
	
	}
	
	
}
hibernate {
    cache.use_second_level_cache=true
    cache.use_query_cache=true
    cache.provider_class='net.sf.ehcache.hibernate.EhCacheProvider'
}
// environment specific settings
environments {
	development {
		dataSource {
			dbCreate = "update" // one of 'create', 'create-drop','update'
			// url = "jdbc:hsqldb:mem:devDB"
			url = "jdbc:mysql://localhost:3306/tlm"
			username = "root"
			password = "password"
		}
	}
	staging {
		dataSource {
			dbCreate = "create-drop" // one of 'create', 'create-drop','update'
			// url = "jdbc:hsqldb:mem:devDB"
			url = "jdbc:mysql://localhost:3306/tlm"
			username = "root"
			password = "password"
		}
	}
	test {
		dataSource {
			dbCreate = "update"
			url = "jdbc:hsqldb:mem:testDb"
		}
	}
	production {
		dataSource {
			pooled = true
			dbCreate = "update"
			url = "jdbc:mysql://localhost:3306/tlm"
			username = "tlm_admin"
			password = "1q2w3e4r"
		}
	}
}