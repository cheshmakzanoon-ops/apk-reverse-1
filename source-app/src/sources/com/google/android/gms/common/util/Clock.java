package com.google.android.gms.common.util;

public interface Clock {

    public final class CC {
    }

    long currentThreadTimeMillis();

    long currentTimeMillis();

    long elapsedRealtime();

    long nanoTime();
}
