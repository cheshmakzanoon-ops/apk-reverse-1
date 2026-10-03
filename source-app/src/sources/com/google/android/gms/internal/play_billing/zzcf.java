package com.google.android.gms.internal.play_billing;

import java.util.Iterator;
import java.util.Map;

final class zzcf extends zzca {
    private final transient zzbz zza;
    private final transient Object[] zzb;
    private final transient int zzc;

    zzcf(zzbz zzbzVar, Object[] objArr, int i, int i2) {
        this.zza = zzbzVar;
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
        return zzd().listIterator(0);
    }

    @Override
    public final int size() {
        return this.zzc;
    }

    @Override
    final int zza(Object[] objArr, int i) {
        return zzd().zza(objArr, 0);
    }

    @Override
    public final zzck iterator() {
        return zzd().listIterator(0);
    }

    @Override
    final boolean zzf() {
        throw null;
    }

    @Override
    final zzbw zzh() {
        return new zzce(this);
    }
}
