package com.google.android.gms.measurement.internal;

final class zzd implements Runnable {
    private final String zza;
    private final long zzb;
    private final zzb zzc;

    zzd(zzb zzbVar, String str, long j) {
        this.zzc = zzbVar;
        this.zza = str;
        this.zzb = j;
    }

    @Override
    public final void run() {
        zzb.zzb(this.zzc, this.zza, this.zzb);
    }
}
