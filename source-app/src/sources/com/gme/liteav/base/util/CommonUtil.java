package com.gme.liteav.base.util;

import com.gme.liteav.base.annotations.JNINamespace;

@JNINamespace("liteav")
public class CommonUtil {
    private static long mNativeNtpTimeManagerListener;
    private static InterfaceC1042a sCallback;

    public interface InterfaceC1042a {
    }

    private static native long nativeCreate();

    private static native long nativeGetNetworkTimestamp(long j);

    public static native String nativeGetSDKVersion();

    private static native int nativeSetGlobalEnv(String str);

    private static native boolean nativeSetSocks5Proxy(String str, int i, String str2, String str3, boolean z, boolean z2, boolean z3);

    private static native int nativeUpdateNetworkTime(long j);

    public static void onUpdateNetworkTime(int i, String str) {
    }

    static {
        SoLoader.loadAllLibraries();
    }

    public static boolean equals(Object obj, Object obj2) {
        if (obj != obj2) {
            return obj != null && obj.equals(obj2);
        }
        return true;
    }

    public static String getFileExtension(String str) {
        int iLastIndexOf;
        if (str == null || str.length() <= 0 || (iLastIndexOf = str.lastIndexOf(46)) < 0 || iLastIndexOf >= str.length() - 1) {
            return null;
        }
        return str.substring(iLastIndexOf + 1);
    }

    public static String getSDKVersionStr() {
        return nativeGetSDKVersion();
    }

    public static boolean setSocks5Proxy(String str, int i, String str2, String str3, boolean z, boolean z2, boolean z3) {
        return nativeSetSocks5Proxy(str, i, str2, str3, z, z2, z3);
    }

    public static int setGlobalEnv(String str) {
        return nativeSetGlobalEnv(str);
    }

    public static void setUpdateNetworkTimeCallback(InterfaceC1042a interfaceC1042a) {
        if (nativeNtpTimeManagerListenerHasBeenCreated()) {
            return;
        }
        mNativeNtpTimeManagerListener = nativeCreate();
        sCallback = interfaceC1042a;
    }

    public static int updateNetworkTime() {
        if (nativeNtpTimeManagerListenerHasBeenCreated()) {
            return nativeUpdateNetworkTime(mNativeNtpTimeManagerListener);
        }
        return -1;
    }

    public static long getNetworkTimestamp() {
        if (nativeNtpTimeManagerListenerHasBeenCreated()) {
            return nativeGetNetworkTimestamp(mNativeNtpTimeManagerListener);
        }
        return 0L;
    }

    private static boolean nativeNtpTimeManagerListenerHasBeenCreated() {
        return sCallback != null;
    }
}
