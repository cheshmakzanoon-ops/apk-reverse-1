package com.google.android.gms.internal.measurement;

public final class zzqa implements zzqb {
    private static final zzgn<Boolean> zza;
    private static final zzgn<Boolean> zzb;

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.sfmc.client", true);
        zzb = zzgvVarZza.zza("measurement.sfmc.service", true);
    }

    @Override
    public final boolean zza() {
        return true;
    }

    @Override
    public final boolean zzb() {
        return zza.zza().booleanValue();
    }

    @Override
    public final boolean zzc() {
        return zzb.zza().booleanValue();
    }
}
