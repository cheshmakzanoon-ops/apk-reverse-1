package com.google.android.gms.internal.games_v2;

import java.util.Iterator;

final class zzhn implements zzhu {
    private final Iterator zza;
    private boolean zzb;
    private Object zzc;

    @Override
    public final boolean hasNext() {
        return this.zzb || this.zza.hasNext();
    }

    @Override
    public final Object next() {
        if (!this.zzb) {
            return this.zza.next();
        }
        Object obj = this.zzc;
        this.zzb = false;
        this.zzc = null;
        return obj;
    }

    @Override
    public final Object zza() {
        if (!this.zzb) {
            this.zzc = this.zza.next();
            this.zzb = true;
        }
        return this.zzc;
    }

    public zzhn(Iterator it) {
        it.getClass();
        this.zza = it;
    }

    @Override
    public final void remove() {
        if (this.zzb) {
            throw new IllegalStateException("Can't remove after you've peeked at next");
        }
        this.zza.remove();
    }
}
