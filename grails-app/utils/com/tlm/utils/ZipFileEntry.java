package com.tlm.utils;

import java.io.InputStream;

public class ZipFileEntry {
	
	final String filename;
	final InputStream stream;
	
	public ZipFileEntry(String filename, InputStream stream) {
		this.filename = filename;
		this.stream = stream;
	}

	public String getFilename() {
		return filename;
	}

	public InputStream getStream() {
		return stream;
	}

}
