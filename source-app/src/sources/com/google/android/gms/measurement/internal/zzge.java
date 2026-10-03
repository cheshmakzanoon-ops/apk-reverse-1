package com.google.android.gms.measurement.internal;

final class zzge implements Runnable {
    private final boolean zza;
    private final zzgb zzb;

    zzge(zzgb zzgbVar, boolean z) {
        this.zzb = zzgbVar;
        this.zza = z;
    }

    @Override
    public final void run() {
        this.zzb.zzb.zza(this.zza);
    }
}
