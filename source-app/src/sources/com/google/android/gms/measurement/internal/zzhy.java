package com.google.android.gms.measurement.internal;

final class zzhy implements Runnable {
    private final zznc zza;
    private final zzo zzb;
    private final zzhj zzc;

    zzhy(zzhj zzhjVar, zznc zzncVar, zzo zzoVar) {
        this.zzc = zzhjVar;
        this.zza = zzncVar;
        this.zzb = zzoVar;
    }

    @Override
    public final void run() {
        this.zzc.zza.zzr();
        if (this.zza.zza() == null) {
            this.zzc.zza.zza(this.zza.zza, this.zzb);
        } else {
            this.zzc.zza.zza(this.zza, this.zzb);
        }
    }
}
