dataSource {
	pooled = true
	// driverClassName = "org.hsqldb.jdbcDriver"
	// username = "sa"
	// password = ""
		
	driverClassName = "com.mysql.jdbc.Driver"
	username = "tlm"
	password = "tlm"	
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