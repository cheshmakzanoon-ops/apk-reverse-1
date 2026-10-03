package com.google.android.gms.measurement.internal;

import com.google.android.gms.internal.measurement.zzps;

final class zzjv implements Runnable {
    private final zzih zza;
    private final long zzb;
    private final long zzc;
    private final boolean zzd;
    private final zzih zze;
    private final zziq zzf;

    zzjv(zziq zziqVar, zzih zzihVar, long j, long j2, boolean z, zzih zzihVar2) {
        this.zzf = zziqVar;
        this.zza = zzihVar;
        this.zzb = j;
        this.zzc = j2;
        this.zzd = z;
        this.zze = zzihVar2;
    }

    @Override
    public final void run() {
        this.zzf.zza(this.zza);
        this.zzf.zza(this.zzb, false);
        zziq.zza(this.zzf, this.zza, this.zzc, true, this.zzd);
        if (zzps.zza() && this.zzf.zze().zza(zzbi.zzbs)) {
            zziq.zza(this.zzf, this.zza, this.zze);
        }
    }
}
