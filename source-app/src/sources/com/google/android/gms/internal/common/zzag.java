package com.google.android.gms.internal.common;

import com.google.firebase.analytics.FirebaseAnalytics;
import j$.util.Objects;
import java.util.List;

final class zzag extends zzah {
    final transient int zza;
    final transient int zzb;
    final zzah zzc;

    zzag(zzah zzahVar, int i, int i2) {
        Objects.requireNonNull(zzahVar);
        this.zzc = zzahVar;
        this.zza = i;
        this.zzb = i2;
    }

    @Override
    public final Object get(int i) {
        zzr.zzb(i, this.zzb, FirebaseAnalytics.Param.INDEX);
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
    final boolean zzf() {
        return true;
    }

    @Override
    public final zzah subList(int i, int i2) {
        zzr.zzd(i, i2, this.zzb);
        int i3 = this.zza;
        return this.zzc.subList(i + i3, i2 + i3);
    }
}
