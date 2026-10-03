package com.google.android.gms.measurement.internal;

import android.net.Uri;

final class zzka implements Runnable {
    private final boolean zza;
    private final Uri zzb;
    private final String zzc;
    private final String zzd;
    private final zzjx zze;

    zzka(zzjx zzjxVar, boolean z, Uri uri, String str, String str2) {
        this.zze = zzjxVar;
        this.zza = z;
        this.zzb = uri;
        this.zzc = str;
        this.zzd = str2;
    }

    @Override
    public final void run() {
        zzjx.zza(this.zze, this.zza, this.zzb, this.zzc, this.zzd);
    }
}
