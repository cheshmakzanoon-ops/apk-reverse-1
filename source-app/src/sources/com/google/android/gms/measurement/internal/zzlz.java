package com.google.android.gms.measurement.internal;

final class zzlz implements Runnable {
    private final long zza;
    private final zzlx zzb;

    zzlz(zzlx zzlxVar, long j) {
        this.zzb = zzlxVar;
        this.zza = j;
    }

    @Override
    public final void run() {
        zzlx.zza(this.zzb, this.zza);
    }
}
