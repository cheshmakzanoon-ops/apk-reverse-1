package com.google.android.gms.internal.measurement;

public final class zzoj implements zzog {
    private static final zzgn<Boolean> zza;
    private static final zzgn<Boolean> zzb;
    private static final zzgn<Boolean> zzc;

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.client.sessions.check_on_reset_and_enable2", true);
        zzb = zzgvVarZza.zza("measurement.client.sessions.check_on_startup", true);
        zzc = zzgvVarZza.zza("measurement.client.sessions.start_session_before_view_screen", true);
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
