package com.google.android.gms.internal.play_billing;

import com.google.firebase.analytics.FirebaseAnalytics;
import j$.util.Objects;
import java.util.AbstractMap;

final class zzce extends zzbw {
    final zzcf zza;

    zzce(zzcf zzcfVar) {
        Objects.requireNonNull(zzcfVar);
        this.zza = zzcfVar;
    }

    @Override
    public final Object get(int i) {
        zzcf zzcfVar = this.zza;
        zzbj.zza(i, zzcfVar.zzc, FirebaseAnalytics.Param.INDEX);
        int i2 = i + i;
        return new AbstractMap.SimpleImmutableEntry(Objects.requireNonNull(zzcfVar.zzb[i2]), Objects.requireNonNull(zzcfVar.zzb[i2 + 1]));
    }

    @Override
    public final int size() {
        return this.zza.zzc;
    }

    @Override
    public final boolean zzf() {
        return true;
    }
}
