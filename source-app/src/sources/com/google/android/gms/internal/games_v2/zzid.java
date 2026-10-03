package com.google.android.gms.internal.games_v2;

import com.google.firebase.analytics.FirebaseAnalytics;
import j$.util.Objects;

final class zzid extends zzhd {
    private final transient Object[] zza;
    private final transient int zzb;
    private final transient int zzc;

    zzid(Object[] objArr, int i, int i2) {
        this.zza = objArr;
        this.zzb = i;
        this.zzc = i2;
    }

    @Override
    public final Object get(int i) {
        zzfu.zzb(i, this.zzc, FirebaseAnalytics.Param.INDEX);
        return Objects.requireNonNull(this.zza[i + i + this.zzb]);
    }

    @Override
    public final int size() {
        return this.zzc;
    }
}
