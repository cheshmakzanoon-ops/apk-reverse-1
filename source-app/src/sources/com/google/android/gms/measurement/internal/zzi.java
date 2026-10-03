package com.google.android.gms.measurement.internal;

final class zzi implements Runnable {
    private final com.google.android.gms.internal.measurement.zzcv zza;
    private final AppMeasurementDynamiteService zzb;

    zzi(AppMeasurementDynamiteService appMeasurementDynamiteService, com.google.android.gms.internal.measurement.zzcv zzcvVar) {
        this.zzb = appMeasurementDynamiteService;
        this.zza = zzcvVar;
    }

    @Override
    public final void run() {
        this.zzb.zza.zzr().zza(this.zza);
    }
}
