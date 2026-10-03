package com.google.android.gms.internal.measurement;

import java.util.NoSuchElementException;

final class zzhp extends zzhr {
    private int zza = 0;
    private final int zzb;
    private final zzhm zzc;

    @Override
    public final byte zza() {
        int i = this.zza;
        if (i >= this.zzb) {
            throw new NoSuchElementException();
        }
        this.zza = i + 1;
        return this.zzc.zzb(i);
    }

    zzhp(zzhm zzhmVar) {
        this.zzc = zzhmVar;
        this.zzb = zzhmVar.zzb();
    }

    @Override
    public final boolean hasNext() {
        return this.zza < this.zzb;
    }
}
