package com.google.android.gms.measurement.internal;

import android.os.Bundle;

final class zzkm implements Runnable {
    private final zzki zza;
    private final zzki zzb;
    private final long zzc;
    private final boolean zzd;
    private final zzkh zze;

    zzkm(zzkh zzkhVar, zzki zzkiVar, zzki zzkiVar2, long j, boolean z) {
        this.zze = zzkhVar;
        this.zza = zzkiVar;
        this.zzb = zzkiVar2;
        this.zzc = j;
        this.zzd = z;
    }

    @Override
    public final void run() {
        this.zze.zza(this.zza, this.zzb, this.zzc, this.zzd, (Bundle) null);
    }
}
