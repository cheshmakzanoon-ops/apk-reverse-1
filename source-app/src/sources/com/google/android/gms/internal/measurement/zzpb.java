package com.google.android.gms.internal.measurement;

public final class zzpb implements zzoy {
    private static final zzgn<Long> zza;
    private static final zzgn<Boolean> zzb;
    private static final zzgn<Boolean> zzc;

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.id.lifecycle.app_in_background_parameter", 0L);
        zzb = zzgvVarZza.zza("measurement.lifecycle.app_backgrounded_tracking", true);
        zzc = zzgvVarZza.zza("measurement.lifecycle.app_in_background_parameter", false);
    }

    @Override
    public final boolean zza() {
        return zzc.zza().booleanValue();
    }
}
