package com.google.android.gms.measurement.internal;

final class zzk implements Runnable {
    private final com.google.android.gms.internal.measurement.zzcv zza;
    private final zzbg zzb;
    private final String zzc;
    private final AppMeasurementDynamiteService zzd;

    zzk(AppMeasurementDynamiteService appMeasurementDynamiteService, com.google.android.gms.internal.measurement.zzcv zzcvVar, zzbg zzbgVar, String str) {
        this.zzd = appMeasurementDynamiteService;
        this.zza = zzcvVar;
        this.zzb = zzbgVar;
        this.zzc = str;
    }

    @Override
    public final void run() {
        this.zzd.zza.zzr().zza(this.zza, this.zzb, this.zzc);
    }
}
