package com.google.android.gms.measurement.internal;

import java.util.Iterator;

final class zzbe implements Iterator<String> {
    private Iterator<String> zza;
    private final zzbb zzb;

    @Override
    public final String next() {
        return this.zza.next();
    }

    zzbe(zzbb zzbbVar) {
        this.zzb = zzbbVar;
        this.zza = zzbbVar.zza.keySet().iterator();
    }

    @Override
    public final void remove() {
        throw new UnsupportedOperationException("Remove not supported");
    }

    @Override
    public final boolean hasNext() {
        return this.zza.hasNext();
    }
}
