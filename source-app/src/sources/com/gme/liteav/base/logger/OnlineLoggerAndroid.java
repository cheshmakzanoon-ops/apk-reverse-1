package com.gme.liteav.base.logger;

import com.gme.liteav.base.annotations.JNINamespace;

@JNINamespace("liteav")
public class OnlineLoggerAndroid {
    private static final int INVALID_INSTANCE = -1;
    private long mNativeOnlineLoggerAndroid;

    private static native long nativeCreate(int i, int i2, String str, String str2);

    private static native void nativeDestroy(long j);

    private static native void nativeLog(long j, int i, String str);

    public enum EnumC1021a {
        kTRTC(0),
        kLive(1),
        kVod(2);

        int value;

        EnumC1021a(int i) {
            this.value = i;
        }
    }

    public enum EnumC1022b {
        kApi(1),
        kInfo(2),
        kWarning(3),
        kError(4);

        int level;

        EnumC1022b(int i) {
            this.level = i;
        }
    }

    public OnlineLoggerAndroid(EnumC1021a enumC1021a, int i, String str, String str2) {
        this.mNativeOnlineLoggerAndroid = -1L;
        this.mNativeOnlineLoggerAndroid = nativeCreate(enumC1021a.value, i, str, str2);
    }

    protected void finalize() throws Throwable {
        super.finalize();
        destroy();
    }

    public synchronized void destroy() {
        long j = this.mNativeOnlineLoggerAndroid;
        if (j == -1) {
            return;
        }
        nativeDestroy(j);
        this.mNativeOnlineLoggerAndroid = -1L;
    }

    public synchronized void log(EnumC1022b enumC1022b, String str) {
        long j = this.mNativeOnlineLoggerAndroid;
        if (j == -1) {
            return;
        }
        nativeLog(j, enumC1022b.level, str);
    }
}
