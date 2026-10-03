package com.google.android.gms.measurement.internal;

final class zzms implements Runnable {
    private final zzna zza;
    private final zzmp zzb;

    zzms(zzmp zzmpVar, zzna zznaVar) {
        this.zzb = zzmpVar;
        this.zza = zznaVar;
    }

    @Override
    public final void run() {
        zzmp.zza(this.zzb, this.zza);
        this.zzb.zzv();
    }
}
