package com.google.android.gms.internal.measurement;

public final class zzok implements zzol {
    private static final zzgn<Boolean> zza;
    private static final zzgn<Boolean> zzb;
    private static final zzgn<Long> zzc;

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.gbraid_campaign.gbraid.client.dev", false);
        zzb = zzgvVarZza.zza("measurement.gbraid_campaign.gbraid.service", false);
        zzc = zzgvVarZza.zza("measurement.id.gbraid_campaign.service", 0L);
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
