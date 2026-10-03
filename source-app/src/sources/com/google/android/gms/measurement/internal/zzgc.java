package com.google.android.gms.measurement.internal;

import com.google.android.gms.common.internal.Preconditions;
import java.net.URL;
import java.util.Map;

final class zzgc implements Runnable {
    private final URL zza;
    private final byte[] zzb;
    private final zzfx zzc;
    private final String zzd;
    private final Map<String, String> zze;
    private final zzfy zzf;

    public zzgc(zzfy zzfyVar, String str, URL url, byte[] bArr, Map<String, String> map, zzfx zzfxVar) {
        this.zzf = zzfyVar;
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotNull(url);
        Preconditions.checkNotNull(zzfxVar);
        this.zza = url;
        this.zzb = bArr;
        this.zzc = zzfxVar;
        this.zzd = str;
        this.zze = map;
    }

    @Override
    public final void run() throws java.lang.Throwable {
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.gms.measurement.internal.zzgc.run():void");
    }
}
