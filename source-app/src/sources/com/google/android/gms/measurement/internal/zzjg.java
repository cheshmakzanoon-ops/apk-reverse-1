package com.google.android.gms.measurement.internal;

import android.os.Bundle;

final class zzjg implements Runnable {
    private final String zza;
    private final String zzb;
    private final long zzc;
    private final Bundle zzd;
    private final boolean zze;
    private final boolean zzf;
    private final boolean zzg;
    private final String zzh;
    private final zziq zzi;

    zzjg(zziq zziqVar, String str, String str2, long j, Bundle bundle, boolean z, boolean z2, boolean z3, String str3) {
        this.zzi = zziqVar;
        this.zza = str;
        this.zzb = str2;
        this.zzc = j;
        this.zzd = bundle;
        this.zze = z;
        this.zzf = z2;
        this.zzg = z3;
        this.zzh = str3;
    }

    @Override
    public final void run() {
        this.zzi.zza(this.zza, this.zzb, this.zzc, this.zzd, this.zze, this.zzf, this.zzg, this.zzh);
    }
}
