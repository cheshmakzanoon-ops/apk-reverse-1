package com.google.android.gms.internal.measurement;

public final class zzpc implements zzpd {
    private static final zzgn<Boolean> zza;
    private static final zzgn<Double> zzb;
    private static final zzgn<Long> zzc;
    private static final zzgn<Long> zzd;
    private static final zzgn<String> zze;

    @Override
    public final double zza() {
        return zzb.zza().doubleValue();
    }

    @Override
    public final long zzb() {
        return zzc.zza().longValue();
    }

    @Override
    public final long zzc() {
        return zzd.zza().longValue();
    }

    @Override
    public final String zzd() {
        return zze.zza();
    }

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.test.boolean_flag", false);
        zzb = zzgvVarZza.zza("measurement.test.double_flag", -3.0d);
        zzc = zzgvVarZza.zza("measurement.test.int_flag", -2L);
        zzd = zzgvVarZza.zza("measurement.test.long_flag", -1L);
        zze = zzgvVarZza.zza("measurement.test.string_flag", "---");
    }

    @Override
    public final boolean zze() {
        return zza.zza().booleanValue();
    }
}
