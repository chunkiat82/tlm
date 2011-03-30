package com.tlm.beans;

class Configuration {
	
	static mapping = {
		columns {
			key column:'`key`'
		}
	}
	
	String key
	String value
	String valueType
	String description
	Boolean editable

}