package com.google.android.gms.measurement.internal;

final class zzmm extends zzaw {
    private final zzmj zza;

    zzmm(zzmj zzmjVar, zzif zzifVar) {
        super(zzifVar);
        this.zza = zzmjVar;
    }

    @Override
    public final void zzb() {
        this.zza.zzu();
        this.zza.zzj().zzp().zza("Starting upload from DelayedRunnable");
        this.zza.zzf.zzw();
    }
}
