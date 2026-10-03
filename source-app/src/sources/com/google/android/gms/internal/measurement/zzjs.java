package com.google.android.gms.internal.measurement;

import java.util.List;

abstract class zzjs {
    private static final zzjs zza = new zzjr();
    private static final zzjs zzb = new zzjt();

    static zzjs zza() {
        return zza;
    }

    abstract <L> List<L> zza(Object obj, long j);

    abstract <L> void zza(Object obj, Object obj2, long j);

    abstract void zzb(Object obj, long j);

    static zzjs zzb() {
        return zzb;
    }

    private zzjs() {
    }
}
