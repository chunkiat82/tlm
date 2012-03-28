def logDirectory = '.'
grails.converters.default.circular.reference.behaviour = "INSERT_NULL"
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [ html: ['text/html','application/xhtml+xml'],
                      xml: ['text/xml', 'application/xml'],
                      text: 'text/plain',
                      js: 'text/javascript',
                      rss: 'application/rss+xml',
                      atom: 'application/atom+xml',
                      css: 'text/css',
                      csv: 'text/csv',
                      excel: 'application/vnd.ms-excel',
                      pdf: 'application/pdf',
                      ods: 'application/vnd.oasis.opendocument.spreadsheet',
                      all: '*/*',
                      json: ['application/json','text/json'],
                      form: 'application/x-www-form-urlencoded',
                      multipartForm: 'multipart/form-data'
                    ]
// The default codec used to encode data with ${}
grails.views.default.codec="none" // none, html, base64
grails.views.gsp.encoding="UTF-8"
grails.converters.encoding="UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder=false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// whether to install the java.util.logging bridge for sl4j. Disable fo AppEngine!
grails.logging.jul.usebridge = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []
grails.converters.json.date = 'javascript'
grails.war.destFile = "tlm.war"
// set per-environment serverURL stem for creating absolute links
environments {
    production {
		logDirectory ="/usr/share/tomcat5/logs"
        grails.serverURL = "http://www.tradelinkmedia.biz/tlm"
    }
	staging {
		grails.serverURL = "http://masotime.dyndns.org/${appName}"
	}
    development {
        grails.serverURL = "http://localhost:9090/${appName}"
    }
    test {
        grails.serverURL = "http://localhost:9090/${appName}"
    }

}

// log4j configuration
log4j = {
	appenders {
		console name:'stdout'
		rollingFile  name:'file', file: logDirectory + '/app.log', threshold: org.apache.log4j.Level.INFO, maxFileSize:"1MB", maxBackupIndex: 10, 'append':true    
	}
    error  'org.codehaus.groovy.grails.web.servlet',  //  controllers
		   'org.codehaus.groovy.grails.web.pages', //  GSP
		   'org.codehaus.groovy.grails.web.sitemesh', //  layouts
		   'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
		   'org.codehaus.groovy.grails.web.mapping', // URL mapping
		   'org.codehaus.groovy.grails.commons', // core / classloading
		   'org.codehaus.groovy.grails.plugins', // plugins
		   'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
		   'org.springframework',
		   'org.hibernate',
		   'net.sf.ehcache.hibernate'

    warn   'org.mortbay.log' /**/
	
	root {
		info 'stdout', 'file'
		additivity = true
	}
}

/*grails {
	mail {
		host = "127.0.0.1"
		port = 25
		username = ""
		password = ""
		props = ["mail.smtp.auth":"", 					   
				"mail.smtp.socketFactory.port":"25",
			//	"mail.smtp.socketFactory.class":"javax.net.ssl.SSLSocketFactory", 
				"mail.smtp.socketFactory.fallback":"false"]		
	}
}*/

grails {
	mail {
		host = "soho.sg"
		port = 465
		username = "tlm@soho.sg"
		password = "1q2w3e4r"
		props = ["mail.smtp.auth":"true", 					   
				"mail.smtp.socketFactory.port":"465",
				"mail.smtp.socketFactory.class":"javax.net.ssl.SSLSocketFactory",
				"mail.smtp.socketFactory.fallback":"false"]		
	}
}

/*
grails {
	mail {
		host = "smtp.gmail.com"
		port = 465
		username = "trade.link.media.development@gmail.com"
		password = "pineappletarts"
		props = ["mail.smtp.auth":"true", 					   
				"mail.smtp.socketFactory.port":"465",
				"mail.smtp.socketFactory.class":"javax.net.ssl.SSLSocketFactory",
				"mail.smtp.socketFactory.fallback":"false"]
	}
}
*/
grails.validateable.classes = [com.tlm.utils.ForwardMail]
