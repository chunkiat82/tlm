package com.soho.hibernate;

import org.hibernate.dialect.MySQL5InnoDBDialect;

/**
 * I can't believe I have to do this.
 * 
 * @author masotime
 */
public class CustomMySQLDialect extends MySQL5InnoDBDialect {
	
	public CustomMySQLDialect() {
	      super();	      
	      registerKeyword("interval");
	      registerKeyword("minute");	      
	}
}
