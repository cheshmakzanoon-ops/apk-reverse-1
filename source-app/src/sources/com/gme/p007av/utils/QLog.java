package com.gme.p007av.utils;

import android.util.Log;

public class QLog {
    public static final int DEBUG = 3;
    public static final int ERROR = 1;
    public static final int INFO = 2;
    public static final int VERBOSE = 4;
    private static volatile boolean useAvsdkLogger = true;

    public static void m907d(String str, String str2) {
        if (useAvsdkLogger) {
            writeLog(3, str, str2);
        } else {
            Log.d(str, str2);
        }
    }

    public static void m908d(String str, String str2, Exception exc) {
        if (useAvsdkLogger) {
            writeLog(3, str, str2, exc);
        } else {
            Log.d(str, str2, exc);
        }
    }

    public static void m915w(String str, String str2) {
        if (useAvsdkLogger) {
            writeLog(1, str, str2);
        } else {
            Log.w(str, str2);
        }
    }

    public static void m916w(String str, String str2, Exception exc) {
        if (useAvsdkLogger) {
            writeLog(1, str, str2, exc);
        } else {
            Log.w(str, str2, exc);
        }
    }

    public static void m909e(String str, String str2) {
        if (useAvsdkLogger) {
            writeLog(1, str, str2);
        } else {
            Log.e(str, str2);
        }
    }

    public static void m910e(String str, String str2, Exception exc) {
        if (useAvsdkLogger) {
            writeLog(1, str, str2, exc);
        } else {
            Log.e(str, str2, exc);
        }
    }

    public static void m911i(String str, String str2) {
        if (useAvsdkLogger) {
            writeLog(2, str, str2);
        } else {
            Log.i(str, str2);
        }
    }

    public static void m912i(String str, String str2, Exception exc) {
        if (useAvsdkLogger) {
            writeLog(2, str, str2, exc);
        } else {
            Log.i(str, str2, exc);
        }
    }

    public static void m913v(String str, String str2) {
        if (useAvsdkLogger) {
            writeLog(4, str, str2);
        } else {
            Log.i(str, str2);
        }
    }

    public static void m914v(String str, String str2, Exception exc) {
        if (useAvsdkLogger) {
            writeLog(4, str, str2, exc);
        } else {
            Log.i(str, str2, exc);
        }
    }

    private static void writeLog(int i, String str, String str2) {
        writeLog(i, str, str2, null);
    }

    private static void writeLog(int i, String str, String str2, Exception exc) {
        String str3 = String.format("[%s]%s", str, str2);
        if (exc != null) {
            str3 = str3 + ", " + Log.getStackTraceString(exc);
        }
        if (GMELibLoader.isLoadLibrary()) {
            nativeWriteLog(i, str3);
        } else {
            Log.i(str, str3);
        }
    }

    private static void nativeWriteLog(int i, String str) {
        Log.i("Native", str);
    }

    private static String nativeGetLogDir() {
        return "";
    }

    public static String getLogDir() {
        return nativeGetLogDir();
    }
}
