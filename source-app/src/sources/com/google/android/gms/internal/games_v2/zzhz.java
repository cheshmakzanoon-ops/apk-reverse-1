package com.google.android.gms.internal.games_v2;

import com.google.firebase.analytics.FirebaseAnalytics;
import j$.util.Objects;

final class zzhz extends zzhd {
    static final zzhd zza = new zzhz(new Object[0], 0);
    final transient Object[] zzb;
    private final transient int zzc;

    zzhz(Object[] objArr, int i) {
        this.zzb = objArr;
        this.zzc = i;
    }

    @Override
    public final Object get(int i) {
        zzfu.zzb(i, this.zzc, FirebaseAnalytics.Param.INDEX);
        return Objects.requireNonNull(this.zzb[i]);
    }

    @Override
    public final int size() {
        return this.zzc;
    }

    @Override
    final Object[] zzb() {
        return this.zzb;
    }

    @Override
    final int zzc() {
        return 0;
    }

    @Override
    final int zzd() {
        return this.zzc;
    }

    @Override
    final int zze(Object[] objArr, int i) {
        Object[] objArr2 = this.zzb;
        int i2 = this.zzc;
        System.arraycopy(objArr2, 0, objArr, 0, i2);
        return i2;
    }
}
