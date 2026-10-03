package com.google.android.gms.internal.measurement;

public final class zzpu implements zzpv {
    private static final zzgn<Boolean> zza;
    private static final zzgn<Boolean> zzb;
    private static final zzgn<Boolean> zzc;
    private static final zzgn<Boolean> zzd;

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.collection.enable_session_stitching_token.client.dev", true);
        zzb = zzgvVarZza.zza("measurement.collection.enable_session_stitching_token.first_open_fix", true);
        zzc = zzgvVarZza.zza("measurement.session_stitching_token_enabled", false);
        zzd = zzgvVarZza.zza("measurement.link_sst_to_sid", true);
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

    @Override
    public final boolean zzd() {
        return zzc.zza().booleanValue();
    }
}
