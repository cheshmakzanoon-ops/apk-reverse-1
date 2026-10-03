package com.gme.liteav.base.util;

import com.gme.liteav.base.Log;
import java.text.SimpleDateFormat;
import java.util.Date;

public class TimeFormat {
    public static long fromString(String str, String str2) {
        try {
            Date date = new SimpleDateFormat(str2).parse(str);
            if (date == null) {
                return 0L;
            }
            return date.getTime();
        } catch (Exception e) {
            Log.m949i("TimeFormat", "formString: Date conversion failed.", e);
            return 0L;
        }
    }

    public static String format(long j, String str) {
        try {
            return new SimpleDateFormat(str).format(new Date(j));
        } catch (Exception e) {
            Log.m949i("TimeFormat", "toString: Date conversion failed.", e);
            return "";
        }
    }
}
