package com.google.android.gms.internal.play_billing;

import com.google.firebase.analytics.FirebaseAnalytics;
import j$.util.Objects;

final class zzcd extends zzbw {
    static final zzbw zza = new zzcd(new Object[0], 0);
    final transient Object[] zzb;
    private final transient int zzc;

    zzcd(Object[] objArr, int i) {
        this.zzb = objArr;
        this.zzc = i;
    }

    @Override
    public final Object get(int i) {
        zzbj.zza(i, this.zzc, FirebaseAnalytics.Param.INDEX);
        return Objects.requireNonNull(this.zzb[i]);
    }

    @Override
    public final int size() {
        return this.zzc;
    }

    @Override
    final int zza(Object[] objArr, int i) {
        Object[] objArr2 = this.zzb;
        int i2 = this.zzc;
        System.arraycopy(objArr2, 0, objArr, 0, i2);
        return i2;
    }

    @Override
    final int zzb() {
        return this.zzc;
    }

    @Override
    final int zzc() {
        return 0;
    }

    @Override
    final boolean zzf() {
        return false;
    }

    @Override
    final Object[] zzg() {
        return this.zzb;
    }
}
