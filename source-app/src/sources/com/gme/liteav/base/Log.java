package com.gme.liteav.base;

import com.facebook.internal.security.CertificateUtil;
import java.util.Locale;

public class Log {
    public static final int ASSERT = 7;
    public static final int DEBUG = 3;
    public static final int ERROR = 6;
    public static final int INFO = 4;
    public static final int VERBOSE = 2;
    public static final int WARN = 5;
    private static final String sDeprecatedTagPrefix = "cr.";
    private static final String sTagPrefix = "cr_";
    private static final boolean useChromiumLog = true;

    private static boolean isDebug() {
        return true;
    }

    private static native void nativeWriteLogToNative(int i, String str, String str2);

    private Log() {
    }

    private static String formatLog(String str, Throwable th, Object... objArr) {
        if (objArr != null) {
            return ((th != null || objArr.length <= 0) && objArr.length <= 1) ? str : String.format(Locale.US, str, objArr);
        }
        return str;
    }

    public static String normalizeTag(String str) {
        if (str.startsWith(sTagPrefix)) {
            return str;
        }
        return sTagPrefix + str.substring(str.startsWith(sDeprecatedTagPrefix) ? 3 : 0, str.length());
    }

    private static String formatLogWithStack(String str, Throwable th, Object... objArr) {
        return "[" + getCallOrigin() + "] " + formatLog(str, th, objArr);
    }

    public static boolean isLoggable(String str, int i) {
        if (isDebug() || i > 4) {
            return android.util.Log.isLoggable(str, i);
        }
        return false;
    }

    public static void m950v(String str, String str2, Object... objArr) {
        nativeWriteLogToNative(2, str, formatLogWithStack(str2, getThrowableToLog(objArr), objArr));
    }

    public static void m947d(String str, String str2, Object... objArr) {
        nativeWriteLogToNative(3, str, formatLogWithStack(str2, getThrowableToLog(objArr), objArr));
    }

    public static void m949i(String str, String str2, Object... objArr) {
        nativeWriteLogToNative(4, str, formatLog(str2, getThrowableToLog(objArr), objArr));
    }

    public static void m951w(String str, String str2, Object... objArr) {
        nativeWriteLogToNative(5, str, formatLog(str2, getThrowableToLog(objArr), objArr));
    }

    public static void m948e(String str, String str2, Object... objArr) {
        nativeWriteLogToNative(6, str, formatLog(str2, getThrowableToLog(objArr), objArr));
    }

    public static void wtf(String str, String str2, Object... objArr) {
        nativeWriteLogToNative(7, str, formatLog(str2, getThrowableToLog(objArr), objArr));
    }

    public static String getStackTraceString(Throwable th) {
        return android.util.Log.getStackTraceString(th);
    }

    private static Throwable getThrowableToLog(Object[] objArr) {
        if (objArr == null || objArr.length == 0) {
            return null;
        }
        Object obj = objArr[objArr.length - 1];
        if (obj instanceof Throwable) {
            return (Throwable) obj;
        }
        return null;
    }

    private static String getCallOrigin() {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        String name = Log.class.getName();
        int i = 0;
        while (i < stackTrace.length) {
            if (stackTrace[i].getClassName().equals(name)) {
                i += 3;
                break;
            }
            i++;
        }
        return stackTrace[i].getFileName() + CertificateUtil.DELIMITER + stackTrace[i].getLineNumber();
    }
}
