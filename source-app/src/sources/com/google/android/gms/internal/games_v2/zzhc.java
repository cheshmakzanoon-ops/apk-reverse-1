package com.google.android.gms.internal.games_v2;

import com.google.firebase.analytics.FirebaseAnalytics;
import j$.util.Objects;
import java.util.List;

final class zzhc extends zzhd {
    final transient int zza;
    final transient int zzb;
    final zzhd zzc;

    zzhc(zzhd zzhdVar, int i, int i2) {
        Objects.requireNonNull(zzhdVar);
        this.zzc = zzhdVar;
        this.zza = i;
        this.zzb = i2;
    }

    @Override
    public final Object get(int i) {
        zzfu.zzb(i, this.zzb, FirebaseAnalytics.Param.INDEX);
        return this.zzc.get(i + this.zza);
    }

    @Override
    public final int size() {
        return this.zzb;
    }

    @Override
    public final List subList(int i, int i2) {
        return subList(i, i2);
    }

    @Override
    final Object[] zzb() {
        return this.zzc.zzb();
    }

    @Override
    final int zzc() {
        return this.zzc.zzc() + this.zza;
    }

    @Override
    final int zzd() {
        return this.zzc.zzc() + this.zza + this.zzb;
    }

    @Override
    public final zzhd subList(int i, int i2) {
        zzfu.zzd(i, i2, this.zzb);
        int i3 = this.zza;
        return this.zzc.subList(i + i3, i2 + i3);
    }
}
