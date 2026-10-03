package com.google.android.gms.measurement.internal;

import androidx.collection.LruCache;
import com.google.android.gms.common.internal.Preconditions;

final class zzgv extends LruCache<String, com.google.android.gms.internal.measurement.zzb> {
    private final zzgp zza;

    protected final Object create(Object obj) {
        String str = (String) obj;
        Preconditions.checkNotEmpty(str);
        return zzgp.zza(this.zza, str);
    }

    zzgv(zzgp zzgpVar, int i) {
        super(20);
        this.zza = zzgpVar;
    }
}
