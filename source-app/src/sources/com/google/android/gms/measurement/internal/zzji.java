package com.google.android.gms.measurement.internal;

import java.util.concurrent.atomic.AtomicReference;

final class zzji implements Runnable {
    private final AtomicReference zza;
    private final boolean zzb;
    private final zziq zzc;

    zzji(zziq zziqVar, AtomicReference atomicReference, boolean z) {
        this.zzc = zziqVar;
        this.zza = atomicReference;
        this.zzb = z;
    }

    @Override
    public final void run() {
        this.zzc.zzo().zza(this.zza, this.zzb);
    }
}
