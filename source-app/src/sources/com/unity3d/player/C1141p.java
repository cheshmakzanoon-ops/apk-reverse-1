package com.unity3d.player;

import android.os.Build;

final class C1141p implements Thread.UncaughtExceptionHandler {

    private volatile Thread.UncaughtExceptionHandler f479a;

    C1141p() {
    }

    final synchronized boolean m677a() {
        Thread.UncaughtExceptionHandler defaultUncaughtExceptionHandler = Thread.getDefaultUncaughtExceptionHandler();
        if (defaultUncaughtExceptionHandler == this) {
            return false;
        }
        this.f479a = defaultUncaughtExceptionHandler;
        Thread.setDefaultUncaughtExceptionHandler(this);
        return true;
    }

    @Override
    public final synchronized void uncaughtException(Thread thread, Throwable th) {
        try {
            Error error = new Error(String.format("FATAL EXCEPTION [%s]\n", thread.getName()) + String.format("Unity version     : %s\n", "2019.4.40f1") + String.format("Device model      : %s %s\n", Build.MANUFACTURER, Build.MODEL) + String.format("Device fingerprint: %s\n", Build.FINGERPRINT));
            error.setStackTrace(new StackTraceElement[0]);
            error.initCause(th);
            this.f479a.uncaughtException(thread, error);
        } catch (Throwable unused) {
            this.f479a.uncaughtException(thread, th);
        }
    }
}
