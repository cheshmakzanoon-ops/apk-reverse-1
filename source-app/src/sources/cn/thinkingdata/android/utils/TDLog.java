package cn.thinkingdata.android.utils;

import android.util.Log;

public class TDLog {
    static volatile boolean mEnableLog = false;
    static volatile boolean mEnableLogInner = false;

    public static void m679d(String str, String str2) {
        if (mEnableLog) {
            Log.d(str, str2);
        }
    }

    public static void m680e(String str, String str2) {
        Log.e(str, str2);
    }

    public static void m681e(String str, String str2, Throwable th) {
        Log.e(str, str2, th);
    }

    public static boolean getEnableLog() {
        return mEnableLog;
    }

    public static void m682i(String str, String str2) {
        if (mEnableLog) {
            if (str2.length() > 4000) {
                largeLog(str, str2);
            } else {
                Log.i(str, str2);
            }
        }
    }

    public static void m683i(String str, String str2, Throwable th) {
        if (mEnableLog) {
            Log.i(str, str2, th);
        }
    }

    public static void m684i(String str, Throwable th) {
        if (mEnableLog) {
            try {
                Log.i(str, "", th);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private static void largeLog(String str, String str2) {
        while (str2.length() > 4000) {
            Log.i(str, str2.substring(0, 4000) + "");
            str2 = str2.substring(4000) + "";
        }
        Log.i(str, str2);
    }

    public static void setEnableLog(boolean z) {
        if (mEnableLogInner) {
            z = true;
        }
        mEnableLog = z;
    }

    public static void setEnableLogInner(boolean z) {
        mEnableLogInner = z;
    }

    public static void m685v(String str, String str2) {
        if (mEnableLog) {
            Log.v(str, str2);
        }
    }

    public static void m686v(String str, String str2, Throwable th) {
        if (mEnableLog) {
            Log.v(str, str2, th);
        }
    }

    public static void m687w(String str, String str2) {
        if (mEnableLog) {
            Log.w(str, str2);
        }
    }

    public static void m688w(String str, String str2, Throwable th) {
        if (mEnableLog) {
            Log.w(str, str2, th);
        }
    }
}
