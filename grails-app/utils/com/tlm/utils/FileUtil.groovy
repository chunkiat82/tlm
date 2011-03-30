package com.tlm.utils;

import java.sql.Blob 
import java.io.FileInputStream;

import javax.activation.MimetypesFileTypeMap 
import org.springframework.web.multipart.MultipartFile 
import org.hibernate.Hibernate

import sun.util.logging.resources.logging;
import groovy.time.TimeCategory

class FileUtil {
	
	/**
	 * This map will contain a persistent mapping of a code to an actual file on the
	 * file system.  File uploads will contain the code, and controllers can use the
	 * getFile method to retrieve the actual file itself from the server temporary
	 * directory.
	 *  
	 */
	static Map<String, File> fileMap = [:]
	
	/**
	 * called as putFile(request.getFile("....")) { fileName, fileBlob -> ...}
	 * The closure must define 2 parameters, and the parameters should be used (or unused)
	 * to set the filename and blob data.
	 * @param file
	 * @param closure
	 * @return
	 */
	static def putFile(MultipartFile file, Closure closure) {
		
		def uploadedData = file.inputStream
		def fileName = file.originalFilename
		
		// tidy up the file name
		def slashIndex = Math.max(fileName.lastIndexOf("/"),fileName.lastIndexOf("\\"))
		if(slashIndex > -1) fileName = fileName.substring(slashIndex + 1) 
		
		closure.call(fileName, Hibernate.createBlob(uploadedData))
		
	}
	
	static def saveFile(MultipartFile file) {
		
		// do a cleanup on expired files
		cleanupFiles()
		
		def uploadedData = file.inputStream
		def fileName = file.originalFilename
		
		// tidy up the file name
		def slashIndex = Math.max(fileName.lastIndexOf("/"),fileName.lastIndexOf("\\"))
		if(slashIndex > -1) fileName = fileName.substring(slashIndex + 1)

		// "overwrite" file if necessary
		removeFile(fileName)
		
		// figure out a suitable temp file name
		File temp = File.createTempFile("upload_", ".file")
		
		// dump the inputstream into the temp file
	    temp.append(uploadedData)
		
		// add it to the map
		fileMap.put(temp.name, temp)
		
		System.out.println "Uploaded ${fileName} to ${temp.absolutePath}"
		
		return temp.name
		
	}
	
	static def getFile(String code) {
		return fileMap.get(code)
	}
	
	static def removeFile(String code) {
		File fileObj = fileMap.get(code)
		if (fileObj) {
			fileObj.delete()
			fileMap.remove(code)
			println "Removed temp file ${fileObj.absolutePath}"
		}
	}
	
	static def removeFile(File file) {
		file.delete()		
	}
	
	// remove all files that are older than 30 minutes
	static def cleanupFiles() {
		File currentDir = new File(System.getProperty("java.io.tmpdir"))
		def now = new Date()
		def thirtyMinutesAgo
		use(TimeCategory) {
		  thirtyMinutesAgo = now - 30.minutes
		}		 
		currentDir.eachFile { File it ->
			def dateModified = new Date(it.lastModified())			
			if (dateModified.before(thirtyMinutesAgo) && it.name.startsWith("upload_") && it.name.endsWith(".file")) {
				removeFile(it)
				println "Removed expired file ${it.name}"
			}
		}
	}
	
	static def getFileBlob(String code) {
		return Hibernate.createBlob(new FileInputStream(fileMap.get(code)))
	}
	
	static def getFileMimeType(String fileName) {
		return MimetypesFileTypeMap.defaultFileTypeMap.getContentType(fileName)
	}
	
	/**
	 * Streams a file to the HTTP response.  The closure must return a Hibernate blob object
	 * from which a binary stream is obtained to render to the HTTP response.
	 * 
	 * @param response
	 * @param fileName The name of the file which the user will see.
	 * @param closure A closure which returns a java.sql.Blob
	 * @return
	 */
	static def renderFile(def response, String fileName, Blob fileData) {
		  def fileNameReplaced = fileName.replace(" ","_");
          response.setHeader("Content-disposition", "attachment; filename=${fileNameReplaced}.pdf")
		  try{
	          // MimetypesFileTypeMap attempts to guess the Mime Type based on the file name.
	          response.contentType = new MimetypesFileTypeMap().getContentType(fileName)
	          response.outputStream << fileData?.getBinaryStream()
			  response.contentLength = fileData?.length()		  
			  response.outputStream.flush()
		 }catch (Exception e){
		 	println "Download of file ${fileNameReplaced}.pdf failed"
		 	e.printStackTrace()
		 }
	}
	static def renderFilePDF(def response, String fileName, Blob fileData) {
		def fileNameReplaced = fileName.replace(" ","_");
		try{
			response.setHeader("Content-disposition", "attachment; filename=${fileNameReplaced}.pdf")
			response.contentType = "application/pdf"
			response.contentLength = fileData?.length()
			response.outputStream << fileData?.getBinaryStream()
			response.outputStream.flush()
		} catch (Exception e){
			println "Download of file ${fileNameReplaced}.pdf failed"
			e.printStackTrace()
		}
	
	}
	
	static def renderImage(def response, InputStream imageData) {
		try{
			response.contentType = "image"		
			response.outputStream << imageData
			response.outputStream.flush()		
		}catch (Exception e){
			println "Download of image failed"
			e.printStackTrace()
		}
	}
}
