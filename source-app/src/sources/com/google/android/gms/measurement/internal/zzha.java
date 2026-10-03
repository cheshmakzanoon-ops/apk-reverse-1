package com.google.android.gms.measurement.internal;

import com.google.android.gms.common.internal.Preconditions;

final class zzha implements Thread.UncaughtExceptionHandler {
    private final String zza;
    private final zzgy zzb;

    public zzha(zzgy zzgyVar, String str) {
        this.zzb = zzgyVar;
        Preconditions.checkNotNull(str);
        this.zza = str;
    }

    @Override
    public final synchronized void uncaughtException(Thread thread, Throwable th) {
        this.zzb.zzj().zzg().zza(this.zza, th);
    }
}
