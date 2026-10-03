package com.google.android.gms.internal.play_billing;

import java.util.Iterator;

final class zzcg extends zzca {
    private final transient zzbz zza;
    private final transient zzbw zzb;

    zzcg(zzbz zzbzVar, zzbw zzbwVar) {
        this.zza = zzbzVar;
        this.zzb = zzbwVar;
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
    final int zza(Object[] objArr, int i) {
        return this.zzb.zza(objArr, 0);
    }

    @Override
    public final zzbw zzd() {
        return this.zzb;
    }

    @Override
    public final zzck iterator() {
        return this.zzb.listIterator(0);
    }

    @Override
    final boolean zzf() {
        throw null;
    }
}
