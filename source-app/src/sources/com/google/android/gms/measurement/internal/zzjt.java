package com.google.android.gms.measurement.internal;

final class zzjt implements Runnable {
    private final Boolean zza;
    private final zziq zzb;

    zzjt(zziq zziqVar, Boolean bool) {
        this.zzb = zziqVar;
        this.zza = bool;
    }

    @Override
    public final void run() {
        this.zzb.zza(this.zza, true);
    }
}
