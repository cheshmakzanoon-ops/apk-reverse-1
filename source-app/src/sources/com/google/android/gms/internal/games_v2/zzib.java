package com.google.android.gms.internal.games_v2;

import java.util.Iterator;
import java.util.Map;

final class zzib extends zzhk {
    private final transient zzhg zza;
    private final transient Object[] zzb;
    private final transient int zzc;

    zzib(zzhg zzhgVar, Object[] objArr, int i, int i2) {
        this.zza = zzhgVar;
        this.zzb = objArr;
        this.zzc = i2;
    }

    @Override
    public final boolean contains(Object obj) {
        if (obj instanceof Map.Entry) {
            Map.Entry entry = (Map.Entry) obj;
            Object key = entry.getKey();
            Object value = entry.getValue();
            if (value != null && value.equals(this.zza.get(key))) {
                return true;
            }
        }
        return false;
    }

    @Override
    public final Iterator iterator() {
        return zzh().listIterator(0);
    }

    @Override
    public final int size() {
        return this.zzc;
    }

    @Override
    public final zzil iterator() {
        return zzh().listIterator(0);
    }

    @Override
    final int zze(Object[] objArr, int i) {
        return zzh().zze(objArr, 0);
    }

    @Override
    final zzhd zzi() {
        return new zzia(this);
    }

    final Object[] zzk() {
        return this.zzb;
    }

    final int zzl() {
        return this.zzc;
    }
}
