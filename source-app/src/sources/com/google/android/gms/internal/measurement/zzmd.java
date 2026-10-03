package com.google.android.gms.internal.measurement;

import java.util.Iterator;

final class zzmd implements Iterator<String> {
    private Iterator<String> zza;
    private final zzmb zzb;

    @Override
    public final String next() {
        return this.zza.next();
    }

    zzmd(zzmb zzmbVar) {
        this.zzb = zzmbVar;
        this.zza = zzmbVar.zza.iterator();
    }

    @Override
    public final void remove() {
        throw new UnsupportedOperationException();
    }

    @Override
    public final boolean hasNext() {
        return this.zza.hasNext();
    }
}
