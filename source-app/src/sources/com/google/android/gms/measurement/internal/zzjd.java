package com.google.android.gms.measurement.internal;

final class zzjd implements Runnable {
    private final long zza;
    private final zziq zzb;

    zzjd(zziq zziqVar, long j) {
        this.zzb = zziqVar;
        this.zza = j;
    }

    @Override
    public final void run() {
        this.zzb.zzk().zzf.zza(this.zza);
        this.zzb.zzj().zzc().zza("Session timeout duration set", Long.valueOf(this.zza));
    }
}
