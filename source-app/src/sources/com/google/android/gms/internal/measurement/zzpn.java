package com.google.android.gms.internal.measurement;

public final class zzpn implements zzpk {
    private static final zzgn<Boolean> zza;
    private static final zzgn<Boolean> zzb;
    private static final zzgn<Boolean> zzc;
    private static final zzgn<Boolean> zzd;
    private static final zzgn<Boolean> zze;
    private static final zzgn<Boolean> zzf;
    private static final zzgn<Boolean> zzg;
    private static final zzgn<Boolean> zzh;
    private static final zzgn<Boolean> zzi;
    private static final zzgn<Boolean> zzj;
    private static final zzgn<Boolean> zzk;
    private static final zzgn<Boolean> zzl;
    private static final zzgn<Boolean> zzm;
    private static final zzgn<Boolean> zzn;

    static {
        zzgv zzgvVarZza = new zzgv(zzgk.zza("com.google.android.gms.measurement")).zzb().zza();
        zza = zzgvVarZza.zza("measurement.redaction.app_instance_id", true);
        zzb = zzgvVarZza.zza("measurement.redaction.client_ephemeral_aiid_generation", true);
        zzc = zzgvVarZza.zza("measurement.redaction.config_redacted_fields", true);
        zzd = zzgvVarZza.zza("measurement.redaction.device_info", true);
        zze = zzgvVarZza.zza("measurement.redaction.e_tag", true);
        zzf = zzgvVarZza.zza("measurement.redaction.enhanced_uid", true);
        zzg = zzgvVarZza.zza("measurement.redaction.populate_ephemeral_app_instance_id", true);
        zzh = zzgvVarZza.zza("measurement.redaction.google_signals", true);
        zzi = zzgvVarZza.zza("measurement.redaction.no_aiid_in_config_request", true);
        zzj = zzgvVarZza.zza("measurement.redaction.retain_major_os_version", true);
        zzk = zzgvVarZza.zza("measurement.redaction.scion_payload_generator", true);
        zzl = zzgvVarZza.zza("measurement.redaction.upload_redacted_fields", true);
        zzm = zzgvVarZza.zza("measurement.redaction.upload_subdomain_override", true);
        zzn = zzgvVarZza.zza("measurement.redaction.user_id", true);
    }

    @Override
    public final boolean zza() {
        return zzj.zza().booleanValue();
    }

    @Override
    public final boolean zzb() {
        return zzk.zza().booleanValue();
    }
}
