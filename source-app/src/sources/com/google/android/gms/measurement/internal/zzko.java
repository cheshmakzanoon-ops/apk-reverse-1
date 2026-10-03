package com.google.android.gms.measurement.internal;

final class zzko implements Runnable {
    private final long zza;
    private final zzkh zzb;

    zzko(zzkh zzkhVar, long j) {
        this.zzb = zzkhVar;
        this.zza = j;
    }

    @Override
    public final void run() {
        this.zzb.zzc().zza(this.zza);
        this.zzb.zza = null;
    }
}
