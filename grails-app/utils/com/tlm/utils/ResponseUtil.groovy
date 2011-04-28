package com.tlm.utils;

import java.io.File;
import java.sql.Blob
import java.util.Map;
import com.tlm.beans.*;

class ResponseUtil {
	
    static Map<String, File> fileMap = [:]
	
	static def renderImageBlob(response, Blob image, String hash) {
		
		// transform the hash to a safe "filename"
		hash = "${hash.encodeAsURL()}"
		
		response.contentType = "image"
		
		// [010910] Ben: Caching mechanism.  Calling funcion will pass
		// in a "hash" string, which represents the file in some way.
		// Typical hash might be the filename, or some table name + id + date.
		//
		// The existence of the hash will determine whether or not this function
		// should load a cached copy.		

		boolean hashInCache = fileMap.containsKey(hash)
		boolean fileExists = hashInCache && ((File) fileMap.get(hash)).exists()
		
		// if the hash is not in the cache, or the file that's supposed to be in the cache doesn't exist
		if (!hashInCache || !fileExists) {
			println "Creating cache image using hash ${hash}"
						
			// create the file and register it into the cache
			File currentDir = new File(System.getProperty("java.io.tmpdir"))
			File cachedFile = new File(currentDir, hash+".cachedimage");
			
			if (cachedFile.exists()) {
				cachedFile.delete();
			}
			
			FileOutputStream fos = new FileOutputStream(cachedFile);
			fos << image?.binaryStream;
			
			fileMap.put(hash, cachedFile);
		}
		
		// after this point, the file is most definitely in the cache
		File cachedFile = fileMap.get(hash)
		//println "Loading image from cache (path = ${cachedFile.absolutePath})"
		
		FileInputStream fis = new FileInputStream(fileMap.get(hash))
		response.outputStream << fis
		response.outputStream.flush()
		fis.close();			
	}
	
	/**
	 * [280411] Ben: Adapted for PDF Files
	 *  
	 * @param response HttpResponse
	 * @param fileName Name of PDF file as seen by user
	 * @param pdfFile Blob for the PDF file in question
	 * @param hash hash representing a time-sensitive identifier for the cached file
	 * @return
	 */
	static def renderPDFBlob(response, String fileName, Blob pdfFile, String hash) {
		// transform the hash to a safe "filename"
		hash = "${hash.encodeAsURL()}"
		
		def fileNameReplaced = fileName.replace(" ","_");
		response.setHeader("Content-disposition", "attachment; filename=${fileNameReplaced}.pdf")
		response.contentType = "application/pdf"		
		
		// [010910] Ben: Caching mechanism.  Calling funcion will pass
		// in a "hash" string, which represents the file in some way.
		// Typical hash might be the filename, or some table name + id + date.
		//
		// The existence of the hash will determine whether or not this function
		// should load a cached copy.

		boolean hashInCache = fileMap.containsKey(hash)
		boolean fileExists = hashInCache && ((File) fileMap.get(hash)).exists()
		
		// if the hash is not in the cache, or the file that's supposed to be in the cache doesn't exist
		if (!hashInCache || !fileExists) {
			println "Creating cache PDF using hash ${hash}"
						
			// create the file and register it into the cache
			File currentDir = new File(System.getProperty("java.io.tmpdir"))
			File cachedFile = new File(currentDir, hash+".cachedpdf"); // Note that this is "cachedpdf"
			
			if (cachedFile.exists()) {
				cachedFile.delete();
			}
			
			FileOutputStream fos = new FileOutputStream(cachedFile);
			fos << pdfFile?.binaryStream;
			
			fileMap.put(hash, cachedFile);
		} else {
			println "Using cached PDF file located via hash ${hash}"
		}
		
		// after this point, the file is most definitely in the cache
		File cachedFile = fileMap.get(hash)
		//println "Loading image from cache (path = ${cachedFile.absolutePath})"
		
		FileInputStream fis = new FileInputStream(fileMap.get(hash))
		response.contentLength = cachedFile.length()
		try {
			response.outputStream << fis
			response.outputStream.flush()
		} catch(Exception e) {
			println "Download of cached PDF file ${fileNameReplaced}.pdf failed"
			e.printStackTrace()
		} finally {
			fis.close();
		}

	}
	
//	static def renderPDF(response, Document doc) {
//		
//		response.contentType = "pdf"		
//		//response.setHeader("Content-disposition", "filename=${file.getName()}")
//		response.setHeader("Content-disposition", "filename="+doc.fileName)
//		response.outputStream << doc.fileData?.binaryStream
//		response.outputStream.flush()
//	}
//	static def renderPDF(response, Blob input, String fileName) {
//		
//		response.contentType = "pdf"				
//		response.setHeader("Content-disposition", "filename=${fileName}.pdf")
//		response.outputStream << input.binaryStream
//		response.outputStream.flush()
//	}

}
