package com.google.android.gms.measurement.internal;

final class zzjf implements Runnable {
    private final String zza;
    private final String zzb;
    private final Object zzc;
    private final long zzd;
    private final zziq zze;

    zzjf(zziq zziqVar, String str, String str2, Object obj, long j) {
        this.zze = zziqVar;
        this.zza = str;
        this.zzb = str2;
        this.zzc = obj;
        this.zzd = j;
    }

    @Override
    public final void run() {
        this.zze.zza(this.zza, this.zzb, this.zzc, this.zzd);
    }
}
