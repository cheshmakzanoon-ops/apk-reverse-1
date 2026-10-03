package com.google.android.gms.measurement.internal;

import com.google.android.gms.common.internal.Preconditions;

final class zzhl implements Runnable {
    private final zzo zza;
    private final zzhj zzb;

    zzhl(zzhj zzhjVar, zzo zzoVar) {
        this.zzb = zzhjVar;
        this.zza = zzoVar;
    }

    @Override
    public final void run() {
        this.zzb.zza.zzr();
        zzmp zzmpVar = this.zzb.zza;
        zzo zzoVar = this.zza;
        zzmpVar.zzl().zzt();
        zzmpVar.zzs();
        Preconditions.checkNotEmpty(zzoVar.zza);
        zzmpVar.zza(zzoVar);
    }
}
