package com.google.android.gms.internal.measurement;

import java.util.Iterator;
import java.util.NoSuchElementException;

final class zzau implements Iterator<zzaq> {
    private int zza = 0;
    private final zzas zzb;

    @Override
    public final zzaq next() {
        if (this.zza >= this.zzb.zza.length()) {
            throw new NoSuchElementException();
        }
        String str = this.zzb.zza;
        int i = this.zza;
        this.zza = i + 1;
        return new zzas(String.valueOf(str.charAt(i)));
    }

    zzau(zzas zzasVar) {
        this.zzb = zzasVar;
    }

    @Override
    public final boolean hasNext() {
        return this.zza < this.zzb.zza.length();
    }
}
