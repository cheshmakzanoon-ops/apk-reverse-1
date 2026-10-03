package com.google.android.gms.internal.play_billing;

import android.os.SystemClock;

final class zzbc extends zzbo {
    zzbc() {
    }

    @Override
    public final long zza() {
        return SystemClock.elapsedRealtime() * 1000000;
    }
}
