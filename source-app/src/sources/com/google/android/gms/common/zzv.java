package com.google.android.gms.common;

final class zzv {
    private String zza = null;
    private Boolean zzb = null;
    private Boolean zzc = null;

    private zzv() {
    }

    zzv(byte[] bArr) {
    }

    final zzv zza(String str) {
        this.zza = str;
        return this;
    }

    final zzv zzb(boolean z) {
        this.zzb = Boolean.valueOf(z);
        return this;
    }

    final zzv zzc(boolean z) {
        this.zzc = Boolean.valueOf(z);
        return this;
    }

    final zzw zzd() {
        Boolean bool = this.zzb;
        if (bool == null) {
            throw new IllegalStateException("allowTestKeys must be set");
        }
        if (this.zzc != null) {
            return new zzw(this.zza, bool.booleanValue(), false, false, this.zzc.booleanValue(), false, null);
        }
        throw new IllegalStateException("isGoogleOrPlatformOnly must be set");
    }
}
