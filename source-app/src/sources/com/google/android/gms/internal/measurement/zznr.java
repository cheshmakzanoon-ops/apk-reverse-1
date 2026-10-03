package com.google.android.gms.internal.measurement;

public final class zznr implements zzno {
    private static final zzgn<Boolean> zza;
    private static final zzgn<Boolean> zzb;
    private static final zzgn<Boolean> zzc;
    private static final zzgn<Boolean> zzd;
    private static final zzgn<Boolean> zze;
    private static final zzgn<Boolean> zzf;
    private static final zzgn<Long> zzg;

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.dma_consent.client", false);
        zzb = zzgvVarZza.zza("measurement.dma_consent.client_bow_check", false);
        zzc = zzgvVarZza.zza("measurement.dma_consent.service", false);
        zzd = zzgvVarZza.zza("measurement.dma_consent.service_gcs_v2", false);
        zze = zzgvVarZza.zza("measurement.dma_consent.service_npa_remote_default", false);
        zzf = zzgvVarZza.zza("measurement.dma_consent.service_split_batch_on_consent", false);
        zzg = zzgvVarZza.zza("measurement.id.dma_consent.service", 0L);
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

    @Override
    public final boolean zzg() {
        return zzf.zza().booleanValue();
    }
}
