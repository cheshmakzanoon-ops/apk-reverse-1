package com.google.android.gms.internal.measurement;

public final class zzns implements zznt {
    private static final zzgn<Boolean> zza;
    private static final zzgn<Boolean> zzb;
    private static final zzgn<Boolean> zzc;

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.collection.event_safelist", true);
        zzb = zzgvVarZza.zza("measurement.service.store_null_safelist", true);
        zzc = zzgvVarZza.zza("measurement.service.store_safelist", true);
    }

    @Override
    public final boolean zza() {
        return true;
    }

    @Override
    public final boolean zzb() {
        return zzb.zza().booleanValue();
    }

    @Override
    public final boolean zzc() {
        return zzc.zza().booleanValue();
    }
}
