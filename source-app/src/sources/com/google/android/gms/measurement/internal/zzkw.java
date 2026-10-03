package com.google.android.gms.measurement.internal;

import com.google.android.gms.common.internal.Preconditions;

final class zzkw implements Runnable {
    private final zzo zza;
    private final boolean zzb;
    private final zznc zzc;
    private final zzkp zzd;

    zzkw(zzkp zzkpVar, zzo zzoVar, boolean z, zznc zzncVar) {
        this.zzd = zzkpVar;
        this.zza = zzoVar;
        this.zzb = z;
        this.zzc = zzncVar;
    }

    @Override
    public final void run() throws Throwable {
        zzfk zzfkVar = this.zzd.zzb;
        if (zzfkVar == null) {
            this.zzd.zzj().zzg().zza("Discarding data. Failed to set user property");
            return;
        }
        Preconditions.checkNotNull(this.zza);
        this.zzd.zza(zzfkVar, this.zzb ? null : this.zzc, this.zza);
        this.zzd.zzal();
    }
}
