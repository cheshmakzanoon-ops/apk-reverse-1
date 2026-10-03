package com.google.android.gms.measurement.internal;

final class zzl implements Runnable {
    private final com.google.android.gms.internal.measurement.zzcv zza;
    private final String zzb;
    private final String zzc;
    private final AppMeasurementDynamiteService zzd;

    zzl(AppMeasurementDynamiteService appMeasurementDynamiteService, com.google.android.gms.internal.measurement.zzcv zzcvVar, String str, String str2) {
        this.zzd = appMeasurementDynamiteService;
        this.zza = zzcvVar;
        this.zzb = str;
        this.zzc = str2;
    }

    @Override
    public final void run() {
        this.zzd.zza.zzr().zza(this.zza, this.zzb, this.zzc);
    }
}
