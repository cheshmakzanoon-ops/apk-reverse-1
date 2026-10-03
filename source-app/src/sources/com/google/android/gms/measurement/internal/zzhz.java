package com.google.android.gms.measurement.internal;

import java.util.concurrent.Callable;

final class zzhz implements Callable<byte[]> {
    private final zzbg zza;
    private final String zzb;
    private final zzhj zzc;

    @Override
    public final byte[] call() throws Exception {
        this.zzc.zza.zzr();
        return this.zzc.zza.zzm().zza(this.zza, this.zzb);
    }

    zzhz(zzhj zzhjVar, zzbg zzbgVar, String str) {
        this.zzc = zzhjVar;
        this.zza = zzbgVar;
        this.zzb = str;
    }
}
