package com.google.android.gms.measurement.internal;

import java.util.concurrent.Callable;

final class zzhu implements Callable<zzam> {
    private final zzo zza;
    private final zzhj zzb;

    @Override
    public final zzam call() throws Exception {
        this.zzb.zza.zzr();
        return new zzam(this.zzb.zza.zza(this.zza.zza));
    }

    zzhu(zzhj zzhjVar, zzo zzoVar) {
        this.zzb = zzhjVar;
        this.zza = zzoVar;
    }
}
