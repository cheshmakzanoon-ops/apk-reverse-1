package com.google.android.gms.internal.measurement;

public final class zznl implements zzni {
    private static final zzgn<Boolean> zza;
    private static final zzgn<Boolean> zzb;
    private static final zzgn<Boolean> zzc;
    private static final zzgn<Long> zzd;

    @Override
    public final long zza() {
        return zzd.zza().longValue();
    }

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.client.consent_state_v1", true);
        zzb = zzgvVarZza.zza("measurement.client.3p_consent_state_v1", true);
        zzc = zzgvVarZza.zza("measurement.service.consent_state_v1_W36", true);
        zzd = zzgvVarZza.zza("measurement.service.storage_consent_support_version", 203600L);
    }
}
