package com.google.android.datatransport.runtime.time;

import android.os.SystemClock;

public class UptimeClock implements Clock {
    @Override
    public long getTime() {
        return SystemClock.elapsedRealtime();
    }
}
