package com.google.android.gms.measurement.internal;

import com.google.android.gms.internal.measurement.zzps;

final class zzjy implements Runnable {
    private final zzih zza;
    private final long zzb;
    private final boolean zzc;
    private final zzih zzd;
    private final zziq zze;

    zzjy(zziq zziqVar, zzih zzihVar, long j, boolean z, zzih zzihVar2) {
        this.zze = zziqVar;
        this.zza = zzihVar;
        this.zzb = j;
        this.zzc = z;
        this.zzd = zzihVar2;
    }

    @Override
    public final void run() {
        this.zze.zza(this.zza);
        zziq.zza(this.zze, this.zza, this.zzb, false, this.zzc);
        if (zzps.zza() && this.zze.zze().zza(zzbi.zzbs)) {
            zziq.zza(this.zze, this.zza, this.zzd);
        }
    }
}
