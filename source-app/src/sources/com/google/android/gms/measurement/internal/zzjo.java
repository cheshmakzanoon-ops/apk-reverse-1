package com.google.android.gms.measurement.internal;

import java.util.concurrent.atomic.AtomicReference;

final class zzjo implements Runnable {
    private final AtomicReference zza;
    private final String zzb = null;
    private final String zzc;
    private final String zzd;
    private final zziq zze;

    zzjo(zziq zziqVar, AtomicReference atomicReference, String str, String str2, String str3) {
        this.zze = zziqVar;
        this.zza = atomicReference;
        this.zzc = str2;
        this.zzd = str3;
    }

    @Override
    public final void run() {
        this.zze.zzu.zzr().zza(this.zza, (String) null, this.zzc, this.zzd);
    }
}
