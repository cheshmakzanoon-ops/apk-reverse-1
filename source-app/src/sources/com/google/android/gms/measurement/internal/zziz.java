package com.google.android.gms.measurement.internal;

import java.util.concurrent.Executor;

final class zziz implements Executor {
    private final zziq zza;

    zziz(zziq zziqVar) {
        this.zza = zziqVar;
    }

    @Override
    public final void execute(Runnable runnable) {
        this.zza.zzl().zzb(runnable);
    }
}
