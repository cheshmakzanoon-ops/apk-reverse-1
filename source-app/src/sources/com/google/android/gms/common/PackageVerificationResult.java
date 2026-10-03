package com.google.android.gms.common;

import javax.annotation.Nullable;

public class PackageVerificationResult {
    private final String zza;
    private final boolean zzb;

    @Nullable
    private final String zzc;

    @Nullable
    private final Throwable zzd;

    private PackageVerificationResult(String str, int i, boolean z, @Nullable String str2, @Nullable Throwable th, @Nullable com.google.android.gms.common.signatureverification.zza zzaVar) {
        this.zza = str;
        this.zzb = z;
        this.zzc = str2;
        this.zzd = th;
    }

    public static PackageVerificationResult zza(String str, String str2, @Nullable Throwable th, @Nullable com.google.android.gms.common.signatureverification.zza zzaVar) {
        return new PackageVerificationResult(str, 1, false, str2, th, null);
    }

    public static PackageVerificationResult zzd(String str, int i, @Nullable com.google.android.gms.common.signatureverification.zza zzaVar) {
        return new PackageVerificationResult(str, i, true, null, null, null);
    }

    public final boolean zzb() {
        return this.zzb;
    }

    public final void zzc() {
        if (this.zzb) {
            return;
        }
        String str = this.zzc;
        String.valueOf(str);
        Throwable th = this.zzd;
        String strConcat = "PackageVerificationRslt: ".concat(String.valueOf(str));
        if (th == null) {
            throw new SecurityException(strConcat);
        }
        throw new SecurityException(strConcat, th);
    }
}
