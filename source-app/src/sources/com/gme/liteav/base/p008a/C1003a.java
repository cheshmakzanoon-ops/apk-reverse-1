package com.gme.liteav.base.p008a;

import android.os.SystemClock;

public final class C1003a {

    private long f604a = 0;

    private final long f605b = 1000;

    public final boolean m954a() {
        long jElapsedRealtime = SystemClock.elapsedRealtime();
        long j = this.f604a;
        if (j != 0 && jElapsedRealtime - j <= this.f605b) {
            return false;
        }
        this.f604a = SystemClock.elapsedRealtime();
        return true;
    }
}
