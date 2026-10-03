package com.gme.liteav.base.util;

import com.gme.liteav.base.Log;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.p008a.C1003a;
import java.util.Locale;

@JNINamespace("liteav")
public class LiteavLog {
    private static final int LEVEL_DEBUG = 1;
    private static final int LEVEL_ERROR = 4;
    private static final int LEVEL_FATAL = 5;
    private static final int LEVEL_INFO = 2;
    private static final int LEVEL_NULL = 6;
    private static final int LEVEL_VERBOSE = 0;
    private static final int LEVEL_WARN = 3;
    private static InterfaceC1047a sCallback = null;
    private static final boolean useChromiumBaseLog = true;

    public interface InterfaceC1047a {
    }

    public static native int nativeGetLogLevel();

    public static native void nativeSetConsoleLogEnabled(boolean z);

    public static native void nativeSetLogCallbackEnabled(boolean z);

    public static native void nativeSetLogCompressEnabled(boolean z);

    public static native void nativeSetLogFilePath(String str);

    public static native void nativeSetLogLevel(int i);

    public static native void nativeSetLogToFileEnabled(boolean z);

    static {
        SoLoader.loadAllLibraries();
    }

    public static void m1000v(C1003a c1003a, String str, String str2, Object... objArr) {
        if (c1003a == null || !c1003a.m954a()) {
            return;
        }
        m1002v(str, str2, objArr);
    }

    public static void m1002v(String str, String str2, Object... objArr) {
        m1001v(str, String.format(Locale.ENGLISH, str2, objArr));
    }

    public static void m1001v(String str, String str2) {
        Log.m950v(str, str2, new Object[0]);
    }

    public static void m989d(C1003a c1003a, String str, String str2, Object... objArr) {
        if (c1003a == null || !c1003a.m954a()) {
            return;
        }
        m991d(str, str2, objArr);
    }

    public static void m991d(String str, String str2, Object... objArr) {
        m990d(str, String.format(Locale.ENGLISH, str2, objArr));
    }

    public static void m990d(String str, String str2) {
        Log.m947d(str, str2, new Object[0]);
    }

    public static void m997i(C1003a c1003a, String str, String str2, Object... objArr) {
        if (c1003a == null || !c1003a.m954a()) {
            return;
        }
        m999i(str, str2, objArr);
    }

    public static void m999i(String str, String str2, Object... objArr) {
        m998i(str, String.format(Locale.ENGLISH, str2, objArr));
    }

    public static void m998i(String str, String str2) {
        Log.m949i(str, str2, new Object[0]);
    }

    public static void m1003w(C1003a c1003a, String str, String str2, Object... objArr) {
        if (c1003a == null || !c1003a.m954a()) {
            return;
        }
        m1005w(str, str2, objArr);
    }

    public static void m1005w(String str, String str2, Object... objArr) {
        m1004w(str, String.format(Locale.ENGLISH, str2, objArr));
    }

    public static void m1004w(String str, String str2) {
        Log.m951w(str, str2, new Object[0]);
    }

    public static void m993e(C1003a c1003a, String str, String str2, Object... objArr) {
        if (c1003a == null || !c1003a.m954a()) {
            return;
        }
        m996e(str, str2, objArr);
    }

    public static void m996e(String str, String str2, Object... objArr) {
        m994e(str, String.format(Locale.ENGLISH, str2, objArr));
    }

    public static void m994e(String str, String str2) {
        Log.m948e(str, str2, new Object[0]);
    }

    public static void m992e(C1003a c1003a, String str, String str2, Throwable th) {
        if (c1003a == null || !c1003a.m954a()) {
            return;
        }
        m995e(str, str2, th);
    }

    public static void m995e(String str, String str2, Throwable th) {
        m994e(str, str2 + "\n" + android.util.Log.getStackTraceString(th));
    }

    public static int getLogLevel() {
        return nativeGetLogLevel();
    }

    public enum EnumC1048b {
        kAll(0),
        kInfo(1),
        kWarning(2),
        kError(3),
        kFatal(4),
        kNone(5);

        private int mNativeValue;

        public static int m1006a(int i) {
            if (i == 0) {
                return 0;
            }
            if (i == 1) {
                return 2;
            }
            if (i == 2) {
                return 3;
            }
            if (i != 3) {
                return i != 4 ? 6 : 5;
            }
            return 4;
        }

        EnumC1048b(int i) {
            this.mNativeValue = i;
        }
    }

    public static void setCallback(InterfaceC1047a interfaceC1047a) {
        sCallback = interfaceC1047a;
    }

    public static void onLog(int i, String str) {
        try {
            if (sCallback != null) {
                EnumC1048b.m1006a(i);
            }
        } catch (Throwable th) {
            th.printStackTrace();
        }
    }
}
