package com.google.android.gms.measurement.internal;

final class zzlv implements Runnable {
    private final zzmp zza;
    private final Runnable zzb;

    zzlv(zzlu zzluVar, zzmp zzmpVar, Runnable runnable) {
        this.zza = zzmpVar;
        this.zzb = runnable;
    }

    @Override
    public final void run() {
        this.zza.zzr();
        this.zza.zza(this.zzb);
        this.zza.zzw();
    }
}
