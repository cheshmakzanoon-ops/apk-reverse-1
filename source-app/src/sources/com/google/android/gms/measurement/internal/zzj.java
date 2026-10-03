package com.google.android.gms.measurement.internal;

final class zzj implements Runnable {
    private final com.google.android.gms.internal.measurement.zzcv zza;
    private final String zzb;
    private final String zzc;
    private final boolean zzd;
    private final AppMeasurementDynamiteService zze;

    zzj(AppMeasurementDynamiteService appMeasurementDynamiteService, com.google.android.gms.internal.measurement.zzcv zzcvVar, String str, String str2, boolean z) {
        this.zze = appMeasurementDynamiteService;
        this.zza = zzcvVar;
        this.zzb = str;
        this.zzc = str2;
        this.zzd = z;
    }

    @Override
    public final void run() {
        this.zze.zza.zzr().zza(this.zza, this.zzb, this.zzc, this.zzd);
    }
}
