package com.google.android.gms.measurement.internal;

import android.os.Bundle;

public final class zzfv {
    public String zza;
    public Bundle zzb;
    private String zzc;
    private long zzd;

    public final zzbg zza() {
        return new zzbg(this.zza, new zzbb(new Bundle(this.zzb)), this.zzc, this.zzd);
    }

    public static zzfv zza(zzbg zzbgVar) {
        return new zzfv(zzbgVar.zza, zzbgVar.zzc, zzbgVar.zzb.zzb(), zzbgVar.zzd);
    }

    public final String toString() {
        return "origin=" + this.zzc + ",name=" + this.zza + ",params=" + String.valueOf(this.zzb);
    }

    private zzfv(String str, String str2, Bundle bundle, long j) {
        this.zza = str;
        this.zzc = str2;
        this.zzb = bundle == null ? new Bundle() : bundle;
        this.zzd = j;
    }
}
