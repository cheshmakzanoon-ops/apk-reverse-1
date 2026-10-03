package com.google.android.gms.internal.measurement;

final class zzkz implements zzkh {
    private final zzkj zza;
    private final String zzb;
    private final Object[] zzc;
    private final int zzd;

    @Override
    public final zzkj zza() {
        return this.zza;
    }

    @Override
    public final zzky zzb() {
        int i = this.zzd;
        if ((i & 1) != 0) {
            return zzky.PROTO2;
        }
        return (i & 4) == 4 ? zzky.EDITIONS : zzky.PROTO3;
    }

    final String zzd() {
        return this.zzb;
    }

    zzkz(zzkj zzkjVar, String str, Object[] objArr) {
        this.zza = zzkjVar;
        this.zzb = str;
        this.zzc = objArr;
        char cCharAt = str.charAt(0);
        if (cCharAt < 55296) {
            this.zzd = cCharAt;
            return;
        }
        int i = cCharAt & 8191;
        int i2 = 13;
        int i3 = 1;
        while (true) {
            int i4 = i3 + 1;
            char cCharAt2 = str.charAt(i3);
            if (cCharAt2 < 55296) {
                this.zzd = i | (cCharAt2 << i2);
                return;
            } else {
                i |= (cCharAt2 & 8191) << i2;
                i2 += 13;
                i3 = i4;
            }
        }
    }

    @Override
    public final boolean zzc() {
        return (this.zzd & 2) == 2;
    }

    final Object[] zze() {
        return this.zzc;
    }
}
