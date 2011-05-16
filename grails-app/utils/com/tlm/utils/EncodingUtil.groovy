package com.tlm.utils;

class EncodingUtil {
	
	static final constantString = "UnsubscribeFromTLinkM"
		
	static def generator = new Random()
	
	static def generateSalt = {
		// note: because ACEGI security does not support salts at version 0.5.2,
		// the salt is currently "disabled"
		// return (generator.nextInt(10000)+1).toString();
		return ""
	}
	
	/**
	 * The point of this method is to take in an ID, append a constant salt to it
	 * then apply an MD5.  This will generate a unique hash for each different ID
	 * that no one else can generate for a different ID without knowing the
	 * constant.
	 * 
	 * @param id
	 * @return
	 */
	static String generateObfuscatedId(Long id) {
		String salted = "${id}${constantString}"
		String encoded = salted.encodeAsMD5()
		// println "Salted ID is [${salted}], encoded is [${encoded}]"
		
		return encoded
	}
	
	static boolean validateObfuscatedId(String id, String validateAgainst) {
		String expectedSalted = "${id}${constantString}"
		String expectedHash = expectedSalted.encodeAsMD5()
		
		if (!expectedHash.equals(validateAgainst)) {
			println "Expected $expectedHash from ${id}${constantString} but got $validateAgainst instead."
			return false
		}
		
		return true
	}

}
