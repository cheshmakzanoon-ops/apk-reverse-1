package com.google.android.gms.measurement.internal;

final class zzn implements Runnable {
    private final com.google.android.gms.internal.measurement.zzcv zza;
    private final AppMeasurementDynamiteService zzb;

    zzn(AppMeasurementDynamiteService appMeasurementDynamiteService, com.google.android.gms.internal.measurement.zzcv zzcvVar) {
        this.zzb = appMeasurementDynamiteService;
        this.zza = zzcvVar;
    }

    @Override
    public final void run() {
        this.zzb.zza.zzt().zza(this.zza, this.zzb.zza.zzab());
    }
}
