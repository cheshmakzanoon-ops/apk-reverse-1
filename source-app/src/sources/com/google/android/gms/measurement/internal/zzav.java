package com.google.android.gms.measurement.internal;

final class zzav implements Runnable {
    private final zzif zza;
    private final zzaw zzb;

    zzav(zzaw zzawVar, zzif zzifVar) {
        this.zzb = zzawVar;
        this.zza = zzifVar;
    }

    @Override
    public final void run() {
        this.zza.zzd();
        if (zzae.zza()) {
            this.zza.zzl().zzb(this);
            return;
        }
        boolean zZzc = this.zzb.zzc();
        this.zzb.zzd = 0L;
        if (zZzc) {
            this.zzb.zzb();
        }
    }
}
