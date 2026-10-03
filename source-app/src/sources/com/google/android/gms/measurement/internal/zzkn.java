package com.google.android.gms.measurement.internal;

final class zzkn implements Runnable {
    private final zzki zza;
    private final long zzb;
    private final zzkh zzc;

    zzkn(zzkh zzkhVar, zzki zzkiVar, long j) {
        this.zzc = zzkhVar;
        this.zza = zzkiVar;
        this.zzb = j;
    }

    @Override
    public final void run() {
        this.zzc.zza(this.zza, false, this.zzb);
        this.zzc.zza = null;
        this.zzc.zzo().zza((zzki) null);
    }
}
