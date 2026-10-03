package com.google.android.gms.measurement.internal;

final class zzhw implements Runnable {
    private final zzbg zza;
    private final String zzb;
    private final zzhj zzc;

    zzhw(zzhj zzhjVar, zzbg zzbgVar, String str) {
        this.zzc = zzhjVar;
        this.zza = zzbgVar;
        this.zzb = str;
    }

    @Override
    public final void run() {
        this.zzc.zza.zzr();
        this.zzc.zza.zza(this.zza, this.zzb);
    }
}
