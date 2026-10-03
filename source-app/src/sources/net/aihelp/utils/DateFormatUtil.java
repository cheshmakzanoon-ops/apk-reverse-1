package net.aihelp.utils;

import android.content.res.Resources;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class DateFormatUtil {
    private static long[] goBackNDays(int i, long j) {
        Calendar calendar = Calendar.getInstance();
        clearCalendar(calendar, 11, 12, 13, 14);
        calendar.add(5, -i);
        long timeInMillis = calendar.getTimeInMillis();
        calendar.setTimeInMillis(j);
        clearCalendar(calendar, 11, 12, 13, 14);
        return new long[]{timeInMillis, calendar.getTimeInMillis()};
    }

    private static void clearCalendar(Calendar calendar, int... iArr) {
        for (int i : iArr) {
            calendar.set(i, 0);
        }
    }

    public static boolean isToday(long j) {
        long[] jArrGoBackNDays = goBackNDays(0, j);
        return jArrGoBackNDays[0] == jArrGoBackNDays[1];
    }

    public static boolean isYesterday(long j) {
        long[] jArrGoBackNDays = goBackNDays(1, j);
        return jArrGoBackNDays[0] == jArrGoBackNDays[1];
    }

    public static boolean isBackNDays(int i, long j) {
        long[] jArrGoBackNDays = goBackNDays(i, j);
        return jArrGoBackNDays[0] <= jArrGoBackNDays[1];
    }

    public static String getWeekOfDate(Resources resources, long j) {
        String[] strArr = {ResResolver.getString("aihelp_sunday"), ResResolver.getString("aihelp_monday"), ResResolver.getString("aihelp_tuesday"), ResResolver.getString("aihelp_wednesday"), ResResolver.getString("aihelp_thursday"), ResResolver.getString("aihelp_friday"), ResResolver.getString("aihelp_saturday")};
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date(j));
        int i = calendar.get(7) - 1;
        if (i < 0) {
            i = 0;
        }
        return strArr[i];
    }

    public static String dateFormat(Date date) {
        return new SimpleDateFormat("yyyy-MM-dd").format(date);
    }

    public static Date StringToDate(String str) {
        try {
            return new SimpleDateFormat("yyyy-MM-dd").parse(str);
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String CSTFormat(String str) throws ParseException {
        return dateFormat(new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy", Locale.US).parse(str));
    }

    public static Date LongToDare(long j) {
        return new Date(j);
    }

    public static String dateFormat(long j) {
        return dateFormat(LongToDare(j));
    }

    public static String getTodayTime(long j) {
        return new SimpleDateFormat("HH:mm").format(new Date(j));
    }

    public static String getProperDate(Resources resources, long j) {
        if (isToday(j)) {
            return getTodayTime(j);
        }
        if (isYesterday(j)) {
            return ResResolver.getString("aihelp_yesterday") + " " + getTodayTime(j);
        }
        if (isBackNDays(6, j)) {
            return getWeekOfDate(resources, j) + " " + getTodayTime(j);
        }
        return dateFormat(j) + " " + getTodayTime(j);
    }
}
