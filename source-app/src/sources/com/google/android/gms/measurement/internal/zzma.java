package com.google.android.gms.measurement.internal;

final class zzma implements Runnable {
    private final long zza;
    private final zzlx zzb;

    zzma(zzlx zzlxVar, long j) {
        this.zzb = zzlxVar;
        this.zza = j;
    }

    @Override
    public final void run() {
        zzlx.zzb(this.zzb, this.zza);
    }
}
