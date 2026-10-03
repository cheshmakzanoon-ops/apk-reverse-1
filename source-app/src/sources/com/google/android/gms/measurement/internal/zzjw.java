package com.google.android.gms.measurement.internal;

final class zzjw implements Runnable {
    private final zzay zza;
    private final zziq zzb;

    zzjw(zziq zziqVar, zzay zzayVar) {
        this.zzb = zziqVar;
        this.zza = zzayVar;
    }

    @Override
    public final void run() {
        if (this.zzb.zzk().zza(this.zza)) {
            this.zzb.zzo().zza(false);
        } else {
            this.zzb.zzj().zzn().zza("Lower precedence consent source ignored, proposed source", Integer.valueOf(this.zza.zza()));
        }
    }
}
