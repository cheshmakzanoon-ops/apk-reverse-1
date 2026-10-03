package com.google.android.gms.measurement.internal;

final class zzhm implements Runnable {
    private final zzad zza;
    private final zzo zzb;
    private final zzhj zzc;

    zzhm(zzhj zzhjVar, zzad zzadVar, zzo zzoVar) {
        this.zzc = zzhjVar;
        this.zza = zzadVar;
        this.zzb = zzoVar;
    }

    @Override
    public final void run() {
        this.zzc.zza.zzr();
        if (this.zza.zzc.zza() == null) {
            this.zzc.zza.zza(this.zza, this.zzb);
        } else {
            this.zzc.zza.zzb(this.zza, this.zzb);
        }
    }
}
