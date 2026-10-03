package com.google.android.gms.internal.measurement;

public final class zzpo implements zzpp {
    private static final zzgn<Boolean> zza;
    private static final zzgn<Long> zzb;

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.remove_app_background.client", false);
        zzb = zzgvVarZza.zza("measurement.id.remove_app_background.client", 0L);
    }

    @Override
    public final boolean zza() {
        return true;
    }

    @Override
    public final boolean zzb() {
        return zza.zza().booleanValue();
    }
}
