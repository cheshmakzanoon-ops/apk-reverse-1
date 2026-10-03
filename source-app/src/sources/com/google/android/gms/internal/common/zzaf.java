package com.google.android.gms.internal.common;

import com.google.firebase.analytics.FirebaseAnalytics;
import java.util.List;

final class zzaf extends zzah {
    private final transient zzah zza;

    zzaf(zzah zzahVar) {
        this.zza = zzahVar;
    }

    private final int zzs(int i) {
        return (this.zza.size() - 1) - i;
    }

    @Override
    public final boolean contains(Object obj) {
        return this.zza.contains(obj);
    }

    @Override
    public final Object get(int i) {
        zzah zzahVar = this.zza;
        zzr.zzb(i, zzahVar.size(), FirebaseAnalytics.Param.INDEX);
        return zzahVar.get(zzs(i));
    }

    @Override
    public final int indexOf(Object obj) {
        int iLastIndexOf = this.zza.lastIndexOf(obj);
        if (iLastIndexOf >= 0) {
            return zzs(iLastIndexOf);
        }
        return -1;
    }

    @Override
    public final int lastIndexOf(Object obj) {
        int iIndexOf = this.zza.indexOf(obj);
        if (iIndexOf >= 0) {
            return zzs(iIndexOf);
        }
        return -1;
    }

    @Override
    public final int size() {
        return this.zza.size();
    }

    @Override
    public final List subList(int i, int i2) {
        return subList(i, i2);
    }

    @Override
    final boolean zzf() {
        return this.zza.zzf();
    }

    @Override
    public final zzah zzh() {
        return this.zza;
    }

    @Override
    public final zzah subList(int i, int i2) {
        zzah zzahVar = this.zza;
        zzr.zzd(i, i2, zzahVar.size());
        return zzahVar.subList(zzahVar.size() - i2, zzahVar.size() - i).zzh();
    }
}
