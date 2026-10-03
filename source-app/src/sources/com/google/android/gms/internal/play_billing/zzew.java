package com.google.android.gms.internal.play_billing;

import com.google.android.gms.common.api.Api;

final class zzew extends zzey {
    private int zzb;
    private int zzc;
    private int zzd;

    zzew(byte[] bArr, int i, int i2, boolean z, zzex zzexVar) {
        super(null);
        this.zzd = Api.BaseClientBuilder.API_PRIORITY_OTHER;
        this.zzb = 0;
    }

    public final int zza(int i) throws zzgc {
        int i2 = this.zzd;
        this.zzd = 0;
        int i3 = this.zzb + this.zzc;
        this.zzb = i3;
        if (i3 > 0) {
            this.zzc = i3;
            this.zzb = 0;
        } else {
            this.zzc = 0;
        }
        return i2;
    }
}
