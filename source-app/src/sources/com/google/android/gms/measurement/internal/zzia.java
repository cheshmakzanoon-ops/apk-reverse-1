package com.google.android.gms.measurement.internal;

import java.util.List;
import java.util.concurrent.Callable;

final class zzia implements Callable<List<zzne>> {
    private final String zza;
    private final zzhj zzb;

    @Override
    public final List<zzne> call() throws Exception {
        this.zzb.zza.zzr();
        return this.zzb.zza.zzf().zzi(this.zza);
    }

    zzia(zzhj zzhjVar, String str) {
        this.zzb = zzhjVar;
        this.zza = str;
    }
}
