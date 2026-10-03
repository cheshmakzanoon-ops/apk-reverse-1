package com.google.android.gms.internal.measurement;

public final class zzpi implements zzpj {
    private static final zzgn<Boolean> zza;
    private static final zzgn<Boolean> zzb;
    private static final zzgn<Boolean> zzc;
    private static final zzgn<Boolean> zzd;
    private static final zzgn<Boolean> zze;
    private static final zzgn<Long> zzf;

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.rb.attribution.client2", false);
        zzb = zzgvVarZza.zza("measurement.rb.attribution.followup1.service", false);
        zzc = zzgvVarZza.zza("measurement.rb.attribution.service", false);
        zzd = zzgvVarZza.zza("measurement.rb.attribution.enable_trigger_redaction", true);
        zze = zzgvVarZza.zza("measurement.rb.attribution.uuid_generation", true);
        zzf = zzgvVarZza.zza("measurement.id.rb.attribution.service", 0L);
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

    @Override
    public final boolean zze() {
        return zzd.zza().booleanValue();
    }

    @Override
    public final boolean zzf() {
        return zze.zza().booleanValue();
    }
}
