package com.tlm.utils;

class DateUtil {
	Date date;
	
	static def today()
	{
		def todayDate = Calendar.getInstance()	
		int yearToday=todayDate.get(Calendar.YEAR)
		int monthToday=todayDate.get(Calendar.MONTH)
		int dayToday=todayDate.get(Calendar.DAY_OF_MONTH)
		todayDate.clear()
		todayDate.set(yearToday,monthToday,dayToday,0,0,0)
		return todayDate.getTime()
	}
}
