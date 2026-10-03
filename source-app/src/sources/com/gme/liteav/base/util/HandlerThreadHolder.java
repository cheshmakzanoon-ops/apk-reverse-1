package com.gme.liteav.base.util;

import android.os.HandlerThread;
import android.os.Looper;
import com.gme.liteav.base.annotations.JNINamespace;

@JNINamespace("liteav")
public class HandlerThreadHolder {
    private final HandlerThread mHandlerThread;

    public HandlerThreadHolder(String str) {
        HandlerThread handlerThread;
        try {
            handlerThread = new HandlerThread(str);
        } catch (Throwable th) {
            LiteavLog.m995e("HandlerThreadHolder", "HandlerThreadHolder failed.", th);
            handlerThread = null;
        }
        this.mHandlerThread = handlerThread;
    }

    public void start() {
        try {
            this.mHandlerThread.start();
        } catch (Throwable th) {
            LiteavLog.m995e("HandlerThreadHolder", "start failed.", th);
        }
    }

    public Looper getLooper() {
        try {
            return this.mHandlerThread.getLooper();
        } catch (Throwable th) {
            LiteavLog.m995e("HandlerThreadHolder", "getLooper failed.", th);
            return null;
        }
    }
}
