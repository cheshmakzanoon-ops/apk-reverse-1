package com.google.android.gms.measurement.internal;

import java.util.Map;

final class zzgx implements com.google.android.gms.internal.measurement.zzo {
    private final String zza;
    private final zzgp zzb;

    @Override
    public final String zza(String str) {
        Map map = (Map) this.zzb.zzc.get(this.zza);
        if (map == null || !map.containsKey(str)) {
            return null;
        }
        return (String) map.get(str);
    }

    zzgx(zzgp zzgpVar, String str) {
        this.zzb = zzgpVar;
        this.zza = str;
    }
}
