package com.google.android.gms.internal.location;

import com.google.firebase.analytics.FirebaseAnalytics;

final class zzbt<E> extends zzbs<E> {
    static final zzbs<Object> zza = new zzbt(new Object[0], 0);
    final transient Object[] zzb;
    private final transient int zzc;

    zzbt(Object[] objArr, int i) {
        this.zzb = objArr;
        this.zzc = i;
    }

    @Override
    public final E get(int i) {
        zzbm.zza(i, this.zzc, FirebaseAnalytics.Param.INDEX);
        return (E) this.zzb[i];
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
    final boolean zzf() {
        return false;
    }

    @Override
    final int zzg(Object[] objArr, int i) {
        System.arraycopy(this.zzb, 0, objArr, 0, this.zzc);
        return this.zzc;
    }
}
