package com.google.android.gms.common.signatureverification;

public final class zzd {
    private static SignatureVerificationConfiguration zza;

    public static synchronized void zza(SignatureVerificationConfiguration signatureVerificationConfiguration) {
        if (zza != null) {
            throw new IllegalStateException("Redundantly setting SignatureVerificationConfiguration");
        }
        zza = signatureVerificationConfiguration;
    }

    public static synchronized SignatureVerificationConfiguration zzc() {
        if (zza == null) {
            zza(new zzb());
        }
        return zza;
    }
}
