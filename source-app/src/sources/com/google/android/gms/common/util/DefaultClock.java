package com.google.android.gms.common.util;

import android.os.SystemClock;

public class DefaultClock implements Clock {
    private static final DefaultClock zza = new DefaultClock();

    private DefaultClock() {
    }

    public static Clock getInstance() {
        return zza;
    }

    @Override
    public final long currentThreadTimeMillis() {
        return SystemClock.currentThreadTimeMillis();
    }

    @Override
    public final long currentTimeMillis() {
        return System.currentTimeMillis();
    }

    @Override
    public final long elapsedRealtime() {
        return SystemClock.elapsedRealtime();
    }

    @Override
    public final long nanoTime() {
        return System.nanoTime();
    }
}
