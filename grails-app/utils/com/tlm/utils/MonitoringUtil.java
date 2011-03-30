package com.tlm.utils;

import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class MonitoringUtil {
	
	private MonitoringUtil() {};
	
	private static Thread daemon;
	
	private static class MonitoringDaemon implements Runnable {
		
			private DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm");
			private DecimalFormat df = new DecimalFormat("0.00");
			
			public void run() {
				while (true) {
					try {
						Thread.sleep(60000);
					} catch (Exception ex) {
						Thread.currentThread().interrupt();
					}
					
					Runtime runtime = Runtime.getRuntime();
					double used = (runtime.totalMemory() - runtime.freeMemory()) / 1024.0 / 1024.0;
					double total = runtime.totalMemory() / 1024.0 / 1024.0;
					double max = runtime.maxMemory() / 1024.0 / 1024.0;
					System.out.println(formatter.format(new Date()) + ": "+df.format(used)+" MB / "+df.format(total)+" MB (max: "+df.format(max)+" MB)");   
					
					if (Thread.currentThread().isInterrupted()) {
						break;
					}
				}
			}
	}
	
	public static synchronized void startMonitoring() {
		if (daemon == null || !daemon.isAlive()) {
			daemon = new Thread(new MonitoringDaemon());
		};
		
		daemon.start();
	}
	
	public static synchronized void stopMonitoring() {
		if (daemon != null) {
			daemon.interrupt();
		}
	}

}
