package com.google.android.gms.measurement.internal;

final class zzhx implements Runnable {
    private final zzbg zza;
    private final zzo zzb;
    private final zzhj zzc;

    zzhx(zzhj zzhjVar, zzbg zzbgVar, zzo zzoVar) {
        this.zzc = zzhjVar;
        this.zza = zzbgVar;
        this.zzb = zzoVar;
    }

    @Override
    public final void run() {
        this.zzc.zzc(this.zzc.zzb(this.zza, this.zzb), this.zzb);
    }
}
