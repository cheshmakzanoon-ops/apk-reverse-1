package com.google.android.gms.internal.measurement;

import java.util.Iterator;
import java.util.NoSuchElementException;

final class zzah implements Iterator<zzaq> {
    private int zza = 0;
    private final zzaf zzb;

    @Override
    public final zzaq next() {
        if (this.zza < this.zzb.zzb()) {
            zzaf zzafVar = this.zzb;
            int i = this.zza;
            this.zza = i + 1;
            return zzafVar.zza(i);
        }
        throw new NoSuchElementException("Out of bounds index: " + this.zza);
    }

    zzah(zzaf zzafVar) {
        this.zzb = zzafVar;
    }

    @Override
    public final boolean hasNext() {
        return this.zza < this.zzb.zzb();
    }
}
