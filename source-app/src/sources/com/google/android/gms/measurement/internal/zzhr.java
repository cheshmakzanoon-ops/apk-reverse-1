package com.google.android.gms.measurement.internal;

import java.util.List;
import java.util.concurrent.Callable;

final class zzhr implements Callable<List<zzne>> {
    private final String zza;
    private final String zzb;
    private final String zzc;
    private final zzhj zzd;

    @Override
    public final List<zzne> call() throws Exception {
        this.zzd.zza.zzr();
        return this.zzd.zza.zzf().zzb(this.zza, this.zzb, this.zzc);
    }

    zzhr(zzhj zzhjVar, String str, String str2, String str3) {
        this.zzd = zzhjVar;
        this.zza = str;
        this.zzb = str2;
        this.zzc = str3;
    }
}
