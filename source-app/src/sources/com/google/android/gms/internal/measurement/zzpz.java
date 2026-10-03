package com.google.android.gms.internal.measurement;

public final class zzpz implements zzpw {
    private static final zzgn<Boolean> zza;
    private static final zzgn<Boolean> zzb;
    private static final zzgn<Boolean> zzc;
    private static final zzgn<Boolean> zzd;
    private static final zzgn<Boolean> zze;
    private static final zzgn<Long> zzf;

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.client.sessions.background_sessions_enabled", true);
        zzb = zzgvVarZza.zza("measurement.client.sessions.enable_fix_background_engagement", false);
        zzc = zzgvVarZza.zza("measurement.client.sessions.immediate_start_enabled_foreground", true);
        zzd = zzgvVarZza.zza("measurement.client.sessions.remove_expired_session_properties_enabled", true);
        zze = zzgvVarZza.zza("measurement.client.sessions.session_id_enabled", true);
        zzf = zzgvVarZza.zza("measurement.id.client.sessions.enable_fix_background_engagement", 0L);
    }

    @Override
    public final boolean zza() {
        return zzb.zza().booleanValue();
    }
}
