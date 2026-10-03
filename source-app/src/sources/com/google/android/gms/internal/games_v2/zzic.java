package com.google.android.gms.internal.games_v2;

import java.util.Iterator;

final class zzic extends zzhk {
    private final transient zzhg zza;
    private final transient zzhd zzb;

    zzic(zzhg zzhgVar, zzhd zzhdVar) {
        this.zza = zzhgVar;
        this.zzb = zzhdVar;
    }

    @Override
    public final boolean contains(Object obj) {
        return this.zza.get(obj) != null;
    }

    @Override
    public final Iterator iterator() {
        return this.zzb.listIterator(0);
    }

    @Override
    public final int size() {
        return this.zza.size();
    }

    @Override
    public final zzil iterator() {
        return this.zzb.listIterator(0);
    }

    @Override
    final int zze(Object[] objArr, int i) {
        return this.zzb.zze(objArr, 0);
    }
}
