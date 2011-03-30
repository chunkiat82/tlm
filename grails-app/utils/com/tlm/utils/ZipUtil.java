package com.tlm.utils;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class ZipUtil {
	
	private static final int BUFFER_SIZE = 10240;
	private ZipUtil() {};
	
	public static void writeZipStream(OutputStream os, List<ZipFileEntry> entries) throws IOException {
		
		ZipOutputStream output = new ZipOutputStream(os);
		
		byte[] buffer = new byte[BUFFER_SIZE]; // read in 10k portions
		
		for (ZipFileEntry zfe : entries) {
			ZipEntry entry = new ZipEntry(zfe.filename);
			entry.setMethod(ZipEntry.DEFLATED);
			
			output.putNextEntry(entry);
			
			// transfer in sizes of 10k
			int bytesRead;			
			while ((bytesRead = zfe.stream.read(buffer)) != -1) {
				output.write(buffer,0,bytesRead);
			}
			
		}
		
		output.close();
		
	}

}
