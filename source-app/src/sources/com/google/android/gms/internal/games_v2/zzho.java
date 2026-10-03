package com.google.android.gms.internal.games_v2;

import java.util.NoSuchElementException;

final class zzho extends zzil {
    private final Object zza;
    private boolean zzb;

    zzho(Object obj) {
        this.zza = obj;
    }

    @Override
    public final boolean hasNext() {
        return !this.zzb;
    }

    @Override
    public final Object next() {
        if (this.zzb) {
            throw new NoSuchElementException();
        }
        this.zzb = true;
        return this.zza;
    }
}
