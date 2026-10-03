package com.google.android.gms.internal.play_billing;

import com.google.firebase.analytics.FirebaseAnalytics;
import j$.util.Objects;

final class zzch extends zzbw {
    private final transient Object[] zza;
    private final transient int zzb;
    private final transient int zzc;

    zzch(Object[] objArr, int i, int i2) {
        this.zza = objArr;
        this.zzb = i;
        this.zzc = i2;
    }

    @Override
    public final Object get(int i) {
        zzbj.zza(i, this.zzc, FirebaseAnalytics.Param.INDEX);
        return Objects.requireNonNull(this.zza[i + i + this.zzb]);
    }

    @Override
    public final int size() {
        return this.zzc;
    }

    @Override
    final boolean zzf() {
        return true;
    }
}
