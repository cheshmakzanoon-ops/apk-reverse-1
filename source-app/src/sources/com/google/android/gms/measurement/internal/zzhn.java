package com.google.android.gms.measurement.internal;

final class zzhn implements Runnable {
    private final String zza;
    private final String zzb;
    private final String zzc;
    private final long zzd;
    private final zzhj zze;

    zzhn(zzhj zzhjVar, String str, String str2, String str3, long j) {
        this.zze = zzhjVar;
        this.zza = str;
        this.zzb = str2;
        this.zzc = str3;
        this.zzd = j;
    }

    @Override
    public final void run() {
        if (this.zza == null) {
            this.zze.zza.zza(this.zzb, (zzki) null);
        } else {
            this.zze.zza.zza(this.zzb, new zzki(this.zzc, this.zza, this.zzd));
        }
    }
}
