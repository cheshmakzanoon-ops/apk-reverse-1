package com.google.android.gms.measurement.internal;

final class zzm implements Runnable {
    private final AppMeasurementDynamiteService.zza zza;
    private final AppMeasurementDynamiteService zzb;

    zzm(AppMeasurementDynamiteService appMeasurementDynamiteService, AppMeasurementDynamiteService.zza zzaVar) {
        this.zzb = appMeasurementDynamiteService;
        this.zza = zzaVar;
    }

    @Override
    public final void run() {
        this.zzb.zza.zzp().zza(this.zza);
    }
}
