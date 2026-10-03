package com.gme.liteav.base.datareport;

import com.gme.liteav.base.annotations.JNINamespace;

@JNINamespace("liteav")
public class Event4XReporter {
    private static final int INVALID_INSTANCE = 0;
    public static final int REPORT_EVENT = 1;
    public static final int REPORT_STATUS = 2;
    private static final String TAG = "Event4XReporter";
    private long mNativeEvent4XReporterAndroid;

    private static native long nativeCreate(int i, int i2, String str, boolean z, int i3);

    private static native void nativeDestroy(long j);

    private static native int nativeGetColdDownTime(long j);

    private static native void nativeSendReport(long j);

    private static native void nativeSetCommonIntValue(long j, String str, long j2);

    private static native void nativeSetCommonStringValue(long j, String str, String str2);

    private static native void nativeSetEventIntValue(long j, String str, long j2);

    private static native void nativeSetEventStringValue(long j, String str, String str2);

    public Event4XReporter(int i, int i2, String str, boolean z, int i3) {
        this.mNativeEvent4XReporterAndroid = 0L;
        this.mNativeEvent4XReporterAndroid = nativeCreate(i, i2, str, z, i3);
    }

    protected void finalize() throws Throwable {
        super.finalize();
        destroy();
    }

    public synchronized void destroy() {
        long j = this.mNativeEvent4XReporterAndroid;
        if (j == 0) {
            return;
        }
        nativeDestroy(j);
        this.mNativeEvent4XReporterAndroid = 0L;
    }

    public synchronized void setCommonIntValue(String str, long j) {
        long j2 = this.mNativeEvent4XReporterAndroid;
        if (j2 != 0 && str != null) {
            nativeSetCommonIntValue(j2, str, j);
        }
    }

    public synchronized void setCommonStringValue(String str, String str2) {
        long j = this.mNativeEvent4XReporterAndroid;
        if (j != 0 && str != null && str2 != null) {
            nativeSetCommonStringValue(j, str, str2);
        }
    }

    public synchronized void setEventIntValue(String str, long j) {
        long j2 = this.mNativeEvent4XReporterAndroid;
        if (j2 != 0 && str != null) {
            nativeSetEventIntValue(j2, str, j);
        }
    }

    public synchronized void setEventStringValue(String str, String str2) {
        long j = this.mNativeEvent4XReporterAndroid;
        if (j != 0 && str != null && str2 != null) {
            nativeSetEventStringValue(j, str, str2);
        }
    }

    public synchronized void sendReport() {
        long j = this.mNativeEvent4XReporterAndroid;
        if (j == 0) {
            return;
        }
        nativeSendReport(j);
    }

    public int getColdDownTime() {
        long j = this.mNativeEvent4XReporterAndroid;
        if (j == 0) {
            return 10000;
        }
        return nativeGetColdDownTime(j);
    }

    public synchronized void reportDau(int i, int i2, String str) {
        long j = this.mNativeEvent4XReporterAndroid;
        if (j == 0) {
            return;
        }
        nativeSetEventStringValue(j, "event_id", String.valueOf(i));
        nativeSetEventStringValue(this.mNativeEvent4XReporterAndroid, "err_code", String.valueOf(i2));
        nativeSetEventStringValue(this.mNativeEvent4XReporterAndroid, "err_info", str);
        nativeSendReport(this.mNativeEvent4XReporterAndroid);
    }
}
