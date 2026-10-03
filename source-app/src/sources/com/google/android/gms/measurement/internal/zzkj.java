package com.google.android.gms.measurement.internal;

import android.os.Bundle;

final class zzkj implements Runnable {
    private final Bundle zza;
    private final zzki zzb;
    private final zzki zzc;
    private final long zzd;
    private final zzkh zze;

    zzkj(zzkh zzkhVar, Bundle bundle, zzki zzkiVar, zzki zzkiVar2, long j) {
        this.zze = zzkhVar;
        this.zza = bundle;
        this.zzb = zzkiVar;
        this.zzc = zzkiVar2;
        this.zzd = j;
    }

    @Override
    public final void run() {
        zzkh.zza(this.zze, this.zza, this.zzb, this.zzc, this.zzd);
    }
}
