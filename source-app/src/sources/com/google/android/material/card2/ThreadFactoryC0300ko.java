package com.google.android.material.card2;

import java.util.concurrent.ThreadFactory;

final class ThreadFactoryC0300ko implements ThreadFactory {

    final boolean f904om;

    final String f905on;

    ThreadFactoryC0300ko(String str, boolean z) {
        this.f905on = str;
        this.f904om = z;
    }

    public static boolean m5788(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m5792(obj);
        }
        return false;
    }

    public static boolean m5789(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((ThreadFactoryC0300ko) obj).f904om;
        }
        return false;
    }

    public static String m5790(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((ThreadFactoryC0300ko) obj).f905on;
        }
        return null;
    }

    public static String m5791(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return m5793(obj);
        }
        return null;
    }

    public static boolean m5792(Object obj) {
        if (abf.m2500() >= 0) {
            return m5789((ThreadFactoryC0300ko) obj);
        }
        return false;
    }

    public static String m5793(Object obj) {
        if (abd.m2166() < 0) {
            return m5790((ThreadFactoryC0300ko) obj);
        }
        return null;
    }

    @Override
    public Thread newThread(Runnable runnable) {
        Thread thread = new Thread(runnable, m5791(this));
        abc.m1911(thread, m5788(this));
        return thread;
    }
}
