package com.bjpowernode.crm.base.util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateTimeUtil {
	
	public static String getSysTime(){
		return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
		
	}
	
}
