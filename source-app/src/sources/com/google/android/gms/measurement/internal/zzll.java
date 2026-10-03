package com.google.android.gms.measurement.internal;

final class zzll implements Runnable {
    private final zzfk zza;
    private final zzlm zzb;

    zzll(zzlm zzlmVar, zzfk zzfkVar) {
        this.zzb = zzlmVar;
        this.zza = zzfkVar;
    }

    @Override
    public final void run() {
        synchronized (this.zzb) {
            this.zzb.zzb = false;
            if (!this.zzb.zza.zzah()) {
                this.zzb.zza.zzj().zzp().zza("Connected to service");
                this.zzb.zza.zza(this.zza);
            }
        }
    }
}
