package com.google.android.gms.internal.common;

import com.google.firebase.analytics.FirebaseAnalytics;
import java.util.NoSuchElementException;

abstract class zzz extends zzal {
    private final int zza;
    private int zzb;

    protected zzz(int i, int i2) {
        zzr.zzc(i2, i, FirebaseAnalytics.Param.INDEX);
        this.zza = i;
        this.zzb = i2;
    }

    @Override
    public final boolean hasNext() {
        return this.zzb < this.zza;
    }

    @Override
    public final boolean hasPrevious() {
        return this.zzb > 0;
    }

    @Override
    public final Object next() {
        if (!hasNext()) {
            throw new NoSuchElementException();
        }
        int i = this.zzb;
        this.zzb = i + 1;
        return zza(i);
    }

    @Override
    public final int nextIndex() {
        return this.zzb;
    }

    @Override
    public final Object previous() {
        if (!hasPrevious()) {
            throw new NoSuchElementException();
        }
        int i = this.zzb - 1;
        this.zzb = i;
        return zza(i);
    }

    @Override
    public final int previousIndex() {
        return this.zzb - 1;
    }

    protected abstract Object zza(int i);
}
