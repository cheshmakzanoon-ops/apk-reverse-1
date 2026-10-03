package com.google.android.gms.measurement.internal;

import java.util.concurrent.atomic.AtomicReference;

final class zzjk implements Runnable {
    private final long zza;
    private final zziq zzb;

    zzjk(zziq zziqVar, long j) {
        this.zzb = zziqVar;
        this.zza = j;
    }

    @Override
    public final void run() {
        this.zzb.zza(this.zza, true);
        this.zzb.zzo().zza(new AtomicReference<>());
    }
}
