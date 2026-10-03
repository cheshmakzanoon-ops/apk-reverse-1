package com.google.android.gms.measurement.internal;

final class zzhs implements Runnable {
    private final zzo zza;
    private final zzhj zzb;

    zzhs(zzhj zzhjVar, zzo zzoVar) {
        this.zzb = zzhjVar;
        this.zza = zzoVar;
    }

    @Override
    public final void run() {
        this.zzb.zza.zzr();
        this.zzb.zza.zzd(this.zza);
    }
}
