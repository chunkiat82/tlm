package com.tlm.utils;

import org.hibernate.Hibernate;

import java.nio.channels.FileChannel;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletResponse 

import org.hibernate.Hibernate;
import org.icepdf.core.pobjects.Document 
import org.icepdf.core.pobjects.Page;
import org.icepdf.core.util.GraphicsRenderingHints;
import com.sun.pdfview.*
import java.awt.image.*
import java.awt.*
import com.sun.image.codec.jpeg.JPEGImageEncoder
import com.sun.image.codec.jpeg.JPEGCodec

class ThumbnailUtil {
	
	static def makeThumbnail(PDFFile pdfFile) {
		
		// draw the first page to an image
		PDFPage page = pdfFile.getPage(0)
		int width = (int) (page.getBBox().getWidth() / 4)
		int height = (int) (page.getBBox().getHeight() / 4)
		
		// create and configure a graphics object
		BufferedImage img = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB)
		Graphics2D g2 = img.createGraphics()
		g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
		
		// do the actual drawing
		Rectangle rect = new Rectangle(0, 0, width, height)
		PDFRenderer renderer = new PDFRenderer(page, g2, rect, null, Color.WHITE)
		page.waitForFinish()
		renderer.run()
		
		// encode the response and return a Blob
		ByteArrayOutputStream baos = new ByteArrayOutputStream()
		JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(baos)
		encoder.encode(img);
		
		return Hibernate.createBlob(baos.toByteArray())
	}
	
	static def generateThumbnailBlob(File pdf) {
		
		FileInputStream fis = new FileInputStream(pdf);
		byte[] fileData = new byte[pdf.length()];
		fis.read(fileData);
		
		Document document = new Document();
		document.setByteArray(fileData, 0, fileData.length, "transient");
		
		float scale = 0.5f;
		float rotation = 0f;

		BufferedImage image = (BufferedImage) document.getPageImage(0, GraphicsRenderingHints.PRINT, Page.BOUNDARY_CROPBOX, rotation, scale);
		RenderedImage rendImage = image;

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ImageIO.write(rendImage, "jpg", baos);
		image.flush();
		
		return Hibernate.createBlob(baos.toByteArray())

	}
	
	static def renderThumbnailResponse(byte[] pdfData, HttpServletResponse response) {
		
		Document document = new Document();
		document.setByteArray(pdfData, 0, pdfData.length, "transient");
		
		float scale = 1.0f;
		float rotation = 0f;
		
		BufferedImage image = (BufferedImage) document.getPageImage(0, GraphicsRenderingHints.PRINT, Page.BOUNDARY_CROPBOX, rotation, scale);
		RenderedImage rendImage = image;
		
		// output to response
		ImageIO.write(rendImage, "jpg", response.outputStream);
		response.flushBuffer()
		
	}

}
