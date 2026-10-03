package com.gme.trtc.hardwareearmonitor.honor;

import com.gme.liteav.base.util.LiteavLog;
import java.util.IllegalFormatException;
import java.util.Locale;
import java.util.regex.PatternSyntaxException;

public class HonorLogUtils {
    public static final int DEBUG = 4;
    public static final int ERROR = 1;
    private static final String ERROR_MESSAGE = "log message error : ";
    public static final int INFO = 3;
    public static final int LOG_LEVEL = 6;
    public static final int VERBOSE = 5;
    public static final int WARN = 2;

    private HonorLogUtils() {
    }

    public static void error(String str, String str2) {
        LiteavLog.m994e(str, str2);
    }

    public static <T> void error(String str, String str2, T... tArr) {
        if (str2 != null) {
            LiteavLog.m994e(str, getMessageString(str2, tArr));
        }
    }

    public static void warn(String str, String str2) {
        LiteavLog.m1004w(str, str2);
    }

    public static void info(String str, String str2) {
        LiteavLog.m998i(str, str2);
    }

    public static <T> void info(String str, String str2, T... tArr) {
        if (str2 != null) {
            LiteavLog.m998i(str, getMessageString(str2, tArr));
        }
    }

    public static void debug(String str, String str2) {
        LiteavLog.m990d(str, str2);
    }

    public static <T> void debug(String str, String str2, T... tArr) {
        if (str2 != null) {
            LiteavLog.m990d(str, getMessageString(str2, tArr));
        }
    }

    public static void verbose(String str, String str2) {
        LiteavLog.m1001v(str, str2);
    }

    private static <T> String getMessageString(String str, T[] tArr) {
        try {
            return String.format(Locale.ENGLISH, str.replaceAll("\\{\\}", "%s"), tArr);
        } catch (IllegalFormatException | PatternSyntaxException e) {
            return ERROR_MESSAGE + e.getMessage();
        }
    }
}
