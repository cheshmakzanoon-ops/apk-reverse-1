package com.google.android.gms.measurement.internal;

final class zzhp implements Runnable {
    private final zzad zza;
    private final zzhj zzb;

    zzhp(zzhj zzhjVar, zzad zzadVar) {
        this.zzb = zzhjVar;
        this.zza = zzadVar;
    }

    @Override
    public final void run() {
        this.zzb.zza.zzr();
        if (this.zza.zzc.zza() == null) {
            this.zzb.zza.zza(this.zza);
        } else {
            this.zzb.zza.zzb(this.zza);
        }
    }
}
