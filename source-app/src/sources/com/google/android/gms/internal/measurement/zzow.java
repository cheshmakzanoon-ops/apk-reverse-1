package com.google.android.gms.internal.measurement;

public final class zzow implements zzox {
    private static final zzgn<Boolean> zza;
    private static final zzgn<Boolean> zzb;
    private static final zzgn<Boolean> zzc;
    private static final zzgn<Long> zzd;

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.sdk.collection.enable_extend_user_property_size", true);
        zzb = zzgvVarZza.zza("measurement.sdk.collection.last_deep_link_referrer2", true);
        zzc = zzgvVarZza.zza("measurement.sdk.collection.last_deep_link_referrer_campaign2", false);
        zzd = zzgvVarZza.zza("measurement.id.sdk.collection.last_deep_link_referrer2", 0L);
    }

    @Override
    public final boolean zza() {
        return zzc.zza().booleanValue();
    }
}
